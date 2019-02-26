//
//  CA_MNewProjectContentVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectContentVC.h"
#import "CA_MNewProjectContentViewManager.h"
#import "CA_MNewProjectContentViewModel.h"
#import "CA_MProjectContentSelectView.h"
#import "CA_MProjectContentScrollView.h"
#import "CA_MProjectMemberView.h"
#import "CA_MProjectAddMemberVC.h"
#import "CA_MNavigationController.h"
#import "CA_MProjectDetailVC.h"
#import "CA_HBrowseFoldersViewModel.h"
#import "CA_MNewSearchProjectVC.h"

@interface CA_MNewProjectContentVC ()
<
UIScrollViewDelegate,
CA_MProjectMemberViewDelegate
>

@property (nonatomic,strong) CA_MNewProjectContentViewManager *viewManager;

@property (nonatomic,strong) CA_MNewProjectContentViewModel *viewModel;

@end

@implementation CA_MNewProjectContentVC

#pragma mark --- Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.viewManager.scrollView.viewModel.updateFileManager.contents.count>0) {
        return NO;
    }
    
    CGPoint point = [gestureRecognizer locationInView:self.view];
    
    if (CGRectContainsPoint(self.viewManager.scrollView.frame, point)) {
        return (self.viewManager.scrollView.contentOffset.x == 0);
    }
    return YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
    
    [self viewModel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

-(void)upView{
    
//    self.navigationItem.rightBarButtonItems = self.viewManager.barButtonItems;

    [self.view addSubview:self.viewManager.scrollView];
    self.viewManager.scrollView.sd_layout
    .topSpaceToView(self.view, 56*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.view)
    .widthIs(CA_H_SCREEN_WIDTH)
    .bottomEqualToView(self.view);
    
    [self.view addSubview:self.viewManager.topView];
    self.viewManager.topView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .widthIs(CA_H_SCREEN_WIDTH)
    .heightIs(56*2*CA_H_RATIO_WIDTH);
    [CA_HFoundFactoryPattern showShadowWithView:self.viewManager.topView];
    
}

-(void)setLocation:(ProjectLocation)location{
    _location = location;
    
    if (location == CA_MProject_Trace) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewManager.topView buttonAction:self.viewManager.topView.buttons[location]];
    });
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.viewManager.topView didScroll:scrollView.contentOffset.x];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.viewManager.topView didEndScroll:scrollView.contentOffset.x];
}

#pragma mark - CA_MProjectMemberViewDelegate

/**
 添加主管或者成员
 
 @param isAddManage 是否是添加主管
 */
- (void)addPerson:(BOOL)isAddManage{
    CA_MProjectAddMemberVC *addMemberVC = [[CA_MProjectAddMemberVC alloc] init];
    CA_MNavigationController *navi = [[CA_MNavigationController alloc] initWithRootViewController:addMemberVC];
    addMemberVC.project_id = self.pId;
    addMemberVC.member_type = isAddManage ?  @"manager" : @"member";//可添加成员列表为"member",可添加主管列表为"manager"
    addMemberVC.addManage = isAddManage;
    CA_H_WeakSelf(self);
    addMemberVC.block = ^{
        CA_H_StrongSelf(self);
        self.viewModel.loadMemberDataBlock();
    };
    
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self presentViewController:navi animated:YES completion:nil];
    });
}

/**
 点击成员操作
 
 @param model member_type_id 1-管理员 2-主管 3-普通成员 0-其他
 */
- (void)didSelectMember:(CA_MMemberModel*)model{
    
    if (self.self.viewModel.model.member_type_id.intValue == 3) {
        return;
    }
    
    UIAlertAction *manageAction = [UIAlertAction actionWithTitle:@"设为主管" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateMemberRole:model member_type_id:@2];
    }];
    UIAlertAction *adminAction = [UIAlertAction actionWithTitle:@"设为管理员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateMemberRole:model member_type_id:@1];
    }];
    UIAlertAction *memberAction = [UIAlertAction actionWithTitle:@"设为成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateMemberRole:model member_type_id:@3];
    }];
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"移除成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"是否确认移除当前成员"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self deleteMember:model];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        CA_H_DISPATCH_MAIN_THREAD(^{
            [self presentViewController:alert animated:YES completion:nil];
        });
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    NSMutableArray* actions = @[].mutableCopy;
    
    if (model.member_type_id.intValue == 1) {
        //设为主管
        [actions addObject:manageAction];
        //设为成员
        [actions addObject:memberAction];
        //移除成员
        [actions addObject:removeAction];
    }else if(model.member_type_id.intValue == 2){
        //设为管理员
        [actions addObject:adminAction];
        //设为成员
        [actions addObject:memberAction];
        //移除成员
        [actions addObject:removeAction];
    }else{
        //设为主管
        [actions addObject:manageAction];
        //设为管理员
        [actions addObject:adminAction];
        //移除成员
        [actions addObject:removeAction];
    }
    //取消操作
    [actions addObject:cancelAction];
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (UIAlertAction* action in actions) {
        [actionSheetController addAction:action];
    }
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self presentViewController:actionSheetController animated:YES completion:nil];
    });
    
}

