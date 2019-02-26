//
//  CA_MPersonDetailRelevanceCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailRelevanceCell.h"
#import "CA_MPersonDetailModel.h"

@interface CA_MPersonDetailRelevanceCell ()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *detailLb;
@end

@implementation CA_MPersonDetailRelevanceCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.detailLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView);
        //
        make.width.height.mas_equalTo(50*CA_H_RATIO_WIDTH);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(10);
        make.top.mas_equalTo(self.iconImgView).offset(2);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(4);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
}


-(void)setModel:(CA_MContact_project *)model{
    [super setModel:model];
    
    NSString *urlStr = model.project_slogan;
    urlStr = ^{
        if ([urlStr hasPrefix:@"http://"]
            ||
            [urlStr hasPrefix:@"https://"]) {
            return urlStr;
        }
        return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
    }();
    [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"loadfail_project50")];
    self.titleLb.text = model.project_name;
    self.detailLb.text = [NSString stringWithFormat:@"关联关系:%@",model.job_position];
}

#pragma mark - getter and setter

-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [[UILabel alloc] init];
    [_detailLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _detailLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 4;
    _iconImgView.layer.masksToBounds = YES;
    return _iconImgView;
}

@end
