//
//  CA_HAddTodoViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAddTodoViewModel.h"

#import "CA_HAddTodoCell.h"
#import "CA_HTodoFileCell.h"

#import "CA_HTodoNetModel.h"

@interface CA_HAddTodoViewModel () 

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CA_HAddTodoViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (void)setDetailModel:(CA_HTodoDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.model.object_id = detailModel.object_id;
    self.model.objectName = detailModel.object_name;
    
    self.model.tag_level = detailModel.tag_level;
    self.model.tag_level_desc = detailModel.tag_level_desc;
    self.model.remind_time = detailModel.remind_time;
    self.model.remind_time_desc = detailModel.remind_time_desc;
    
    self.model.peoples = detailModel.member_list;
    NSMutableArray *mut = [NSMutableArray new];
    for (CA_HParticipantsModel *pModel in detailModel.member_list) {
        if ([pModel isKindOfClass:[CA_HParticipantsModel class]]) {
            [mut addObject:pModel.user_id];
        }
    }
    self.model.member_id_list = mut;
    
    self.model.ts_finish = detailModel.ts_finish;
    self.model.finishDate = [NSDate dateWithTimeIntervalSince1970:detailModel.ts_finish.longValue];
    
    self.model.todo_content = detailModel.todo_content;
    
    for (CA_HTodoDetailFileModel *fModel in detailModel.file_list) {
        if ([fModel isKindOfClass:[CA_HTodoDetailFileModel class]]) {
            CA_HAddFileModel *model = [CA_HAddFileModel new];
            model.isFinish = YES;
            
            model.file_id = fModel.file_id;
            model.file_url = fModel.file_url;
            model.fileName = fModel.file_name;
            
            model.createDate = [NSDate dateWithTimeIntervalSince1970:fModel.ts_create.longValue];
            
            double size = fModel.file_size.doubleValue;
            NSString * fileSize;
            if (size < 102.4) {
                fileSize = [NSString stringWithFormat:@"%.2fB", size];
            }else if (size < 102.4*1024) {
                fileSize = [NSString stringWithFormat:@"%.2fK", size/1024.0];
            }else {
                fileSize = [NSString stringWithFormat:@"%.2fM", size/1024.0/1024.0];
            }
            model.fileSize = fileSize;
            
            [self.files addObject:model];
        }
    }
    
    [self.tableView reloadData];
}

- (CA_HTodoModel *)model {
    if (!_model) {
        _model = [CA_HTodoModel new];
    }
    return _model;
}

- (UIBarButtonItem *(^)(id, SEL))rightBarButtonItemBlock {
    if (!_rightBarButtonItemBlock) {
        _rightBarButtonItemBlock = ^UIBarButtonItem *(id target, SEL action) {
            UIButton * button = [UIButton new];
            button.tag = 101;
            
            [button setTitle:CA_H_LAN(@"保存") forState:UIControlStateNormal];
            [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
            [button setTitleColor:CA_H_4DISABLEDCOLOR forState:UIControlStateDisabled];
            [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
            
            button.titleLabel.sd_resetLayout
            .centerYEqualToView(button)
            .rightEqualToView(button)
            .autoHeightRatio(0);
            button.titleLabel.numberOfLines = 1;
            [button.titleLabel setMaxNumberOfLinesToShow:1];
            [button.titleLabel setSingleLineAutoResizeWithMaxWidth:70];
            
            button.frame = CGRectMake(0, 0, 70, 44);
            
            [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//            button.enabled = NO;
            
            return barButtonItem;
        };
    }
    return _rightBarButtonItemBlock;
}

- (UIView *(^)(id))titleViewBlock {
    if (!_titleViewBlock) {
        _titleViewBlock = ^UIView *(id delegate) {
            
            UIView *view = [UIView new];
            
            view.backgroundColor = [UIColor whiteColor];
            CA_H_WeakSelf(view);
            view.didFinishAutoLayoutBlock = ^(CGRect frame) {
                CA_H_StrongSelf(view);
                [CA_HShadow dropShadowWithView:view
                                        offset:CGSizeMake(0, 3)
                                        radius:3
                                         color:CA_H_SHADOWCOLOR
                                       opacity:0.3];
            };
            
            UIButton *button = [UIButton new];
            button.tag = 101;
            [button setBackgroundImage:[UIImage imageNamed:@"unfinished"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"finished"] forState:UIControlStateSelected];
            button.userInteractionEnabled = NO;
            
            [view addSubview:button];
            button.sd_layout
            .widthIs(26*CA_H_RATIO_WIDTH)
            .heightEqualToWidth()
            .topSpaceToView(view, 5*CA_H_RATIO_WIDTH)
            .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH);
            
            
            UITextField *textField = [UITextField new];
            textField.tag = 102;
            
            textField.font = CA_H_FONT_PFSC_Medium(18);
            textField.textColor = CA_H_4BLACKCOLOR;
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:CA_H_LAN(@"待办标题")];
            attr.font = textField.font;
            attr.color = CA_H_9GRAYCOLOR;
            textField.attributedPlaceholder = attr;
            
            textField.returnKeyType = UIReturnKeyDone;
            
            [textField addTarget:delegate action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            if (@available(iOS 11.0, *)) {
                UIView * view = [textField valueForKey:@"textContentView"];
                view.sd_resetLayout
                .spaceToSuperView(UIEdgeInsetsZero);
            }else {
                textField.adjustsFontSizeToFitWidth = YES;
            }
            
            textField.delegate = delegate;
            
            [view addSubview:textField];
            textField.sd_layout
            .heightIs(25*CA_H_RATIO_WIDTH)
            .leftSpaceToView(view, 54*CA_H_RATIO_WIDTH)
            .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH)
            .centerYEqualToView(button);
            
            return view;
        };
    }
    return _titleViewBlock;
}

- (UITableView *(^)(id))tableViewBlock {
    if (!_tableViewBlock) {
        CA_H_WeakSelf(self);
        _tableViewBlock = ^UITableView *(id delegate) {
            CA_H_StrongSelf(self);
            UITableView * tableView = [UITableView newTableViewPlain];
            self.tableView = tableView;
            
            tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight+20*CA_H_RATIO_WIDTH, 0);
            
            UIView * view = [UIView new];
            view.frame = CGRectMake(0, 0, CA_H_RATIO_WIDTH, 5.5*CA_H_RATIO_WIDTH);
            tableView.tableHeaderView = view;
            
            [tableView registerClass:[CA_HAddTodoCell class] forCellReuseIdentifier:@"cell"];
            [tableView registerClass:[CA_HAddTodoCell class] forCellReuseIdentifier:@"cellPeople"];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.bounces = NO;
            
            tableView.delegate = delegate;
            tableView.dataSource = delegate;
            
            return tableView;
        };
    }
    return _tableViewBlock;
}

