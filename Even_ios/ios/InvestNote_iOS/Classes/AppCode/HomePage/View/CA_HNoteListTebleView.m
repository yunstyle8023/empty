//
//  CA_HNoteListTebleView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/23.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HNoteListTebleView.h"

#import "CA_HNullView.h"
#import "CA_HNoteListCell.h"

#import "CA_MProjectModel.h" // 移动笔记

@interface CA_HNoteListTebleView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CA_HNoteListTebleView


#pragma mark --- Lazy

- (CA_HListNoteModel *)listNoteModel {
    if (!_listNoteModel) {
        CA_HListNoteModel *model = [CA_HListNoteModel new];
        _listNoteModel = model;
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(CA_H_RefreshType type) {
            CA_H_StrongSelf(self);
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
        };
    }
    return _listNoteModel;
}

#pragma mark --- LifeCircle

+ (instancetype)newWithProjectId:(NSNumber *)projectId objectType:(NSString *)objectType {
    CA_HNoteListTebleView *tableView = [self newTableViewGrouped];
    tableView.listNoteModel.objectId = projectId;
    tableView.listNoteModel.objectType = objectType;
    [CA_HProgressHUD loading:tableView];
    tableView.listNoteModel.loadMoreBlock(@"");
    [tableView upView];
    return tableView;
}

//- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
//{
//    self = [super initWithFrame:frame style:style];
//    if (self) {
//       
//    }
//    return self;
//}

#pragma mark --- Custom

- (void)upView{
    
    CA_H_WeakSelf(self);
    self.backgroundView = [CA_HNullView newTitle:@"记一下，好记性不如烂笔头"
                                     buttonTitle:@"添加笔记"
                                             top:99*CA_H_RATIO_WIDTH
                                        onButton:^{
                                            CA_H_StrongSelf(self);
                                            if (self.pushBlock) {
                                                self.pushBlock(@"CA_HAddNoteViewController", nil);
                                            }
                                        }
                                       imageName:@"empty_note"];
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerClass:[CA_HNoteListCell class] forCellReuseIdentifier:@"noteList"];
    
    self.delegate = self;
    self.dataSource = self;
    
    
    self.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
        CA_H_StrongSelf(self);
        self.listNoteModel.page_num = @(0);
        self.listNoteModel.loadMoreBlock(@"");
    }];
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        CA_H_StrongSelf(self);
        self.listNoteModel.loadMoreBlock(@"");
    }];
    
}

- (UIView *)headerView {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 50*CA_H_RATIO_WIDTH);
    
    CA_HSetButton *searchButton = [CA_HSetButton new];

    searchButton.backgroundColor = CA_H_F8COLOR;
    [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateHighlighted];
    searchButton.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    [searchButton setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [searchButton setTitle:@" 搜索" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(onSearchButton:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:searchButton];
    searchButton.sd_layout.spaceToSuperView(UIEdgeInsetsMake(15*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 5*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
    searchButton.sd_cornerRadiusFromHeightRatio = @(0.2);
    
    return view;
}

- (void)shareNote:(NSNumber *)noteId {
    
    if (!noteId) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
    }
    
    [CA_HProgressHUD showHud:nil];
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_ShareNote parameters:@{@"note_id":noteId} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    CA_H_StrongSelf(self);
                    
                    NSString *share_title = netModel.data[@"share_title"];
                    NSString *share_h5 = [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, netModel.data[@"share_h5"]];
                    
                    CA_H_WeakSelf(self);
                    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray * returnedItems, NSError * activityError)
                    {
                        CA_H_StrongSelf(self);
                        NSLog(@"activityType :%@", activityType);
                        
                        if ([activityType isEqualToString:@"CACustomActivityLong"]) {
                            self.pushBlock(@"CA_HLongViewController", @{@"noteId":noteId});
                        } else if ([activityType isEqualToString:@"CACustomActivityCopy"]) {
                            [CA_HProgressHUD showHudStr:CA_H_LAN(@"复制成功!")];
                            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                            pasteboard.string=share_h5;
                        }
                        
                        if (completed)
                        {
                            NSLog(@"completed");
                        }
                        else
                        {
                            NSLog(@"cancel");
                        }
                    };
                    
                    [CA_H_MANAGER share:myBlock text:share_title image:nil urlStr:share_h5];
                    
                    return ;
                }
            }
        }
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    } progress:nil];
}

- (void)moveNote:(CA_HListNoteContentModel *)model {
    
    if (!model) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
    }
    
    if (self.pushBlock) {
        CA_H_WeakSelf(self);
        self.pushBlock(@"CA_HMoveListViewController", @{@"objectId":model.object_id,@"doneBlock":^ (NSString *objectType, CA_MProjectModel *projectModel, void (^doneBlock)(void) ){
            CA_H_StrongSelf(self);
            
            NSDictionary *parameters = @{
                                         @"note_id":model.note_id,
                                         @"target_object_type":objectType,
                                         @"target_object_id":projectModel.project_id,
                                         @"target_note_type_id":model.note_type_id
                                         };
            
            [CA_HProgressHUD showHud:nil];
            CA_H_WeakSelf(self);
            [CA_HNetManager postUrlStr:CA_H_Api_MoveNote parameters:parameters callBack:^(CA_HNetModel *netModel) {
                [CA_HProgressHUD hideHud];
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.integerValue == 0) {
                        if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                            [CA_H_NotificationCenter postNotificationName:CA_H_RefreshNoteListNotification object:objectType];
                            if (doneBlock) {
                                doneBlock();
                            }
                            return ;
                        }
                    }
                }
                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                }
            } progress:nil];
        }});
    }
}

