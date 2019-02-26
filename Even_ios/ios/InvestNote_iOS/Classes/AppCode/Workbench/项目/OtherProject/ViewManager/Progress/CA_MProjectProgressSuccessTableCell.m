
//
//  CA_MProjectProgressSuccessTableCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectProgressSuccessTableCell.h"
#import "CA_MProjectProgressModel.h"

@interface CA_MProjectProgressSuccessTableCell ()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *resultLb;
@property (nonatomic,strong) UILabel *commentLb;
@end

@implementation CA_MProjectProgressSuccessTableCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.resultLb];
    [self.contentView addSubview:self.commentLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.contentView);
    }];
    [self.resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(5);
    }];
    [self.commentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(67);
    }];
    
}


-(void)setModel:(CA_MApproval_result *)model{
    [super setModel:model];
    
    [self.iconImgView setImageWithURL:[NSURL URLWithString:model.approval_user.avatar] placeholder:kImage(@"head20")];
    
    if ([model.approval_result isEqualToString:@"negative"]) {
        self.resultLb.text = @"不同意";
    }else if ([model.approval_result isEqualToString:@"abstenting"]){
        self.resultLb.text = @"弃权";
    }else {
        self.resultLb.text = @"同意";
    }
    
    self.commentLb.text = [NSString stringWithFormat:@"意见：%@",[NSString isValueableString:model.approval_comment]?model.approval_comment:@"暂无"];
    
}

-(UILabel *)commentLb{
    if (_commentLb) {
        return _commentLb;
    }
    _commentLb = [UILabel new];
    [_commentLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _commentLb;
}
-(UILabel *)resultLb{
    if (_resultLb) {
        return _resultLb;
    }
    _resultLb = [UILabel new];
    [_resultLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _resultLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [UIImageView new];
    _iconImgView.layer.cornerRadius = 20/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    return _iconImgView;
}

@end
