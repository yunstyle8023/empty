//
//  CA_HAddFileViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAddFileViewModel.h"

#import "CA_HSaveFolderCell.h"
#import "CA_HAddFileCell.h"

#import "CA_HChooseTagMenuController.h"
#import "CA_HBrowseFoldersModel.h"

#import "CA_HAddFileModel.h"

#import "CA_HUpdateFileManager.h"
#import "CA_HNewFileManager.h"

@interface CA_HAddFileViewModel () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * folders;
@property (nonatomic, strong) NSMutableArray * files;

@property (nonatomic, strong) NSIndexPath * selectIndexPath;

@property (nonatomic, strong) CA_HUpdateFileManager *updateFileManager;

@end


@implementation CA_HAddFileViewModel

#pragma mark --- Action

- (void)onButton:(UIButton *)sender{
    
    if (sender.tag == 100) {
        if (self.files.count > 0) {
            if (_getControllerBlock) {
                CA_H_WeakSelf(self);
                [_getControllerBlock() presentAlertTitle:@"" message:CA_H_LAN(@"文件未保存是否要离开?") buttons:@[CA_H_LAN(@"离开"),CA_H_LAN(@"取消")] clickBlock:^(UIAlertController *alert, NSInteger index) {
                    CA_H_StrongSelf(self);
                    switch (index) {
                        case 0:
                            if (self.backBlock) {
                                self.backBlock(NO);
                            }
                            break;
                        default:
                            break;
                    }
                }];
            }
        } else {
            if (self.backBlock) {
                self.backBlock(NO);
            }
        }
    } else {
        [self doneSave];
    }
}

- (void (^)(NSString *, NSData *))addShareFileBlock {
    if (!_addShareFileBlock) {
        CA_H_WeakSelf(self);
        _addShareFileBlock = ^ (NSString *fileName, NSData *data) {
            CA_H_StrongSelf(self);
            CA_HAddFileModel *model = [CA_HAddFileModel new];
            model.type = CA_H_AddFileTypeDocument;
            model.file = data;
            model.fileName = fileName;
            
            [self addFile:model];
        };
    }
    return _addShareFileBlock;
}

- (void)onSheet:(NSInteger)index{
    
    CA_H_WeakSelf(self);
    if (index == 2) {
        
        CA_H_MANAGER.fileBlock = ^(NSString *filePath, NSData *data) {
            CA_H_StrongSelf(self);
            CA_HAddFileModel *model = [CA_HAddFileModel new];
            model.type = CA_H_AddFileTypeDocument;
            model.filePath = filePath;
            model.file = data;
            
            [self addFile:model];
        };
        [CA_H_MANAGER presentDocumentPicker:_getControllerBlock()];
        return;
    }
    
    CA_H_MANAGER.imageBlock = ^(BOOL success, UIImage *image, NSDictionary *info) {
        CA_H_StrongSelf(self);
        if (success) {
            
            NSURL *url = info[@"PHImageFileURLKey"];
            if (!url) {
                url = info[@"UIImagePickerControllerImageURL"];
            }
            
            CA_HAddFileModel *model = [CA_HAddFileModel new];
            model.type = CA_H_AddFileTypeImage;
            NSData *imageData = info[@"ca_imageData"];
            model.file =  imageData?:image.imageDataRepresentation;
            if (url) {
                NSString *filePath = url.absoluteString;
                if ([filePath hasSuffix:@".HEIC"]) {
                    filePath = [filePath stringByReplacingCharactersInRange:NSMakeRange(filePath.length-4, 4) withString:@"jpeg"];
                }
                model.filePath = filePath;
            } else {
                model.file = UIImageJPEGRepresentation(image, 1);
                model.fileName = [[[info[UIImagePickerControllerMediaMetadata][@"{TIFF}"][@"DateTime"] stringByReplacingOccurrencesOfString:@" " withString:@"T"]stringByReplacingOccurrencesOfString:@":" withString:@"-"] stringByAppendingString:@".jpeg"];
            }
            
            [self addFile:model];
            
        }
        
    };
    switch (index) {
        case 0:
            [CA_H_MANAGER multiSelectImage:_getControllerBlock() maxSelected:9];
            break;
        case 1:
            [CA_H_MANAGER selectImageFromCamera:_getControllerBlock()];
            break;
        default:
            break;
    }
}

