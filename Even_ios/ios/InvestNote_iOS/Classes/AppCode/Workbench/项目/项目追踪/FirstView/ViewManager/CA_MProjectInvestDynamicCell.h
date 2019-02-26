//
//  CA_MProjectInvestDynamicCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"
@class ButtonLabel;

@interface CA_MProjectInvestDynamicCell : CA_HBaseTableCell

@property (nonatomic,strong) UIImageView *sloganImgView;

@property (nonatomic,strong) ButtonLabel *investorLb;

@property (nonatomic,strong) UILabel *investmentLb;

@property (nonatomic,strong) ButtonLabel *investoredLb;

@property (nonatomic,strong) UILabel *introduceLb;

@property (nonatomic,strong) ButtonLabel *newsLb;

@end
