//
//  CA_MProjectInvestRelevanceCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_MProjectInvestRelevanceCell : CA_HBaseTableCell

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *messageLb;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,copy) dispatch_block_t closeBlock;

@end
