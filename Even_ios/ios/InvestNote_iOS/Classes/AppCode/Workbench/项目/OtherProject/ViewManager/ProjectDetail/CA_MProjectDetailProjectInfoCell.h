//
//  CA_MProjectDetailProjectInfoCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MProjectDetailModel.h"

@interface CA_MProjectDetailProjectInfoCell : UITableViewCell
- (CGFloat)configCell:(CA_MProject_info*)model;
@property (nonatomic,copy) void(^pushBlock)(NSString *tagName);
@end

