//
//  CA_HFileListTableView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HFileListTableView.h"

#import "CA_HNullView.h"

#import "CA_HFileListCell.h"
#import "CA_HFolderFileCell.h"
#import "CA_HScreeningCell.h"
#import "CA_HAddFileCell.h"

#import "CA_HNewFileManager.h"
#import "CA_HAddFileModel.h"

@interface CA_HFileListTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * searchScreening;

@end

@implementation CA_HFileListTableView

#pragma mark --- Lazy

- (NSMutableArray *)uploads {
    if (!_uploads) {
        _uploads = [NSMutableArray new];
    }
    return _uploads;
}

- (NSMutableArray<CA_HBrowseFoldersModel *> *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

- (NSMutableArray *)files{
    if (!_files) {
        _files = [NSMutableArray new];
    }
    return _files;
}

- (NSMutableArray *)folders{
    if (!_folders) {
        _folders = [NSMutableArray new];
    }
    return _folders;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark --- Custom

- (void)deleteCell:(CA_HAddFileCell *)deleteCell indexPath:(NSIndexPath *)indexPath isDelete:(BOOL) isDelete {
    if (isDelete) {
//        NSIndexPath * deleteIndexPath = [self indexPathForCell:deleteCell];
//        [self.uploads removeObjectAtIndex:deleteIndexPath.row];
        [self.uploads removeObject:deleteCell.model];
        NSLog(@"----- %@ -- %@ --", @(self.uploads.count), [(id)deleteCell.model fileName]);
        CA_H_WeakSelf(self);
        CA_H_DISPATCH_MAIN_THREAD(^{
            CA_H_StrongSelf(self);
            [self reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
//            [self deleteRowAtIndexPath:deleteIndexPath withRowAnimation:UITableViewRowAnimationLeft];
        });
    } else {
        [self newFile:deleteCell];
    }
}

- (void)newFile:(CA_HAddFileCell *)cell {
    
    if (!cell) return;
    
    CA_HAddFileModel *doneModel = (id)cell.model;
    CA_H_WeakSelf(self);
    [CA_HNewFileManager newFile:doneModel.parent_id parentPath:doneModel.parent_path fileList:@[@{@"file_id":doneModel.file_id, @"tags_id":@[]}] callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                
                if ([netModel.data isKindOfClass:[NSArray class]]) {
                    
                    BOOL needToadd = NO;
                    NSInteger begin = 0;
                    
                    if (self.data.count == 0) {
                        needToadd = YES;
                        begin = 0;
                    } else if ([self.data.lastObject.file_type isEqualToString:@"directory"]) {
                        if (self.mj_footer.state == MJRefreshStateNoMoreData) {
                            needToadd = YES;
                            begin = self.data.count;
                        } else {
                            needToadd = NO;
                        }
                    } else {
                        needToadd = YES;
                        for (NSInteger i = 0; i < self.data.count; i++) {
                            if (i >= self.data.count) {
                                needToadd = NO;
                                break;
                            }
                            CA_HBrowseFoldersModel *beginModel = self.data[i];
                            if ([beginModel.file_type isEqualToString:@"file"]) {
                                begin = i;
                                break;
                            }
                        }
                    }
                    
                    if (needToadd) {
                        
                        NSMutableArray *dataArray = [NSMutableArray new];
                        NSMutableArray *indexPaths = [NSMutableArray new];
                        for (NSDictionary *dic in netModel.data) {
                            [indexPaths addObject:[NSIndexPath indexPathForRow:dataArray.count+begin inSection:1]];
                            [dataArray addObject:[CA_HBrowseFoldersModel modelWithDictionary:dic]];
                        }
                        
                        CA_H_WeakSelf(self);
                        CA_H_DISPATCH_MAIN_THREAD(^{
                            CA_H_StrongSelf(self);
                            [self.uploads removeObject:doneModel];
                            [self reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
                            [self.data insertObjects:dataArray atIndex:begin];
                            [self reloadDataWithInsertingDataAtTheBeginingOfSection:1 newDataCount:dataArray.count];
                        });
                    } else {
                        CA_H_WeakSelf(self);
                        CA_H_DISPATCH_MAIN_THREAD(^{
                            CA_H_StrongSelf(self);
                            [self.uploads removeObject:doneModel];
                            [self reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
                        });
                    }
                    
                }
                return ;
            }
        }
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    }];
}

- (void)upView{
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerClass:[CA_HFileListCell class] forCellReuseIdentifier:@"default"];
    [self registerClass:[CA_HFileListCell class] forCellReuseIdentifier:@"folder"];
    [self registerClass:[CA_HFolderFileCell class] forCellReuseIdentifier:@"file"];
    [self registerClass:[CA_HScreeningCell class] forCellReuseIdentifier:@"screening"];
    [self registerClass:[CA_HAddFileCell class] forCellReuseIdentifier:@"upload"];
    
    self.delegate = self;
    self.dataSource = self;
    
}

- (void)nullTitle:(NSString *)title
      buttonTitle:(NSString *)buttonTitle
              top:(CGFloat)top
         onButton:(void(^)(void))block
        imageName:(NSString *)imageName {
    self.backgroundView = [CA_HNullView newTitle:title buttonTitle:buttonTitle top:top onButton:block imageName:imageName];
}

#pragma mark --- action


- (void)onSearchButton:(UIButton *)sender{
    if (_pushBlock) {
        _pushBlock(nil);
    }
}

- (void)onSearchScreening:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.bounces = !sender.selected;
    self.rowHeight = sender.selected?(CA_H_SCREEN_HEIGHT-64-CA_H_MANAGER.xheight-50*CA_H_RATIO_WIDTH-self.tableHeaderView.mj_h-self.tableFooterView.mj_h):65*CA_H_RATIO_WIDTH;
    [self reloadData];
}

