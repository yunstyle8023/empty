//
//  CA_HTodoDetailModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HTodoDetailModel.h"

@implementation CA_HTodoDetailCommentModel

- (void)setNotice_user_list:(NSArray<CA_HParticipantsModel *> *)notice_user_list {
    if (![notice_user_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in notice_user_list) {
        if ([dic isKindOfClass:[CA_HParticipantsModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HParticipantsModel modelWithDictionary:dic]];
        }
    }
    _notice_user_list = array;
}

@end
@implementation CA_HTodoDetailFileModel
@end

@implementation CA_HTodoDetailModel

- (void)setMember_list:(NSArray<CA_HParticipantsModel *> *)member_list {
    if (![member_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in member_list) {
        if ([dic isKindOfClass:[CA_HParticipantsModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HParticipantsModel modelWithDictionary:dic]];
        }
    }
    _member_list = array;
}

- (void)setFile_list:(NSArray<CA_HTodoDetailFileModel *> *)file_list {
    if (![file_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in file_list) {
        if ([dic isKindOfClass:[CA_HTodoDetailFileModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HTodoDetailFileModel modelWithDictionary:dic]];
        }
    }
    _file_list = array;
}

- (void)setComment_list:(NSMutableArray<CA_HTodoDetailCommentModel *> *)comment_list {
    if (![comment_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in comment_list) {
        if ([dic isKindOfClass:[CA_HTodoDetailCommentModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HTodoDetailCommentModel modelWithDictionary:dic]];
        }
    }
    _comment_list = array;
}

@end
