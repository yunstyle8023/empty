
//
//  CA_MApproveResultCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MApproveResultCell.h"

@interface CA_MApproveResultCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MApproveResultCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.titleLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(15);
        make.centerY.mas_equalTo(self.bgView);
        make.trailing.mas_equalTo(self.bgView).offset(-15);
    }];
    
}

-(CGFloat)configCell:(NSArray*)array{
    self.titleLb.text = [array firstObject];
    self.titleLb.textColor = kColor([array lastObject]);
    CGFloat height = [self.titleLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:CA_H_SCREEN_WIDTH-40];
    return height + 20*2;
}

#pragma mark - getter and setter
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [UILabel new];
    _titleLb.font = CA_H_FONT_PFSC_Regular(14);
    _titleLb.numberOfLines = 0;
    return _titleLb;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [UIView new];
    _bgView.backgroundColor = kColor(@"#F8F8F8");
    _bgView.layer.cornerRadius = 2;
    _bgView.layer.masksToBounds = YES;
    return _bgView;
}

@end
