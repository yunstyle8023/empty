//
//  CA_HTodoListTableView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HTodoListTableView.h"

#import "CA_HNullView.h"
#import "CA_HTodoListCell.h"
#import "CA_HTodoNetModel.h"

@interface CA_HTodoListTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CA_H_TodoCellType type;

@end

@implementation CA_HTodoListTableView

#pragma mark --- Lazy

- (CA_HListTodoModel *)finishedModel {
    if (!_finishedModel) {
        CA_HListTodoModel *model = [CA_HListTodoModel new];
        _finishedModel = model;
        
        model.status = @"finish";
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(CA_H_RefreshType type) {
            CA_H_StrongSelf(self);
            self.FinishRequestType = type;
        };
        
        model.showFirstBlock = ^{
            CA_H_StrongSelf(self);
            [CA_HProgressHUD hideHud:self animated:NO];
            [CA_HProgressHUD loading:self];
        };
        
    }
    return _finishedModel;
}

- (CA_HListTodoModel *)unfinishedModel {
    if (!_unfinishedModel) {
        CA_HListTodoModel *model = [CA_HListTodoModel new];
        _unfinishedModel = model;
        
        model.status = @"ready";
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(CA_H_RefreshType type) {
            CA_H_StrongSelf(self);
            self.FinishRequestType = type;
        };
        
        model.showFirstBlock = ^{
            CA_H_StrongSelf(self);
            [CA_HProgressHUD hideHud:self animated:NO];
            [CA_HProgressHUD loading:self];
        };
        
    }
    return _unfinishedModel;
}

#pragma mark --- LifeCircle

+ (instancetype)newWithProjectId:(NSNumber *)projectId {
    CA_HTodoListTableView *tableView = [self newTableViewGrouped];
    if (projectId.integerValue == 0) {
        tableView.finishedModel.objectType = @"person";
        tableView.finishedModel.objectId = projectId;
        tableView.unfinishedModel.objectType = @"person";
        tableView.unfinishedModel.objectId = projectId;
    } else {
        tableView.finishedModel.objectType = @"project";
        tableView.finishedModel.objectId = projectId;
        tableView.unfinishedModel.objectType = @"project";
        tableView.unfinishedModel.objectId = projectId;
    }
    [tableView upView];
    return tableView;
}

//- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
//{
//    self = [super initWithFrame:frame style:style];
//    if (self) {
//        [self upView];
//    }
//    return self;
//}

#pragma mark --- Custom

- (void)updateTodoStatus:(CA_HListTodoContentModel *)clickModel clickCell:(CA_HTodoListCell *)clickCell {
    CA_H_WeakSelf(self);
    [CA_HTodoNetModel updateTodoStatus:clickModel.todo_id objectId:clickModel.object_id status:clickModel.status callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            
            if (netModel.errcode.integerValue == 0) {
                NSIndexPath *clickIndexPath = [self indexPathForCell:clickCell];
                if (self.type == CA_H_TodoCellTypeContinue) {
                    [self.unfinishedModel.data removeObjectAtIndex:clickIndexPath.row];
                    [CA_H_NotificationCenter postNotificationName:CA_H_RefreshTodoListNotification object:@"finish"];
                } else {
                    [self.finishedModel.data removeObjectAtIndex:clickIndexPath.row];
                    [CA_H_NotificationCenter postNotificationName:CA_H_RefreshTodoListNotification object:@"ready"];
                }
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [self deleteRowAtIndexPath:clickIndexPath withRowAnimation:UITableViewRowAnimationLeft];
                });
            }
        }
    }];
}

- (void)upView{
    CA_H_WeakSelf(self);
    self.backgroundView = [CA_HNullView newTitle:@"有事就去办"
                                     buttonTitle:@"添加待办"
                                             top:70*CA_H_RATIO_WIDTH
                                        onButton:^{
                                            CA_H_StrongSelf(self);
                                            if (self.pushBlock) {
                                                self.pushBlock(@"CA_HAddTodoViewController", nil);
                                            }
                                        } imageName:@"empty_todo"];
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerClass:[CA_HTodoListCell class] forCellReuseIdentifier:@"todoList"];
    
    self.rowHeight = 95*CA_H_RATIO_WIDTH;
    
    self.delegate = self;
    self.dataSource = self;
    
    self.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
        CA_H_StrongSelf(self);
        if (self.type == CA_H_TodoCellTypeContinue) {
            self.unfinishedModel.page_num = @(0);
            self.unfinishedModel.loadMoreBlock();
        } else {
            self.finishedModel.page_num = @(0);
            self.finishedModel.loadMoreBlock();
        }
    }];
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        CA_H_StrongSelf(self);
        if (self.type == CA_H_TodoCellTypeContinue) {
            self.unfinishedModel.loadMoreBlock();
        } else {
            self.finishedModel.loadMoreBlock();
        }
    }];
    
    UIView * header = [self tableView:self viewForHeaderInSection:0];
    header.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 55*CA_H_RATIO_WIDTH);
    _header = header;
    
}

