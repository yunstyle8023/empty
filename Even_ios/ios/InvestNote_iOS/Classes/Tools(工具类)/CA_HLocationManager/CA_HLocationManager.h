//
//  CA_HLocationManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HLocationManager : NSObject

+ (id)singleLocation:(void(^)(NSArray *location))block;

@end
