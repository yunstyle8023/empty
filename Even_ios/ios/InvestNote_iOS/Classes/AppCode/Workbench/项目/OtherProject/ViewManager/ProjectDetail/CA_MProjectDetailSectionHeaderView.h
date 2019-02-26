//
//  CA_MProjectDetailSectionHeaderView.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CA_MProjectDetailSectionHeaderViewDelegate <NSObject>
-(void)editClick:(NSString*)title;
@end

@interface CA_MProjectDetailSectionHeaderView : UIView
@property(nonatomic,weak)id<CA_MProjectDetailSectionHeaderViewDelegate> delegate;
-(void)configTitle:(NSString*)title isHiddenEditBtn:(BOOL)isHidden;
@end
