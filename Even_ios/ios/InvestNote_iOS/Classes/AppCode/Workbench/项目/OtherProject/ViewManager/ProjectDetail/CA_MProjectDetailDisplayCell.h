//
//  CA_MProjectDetailDisplayCell.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ButtonLabel;

@interface CA_MProjectDetailDisplayCell : UITableViewCell
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)ButtonLabel* valueLb;
-(void)configCell:(NSString*)title value:(NSString*)valueStr;
@end

