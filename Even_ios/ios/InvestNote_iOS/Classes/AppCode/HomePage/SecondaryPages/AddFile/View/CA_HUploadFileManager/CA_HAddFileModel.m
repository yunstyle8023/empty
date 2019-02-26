//
//  CA_HAddFileModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAddFileModel.h"

#import "CA_HDownloadCenterViewModel.h"

@implementation CA_HAddFileModel

#pragma mark --- Action

#pragma mark --- Lazy

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    NSString *fileName = [filePath componentsSeparatedByString:@"/"].lastObject;
    _fileName = [CA_HDownloadCenterViewModel fileName:[fileName stringByRemovingPercentEncoding] transcoding:NO];
}


#pragma mark --- LifeCircle

#pragma mark --- Custom



#pragma mark --- Delegate

@end
