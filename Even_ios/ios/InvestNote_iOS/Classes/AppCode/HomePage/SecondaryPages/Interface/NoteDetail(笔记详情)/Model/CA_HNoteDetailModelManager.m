//
//  CA_HNoteDetailModelManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteDetailModelManager.h"

#import "CA_HNoteNetManager.h"//笔记请求

@interface CA_HNoteDetailModelManager ()

@end

@implementation CA_HNoteDetailModelManager

#pragma mark --- Action

#pragma mark --- Lazy

#pragma mark --- LifeCircle

#pragma mark --- Custom

// 刷新列表对应的评论数量
- (void)commentContent {
    if (self.model) {
        NSDictionary *userInfo =
        @{
          @"note_id":self.model.note_id?:@(0),
          @"comment_count":@(self.model.comment_list.count)?:@(0),
          };
        [[NSNotificationCenter defaultCenter] postNotificationName:CA_H_NoteCommontCountNotification object:nil userInfo:userInfo];
    }
}

//请求笔记详情数据
- (void)requestNote:(NSNumber *)noteId view:(UIView *)view {
    CA_H_WeakSelf(self);
    [CA_HNoteNetManager queryNote:noteId callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    CA_H_StrongSelf(self);
                    self.DetailDic = netModel.data;
                }
                return ;
            }
        }
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    } view:view];
}
//数据回调
- (void)setDetailDic:(NSDictionary *)detailDic {
    if (self.model) {
        [self.model modelSetWithDictionary:detailDic];
    } else {
        self.model = [CA_HNoteDetailModel modelWithDictionary:detailDic];
    }
    
    _actionSheets = nil;
    if (self.loadDataBlock) {
        self.loadDataBlock();
    }
}

//更多
- (NSArray *)actionSheets {
    if (!_actionSheets) {
        NSMutableArray *mut = [NSMutableArray new];
        _actionSheets = mut;
        
        if ([self.model.privilege containsObject:@"edit"]) {
            [mut addObject:CA_H_LAN(@"编辑")];
        }
        if ([self.model.privilege containsObject:@"jump"]) {
            if ([self.model.object_type isEqualToString:@"project"]) {
                [mut addObject:CA_H_LAN(@"前往项目")];
            }
        }
        if ([self.model.privilege containsObject:@"move"]) {
            [mut addObject:CA_H_LAN(@"移动")];
        }
        if ([self.model.privilege containsObject:@"delete"]) {
            [mut addObject:@[CA_H_LAN(@"删除")]];
        }
    }
    return _actionSheets;
}

- (void)setOnActionSheet:(NSInteger)onActionSheetl {
    NSString *str = self.actionSheets[onActionSheetl];
    if ([str isEqualToString:CA_H_LAN(@"前往项目")]) {
        if (self.gotoProjectDetailBlock) {
            self.gotoProjectDetailBlock();
        }
    } else if ([str isEqualToString:CA_H_LAN(@"移动")]) {
        if (self.moveBlock) {
            self.moveBlock();
        }
    } else if ([str isEqualToString:CA_H_LAN(@"编辑")]) {
        if (self.editBlock) {
            self.editBlock();
        }
    }
}

#pragma mark --- Share

//分享功能
- (void)share {
    
    [CA_HProgressHUD showHud:nil];
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_ShareNote parameters:@{@"note_id":self.model.note_id} callBack:^(CA_HNetModel *netModel) {
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
                            if (self.shareLongBlock) {
                                self.shareLongBlock();
                            }
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

//移动笔记
- (void)doneMoveType:(NSString *)objectType model:(CA_MProjectModel *)model doneBlock:(void(^)(void))doneBlock {
    NSDictionary *parameters =
    @{
      @"note_id":self.model.note_id,
      @"target_object_type":objectType,
      @"target_object_id":model.project_id,
      @"target_note_type_id":self.model.note_type_id
      };
    
    [CA_HProgressHUD showHud:nil];
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_MoveNote parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    CA_H_StrongSelf(self);
                    self.DetailDic = netModel.data;
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
}

//删除笔记
- (void)deleteNote {
    [CA_HProgressHUD showHud:nil];
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_DeleteNote parameters:@{@"note_id":self.model.note_id} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                CA_H_StrongSelf(self);
                [CA_H_NotificationCenter postNotificationName:CA_H_RefreshNoteListNotification object:self.model.object_type];
                if (self.deleteNoteBlock) {
                    self.deleteNoteBlock();
                }
                return ;
            }
        }
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    } progress:nil];
}

//评论
- (void)addComment:(NSString *)text {
    
    if (text.length <= 0) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    NSMutableArray *noticeUserIdList = [NSMutableArray new];
    NSMutableString *conmmentContent = [NSMutableString new];
    
    NSArray<NSString *> *array = [text componentsSeparatedByString:@"0/0"];
    
    for (NSInteger i=0; i<array.count; i++) {
        if (i%2) {
            [noticeUserIdList addObject:array[i].numberValue];
        } else {
            [conmmentContent appendString:array[i]];
        }
    }
    
    CA_H_WeakSelf(self);
    [CA_HNoteNetManager addNoteComment:self.model.note_id objectType:self.model.object_type objectId:self.model.object_id conmmentContent:conmmentContent noticeUserIdList:noticeUserIdList callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    if (!self.model.comment_list) {
                        self.model.comment_list = [NSMutableArray new];
                    }
                    [self.model.comment_list addObject:[CA_HTodoDetailCommentModel modelWithDictionary:netModel.data]];
                    
                    if (self.addCommentBlock) {
                        self.addCommentBlock();
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

- (void)deleteComment:(CA_HTodoDetailCommentModel *)model indexPath:(NSIndexPath *)indexPath {
    CA_H_WeakSelf(self);
    [CA_HNoteNetManager deleteNoteComment:model.comment_id callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                [self.model.comment_list removeObjectAtIndex:indexPath.row];
                if (self.deleteCommentBlock) {
                    self.deleteCommentBlock(indexPath);
                }
                return ;
            }
        }
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    }];
}

@end