- (NSMutableArray *)files {
    if (!_files) {
        _files = [NSMutableArray new];
    }
    return _files;
}

- (CA_HUpdateFileManager *)updateFileManager {
    if (!_updateFileManager) {
        _updateFileManager = [CA_HUpdateFileManager new];
    }
    return _updateFileManager;
}


#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)setAddFile:(CA_HAddFileModel *)addFile{
    
    addFile.createDate = [NSDate date];
    
//    [self.updateFileManager.contents addObject:addFile];
//    self.updateFileManager.updateBlock();
    
    CA_H_WeakSelf(self);
    [self.updateFileManager saveToTmp:addFile success:^{
        CA_H_StrongSelf(self);
        
        [self.updateFileManager update:addFile];
        
        [self.files addObject:addFile];
//        NSInteger row = self.files.count;
        CA_H_WeakSelf(self);
        CA_H_DISPATCH_MAIN_THREAD(^{
            CA_H_StrongSelf(self);
//            [self.tableView insertRow:row inSection:3 withRowAnimation:UITableViewRowAnimationLeft];
//            [self.tableView scrollToRow:row inSection:3 atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
            [self.tableView reloadSection:CA_H_AddTodoTypeFile-1 withRowAnimation:UITableViewRowAnimationNone];
        });
    } failed:^{
        
    }];
}

- (void)setTodoName:(NSString *)todoName {
    
    self.model.todo_name = todoName;
    
    NSMutableArray *mut = [NSMutableArray new];
    for (CA_HAddFileModel *model in self.files) {
        if (model.isFinish) {
            [mut addObject:model.file_id];
        }
    }
    self.model.file_id_list = mut;
    
    if (self.detailModel.todo_id) {
        [CA_HTodoNetModel updateTodo:self.detailModel.todo_id model:self.model callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    [CA_H_NotificationCenter postNotificationName:CA_H_RefreshTodoListNotification object:self.detailModel.status?:@"ready"];
                    if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                        if (self.pushDetailBlock) {
                            self.pushDetailBlock(netModel.data, YES);
                        }
                        return;
                    }
                }
            }
            if (netModel.error.code != -999) {
                [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
            }
        }];
    } else {
        [CA_HTodoNetModel createTodo:self.model callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                        [CA_H_NotificationCenter postNotificationName:CA_H_RefreshTodoListNotification object:@"ready"];
                        if (self.pushDetailBlock) {
                            self.pushDetailBlock(netModel.data, NO);
                        }
                        return;
                    }
                }
            }
            if (netModel.error.code != -999) {
                [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
            }
        }];
    }
}

- (void)loadParams:(void (^)(BOOL success))block {
    CA_H_WeakSelf(self);
    [CA_HTodoNetModel listTaskParams:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    
                    self.remindData = netModel.data[@"remind_data"];
                    self.tagData = netModel.data[@"tag_data"];
                    
                    if (block) block(YES);
                    return;
                }
            }
        }
        
        if (block) block(NO);
        
        if (netModel.error.code != -999) {
            if (netModel.errmsg.length) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    }];
}

#pragma mark --- Table

- (UITableViewCell *(^)(UITableView *, NSIndexPath *))cellForRowBlock {
    if (!_cellForRowBlock) {
        CA_H_WeakSelf(self);
        _cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            CA_H_StrongSelf(self);
            
            UITableViewCell * cell;
            if (indexPath.row == 0) {
                NSString *identifier = indexPath.section==1?@"cellPeople":@"cell";
                CA_HAddTodoCell * todoCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                todoCell.type = indexPath.section;
                todoCell.model = self.model;
                
                cell = todoCell;
            } else {
                CA_HAddFileModel *model = self.files[indexPath.row-1];
                
                CA_HTodoFileCell *fileCell = [tableView dequeueReusableCellWithIdentifier:@"todoFIleCell"];
                if (!fileCell) {
                    fileCell = [[CA_HTodoFileCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"todoFIleCell"];
                    CA_H_WeakSelf(self);
                    fileCell.deleteBlock = ^(CA_HTodoFileCell *deleteCell) {
                        CA_H_StrongSelf(self);
                        
                        NSIndexPath * deleteIndexPath = [tableView indexPathForCell:deleteCell];
                        [self.files removeObjectAtIndex:deleteIndexPath.row-1];
                        [tableView deleteRowAtIndexPath:deleteIndexPath withRowAnimation:UITableViewRowAnimationLeft];
                        
                    };
                }
                fileCell.model = model;
                
                cell = fileCell;
            }
            
            return cell;
        };
    }
    return _cellForRowBlock;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
}

@end
