//
//  CA_HNoteDetailController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteDetailController.h"

#import "CA_HNoteDetailNewViewManager.h"

#import "CA_HNoteInformationViewController.h" //笔记详情信息页
#import "CA_HBorwseFileManager.h" //预览附件
#import "CA_HLongViewController.h" //生成长图
#import "CA_MProjectDetailVC.h" //前往项目
#import "CA_HAddNoteViewController.h" //编辑笔记
#import "CA_HChooseParticipantsViewController.h" //选择联系人

@interface CA_HNoteDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HNoteDetailNewViewManager *viewManager;

@end

@implementation CA_HNoteDetailController

#pragma mark --- Action

- (void)ca_backAction {
    [self.modelManager commentContent];
    [super ca_backAction];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    [self.modelManager commentContent];
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (void)onBarButton:(UIButton *)sender {
    CA_HNoteInformationViewController *vc = [CA_HNoteInformationViewController new];
    vc.viewModel.model = self.modelManager.model;
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}

- (void)onButton:(UIButton *)sender {
    switch (sender.tag) {
        case 100:// 评论
            [self.viewManager onReplyButton];
            break;
        case 101:// 分享
            [self.modelManager share];
            break;
        case 102:// 更多
        {
            CA_H_WeakSelf(self);
            [self presentActionSheetTitle:nil message:nil buttons:self.modelManager.actionSheets clickBlock:^(UIAlertController *alert, NSInteger index) {
                CA_H_StrongSelf(self);
                NSString *str = self.modelManager.actionSheets[index];
                if ([str isKindOfClass:[NSArray class]]) {
                    CA_H_WeakSelf(self);
                    [self presentAlertTitle:nil message:CA_H_LAN(@"是否确认删除该笔记？") buttons:@[CA_H_LAN(@"取消"),CA_H_LAN(@"确认")] clickBlock:^(UIAlertController *alert, NSInteger index) {
                        CA_H_StrongSelf(self);
                        if (index == 1) {
                            [self.modelManager deleteNote];
                        }
                    }];
                } else {
                    self.modelManager.OnActionSheet = index;
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)onKeyboardView:(UIButton *)sender {
    if (sender == self.viewManager.remindButton) {
        CA_HChooseParticipantsViewController *vc = [CA_HChooseParticipantsViewController new];
        //选中所有人
        vc.title = CA_H_LAN(@"选择要提醒的成员");
        vc.viewModel.projectId = [self.modelManager.model.object_type isEqualToString:@"project"]?self.modelManager.model.object_id:@(0);
        vc.viewModel.isAll = YES;
        CA_H_WeakSelf(self);
        vc.viewModel.backBlock = ^(NSArray *people) {
            CA_H_StrongSelf(self);
            self.viewManager.people = people;
            [self.viewManager.textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.26];
        };
//        self.isKeyboard = YES;
        [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:^{
            
        }];
    } else if (sender == self.viewManager.sendButton) {
        [self.viewManager.textView resignFirstResponder];
        [self.modelManager addComment:self.viewManager.textView.text];
    }
}

#pragma mark --- Lazy

- (CA_HNoteDetailModelManager *)modelManager {
    if (!_modelManager) {
        CA_HNoteDetailModelManager *object = [CA_HNoteDetailModelManager new];
        _modelManager = object;
        
        CA_H_WeakSelf(self);
        object.loadDataBlock = ^ {
            CA_H_StrongSelf(self);
            [self.viewManager reloadCellsData:self.modelManager.model];
            [self.viewManager.tableView reloadData];
            [self.viewManager bottomButtons:self.modelManager.model.privilege target:self action:@selector(onButton:)];
            self.viewManager.remindButton.hidden = [self.modelManager.model.object_type isEqualToString:@"person"];
            
            [self performSelector:@selector(gotoComment) withObject:nil afterDelay:0.1];
        };
        
        object.shareLongBlock = ^{
            CA_H_StrongSelf(self);
            CA_HLongViewController *vc = [CA_HLongViewController new];
            vc.model = self.modelManager.model;
            vc.noteId = self.modelManager.model.note_id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        object.gotoProjectDetailBlock = ^{
            CA_H_StrongSelf(self);
            CA_MProjectModel *model = [CA_MProjectModel new];
            model.project_id = self.modelManager.model.object_id;
            CA_MProjectDetailVC* detailVC = [[CA_MProjectDetailVC alloc] init];
            detailVC.model = model;
            [self.navigationController pushViewController:detailVC animated:YES];
        };
        
        object.moveBlock = ^{
            CA_H_StrongSelf(self);
            CA_HMoveListViewController *vc = [CA_HMoveListViewController new];
            vc.objectId = self.modelManager.model.object_id;
            CA_H_WeakSelf(self);
            vc.doneBlock = ^(NSString *objectType, CA_MProjectModel *model, void (^doneBlock)(void)) {
                CA_H_StrongSelf(self);
                [self.modelManager doneMoveType:objectType model:model doneBlock:doneBlock];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        object.deleteNoteBlock = ^{
            CA_H_StrongSelf(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        object.editBlock = ^{
            CA_H_StrongSelf(self);
            CA_HAddNoteViewController *vc = [CA_HAddNoteViewController new];
            if ([self.modelManager.model.object_type isEqualToString:@"human"]) {
                vc.humamId = self.modelManager.model.object_id;
            }
            vc.viewModel.model = self.modelManager.model;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        object.addCommentBlock = ^{
            CA_H_StrongSelf(self);
            self.viewManager.textView.text = nil;
            [self.viewManager commentCellHeight:self.modelManager.model.comment_list.lastObject];
            CA_H_WeakSelf(self);
            CA_H_DISPATCH_MAIN_THREAD(^{
                CA_H_StrongSelf(self);
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.modelManager.model.comment_list.count-1 inSection:2];
                [self.viewManager.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.viewManager.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            });
        };

        object.deleteCommentBlock = ^(NSIndexPath *indexPath) {
            CA_H_StrongSelf(self);
            CA_H_WeakSelf(self);
            CA_H_DISPATCH_MAIN_THREAD(^{
                CA_H_StrongSelf(self);
                if (self.modelManager.model.comment_list.count>0) {
                    [self.viewManager.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
                } else {
                    [self.viewManager.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationLeft];
                }
            });
        };
    }
    return _modelManager;
}

- (CA_HNoteDetailNewViewManager *)viewManager {
    if (!_viewManager) {
        CA_HNoteDetailNewViewManager *object = [CA_HNoteDetailNewViewManager new];
        _viewManager = object;
        
        object.tableView.delegate = self;
        object.tableView.dataSource = self;
        
        [object.sendButton addTarget:self action:@selector(onKeyboardView:) forControlEvents:UIControlEventTouchUpInside];
        [object.remindButton addTarget:self action:@selector(onKeyboardView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [IQKeyboardManager sharedManager].enable = NO;
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)upView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [self.viewManager rightBarButton:self action:@selector(onBarButton:)];
    
    CGRect rect = self.view.bounds;
    rect.size.height = CA_H_SCREEN_HEIGHT-64-CA_H_MANAGER.xheight-48*CA_H_RATIO_WIDTH-CA_H_MANAGER.xheight;
    
    self.viewManager.tableView.frame = rect;
    [self.view addSubview:self.viewManager.tableView];
    
    self.viewManager.bottomView.frame = CGRectMake(0, rect.size.height, rect.size.width, 48*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    [self.view addSubview:self.viewManager.bottomView];
    
    self.viewManager.replyView.top = self.viewManager.bottomView.top;
    [self.view insertSubview:self.viewManager.replyView belowSubview:self.viewManager.bottomView];
    
    
    if (self.dataDic) {
        self.modelManager.DetailDic = self.dataDic;
    } else {
        [self.modelManager requestNote:self.noteId view:self.view];
    }
}

- (void)gotoComment {
    if (self.modelManager.commentId) {
        for (CA_HTodoDetailCommentModel *model in self.modelManager.model.comment_list) {
            if ([model.comment_id isEqualToNumber:self.modelManager.commentId]) {
                self.modelManager.commentId = nil;
                NSInteger index = [self.modelManager.model.comment_list indexOfObject:model];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:2];
                [self.viewManager.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                break;
            }
        }
    }
}

#pragma mark --- Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.modelManager.model) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.modelManager.model.content.count;
    } else if (section == 2) {
        return self.modelManager.model.comment_list.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2
        &&
        self.modelManager.model.comment_list.count>0) {
        return 79*CA_H_RATIO_WIDTH;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewManager heightForRowAtIndexPath:indexPath model:self.modelManager.model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewManager heightForRowAtIndexPath:indexPath model:self.modelManager.model];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2
        &&
        self.modelManager.model.comment_list.count>0) {
        return self.viewManager.commentHeader;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.viewManager cellForRowAtIndexPath:indexPath model:self.modelManager.model];
    
    if (indexPath.section == 2) {
        CA_HReplyCell *replyCell = (id)cell;
        CA_H_WeakSelf(self);
        replyCell.onClickBlock = ^(CA_HReplyCell *clickCell, BOOL isDelete) {
            CA_H_StrongSelf(self);
            if (isDelete) {
                CA_H_WeakSelf(self);
                [self.viewManager.textView resignFirstResponder];
                NSIndexPath *deleteIndexPath = [tableView indexPathForCell:clickCell];
                [self presentAlertTitle:nil message:CA_H_LAN(@"是否删除该条评论？") buttons:@[CA_H_LAN(@"否"), CA_H_LAN(@"是")] clickBlock:^(UIAlertController *alert, NSInteger index) {
                    if (index == 1) {
                        CA_H_StrongSelf(self);
                        [self.modelManager deleteComment:(id)clickCell.model indexPath:deleteIndexPath];
                    }
                }];
            } else {
                CA_HTodoDetailCommentModel *clickModel = (id)clickCell.model;
                self.viewManager.People = @[clickModel.creator];
            }
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row < self.modelManager.model.content.count) {
            CA_HNoteDetailContentModel *model = self.modelManager.model.content[indexPath.row];
            [self.viewManager.textView resignFirstResponder];
            if ([model.type isEqualToString:@"image"]) {// 图片
                YYPhotoBrowseView *photoView = [[YYPhotoBrowseView alloc]initWithGroupItems:self.viewManager.photoGroupItems];
                photoView.blurEffectBackground = NO;
                
                CA_H_WeakSelf(self);
                photoView.getControllerBlock = ^UIViewController *(BOOL statusBarHidden) {
                    CA_H_StrongSelf(self);
                    self.modelManager.statusBarHidden = statusBarHidden;
                    return self;
                };
                
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIImageView *imageView = [cell.contentView viewWithTag:2333];
                if (imageView) {
                    [photoView presentFromImageView:imageView toContainer:CA_H_MANAGER.mainWindow animated:YES completion:^{
                        photoView.pager.alpha = 0;
                        photoView.pager.hidden = YES;
                    }];
                }
                
            } else if ([model.type isEqualToString:@"record"]) {// 录音
                [CA_HBorwseFileManager browseCachesRecord:model.file_id recordName:model.file_name fileUrl:model.file_url controller:self];
            } else if ([model.type isEqualToString:@"attach"]) {// 文件
                [CA_HBorwseFileManager browseCachesFile:model.file_id fileName:model.file_name fileUrl:model.file_url controller:self];
            }
        }
    }
}

#pragma mark --- StatusBar

- (BOOL)prefersStatusBarHidden {
    return self.modelManager.statusBarHidden;//隐藏为YES，显示为NO
}

#pragma mark --- Keyboard

- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect rect = [self.view convertRect:keyboardFrame fromView:CA_H_MANAGER.mainWindow];
    
    [self.viewManager keyboardFrame:rect isShow:YES];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect rect = [self.view convertRect:keyboardFrame fromView:CA_H_MANAGER.mainWindow];
    [self.viewManager keyboardFrame:rect isShow:NO];
}


@end