- (void)addFile:(CA_HAddFileModel *)model{
    
    CA_H_WeakSelf(self);
    [self.updateFileManager saveToTmp:model success:^{
        CA_H_StrongSelf(self);
        [self.updateFileManager update:model];
        
        [self.files addObject:model];
        if (self.tableView.superview) {
            NSInteger row = self.files.count - 1;
            [self.tableView insertRow:row inSection:2 withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView scrollToRow:row inSection:2 atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        
        [self changeButtonState];
    } failed:^{
        
    }];
    
}

#pragma mark --- Lazy

- (CA_HUpdateFileManager *)updateFileManager {
    if (!_updateFileManager) {
        _updateFileManager = [CA_HUpdateFileManager new];
    }
    return _updateFileManager;
}

- (NSMutableArray *)files{
    if (!_files) {
        _files = [NSMutableArray new];
    }
    return _files;
}

- (NSMutableArray *)folders{
    if (!_folders) {
        NSArray *history = [CA_H_UserDefaults objectForKey:CA_H_HistoryDirectory];
        
        NSMutableArray *mutArray = [NSMutableArray new];
        for (NSString *jsonStr in history) {
            [mutArray addObject:[CA_HBrowseFoldersModel modelWithJSON:jsonStr]];
        }
        _folders = mutArray;
    }
    return _folders;
}

- (NSString *)title{
    return CA_H_LAN(@"添加文件");
}

- (UIBarButtonItem *)leftBarButtonItem{
    if (!_leftBarButtonItem) {
        
        UIButton * button = [UIButton new];
        button.tag = 100;
        
        [button setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
        [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 70-titleSize.width)];
        
        button.frame = CGRectMake(0, 0, 70, 44);
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
    }
    return _leftBarButtonItem;
}

- (UIBarButtonItem *)rightBarButtonItem{
    if (!_rightBarButtonItem) {
        
        UIButton * button = [UIButton new];
        button.tag = 101;
        
        [button setTitle:CA_H_LAN(@"完成") forState:UIControlStateNormal];
        [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        [button setTitleColor:CA_H_4DISABLEDCOLOR forState:UIControlStateDisabled];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 70-titleSize.width, 0, 0)];
        
        button.frame = CGRectMake(0, 0, 70, 44);
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        button.enabled = NO;
    }
    return _rightBarButtonItem;
}


- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [UITableView newTableViewGrouped];
        
        [tableView registerClass:[CA_HSaveFolderCell class] forCellReuseIdentifier:@"cell0"];
        [tableView registerClass:[CA_HAddFileCell class] forCellReuseIdentifier:@"cell2"];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.bounces = NO;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        
        tableView.rowHeight = 65*CA_H_RATIO_WIDTH;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark --- Custom

#pragma mark --- Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 || section == 3) {
        return 1;
    }
    
    if (section == 0) {
        return self.folders.count;
    }
    
    if (section == 2) {
        return self.files.count;
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 3) {
        return 0;
    }
    return 50*CA_H_RATIO_WIDTH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString * identifier = CA_H_LAN(section?@"选择文件":@"保存至");
    
    UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identifier];
        
        UILabel * label = [UILabel new];
        
        label.font = CA_H_FONT_PFSC_Regular(14);
        label.textColor = CA_H_9GRAYCOLOR;
        label.text = identifier;
        
        [header.contentView addSubview:label];
        label.sd_layout
        .leftSpaceToView(header.contentView, 20*CA_H_RATIO_WIDTH)
        .centerYEqualToView(header.contentView).offset(5*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [label setMinimumScaleFactor:1];
        [label setSingleLineAutoResizeWithMaxWidth:300*CA_H_RATIO_WIDTH];
        
        
        
        UIView *line = [UIView new];
        line.backgroundColor = CA_H_BACKCOLOR;
        [header addSubview:line];
        line.sd_layout
        .heightIs(CA_H_LINE_Thickness)
        .leftSpaceToView(header, 20*CA_H_RATIO_WIDTH)
        .rightEqualToView(header)
        .bottomEqualToView(header);
    }
    
    
    
    return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = [NSString stringWithFormat:@"cell%ld", indexPath.section];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = CA_H_FONT_PFSC_Regular(16);
        cell.textLabel.textColor = CA_H_9GRAYCOLOR;
        
        UIView *line = [UIView new];
        line.backgroundColor = CA_H_BACKCOLOR;
        [cell addSubview:line];
        line.sd_layout
        .heightIs(CA_H_LINE_Thickness)
        .leftSpaceToView(cell, 20*CA_H_RATIO_WIDTH)
        .rightEqualToView(cell)
        .bottomEqualToView(cell);
        
        if (indexPath.section == 1) {
            cell.imageView.image = [UIImage imageNamed:@"file_icon"];
            cell.imageView.sd_resetLayout
            .widthIs(44*CA_H_RATIO_WIDTH)
            .heightEqualToWidth()
            .leftSpaceToView(cell.imageView.superview, 20*CA_H_RATIO_WIDTH)
            .centerYEqualToView(cell.imageView.superview);
            
            cell.textLabel.text = CA_H_LAN(@"选择文件夹");
            cell.textLabel.sd_resetLayout
            .centerYEqualToView(cell.textLabel.superview)
            .leftSpaceToView(cell.textLabel.superview, 74*CA_H_RATIO_WIDTH)
            .autoHeightRatio(0);
            [cell.textLabel setMaxNumberOfLinesToShow:1];
            [cell.textLabel setSingleLineAutoResizeWithMaxWidth:257*CA_H_RATIO_WIDTH];
            
        }else {
            
            cell.textLabel.text = CA_H_LAN(@"添加文件");
            cell.textLabel.sd_resetLayout
            .centerYEqualToView(cell.textLabel.superview)
            .leftSpaceToView(cell.textLabel.superview, 20*CA_H_RATIO_WIDTH)
            .autoHeightRatio(0);
            [cell.textLabel setMaxNumberOfLinesToShow:1];
            [cell.textLabel setSingleLineAutoResizeWithMaxWidth:257*CA_H_RATIO_WIDTH];
        }
    }
    
    if (indexPath.section == 0) {
        
        ((CA_HSaveFolderCell *)cell).model = self.folders[indexPath.row];
        
        if ([indexPath isEqual:_selectIndexPath]) {
            ((CA_HSaveFolderCell *)cell).chooseIcon.hidden = NO;
        }else {
            ((CA_HSaveFolderCell *)cell).chooseIcon.hidden = YES;
        }
        
    }else if (indexPath.section == 2) {
        ((CA_HAddFileCell *)cell).model = self.files[indexPath.row];
        
        CA_H_WeakSelf(self);
        ((CA_HAddFileCell *)cell).deleteBlock = ^(CA_HAddFileCell *deleteCell, BOOL isDelete) {
            CA_H_StrongSelf(self);
            
            if (isDelete) {
                if ([(CA_HAddFileModel *)deleteCell.model isFinish]) {
                    if (self.getControllerBlock) {
                        CA_H_WeakSelf(self);
                        [self.getControllerBlock() presentAlertTitle:nil message:@"是否确定删除该文件？" buttons:@[@"取消", @"确认"] clickBlock:^(UIAlertController *alert, NSInteger index) {
                            if (index == 1) {
                                CA_H_StrongSelf(self);
                                [self deleteCell:deleteCell tableView:tableView];
                            }
                        }];
                    }
                } else {
                    [self deleteCell:deleteCell tableView:tableView];
                }
                
            }
            [self changeButtonState];
            
        };
    }
    
    return cell;
}

