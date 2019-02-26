//
//  CA_HUploadFileManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CA_HAddFileModel.h"

@interface CA_HUpdateFileManager : NSObject

@property (nonatomic, strong) NSMutableArray<CA_HAddFileModel *> *contents;
//@property (nonatomic, copy) void (^updateBlock)(void);

- (void)update:(CA_HAddFileModel *)model;
- (void)saveToTmp:(CA_HAddFileModel *)model success:(void(^)(void))success failed:(void(^)(void))failed;

@end