#pragma mark --- tableView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView *backView = self.backgroundView.subviews.firstObject;
    if (backView.centerX > 0) {
        backView.sd_closeAutoLayout = YES;
        backView.mj_y = -self.contentOffset.y;
    }

    if (self.scrollBlock) {
        self.scrollBlock(scrollView);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_searchType&&section==0) {
        return 50*CA_H_RATIO_WIDTH;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 65*CA_H_RATIO_WIDTH;
    }
    
    CA_HBrowseFoldersModel *model = self.data[indexPath.row];
    
    if ([model.file_type isEqualToString:@"directory"]) {
        return 65*CA_H_RATIO_WIDTH;
    } else {
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CA_HFolderFileCell class] contentViewWidth:tableView.width];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_searchScreening.selected) {
        tableView.backgroundView.hidden = YES;
//        self.mj_footer.hidden = !tableView.backgroundView.hidden;
        return 1;
    }
    
    tableView.backgroundView.hidden = (self.uploads.count+self.data.count>0);
//    self.mj_footer.hidden = !tableView.backgroundView.hidden;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_searchScreening.selected) {
        return 1;
    }
    if (section == 1) {
        return self.data.count;
    }
    return self.uploads.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString * identifier = @"searchHeader";
    
    UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identifier];
        CA_HSetButton * searchButton = [CA_HSetButton new];
        
        searchButton.backgroundColor = CA_H_F8COLOR;
        [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateHighlighted];
        searchButton.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
        [searchButton setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [searchButton setTitle:@" 搜索" forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(onSearchButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [header.contentView addSubview:searchButton];
        
        searchButton.sd_cornerRadiusFromHeightRatio = @(0.2);
        
        if (_searchType == CA_HFileSearchTypeScreening) {
            
            UIButton * button = [UIButton new];
            
            button.imageView.sd_resetLayout
            .widthIs(18*CA_H_RATIO_WIDTH)
            .heightEqualToWidth()
            .centerYEqualToView(button.imageView.superview)
            .centerXEqualToView(button.imageView.superview);
            
            [button setImage:[UIImage imageNamed:@"screen_icon"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"screen_icon2"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onSearchScreening:) forControlEvents:UIControlEventTouchUpInside];
            
            _searchScreening = button;
            
            [header.contentView addSubview:button];
            
            searchButton.sd_layout
            .spaceToSuperView(UIEdgeInsetsMake(15*CA_H_RATIO_WIDTH, 58*CA_H_RATIO_WIDTH, 5*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
            
            button.sd_layout
            .widthIs(58*CA_H_RATIO_WIDTH)
            .heightEqualToWidth()
            .centerYEqualToView(searchButton)
            .leftEqualToView(header.contentView);
            
            
        }else if (_searchType == CA_HFileSearchTypeButton) {
            searchButton.sd_layout
            .spaceToSuperView(UIEdgeInsetsMake(15*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 5*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
        }
        
    }
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_searchScreening.selected) {
        CA_HScreeningCell * cell = [tableView dequeueReusableCellWithIdentifier:@"screening"];
        
        CA_H_WeakSelf(self);
        cell.doneBlock = ^{
            CA_H_StrongSelf(self);
            
            [self onSearchScreening:self.searchScreening];
        };
        
        return cell;
    }
    
    if (indexPath.section == 0) {
        CA_HAddFileCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"upload%ld", indexPath.row]];
        if (!cell) {
            cell = [[CA_HAddFileCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"upload%ld", indexPath.row]];
        }
                                 
        cell.noChange = YES;
        CA_H_WeakSelf(self);
        cell.deleteBlock = ^(CA_HAddFileCell *deleteCell, BOOL isDelete) {
            CA_H_StrongSelf(self);
            [self deleteCell:deleteCell indexPath:indexPath isDelete:isDelete];
            
        };
        cell.model = self.uploads[indexPath.row];
        return cell;
    }
    
    CA_HBrowseFoldersModel *model = self.data[indexPath.row];
    
    NSString * identifier;
    if ([model.file_type isEqualToString:@"directory"]) {
        identifier = (model.creator.user_id.integerValue==0)?@"default":@"folder";
    } else {
        identifier = @"file";
    }
    
    CA_HFileListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.editBlock = _editBlock;
    cell.model = model;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_searchScreening.selected) {
        return;
    }
    
    if (indexPath.section == 1) {
        CA_HBrowseFoldersModel *model = self.data[indexPath.row];
        if ([model.path_option indexOfObject:@"preview"]==NSNotFound) {
            return;
        }
    }
    
    if (_pushBlock) {
        _pushBlock(indexPath);
    }
}




@end
