
//
//  CA_MDiscoverProjectDetailFinancInfoViewCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailFinancInfoViewCell.h"
#import "CA_MDiscoverProjectDetailModel.h"

@interface CA_MDiscoverProjectDetailFinancInfoViewCell ()
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MDiscoverProjectDetailFinancInfoViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstraints];
    }
    return self;
}

-(void)upView{
    [self.contentView addSubview:self.titleLb];
}

-(void)setConstraints{
    self.titleLb.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

-(void)setModel:(CA_MDiscoverGp_list *)model{
    _model = model;
    self.titleLb.text = model.gp_name;
    
    if ([NSString isValueableString:model.data_id]) {
        self.titleLb.textColor = CA_H_TINTCOLOR;
    }else{
        self.titleLb.textColor = CA_H_9GRAYCOLOR;
    }
    
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@""
                   textColor:CA_H_TINTCOLOR
                        font:14];
    }
    return _titleLb;
}

@end
