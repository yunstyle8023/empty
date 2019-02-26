//
//  CA_HBorwseFileManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HFoundReportModel.h"

@interface CA_HBorwseFileManager : NSObject

+ (void)browseReport:(CA_HFoundReportData *)model controller:(UIViewController *)controller;

+ (void)browseCachesFile:(NSNumber *)fileId fileName:(NSString *)fileName fileUrl:(NSString *)fileUrl controller:(UIViewController *)controller;

+ (void)browseCachesRecord:(NSNumber *)fileId recordName:(NSString *)fileName fileUrl:(NSString *)fileUrl controller:(UIViewController *)controller;

@end
