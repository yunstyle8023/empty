//
//  CA_HNoteDetailModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteDetailModel.h"

@implementation CA_HNoteDetailContentModel

@end

@implementation CA_HNoteDetailModel

- (void)setContent:(NSArray<CA_HNoteDetailContentModel *> *)content {
    if (![content isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in content) {
        if ([dic isKindOfClass:[CA_HNoteDetailContentModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HNoteDetailContentModel modelWithDictionary:dic]];
        }
    }
    _content = array;
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
