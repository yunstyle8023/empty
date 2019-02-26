//
//  CA_MProjectMemberCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectMemberCell.h"
#import "CA_MProjectTagLabel.h"
#import "CA_MProjectMemberModel.h"

@interface CA_MProjectMemberCell()
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)CA_MProjectTagLabel* positionLb;
@end

@implementation CA_MProjectMemberCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.positionLb];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
        //
        make.width.height.mas_equalTo(30*CA_H_RATIO_WIDTH);
    }];

    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(8);
    }];
    
    [self.positionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.leading.mas_equalTo(self.titleLb.mas_trailing).offset(5);
    }];
    
}

-(void)setModel:(CA_MMemberModel *)model{
    [super setModel:model];
    
    self.titleLb.text = model.chinese_name;
    
    if (model.member_type_id.intValue == 3){
        self.positionLb.hidden = YES;
    }else{
        self.positionLb.hidden = NO;
    }
    
    if ([NSString isValueableString:model.member_type_name]) {
        self.positionLb.title = model.member_type_name;
    }else{
        self.positionLb.title = @"";
    }
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.avatar];
    [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"head30")];
}

-(CA_MProjectTagLabel *)positionLb{
    if (_positionLb) {
        return _positionLb;
    }
    _positionLb = [[CA_MProjectTagLabel alloc] init];
    return _positionLb;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _titleLb;
}

-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 15;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    return _iconImgView;
}

@end