-(void)updateMemberRole:(CA_MMemberModel*)model member_type_id:(NSNumber*)member_type_id{
    CA_H_WeakSelf(self)
    [self.viewModel updateMemberRoleWithPid:self.pId user_id:model.user_id member_type_id:member_type_id block:^{
        CA_H_StrongSelf(self)
        self.viewModel.loadMemberDataBlock();
    }];
}

-(void)deleteMember:(CA_MMemberModel*)model{
    CA_H_WeakSelf(self)
    [self.viewModel deleteMemberWithPid:self.pId user_id:model.user_id block:^{
        CA_H_StrongSelf(self)
        self.viewModel.loadMemberDataBlock();
    }];
}

/**
 关注/取消关注项目操作
 */
-(void)updateAttentionStatus{
    CA_H_WeakSelf(self)
    [self.viewModel updateFollowProjectWithPid:self.pId is_follow:(!self.viewModel.model.is_follow) block:^{
        CA_H_StrongSelf(self)
        self.viewModel.model.is_follow = !self.viewModel.model.is_follow;
        self.refreshBlock ? self.refreshBlock(self.pId) : nil;
    }];
    
}

/**
 更改项目隐私 公开权限
 */
-(void)updateProjectPrivacy{
    CA_H_WeakSelf(self)
    NSString* privacyStr = [self.viewModel.model.privacy isEqualToString:@"secret"]?@"public":@"secret";
    [self.viewModel updateProjectPrivacyWithPid:self.pId privacy:privacyStr block:^(NSString *result){
        CA_H_StrongSelf(self)
        self.viewModel.model.privacy = result;
        NSString *text = [self.viewModel.model.privacy isEqualToString:@"secret"]?CA_H_LAN(@"已设置为隐私项目"):CA_H_LAN(@"已设置为公开项目");
        CGSize size = CGSizeMake(124*CA_H_RATIO_WIDTH, CA_H_MANAGER.xheight+64+48*CA_H_RATIO_WIDTH);
        [CA_HShadow showUpdate:YES text:text size:size];
    }];
}

