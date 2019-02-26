//
//  CA_HShowDate.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HShowDate : NSObject

+ (NSString *)showDate:(NSDate *)date;
+ (NSString *)showDateWithoutTime:(NSDate *)date;

@end
