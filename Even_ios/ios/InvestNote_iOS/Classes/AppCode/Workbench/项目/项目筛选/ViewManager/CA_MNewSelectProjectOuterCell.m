//
//  CA_MNewSelectProjectOuterCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewSelectProjectOuterCell.h"
#import "CA_MNewSelectProjectConditionsModel.h"

@interface CA_MNewSelectProjectOuterCell ()
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *titleLb;
@end

@implementation CA_MNewSelectProjectOuterCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.lineView];
    [self setConstrains];
}

-(void)setConstrains{
    
    self.titleLb.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.lineView.sd_layout
    .leftEqualToView(self.contentView)
    .centerYEqualToView(self.titleLb)
    .heightIs(8*2*CA_H_RATIO_WIDTH)
    .widthIs(2*2*CA_H_RATIO_WIDTH);
}

-(void)setModel:(CA_MNewSelectProjectConditionsModel *)model{
    [super setModel:model];
    
    if (model.selectedCount > 0) {
        self.titleLb.text = [NSString stringWithFormat:@"%@（%d）",model.name,model.selectedCount];
    }else{
       self.titleLb.text = model.name;
    }
    
    if (model.isSelected) {
        self.titleLb.textColor = CA_H_TINTCOLOR;
        self.lineView.hidden = NO;
    }else{
        self.titleLb.textColor = CA_H_4BLACKCOLOR;
        self.lineView.hidden = YES;
    }
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_TINTCOLOR;
    }
    return _lineView;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@"人员"
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}

@end