-(void)handleProject:(BOOL)isDel{
    CA_H_WeakSelf(self)
    [self.viewModel deleteOrQuitProjectWithPid:self.pId isDel:isDel block:^(void) {
        CA_H_StrongSelf(self)
        self.refreshBlock?self.refreshBlock(self.pId):nil;
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - getter and setter

-(CA_MNewProjectContentViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MNewProjectContentViewManager new];
        _viewManager.pId = self.pId;
        _viewManager.scrollView.delegate = self;
        _viewManager.memberView.delegate = self;
        
        CA_H_WeakSelf(self)
        _viewManager.topView.didSelect = ^(NSInteger index) {
            CA_H_StrongSelf(self)
            [self.viewManager.scrollView setContentOffset:CGPointMake(index*CA_H_SCREEN_WIDTH, 0) animated:YES];
        };
        _viewManager.topView.jumpBlock = ^{
            CA_H_StrongSelf(self)
            
            CA_MProjectDetailVC *detailVC = [CA_MProjectDetailVC new];
            detailVC.model = self.viewModel.model;
            [self.navigationController pushViewController:detailVC animated:YES];
        };
        _viewManager.memberBlock = ^{
            CA_H_StrongSelf(self)
            [self.navigationController.view addSubview:self.viewManager.memberView];
            [self.viewManager.memberView showMember:YES];
        };
        _viewManager.settingBlock = ^{
            CA_H_StrongSelf(self)
            //添加/取消关注项目
            NSString *attentionStr = self.viewModel.model.is_follow ? @"取消关注":@"关注项目";
            NSString *attentionTitle = [NSString stringWithFormat:@"%@",attentionStr];
            UIAlertAction *attentionAction = [UIAlertAction actionWithTitle:attentionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateAttentionStatus];
            }];
            //修改关联项目
            UIAlertAction *updateRelationAction = [UIAlertAction actionWithTitle:@"修改关联项目" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CA_MNewSearchProjectVC *searchProjectVC = [CA_MNewSearchProjectVC new];
                searchProjectVC.project_id = self.pId;
                searchProjectVC.finishedBlock = ^{
                    CA_H_StrongSelf(self)
                    NSLog(@"关联成功!!!");
                    [CA_H_NotificationCenter postNotificationName:@"RelationSuccess" object:nil];
                };
                
                CA_MNavigationController *nav = [[CA_MNavigationController alloc] initWithRootViewController:searchProjectVC];
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [self presentViewController:nav animated:YES completion:nil];
                });
            }];
            
            //设为公开隐私
            NSString* privacy = ![self.viewModel.model.privacy isEqualToString:@"secret"] ? @"公开" : @"私密";
            NSString* title = [self.viewModel.model.privacy isEqualToString:@"secret"] ? @"公开" : @"私密";
            title = [NSString stringWithFormat:@"项目%@-设为%@",privacy,title];
            UIAlertAction *settingAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateProjectPrivacy];
            }];
            
            //退出项目
            UIAlertAction *outAction = [UIAlertAction actionWithTitle:@"退出项目" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                NSString* message = [self.viewModel.model.privacy isEqualToString:@"secret"]?@"确认退出？私有项目退出后对你不再可见":@"确认退出?";
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [self handleProject:NO];
                                                                      }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action) {
                                                                         
                                                                     }];
                [alert addAction:cancelAction];
                [alert addAction:defaultAction];
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }];
            
            //删除项目
            UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除项目" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:@"确认删除项目?"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [self handleProject:YES];
                                                                      }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action) {
                                                                         
                                                                     }];
                [alert addAction:cancelAction];
                [alert addAction:defaultAction];
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }];
            
            //取消
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            
            NSMutableArray* actions = @[].mutableCopy;
            
            if (self.viewModel.model.member_type_id.intValue == 3) {
                [actions addObject:attentionAction];
                [actions addObject:updateRelationAction];
                [actions addObject:outAction];
            }else{
                [actions addObject:attentionAction];
                [actions addObject:updateRelationAction];
                [actions addObject:settingAction];
                [actions addObject:outAction];
                [actions addObject:delAction];
            }
            [actions addObject:cancelAction];
            
            UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            for (UIAlertAction* action in actions) {
                [actionSheetController addAction:action];
            }

            CA_H_DISPATCH_MAIN_THREAD(^{
                [self presentViewController:actionSheetController animated:YES completion:nil];
            });
        };
        
        _viewManager.scrollView.pushBlock = ^ CA_HBaseViewController * (NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            if (classStr) {
                UIViewController * vc = [NSClassFromString(classStr) new];
                [vc setValuesForKeysWithDictionary:kvcDic];
                [self.navigationController pushViewController:vc animated:YES];
            }
            return self;
        };
        
        //侧滑返回手势防止拦截
        UIGestureRecognizer * screenEdgePanGestureRecognizer = self.navigationController.interactivePopGestureRecognizer;
        if(screenEdgePanGestureRecognizer)
            [_viewManager.scrollView.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
    }
    return _viewManager;
}

-(CA_MNewProjectContentViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MNewProjectContentViewModel new];
        _viewModel.loadingView = CA_H_MANAGER.mainWindow;
        _viewModel.pId = self.pId;
        _viewModel.loadDataBlock();
        _viewModel.loadMemberDataBlock();
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^{
            CA_H_StrongSelf(self)
            
            if (!self.viewModel.model) {
                for (UIView *tmpView in self.view.subviews) {
                    [tmpView removeFromSuperview];
                }
                [CA_HProgressHUD showHudStr:@"此项目已被删除"];
                return ;
            }
            
            if (self.viewModel.model.member_type_id.intValue == 0) {
                self.navigationItem.rightBarButtonItem = self.viewManager.memberItem;
            }else{
                self.navigationItem.rightBarButtonItems = self.viewManager.barButtonItems;
            }
            
            self.viewManager.topView.model = self.viewModel.model;
            self.viewManager.scrollView.model = self.viewModel.model;
        };
        _viewModel.memberBlock = ^{
            CA_H_StrongSelf(self)
            self.viewManager.memberView.member_type_id = self.viewModel.memberModel.member_type_id;
            self.viewManager.memberView.memberModel = self.viewModel.memberModel;
        };
    }
    return _viewModel;
}


@end