- (void)deleteNote:(NSNumber *)noteId indexPath:(NSIndexPath *)indexPath {
    if (!noteId) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
    }
    
    [CA_HProgressHUD showHud:nil];
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_DeleteNote parameters:@{@"note_id":noteId} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                CA_H_StrongSelf(self);
                NSMutableArray *mut = self.listNoteModel.data[indexPath.section];
                CA_H_WeakSelf(self);
                if (mut.count <= 1) {
                    [self.listNoteModel.data removeObjectAtIndex:indexPath.section];
                    CA_H_DISPATCH_MAIN_THREAD(^{
                        CA_H_StrongSelf(self);
                        [self deleteSection:indexPath.section withRowAnimation:UITableViewRowAnimationLeft];
                    });
                } else {
                    [mut removeObjectAtIndex:indexPath.row];
                    CA_H_DISPATCH_MAIN_THREAD(^{
                        CA_H_StrongSelf(self);
                        [self deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
                    });
                }
                return ;
            }
        }
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    } progress:nil];
}

#pragma mark --- action


- (void)onSearchButton:(UIButton *)sender{
    if (_pushBlock) {
        _pushBlock(@"CA_HHomeSearchViewController", @{@"buttonTitle":@"笔记"});
    }
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
    if (section) {
        return 40*CA_H_RATIO_WIDTH;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath model:self.listNoteModel.data[indexPath.section][indexPath.row] keyPath:@"model" cellClass:[CA_HNoteListCell class] contentViewWidth:tableView.width];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    tableView.backgroundView.hidden = (self.listNoteModel.data.count>0);
    self.mj_footer.hidden = !tableView.backgroundView.hidden;
    return self.listNoteModel.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listNoteModel.data[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString * identifier = @"noteListHeader";
    
    UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identifier];
        YYLabel * year = [YYLabel new];
        year.tag = 123;
        
        year.font = CA_H_FONT_PFSC_Regular(14);
        year.textColor = CA_H_9GRAYCOLOR;
        year.backgroundColor = CA_H_F8COLOR;
        year.textAlignment = NSTextAlignmentCenter;
        
        CA_H_WeakSelf(year);
        year.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(year);
            CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
            UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5*CA_H_RATIO_WIDTH,5*CA_H_RATIO_WIDTH)];//圆角大小
            CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = bounds;
            maskLayer.path = maskPath.CGPath;
            year.layer.mask = maskLayer;
        };
        
        [header.contentView addSubview:year];
        
        year.sd_layout
        .heightIs(30*CA_H_RATIO_WIDTH)
        .widthIs(70*CA_H_RATIO_WIDTH)
        .leftEqualToView(header.contentView)
        .bottomEqualToView(header.contentView);
    }
    
    UILabel * label = [header viewWithTag:123];
    label.text = [NSString stringWithFormat:@"%ld年", self.listNoteModel.data[section].firstObject.year];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_HNoteListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"noteList"];
    
    cell.isProject = [self.listNoteModel.objectType isEqualToString:@"project"];
    cell.isHuman = [self.listNoteModel.objectType isEqualToString:@"human"];
    
    cell.model = self.listNoteModel.data[indexPath.section][indexPath.row];
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.listNoteModel.objectType isEqualToString:@"person"];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CA_HListNoteContentModel *model = self.listNoteModel.data[indexPath.section][indexPath.row];
    
    // 添加一个删除按钮
    CA_H_WeakSelf(self);
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        CA_H_StrongSelf(self);
        NSLog(@"点击了删除");
        CA_H_WeakSelf(self);
        [self.viewController presentAlertTitle:nil message:CA_H_LAN(@"是否确认删除该笔记？") buttons:@[CA_H_LAN(@"取消"),CA_H_LAN(@"确认")] clickBlock:^(UIAlertController *alert, NSInteger index) {
            CA_H_StrongSelf(self);
            if (index == 1) {
                [self deleteNote:model.note_id indexPath:indexPath];
            }
        }];
        [tableView setEditing:NO animated:YES];
    }];
    deleteRowAction.backgroundColor = CA_H_F8COLOR;
    
    // 删除一个分享按钮
    UITableViewRowAction * shareRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"分享" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了分享");
        CA_H_StrongSelf(self);
        [self shareNote:model.note_id];
        [tableView setEditing:NO animated:YES];
    }];
    shareRowAction.backgroundColor = CA_H_F8COLOR;
    
    // 添加一个移动按钮
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"移动" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        CA_H_StrongSelf(self);
        NSLog(@"点击了移动");
        [self moveNote:model];
        [tableView setEditing:NO animated:YES];
    }];
    moreRowAction.backgroundColor = CA_H_F8COLOR;
    
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, shareRowAction, moreRowAction];
    
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configSwipeButtons:indexPath]; 
}


- (void)configSwipeButtons:(NSIndexPath *)indexPath
{
    // 获取选项按钮的reference
    if (@available(iOS 11.0, *)){
        
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        NSArray * images = CA_H_EDIT_IMAGES;
        
        for (UIView *subView in self.subviews)
        {
            if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subView.subviews count] >= images.count)
            {
                // 和iOS 10的按钮顺序相反
                for (NSInteger i = 0; i < images.count; i++) {
                    UIButton * button = subView.subviews[i];
                    [CA_HNoteListCell customButton:button title:button.titleLabel.text imageName:images[i]];
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HListNoteContentModel *model = self.listNoteModel.data[indexPath.section][indexPath.row];
    if (model.note_id&&_pushBlock) {
        _pushBlock(@"CA_HNoteDetailController", @{@"noteId":model.note_id});
    }
}

@end
