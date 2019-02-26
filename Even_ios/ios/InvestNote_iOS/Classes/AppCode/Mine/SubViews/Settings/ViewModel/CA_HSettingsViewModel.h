//
//  CA_HSettingsViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HSettingsViewModel : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *title;

+ (long long)folderSizeAtPath:(NSString *)folderPath;
+ (void)clearCache;

@end