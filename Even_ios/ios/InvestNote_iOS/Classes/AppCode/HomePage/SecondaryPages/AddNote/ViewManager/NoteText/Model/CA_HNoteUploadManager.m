//
//  CA_HNoteUploadManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteUploadManager.h"

@implementation CA_HNoteUploadManager

- (CA_HUpdateFileManager *)updateFileManager {
    if (!_updateFileManager) {
        _updateFileManager = [CA_HUpdateFileManager new];
    }
    return _updateFileManager;
}

- (void)addFile:(CA_HAddFileModel *)model {
    [self.updateFileManager update:model];
//    [self.updateFileManager.contents addObject:model];
//    self.updateFileManager.updateBlock();
}

@end