- (void)deleteCell:(CA_HAddFileCell *)deleteCell tableView:(UITableView *)tableView {
    NSIndexPath * deleteIndexPath = [tableView indexPathForCell:deleteCell];
    [self.files removeObjectAtIndex:deleteIndexPath.row];
    CA_H_DISPATCH_MAIN_THREAD(^{
        [tableView deleteRowAtIndexPath:deleteIndexPath withRowAnimation:UITableViewRowAnimationLeft];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_pushBlock) {
        return;
    }
    
    CA_H_WeakSelf(self);
    switch (indexPath.section) {
        case 1:{
            _pushBlock(@"CA_HChooseFolderViewController", @{@"chooseBlock":^UIViewController *(CA_HBrowseFoldersModel *parentModel){
                CA_H_StrongSelf(self);
                NSInteger index = NSNotFound;
                for (NSInteger i=0; i<self.folders.count; i++) {
                    if ([parentModel.file_id isEqualToNumber:[self.folders[i] file_id]]) {
                        index = i;
                        break;
                    }
                }
                
                if (index == NSNotFound) {
                    [self.folders insertObject:parentModel atIndex:0];
                }else {
                    [self.folders removeObjectAtIndex:index];
                    [self.folders insertObject:parentModel atIndex:0];
                }
                
                
                NSMutableArray *saveArray = [NSMutableArray new];
                for (CA_HBrowseFoldersModel *model in self.folders) {
                    [saveArray addObject:[model modelToJSONString]];
                    if (saveArray.count >= 5) break;
                }
                [CA_H_UserDefaults setObject:saveArray forKey:CA_H_HistoryDirectory];
                
                self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView scrollToRowAtIndexPath:self.selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                
                [self changeButtonState];
                
                return self.getControllerBlock();
            }});
        }break;
        case 3:
            if (_getControllerBlock) {
                [_getControllerBlock() presentActionSheetTitle:nil
                                                       message:nil
                                                       buttons:@[CA_H_LAN(@"选择图片"),
                                                                 CA_H_LAN(@"拍摄图片"),
                                                                 CA_H_LAN(@"浏览")]
                                                    clickBlock:^(UIAlertController *alert, NSInteger index) {
                                                        CA_H_StrongSelf(self);
                                                        [self onSheet:index];
                }];
            }
            break;
        case 2:{
            
            CA_HAddFileCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell.canTag) {
                return;
            }
            if (_getControllerBlock) {
                CA_HChooseTagMenuController *tagMenuVC = [CA_HChooseTagMenuController new];
                tagMenuVC.viewModel.dataCorrectionBlock = ^(NSArray *tags) {
                    
                    [cell setTags:tags];
                    
                };
                tagMenuVC.viewModel.oldTagsBlock(cell.tags);
                
                CA_H_DISPATCH_MAIN_THREAD(^{
                    CA_H_WeakSelf(self);
                    [self.getControllerBlock() presentViewController:tagMenuVC animated:NO completion:^{
                        
                    }];
                });
            }
            
        }break;
        case 0:{
            if (![indexPath isEqual:_selectIndexPath]) {
                CA_HSaveFolderCell * oldCell = [tableView cellForRowAtIndexPath:_selectIndexPath];
                CA_HSaveFolderCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                
                _selectIndexPath = indexPath;
                oldCell.chooseIcon.hidden = YES;
                cell.chooseIcon.hidden = NO;
                
                [self changeButtonState];
            }
            
        }break;
        default:
            break;
    }
    
}

