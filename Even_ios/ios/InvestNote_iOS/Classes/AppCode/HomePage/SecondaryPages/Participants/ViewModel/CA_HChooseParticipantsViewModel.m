//
//  CA_HChooseParticipantsViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HChooseParticipantsViewModel.h"
#import "CA_HParticipantsCell.h"
#import "CA_HNoteNetManager.h"

@interface CA_HChooseParticipantsViewModel ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CA_HChooseParticipantsViewModel

#pragma mark --- Action

- (void (^)(BOOL))onButtonBlock {
    if (!_onButtonBlock) {
        CA_H_WeakSelf(self);
        _onButtonBlock = ^ (BOOL isDone) {
            CA_H_StrongSelf(self);
            if (isDone
                &&
                self.backBlock) {
                NSMutableArray *peoples = [NSMutableArray new];
                for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
                    NSInteger index = indexPath.row - self.isAll;
                    if (index < 0) {
//                        [peoples addObject:@""];
                        self.backBlock(self.data);
                        return ;
                    } else {
                        [peoples addObject:self.data[index]];
                    }
                }
                self.backBlock(peoples);
            }
        };
    }
    return _onButtonBlock;
}

#pragma mark --- Lazy

- (NSMutableArray<CA_HParticipantsModel *> *)data {
    if (!_data) {
        _data = [NSMutableArray new];
        CA_H_WeakSelf(self);
        
        if (self.projectId.integerValue) {
            [CA_HTodoNetModel listMember:self.projectId callBack:^(CA_HNetModel *netModel) {
                CA_H_StrongSelf(self);
                [self dataWithNetModel:netModel];
            }];
        } else {
            [CA_HNoteNetManager listCompanyUser:^(CA_HNetModel *netModel) {
                CA_H_StrongSelf(self);
                [self dataWithNetModel:netModel];
            }];
        }
    }
    return _data;
}

- (UIBarButtonItem *(^)(id, SEL))leftBarButtonItemBlock {
    if (!_leftBarButtonItemBlock) {
        _leftBarButtonItemBlock = ^UIBarButtonItem *(id target, SEL action) {
            UIButton * button = [UIButton new];
            button.tag = 100;
            
            [button setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
            [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
            [button setTitleColor:CA_H_4DISABLEDCOLOR forState:UIControlStateDisabled];
            [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
            
            button.titleLabel.sd_resetLayout
            .centerYEqualToView(button)
            .leftEqualToView(button)
            .autoHeightRatio(0);
            button.titleLabel.numberOfLines = 1;
            [button.titleLabel setMaxNumberOfLinesToShow:1];
            [button.titleLabel setSingleLineAutoResizeWithMaxWidth:70];
            
            button.frame = CGRectMake(0, 0, 70, 44);
            
            [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
            
            return barButtonItem;
        };
    }
    return _leftBarButtonItemBlock;
}

- (UIBarButtonItem *(^)(id, SEL))rightBarButtonItemBlock {
    if (!_rightBarButtonItemBlock) {
        CA_H_WeakSelf(self);
        _rightBarButtonItemBlock = ^UIBarButtonItem *(id target, SEL action) {
            CA_H_StrongSelf(self);
            UIButton * button = [UIButton new];
            button.tag = 101;
            
            [button setTitle:CA_H_LAN(@"完成") forState:UIControlStateNormal];
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
            
            if (self.isAll) {
                button.enabled = NO;
            }
            
            return barButtonItem;
        };
    }
    return _rightBarButtonItemBlock;
}


- (void (^)(UIView *))changeRightBarBlock {
    if (!_changeRightBarBlock) {
        CA_H_WeakSelf(self);
        _changeRightBarBlock = ^ (UIView *barView) {
            CA_H_StrongSelf(self);
            if (self.isAll) {
                UIButton *button = (id)barView;
                button.enabled = (self.tableView.indexPathsForSelectedRows.count > 0);
            }
        };
    }
    return _changeRightBarBlock;
}

- (UITableView *(^)(id))tableViewBlock {
    if (!_tableViewBlock) {
        CA_H_WeakSelf(self);
        _tableViewBlock = ^UITableView *(id delegate) {
            CA_H_StrongSelf(self);
            UITableView * tableView = [UITableView newTableViewPlain];
            self.tableView = tableView;
            UIView * view = [UIView new];
            view.frame = CGRectMake(0, 0, CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH);
            tableView.tableHeaderView = view;
            
            [tableView registerClass:[CA_HParticipantsCell class] forCellReuseIdentifier:@"cell"];
            if (self.isAll) {
                [tableView registerClass:[CA_HParticipantsCell class] forCellReuseIdentifier:@"isAll"];
            }
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
            tableView.rowHeight = 70*CA_H_RATIO_WIDTH;
            
            tableView.allowsMultipleSelection = !self.isAll;
            
            tableView.delegate = delegate;
            tableView.dataSource = delegate;
            
            return tableView;
        };
    }
    return _tableViewBlock;
}




#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)dataWithNetModel:(CA_HNetModel *)netModel {
    
    if (netModel.type == CA_H_NetTypeSuccess) {
        if (netModel.errcode.integerValue == 0) {
            if ([netModel.data isKindOfClass:[NSArray class]]) {
                NSMutableArray *selects = [NSMutableArray new];
                for (NSDictionary *dic in netModel.data) {
                    CA_HParticipantsModel *model = [CA_HParticipantsModel modelWithDictionary:dic];
                    if (self.selectId) {
                        NSInteger index = [self.selectId indexOfObject:model.user_id];
                        if (index != NSNotFound ) {
                            [selects addObject:[NSIndexPath indexPathForRow:self.data.count inSection:0]];
                        }
                    }
                    [self.data addObject:model];
                }
                CA_H_WeakSelf(self);
                CA_H_DISPATCH_MAIN_THREAD(^{
                    CA_H_StrongSelf(self);
                    [self.tableView reloadData];
                    for (NSIndexPath *indexPath in selects) {
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                    }
                });
            }
            return ;
        }
    }
    if (netModel.error.code != -999) {
        [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
    }
}

#pragma mark --- Table

- (UITableViewCell *(^)(UITableView *, NSIndexPath *))cellForRowBlock {
    if (!_cellForRowBlock) {
        CA_H_WeakSelf(self);
        _cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            CA_H_StrongSelf(self);
            if (self.isAll&&indexPath.row == 0) {
                CA_HParticipantsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"isAll"];
                cell.model = @"";
                return cell;
            }
            
            CA_HParticipantsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.model = self.data[indexPath.row-self.isAll];
            return cell;
        };
    }
    return _cellForRowBlock;
}

@end
