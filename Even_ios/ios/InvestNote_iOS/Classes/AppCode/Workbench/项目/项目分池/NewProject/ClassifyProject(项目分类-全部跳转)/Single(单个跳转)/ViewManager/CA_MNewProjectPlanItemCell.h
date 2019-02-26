//
//  CA_MNewProjectPlanItemCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"
#import "CA_MProjectTagView.h"

@interface CA_MNewProjectPlanItemCell : CA_HBaseTableCell

@property (nonatomic,strong) UIImageView *sologImgView;

@property (nonatomic,strong) UIButton *importBtn;

@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) CA_MProjectTagView *tagView;

@property (nonatomic,strong) UILabel *iconLb;

@end
