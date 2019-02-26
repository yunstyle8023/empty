//
//  CA_HShareActivity.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/28.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HShareActivity.h"


@interface CA_HShareActivity ()

@property (nonatomic, copy) NSString * type;

@end


@implementation CA_HShareActivity


+ (instancetype)newWithType:(NSString *)type{
    
    CA_HShareActivity * activity = [self new];
    activity.type = type;
    return activity;
}

- (NSString *)activityType{
    return _type;
}

- (nullable NSString *)activityTitle{
    
    if ([_type isEqualToString:UIActivityTypeCACustomLong]) {
        return CA_H_LAN(@"生成长图");
    }else
    if ([_type isEqualToString:UIActivityTypeCACustomCopy]) {
        return CA_H_LAN(@"复制链接");
    }
    return @"";
}

- (nullable UIImage *)activityImage{
    
    NSString * imageName;
    if ([_type isEqualToString:UIActivityTypeCACustomLong]) {
        imageName = @"generateimageIcon";
    }else
    if ([_type isEqualToString:UIActivityTypeCACustomCopy]) {
        imageName = @"copylink_Icon";
    }
    return [UIImage imageNamed:imageName];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems{
    [super prepareWithActivityItems:activityItems];
}

- (void)performActivity{
    [super performActivity];
}

@end
