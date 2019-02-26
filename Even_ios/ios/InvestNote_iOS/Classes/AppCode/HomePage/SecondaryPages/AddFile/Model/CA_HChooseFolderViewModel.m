//
//  CA_HChooseFolderViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HChooseFolderViewModel.h"

#import "CA_HFileListTableView.h"

#import "CA_HNewFolderManager.h"

@interface CA_HChooseFolderViewModel ()

@property (nonatomic, strong) NSMutableArray * tableViews;
@property (nonatomic, strong) CA_HListFileModel *model;

@end

@implementation CA_HChooseFolderViewModel

#pragma mark --- Action

- (void)onButton:(UIButton *)sender{
    
    if (sender.tag == 100) {
        [self createDirectory:sender.superview.tag-300];
    }else if (sender.tag == 101){
        if (_chooseBlock) {
            if (self.parentModel) {
                _chooseBlock(self.parentModel);
            } else {
                _chooseBlock(_model.model_list[sender.superview.tag-300]);
            }
        }
    }
    
}

#pragma mark --- Lazy

- (void (^)(void))loadDataBlock {
    if (!_loadDataBlock) {
        CA_H_WeakSelf(self);
        _loadDataBlock = ^ {
            CA_H_StrongSelf(self);
            [self model];
        };
    }
    return _loadDataBlock;
}

- (CA_HListFileModel *)model {
    if (!_model) {
        CA_HListFileModel *model = [CA_HListFileModel new];
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(BOOL success, BOOL noMore) {
            CA_H_StrongSelf(self);
            
            if (self.finishRequestBlock) {
                self.finishRequestBlock(success, noMore);
            }
            
            if (self.tableViews.count > 0) {
                CA_HFileListTableView *tableView = nil;
                
                if (self.parentModel) {
                    tableView = self.tableViews.firstObject;
                } else {
                    for (CA_HBrowseFoldersModel *mList in self.model.model_list) {
                        if ([mList.file_id isEqualToNumber:self.model.current_dir_id]) {
                            mList.page_num = self.model.page_num;
                            
                            NSString *title = mList.file_name;
                            if ([title hasSuffix:@"文件夹"]&&title.length>3) {
                                title = [title substringToIndex:title.length-3];
                            }
                            NSInteger item = [self.titles indexOfObject:title];
                            if (item < self.tableViews.count) {
                                tableView = self.tableViews[item];
                            } else {
                                return;
                            }
                            break;
                        }
                    }
                }
                
                [tableView.mj_header endRefreshing];
                if (noMore) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [tableView.mj_footer endRefreshing];
                }
                
                if (success) {
                    if (self.model.page_num.integerValue == 1) {
                        [tableView.data removeAllObjects];
                    }
                    [tableView.data addObjectsFromArray:self.model.data_list];
                    
                    CA_H_DISPATCH_MAIN_THREAD(^{
                        [tableView reloadData];
                    });
                    
                }
                [CA_HProgressHUD hideHud:tableView];
            }
            
        };
        
        if (self.parentModel) {
            model.loadDataBlock(self.parentModel.file_path, nil);
        } else {
            [model loadChooseData:nil page_num:@1];
        }
        
        _model = model;
    }
    return _model;
}

- (NSString *)title{
    return CA_H_LAN(@"选择文件夹");
}

- (NSArray *)titles{
    if (!_titles) {
        
        NSMutableArray *array = [NSMutableArray new];
        for (CA_HBrowseFoldersModel *model in self.model.model_list) {
            
            NSString *title = model.file_name;
            if ([title hasSuffix:@"文件夹"]&&title.length>3) {
                title = [title substringToIndex:title.length-3];
            }
            
            [array addObject:title];
        }
        
        _titles = array;
    }
    return _titles;
}

- (NSMutableArray *)tableViews{
    if (!_tableViews) {
        _tableViews = [NSMutableArray new];
    }
    return _tableViews;
}

#pragma mark --- Custom

