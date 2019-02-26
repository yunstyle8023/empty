//
//  CA_HNoteUploadManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HUpdateFileManager.h"

@interface CA_HNoteUploadManager : NSObject

@property (nonatomic, strong) CA_HUpdateFileManager *updateFileManager;

- (void)addFile:(CA_HAddFileModel *)model;

@end
