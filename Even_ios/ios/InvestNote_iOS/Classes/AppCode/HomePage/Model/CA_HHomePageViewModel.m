//
//  CA_HHomePageViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/21.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HHomePageViewModel.h"

#import "CA_HAddMenuView.h"

@interface CA_HHomePageViewModel ()

@property (nonatomic, copy) CA_HAddMenuView *addMenuView;

@property (nonatomic, strong) CA_HListFileModel *listFileModel;

@end

@implementation CA_HHomePageViewModel


#pragma mark --- Lazy

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"日程", @"待办", @"文件", @"笔记"];
    }
    return _titles;
}
    
- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_34"]];
    }
    return _titleView;
}

- (UIBarButtonItem *)rightNavBarButton{
    if (!_rightNavBarButton) {
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:kImage(@"add") forState:UIControlStateNormal];
        [rightButton setImage:kImage(@"add") forState:UIControlStateHighlighted];
        [rightButton sizeToFit];
        [rightButton addTarget: self action: @selector(addBarButton:) forControlEvents: UIControlEventTouchUpInside];
        _rightNavBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//        _rightNavBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBarButton:)];
    }
    return _rightNavBarButton;
}

//日程
- (CA_HScheduleListVC *)scheduleList {
    if (!_scheduleList) {
        _scheduleList = [CA_HScheduleListVC new];
        _scheduleList.pushBlock = self.pushBlock;
    }
    return _scheduleList;
}


// 笔记
- (CA_HNoteListTebleView *)noteTableView{
    if (!_noteTableView) {
        _noteTableView = [CA_HNoteListTebleView newWithProjectId:nil objectType:nil];
        _noteTableView.tableHeaderView = _noteTableView.headerView;
        [_noteTableView sendSubviewToBack:_noteTableView.tableHeaderView];
        _noteTableView.pushBlock = _pushBlock;
        
        _noteTableView.contentInset = UIEdgeInsetsMake(0, 0, 70*CA_H_RATIO_WIDTH, 0);
    }
    return _noteTableView;
}


// 待办

- (UIView *)todoView{
    if (!_todoView) {
        UIView * view = [UIView new];
        
        [view addSubview:self.todoTableView];
        [view addSubview:self.todoTableView.header];
        
        self.todoTableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(self.todoTableView.header.mj_h, 0, 0, 0));
        
        _todoView = view;
    }
    return _todoView;
}

- (CA_HTodoListTableView *)todoTableView{
    if (!_todoTableView) {
        _todoTableView = [CA_HTodoListTableView newWithProjectId:(id)@"pass"];
        _todoTableView.pushBlock = _pushBlock;
        
        _todoTableView.contentInset = UIEdgeInsetsMake(0, 0, 70*CA_H_RATIO_WIDTH, 0);
    }
    return _todoTableView;
}

// 文件
- (CA_HListFileModel *)listFileModel {
    if (!_listFileModel) {
        CA_HListFileModel *model = [CA_HListFileModel new];
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(BOOL success, BOOL noMore) {
            CA_H_StrongSelf(self);
            [self.fileTableView.mj_header endRefreshing];
            if (noMore) {
                [self.fileTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.fileTableView.mj_footer endRefreshing];
            }
            if (success) {
                
                if (self.listFileModel.page_num.integerValue == 1) {
                    [self.fileTableView.data removeAllObjects];
                }
                [self.fileTableView.data addObjectsFromArray:self.listFileModel.data_list];
                [self.fileTableView reloadData];
            }
            
            [CA_HProgressHUD performSelector:@selector(hideHud:) withObject:self.fileTableView afterDelay:0.5];
        };
        
        _listFileModel = model;
    }
    return _listFileModel;
}
- (CA_HFileListTableView *)fileTableView{
    if (!_fileTableView) {
        _fileTableView = [CA_HFileListTableView newTableViewGrouped];
        _fileTableView.searchType = CA_HFileSearchTypeButton;
        
        CA_H_WeakSelf(self);
        _fileTableView.pushBlock = ^(NSIndexPath *indexPath) {
            CA_H_StrongSelf(self);
            if (self.pushBlock) {
                if (indexPath) {
                    if (indexPath.section == 0) {
                        return ;
                    }
                    CA_HBrowseFoldersModel *model = self.fileTableView.data[indexPath.row];
                    if ([model.file_type isEqualToString:@"directory"]) {
                        self.pushBlock(@"CA_HBrowseFoldersViewController", @{@"model":model});
                    }
                }else{
                    self.pushBlock(@"CA_HHomeSearchViewController", @{@"buttonTitle":@"文件"});
                }
            }
        };
        
        _fileTableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.listFileModel.loadDataBlock(@[@"/"], nil);
        }];
        
        _fileTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.listFileModel loadMore];
        }];
        
        [CA_HProgressHUD loading:_fileTableView];
        self.listFileModel.loadDataBlock(@[@"/"], nil);
        
        _fileTableView.contentInset = UIEdgeInsetsMake(0, 0, 70*CA_H_RATIO_WIDTH, 0);
    }
    return _fileTableView;
}