- (void)setFinishRequestType:(CA_H_RefreshType)type {
    switch (type) {
        case CA_H_RefreshTypeNomore:
            [self.mj_footer endRefreshingWithNoMoreData];
            break;
        case CA_H_RefreshTypeFirst:
            [self.mj_footer resetNoMoreData];
        default:
            [self.mj_footer endRefreshing];
            break;
    }
    [self.mj_header endRefreshing];

    CA_H_WeakSelf(self);
    CA_H_DISPATCH_MAIN_THREAD(^{
        CA_H_StrongSelf(self);
        [self reloadData];
    });
    
    [CA_HProgressHUD performSelector:@selector(hideHud:) withObject:self afterDelay:0.5];
}


#pragma mark --- action

- (void)onHeader:(UIButton *)sender{
    
    if (!sender.selected) {
        
        _type = sender.tag - 100;
        
        if (_type == CA_H_TodoCellTypeContinue) {
            [self.finishedModel.dataTask cancel];
        } else {
            [self.unfinishedModel.dataTask cancel];
        }
        
        [self reloadData];
        
        UIButton * button = [sender.superview viewWithTag:201-sender.tag];
        UIView * whiteView = [sender.superview viewWithTag:1234];
        
        button.selected = NO;
        sender.selected = YES;
        
        CGPoint center = sender.center;
        center.x += (100.5-sender.tag)*2*CA_H_RATIO_WIDTH;
        whiteView.center = center;
        
    }
    
}

#pragma mark --- tableView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView *backView = self.backgroundView.subviews.firstObject;
    if (backView.centerX > 0) {
        backView.sd_closeAutoLayout = YES;
        backView.mj_y = -self.contentOffset.y;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 64*CA_H_RATIO_WIDTH;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_type == CA_H_TodoCellTypeContinue) {
        tableView.backgroundView.hidden = (self.unfinishedModel.data.count>0);
        self.mj_footer.hidden = !tableView.backgroundView.hidden;
        return self.unfinishedModel.data.count;
    } else {
        tableView.backgroundView.hidden = (self.finishedModel.data.count>0);
        self.mj_footer.hidden = !tableView.backgroundView.hidden;
        return self.finishedModel.data.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString * identifier = @"chooseHeader";
    
    UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identifier];
        
        UIView * backView = [UIView new];
        backView.backgroundColor = CA_H_F8COLOR;
        [header addSubview:backView];
        backView.sd_layout
        .heightIs(36*CA_H_RATIO_WIDTH)
        .topSpaceToView(header, 15*CA_H_RATIO_WIDTH)
        .leftSpaceToView(header, 20*CA_H_RATIO_WIDTH)
        .rightSpaceToView(header, 20*CA_H_RATIO_WIDTH);
        backView.sd_cornerRadius = @(6*CA_H_RATIO_WIDTH);
        
        UIView * whiteView = [UIView new];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.tag = 1234;
        whiteView.frame = CGRectMake(2*CA_H_RATIO_WIDTH, 2*CA_H_RATIO_WIDTH, 165*CA_H_RATIO_WIDTH, 32*CA_H_RATIO_WIDTH);
        [whiteView.layer setCornerRadius:4*CA_H_RATIO_WIDTH];
        [whiteView.layer setMasksToBounds:YES];
        [backView addSubview:whiteView];
        
        NSArray * titles = @[@"未完成",@"已完成"];
        for (NSString * title in titles) {
            CA_HSetButton * button = [CA_HSetButton new];
            
            [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
            [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateSelected];
            [button.titleLabel setFont:CA_H_FONT_PFSC_Regular(14)];
            [button setTitle:title forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(onHeader:) forControlEvents:UIControlEventTouchUpInside];
            
            NSInteger index = [titles indexOfObject:title];
            
            button.tag = 100 + index;
            button.selected = !index;
            
            CGFloat width = 335./2*CA_H_RATIO_WIDTH;
            button.frame = CGRectMake(index * width, 0, width, 36*CA_H_RATIO_WIDTH);
            
            [backView addSubview:button];
        }
    }
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_HTodoListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"todoList"];
    
    cell.type = _type;
    CA_HListTodoContentModel *model = [(_type?_finishedModel.data:_unfinishedModel.data) objectAtIndex:indexPath.row];
    cell.model = model;
    CA_H_WeakSelf(self);
    cell.clickBlock = ^(CA_HTodoListCell *clickCell) {
        CA_H_StrongSelf(self);
        [self updateTodoStatus:(id)clickCell.model clickCell:clickCell];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HListTodoContentModel *model = [(_type?_finishedModel.data:_unfinishedModel.data) objectAtIndex:indexPath.row];
    NSDictionary *dic = @{@"todo_id":model.todo_id,
                          @"object_id":model.object_id.integerValue?model.object_id:@"pass"};
    if (_pushBlock) {
        CA_H_WeakSelf(self);
        _pushBlock(@"CA_HTodoDetailViewController", @{@"dic":dic, @"deleteBlock":^{
            CA_H_StrongSelf(self);
            if (self.type == CA_H_TodoCellTypeContinue) {
                [self.unfinishedModel.data removeObjectAtIndex:indexPath.row];
            } else {
                [self.finishedModel.data removeObjectAtIndex:indexPath.row];
            }
            CA_H_DISPATCH_MAIN_THREAD(^{
                [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
            });
        }});
    }
}

#pragma mark --- Scroll



@end
