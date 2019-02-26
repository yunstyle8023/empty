//
//  CA_MProjectAddMemberCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectAddMemberCell.h"

@interface CA_MProjectAddMemberCell()
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* titleLb;
@end

@implementation CA_MProjectAddMemberCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLb];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(8);
    }];
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _titleLb;
}

-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.image = kImage(@"addMember");
    return _iconImgView;
}

@end