#pragma mark --- Custom

- (void)hideMenu:(BOOL)animated{
    [self.noteTableView setEditing:NO animated:animated];
    [_addMenuView hideMenu:animated];
    _addMenuView = nil;
}

- (void)reloadData {
    //登录更新
    //笔记
    [self.noteTableView.listNoteModel.data removeAllObjects];
    [self.noteTableView reloadData];
    [CA_HProgressHUD hideHud:self.noteTableView animated:NO];
    [CA_HProgressHUD loading:self.noteTableView];
    self.noteTableView.listNoteModel.page_num = @(0);
    self.noteTableView.listNoteModel.loadMoreBlock(@"");
    //待办
    [self.todoTableView.unfinishedModel.data removeAllObjects];
//    self.todoTableView.unfinishedModel.data = nil;
    [self.todoTableView.finishedModel.data removeAllObjects];
//    self.todoTableView.finishedModel.data = nil;
    [self.todoTableView reloadData];
    self.todoTableView.unfinishedModel.showFirstBlock();
    self.todoTableView.finishedModel.showFirstBlock();
    self.todoTableView.unfinishedModel.page_num = @(0);
    self.todoTableView.unfinishedModel.loadMoreBlock();
    self.todoTableView.finishedModel.page_num = @(0);
    self.todoTableView.finishedModel.loadMoreBlock();
    
    //文件
    self.listFileModel.data_list = nil;
    [self.fileTableView.data removeAllObjects];
    [self.fileTableView reloadData];
    [CA_HProgressHUD hideHud:self.fileTableView animated:NO];
    [CA_HProgressHUD loading:self.fileTableView];
    self.listFileModel.loadDataBlock(@[@"/"], nil);
    
    //日程
    [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule_screeningChange" object: @"reset" userInfo:@{}];
}


#pragma mark --- Action

- (void)addBarButton:(UIBarButtonItem *)sender{
    
    if (_addMenuView) {
        [self hideMenu:YES];
    }else {
        if (_getControllerBlock) {
            _addMenuView = [CA_HAddMenuView new];
            
            CA_HHomePageViewController * hvc = _getControllerBlock();
            CA_H_WeakSelf(self);
            _addMenuView.clickBlock = ^(NSInteger item) {
                CA_H_StrongSelf(self);

                if (self.pushBlock) {
                    switch (item) {
                        case 0:
                            self.pushBlock(@"CA_HAddNoteViewController", nil);
                            break;
                        case 1:
                            self.pushBlock(@"CA_HAddTodoViewController",nil);
                            break;
                        case 2:
                            self.pushBlock(@"CA_HAddFileViewController",nil);
                            break;
                        default:
                            break;
                    }

                }

                [self hideMenu:YES];
            };
            _addMenuView.frame = hvc.view.bounds;
            _addMenuView.data = @[@"笔记",
                                  @"待办",
                                  @"文件"];
            [hvc.view addSubview:_addMenuView];
            [_addMenuView showMenu:YES];
            
            [self.noteTableView setEditing:NO animated:YES];
        }
    }
}



@end
