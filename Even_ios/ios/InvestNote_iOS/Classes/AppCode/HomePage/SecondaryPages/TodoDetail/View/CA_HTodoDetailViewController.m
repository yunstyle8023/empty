//
//  CA_HTodoDetailViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HTodoDetailViewController.h"

#import "CA_HChooseParticipantsViewController.h"
#import "CA_HTodoNetModel.h"

#import "CA_HAddTodoViewController.h"

#import "CA_MProjectDetailVC.h"
#import "CA_MProjectModel.h"

@interface CA_HTodoDetailViewController () <YYTextKeyboardObserver>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) BOOL isKeyboard;

@end

@implementation CA_HTodoDetailViewController

#pragma mark --- Action
- (void)onButton:(UIButton *)sender {
    switch (sender.tag) {
        case 100: //评论
            self.viewModel.onReplyBlock(NO);
            break;
        case 101: //编辑
            [self editTodo];
            break;
        case 102: //跳转
            [self gotoDetail];
            break;
        case 103: //删除
        {
            [self presentAlertTitle:nil message:CA_H_LAN(@"是否确认删除该待办？") buttons:@[CA_H_LAN(@"取消"), CA_H_LAN(@"确认")] clickBlock:^(UIAlertController *alert, NSInteger index) {
                if (index == 1) {
                    [self deleteTodo];
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark --- Lazy

//- (void)setDic:(NSDictionary *)dic {
////    @{@"todo_id":model.todo_id,
////      @"object_id":model.object_id};
//    if (!_dic) {
//        _dic = dic;
//        self.viewModel.loadDetailBlock(dic[@"todo_id"], dic[@"object_id"]);
//    }
//}

- (CA_HTodoDetailViewModel *)viewModel {
    if (!_viewModel) {
        CA_HTodoDetailViewModel *viewModel = [CA_HTodoDetailViewModel new];
        _viewModel = viewModel;
        
        CA_H_WeakSelf(self);
        viewModel.deleteCommentBlock = ^(CA_HReplyCell *cell) {
            CA_H_StrongSelf(self);
            [self presentAlertTitle:nil message:CA_H_LAN(@"是否删除该条评论？") buttons:@[CA_H_LAN(@"否"), CA_H_LAN(@"是")] clickBlock:^(UIAlertController *alert, NSInteger index) {
                if (index == 1) {
                    CA_H_StrongSelf(self);
                    [self deleteTodoComment:cell];
                }
            }];
        };
        
        viewModel.onKeyboardBlock = ^(BOOL isSend) {
            CA_H_StrongSelf(self);
            
            if (!isSend) {
                CA_HChooseParticipantsViewController *vc = [CA_HChooseParticipantsViewController new];
                //选中所有人
                vc.title = CA_H_LAN(@"选择要提醒的成员");
                vc.viewModel.projectId = self.viewModel.model.object_id;
                vc.viewModel.isAll = YES;
                CA_H_WeakSelf(self);
                vc.viewModel.backBlock = ^(NSArray *people) {
                    CA_H_StrongSelf(self);
                    self.viewModel.People = people;
                };
                self.isKeyboard = YES;
                [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:^{
                    
                }];
            }
        };
        
        viewModel.borwseFileControllerBlock = ^(NSNumber *fileId, NSString *fileName, NSString *fileUrl) {
            CA_H_StrongSelf(self);
            self.viewModel.borwseFileBlock(fileId, fileName, fileUrl, self);
        };
        
        viewModel.getDetailBlock = ^{
            CA_H_StrongSelf(self);
            if (self.view.subviews.count < 2) {
                [self upView];
            }
        };
        
        viewModel.buttonViewBlock = ^(UIView *buttonView) {
            CA_H_StrongSelf(self);
            [self.viewModel buttonView:buttonView target:self action:@selector(onButton:)];
        };
        
    }
    return _viewModel;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = self.viewModel.titleViewBlock();
    }
    return _titleView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = self.viewModel.bottomViewBlock();
    }
    return _bottomView;
}

- (UIView *)middleView {
    if (!_middleView) {
        _middleView = self.viewModel.middleViewBlock();
    }
    return _middleView;
}


#pragma mark --- LifeCircle

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
    if (_isKeyboard) {
        [self.viewModel.textView becomeFirstResponder];
    }
    _isKeyboard = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    if (self.dic.allKeys.count<3) {
        self.viewModel.loadDetailBlock(self.dic[@"todo_id"], self.dic[@"object_id"], self.view);
    } else {
        self.viewModel.DetailDic = self.dic;
    }
    
}

#pragma mark --- Custom

- (void)deleteTodoComment:(CA_HReplyCell *)cell {
    CA_HTodoDetailCommentModel *model = (id)cell.model;
    CA_H_WeakSelf(self);
    [CA_HTodoNetModel deleteTodoComment:self.viewModel.model.todo_id objectId:self.viewModel.model.object_id conmmentId:model.comment_id callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                NSIndexPath *indexPath = [self.viewModel.tableView indexPathForCell:cell];
                [self.viewModel.model.comment_list removeObjectAtIndex:indexPath.row];
                CA_H_WeakSelf(self);
                CA_H_DISPATCH_MAIN_THREAD(^{
                    CA_H_StrongSelf(self);
                    [self.viewModel.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
                });
                return ;
            }
        }
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    }];
}

- (void)upView {
    
    [self.view addSubview:self.middleView];
    [self.view addSubview:self.titleView];
    
    if (self.viewModel.model.privilege.count != 0) {
        [self.view addSubview:self.bottomView];
        self.bottomView.sd_layout
        .heightIs(48*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
        .bottomEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view);
    }
    
    self.titleView.sd_layout
//    .heightIs(44*CA_H_RATIO_WIDTH)
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
    self.middleView.sd_layout
    .topSpaceToView(self.titleView, 0)
    .bottomSpaceToView(self.viewModel.model.privilege.count==0?self.view:self.bottomView, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
    [self performSelector:@selector(gotoComment) withObject:nil afterDelay:0.1];
}

- (void)gotoComment {
    if (self.viewModel.commentId) {
        for (CA_HTodoDetailCommentModel *model in self.viewModel.model.comment_list) {
            if ([model.comment_id isEqualToNumber:self.viewModel.commentId]) {
                self.viewModel.commentId = nil;
                NSInteger index = [self.viewModel.model.comment_list indexOfObject:model];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
                [self.viewModel.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                break;
            }
        }
    }
}

- (void)deleteTodo {
    CA_H_WeakSelf(self);
    [CA_HTodoNetModel deleteTodo:self.viewModel.model callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if (self.deleteBlock) {
                    self.deleteBlock();
                }
                [CA_H_NotificationCenter postNotificationName:CA_H_RefreshTodoListNotification object:self.viewModel.model.status];
                [CA_HProgressHUD showHudStr:CA_H_LAN(@"删除成功")];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    }];
}

- (void)editTodo {
    CA_HAddTodoViewController *vc = [CA_HAddTodoViewController new];
    vc.detailModel = self.viewModel.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoDetail{
    CA_MProjectModel *model = [CA_MProjectModel new];
    model.project_id = self.viewModel.model.object_id;
    CA_MProjectDetailVC* detailVC = [[CA_MProjectDetailVC alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark --- Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.viewModel.textView resignFirstResponder];
}

#pragma mark --- Keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    
    if (transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            [self.viewModel openKeyboard:rect.size.height];
            clipped = YES;
        }
    }
    
    if (!clipped) {
        [self.viewModel closeKeyboard];
    }
}

@end