#pragma mark --- CheckDirectory

- (void (^)(void))checkDirectoryBlock {
    if (!_checkDirectoryBlock) {
        CA_H_WeakSelf(self);
        _checkDirectoryBlock = ^ {
            CA_H_StrongSelf(self);
            [self checkDirectory];
        };
    }
    return _checkDirectoryBlock;
}

- (void)checkDirectory {
    
    NSArray *history = [CA_H_UserDefaults objectForKey:CA_H_HistoryDirectory];
    if (!history.count) {
        if (_finishCheckBlock) {
            _finishCheckBlock(YES);
        }
        return;
    }
    
    NSMutableArray *mutArray = [NSMutableArray new];
    for (NSString *jsonStr in history) {
        [mutArray addObject:[CA_HBrowseFoldersModel modelWithJSON:jsonStr].file_id];
    }
    
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_AuthDirectory parameters:@{@"directory_id_list":mutArray} callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        BOOL set = NO;
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                set = YES;
                if ([netModel.data isKindOfClass:[NSArray class]]) {
                    if ([netModel.data count] != history.count) {
                        
                        NSMutableArray *mut = [NSMutableArray new];
                        for (NSNumber *number in netModel.data) {
                            NSInteger index = [mutArray indexOfObject:number];
                            if (index != NSNotFound) {
                                [mut addObject:history[index]];
                            }
                        }
                        [CA_H_UserDefaults setObject:mut forKey:CA_H_HistoryDirectory];
                        
                    }
                }
            }
        }
        if (self.finishCheckBlock) {
            self.finishCheckBlock(set);
        }
    } progress:nil];
}

#pragma mark --- CheckButton

- (void)changeButtonState {
    UIButton *button = (id)self.rightBarButtonItem.customView;
    if (_selectIndexPath
        &&
        self.files.count > 0
        &&
        self.updateFileManager.contents.count == 0) {
        button.enabled = YES;
    } else {
        button.enabled = NO;
    }
}

- (void)doneSave {
    
    CA_HBrowseFoldersModel *parentModel = self.folders[_selectIndexPath.row];
    
    NSMutableArray *mutArray = [NSMutableArray new];
    for (CA_HAddFileModel *model in self.files) {
        if (model.isFinish
            &&
            model.file_id) {
            
            NSMutableArray *tagsId = [NSMutableArray new];
            for (CA_HFileTagModel *tagsModel in model.tags) {
                [tagsId addObject:tagsModel.tag_id];
            }
            
            [mutArray addObject:@{@"file_id":model.file_id, @"tags_id":tagsId}];
        }
    }
    
    CA_H_WeakSelf(self);
    [CA_HNewFileManager newFile:parentModel.file_id parentPath:parentModel.file_path fileList:mutArray callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                
                [CA_HProgressHUD showHudStr:@"保存成功!"];
                
                if (self.backBlock) {
                    self.backBlock(YES);
                }
                return ;
            }
        }
        if (netModel.error.code != -999) {
        [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
    }
    }];
    
}

@end
