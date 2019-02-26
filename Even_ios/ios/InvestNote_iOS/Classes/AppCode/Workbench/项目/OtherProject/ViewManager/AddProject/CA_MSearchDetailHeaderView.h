//
//  CA_MSearchDetailHeaderView.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MSelectModelDetail.h"

@interface CA_MSearchDetailHeaderView : UIView
@property (nonatomic,strong) CA_MSelectModelDetail *model;
@property (nonatomic,copy) void(^block)(NSInteger row);
@end