- (UIView *)fileListView:(NSInteger)item{
    
    CA_HFileListTableView * tableView = [CA_HFileListTableView newTableViewGrouped];
    [self.tableViews addObject:tableView];
    
    CA_H_WeakSelf(self);
    CA_H_WeakSelf(tableView);
    tableView.pushBlock = ^(NSIndexPath *indexPath) {
        CA_H_StrongSelf(self);
        CA_H_StrongSelf(tableView);
        if (indexPath.section == 1) {
            CA_HBrowseFoldersModel *model = tableView.data[indexPath.row];
            if ([model.file_type isEqualToString:@"directory"]) {
                if (self.pushBlock) {
                    self.pushBlock(@"CA_HChooseFolderListViewController", model);
                }
            }
        }
        
    };
    
    tableView.searchType = CA_HFileSearchTypeNone;
    
    
    NSString *null_msg = @"暂无文件";
    NSInteger index = NSNotFound;
    
    [tableView.data removeAllObjects];
    
    if (self.parentModel) {
        
        tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.model.loadDataBlock(self.parentModel.file_path, nil);
        }];
        
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.model loadMore];
        }];
        
        [tableView.data addObjectsFromArray:self.model.data_list];
        if (self.parentModel.null_msg.length>0) {
            null_msg = self.parentModel.null_msg;
        }
        index = [self.parentModel.path_option indexOfObject:@"create"];
    } else {
        CA_HBrowseFoldersModel *model = self.model.model_list[item];
        
        tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.model loadChooseData:model.file_id page_num:@1];
        }];
        
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.model loadChooseData:model.file_id page_num:@(model.page_num.integerValue+1)];
        }];
        
        if ([model.file_id isEqualToNumber:self.model.current_dir_id]) {
            [tableView.data addObjectsFromArray:self.model.data_list];
        } else {
            [CA_HProgressHUD loading:tableView];
            [self.model loadChooseData:model.file_id page_num:@1];
        }
        null_msg = model.null_msg;
        index = [model.path_option indexOfObject:@"create"];
        model.page_num = @1;
    }
    
    tableView.mj_header.ignoredScrollViewContentInsetTop = 10*CA_H_RATIO_WIDTH;
    
    [tableView nullTitle:null_msg buttonTitle:nil top:135*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_file"];
    
    if (index != NSNotFound) {
        UIView * view = [UIView new];
        UIView * bottomView = [self bottomView];
        bottomView.tag = 300+item;
        [view addSubview:tableView];
        [view addSubview:bottomView];
        
        tableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 56*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight, 0));
        bottomView.sd_layout
        .topSpaceToView(tableView, 0)
        .leftEqualToView(view)
        .rightEqualToView(view)
        .bottomEqualToView(view);
        
        tableView.contentInset = UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 0, 0, 0);
        
        return view;
    }
    
    tableView.contentInset = UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 0, CA_H_MANAGER.xheight, 0);
    
    return tableView;
}

- (UIView *)bottomView{
    UIView * view = [UIView new];
    
    UIButton * new = [UIButton new];
    CA_H_ViewBorderRadius(new, 4*CA_H_RATIO_WIDTH, 0.5*CA_H_RATIO_WIDTH, CA_H_TINTCOLOR);
    new.backgroundColor = [UIColor whiteColor];
    [new setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
    [new.titleLabel setFont:CA_H_FONT_PFSC_Regular(15)];
    [new setTitle:CA_H_LAN(@"新建文件夹") forState:UIControlStateNormal];
    new.tag = 100;
    [new addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * choose = [UIButton new];
    choose.backgroundColor = CA_H_TINTCOLOR;
    [choose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [choose.titleLabel setFont:CA_H_FONT_PFSC_Regular(15)];
    [choose setTitle:CA_H_LAN(@"选择") forState:UIControlStateNormal];
    choose.tag = 101;
    [choose addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:new];
    [view addSubview:choose];
    
    new.sd_layout
    .topSpaceToView(view, 8*CA_H_RATIO_WIDTH)
    .leftSpaceToView(view, 10*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(view, 10*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    
    choose.sd_layout
    .topSpaceToView(view, 8*CA_H_RATIO_WIDTH)
    .leftSpaceToView(new, 7*CA_H_RATIO_WIDTH)
    .rightSpaceToView(view, 10*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(view, 10*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    choose.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    
    view.sd_equalWidthSubviews = @[new, choose];
    
    
    return view;
}

- (void)createDirectory:(NSInteger)item {
    
    if (_getControllerBlock) {
        
        NSNumber *parentId;
        NSArray *parentPath;
        
        if (self.parentModel) {
            parentId = self.parentModel.file_id;
            parentPath = self.parentModel.file_path;
        } else {
            parentId = _model.model_list[item].file_id;
            parentPath = _model.model_list[item].file_path;
        }
        
        CA_H_WeakSelf(self);
        [CA_HNewFolderManager newFolder:parentId parentPath:parentPath callBack:^(CA_HNetModel *netModel) {
            CA_H_StrongSelf(self);
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    
                    if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                        CA_HFileListTableView *tableView = self.tableViews[item];
                        [tableView.data insertObject:[CA_HBrowseFoldersModel modelWithDictionary:netModel.data] atIndex:0];
                        
                        NSIndexPath *indexPathZero = [NSIndexPath indexPathForRow:0 inSection:1];
                        [tableView insertRowAtIndexPath:indexPathZero withRowAnimation:UITableViewRowAnimationLeft];
                        [tableView scrollToRowAtIndexPath:indexPathZero atScrollPosition:UITableViewScrollPositionNone animated:YES];
                        
                        return ;
                    }
                }
                
            }
            
            if (netModel.error.code != -999) {
                [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
            }
            
        } controller:_getControllerBlock()];
        
    }
}

@end
