//
//  CA_HShareActivity.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/28.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIActivityTypeCACustomLong @"CACustomActivityLong"
#define UIActivityTypeCACustomCopy @"CACustomActivityCopy"


@interface CA_HShareActivity : UIActivity

+ (instancetype)newWithType:(NSString *)type;

@end
