//
//  CA_HNoteInformationViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteInformationViewModel.h"

@implementation CA_HNoteInformationViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (NSArray<NSString *> *)topArray {
    if (_topArray.count != 4) {
        if (self.model) {
            _topArray = @[
                          [NSString stringWithFormat:@"%@", self.model.word_count],
                          [NSString stringWithFormat:@"%@", self.model.char_count],
                          [NSString stringWithFormat:@"%@", self.model.reading_time],
                          [NSString stringWithFormat:@"%@", self.model.paragraph_count]
                          ];
        }
    }
    return _topArray;
}

- (NSArray<NSString *> *)bottomArray {
    if (_bottomArray.count != 3) {
        if (self.model) {
            
            NSString *createStr = [[NSDate dateWithTimeIntervalSince1970:self.model.ts_create.longValue] stringWithFormat:@"yyyy.MM.dd HH:mm"];
            NSString *updateStr = [[NSDate dateWithTimeIntervalSince1970:self.model.ts_update.longValue] stringWithFormat:@"yyyy.MM.dd HH:mm"];
            NSString *locationStr = self.model.location.count?[self.model.location  componentsJoinedByString:@"·"]:@"暂无";
            
            _bottomArray = @[createStr, updateStr, locationStr];
        }
    }
    return _bottomArray;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
