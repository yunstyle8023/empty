//
//  CA_MDiscoverProjectDetailHeaderView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CA_MDiscoverProjectDetailModel;

@interface CA_MDiscoverProjectDetailHeaderView : UIView
@property (nonatomic,copy) void(^pushBlock)(NSIndexPath *indexPath,NSString *tagName);
-(CGFloat)configView:(CA_MDiscoverProjectDetailModel *)model;
@end

