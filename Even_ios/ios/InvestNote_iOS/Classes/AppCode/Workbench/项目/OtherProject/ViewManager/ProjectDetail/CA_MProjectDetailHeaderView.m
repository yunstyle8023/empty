
//
//  CA_MProjectDetailHeaderView.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MProjectDetailHeaderView.h"

@interface CA_MProjectDetailHeaderView()
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* iconLb;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UILabel* introduceLb;
@end

@implementation CA_MProjectDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = kColor(@"#FFFFFF");
    [self addSubview:self.iconImgView];
    [self addSubview:self.iconLb];
    [self addSubview:self.titleLb];
    [self addSubview:self.introduceLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(10);
        //
        make.width.height.mas_equalTo(65);
    }];
    
    [self.iconLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.iconImgView);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconImgView);
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
    }];
    
    [self.introduceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleLb);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(5);
    }];
    
}

-(void)setModel:(CA_MHeader_info *)model{
    _model = model;
    if ([NSString isValueableString:model.project_logo]) {
        NSString* urlStr = @"";
        if ([model.project_logo hasPrefix:@"http"]) {
            urlStr = model.project_logo;
        }else{
            urlStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.project_logo];
        }
        [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"loadfail_project65")];
        self.iconImgView.backgroundColor = kColor(@"#FFFFFF");
        //
        self.iconLb.hidden = YES;
        self.iconLb.text = @"";
    }else{
        self.iconImgView.image = nil;
        self.iconImgView.backgroundColor = kColor(model.project_color);
        //
        self.iconLb.hidden = NO;
        self.iconLb.text = [model.project_name substringToIndex:1];
    }
    
    self.titleLb.text = model.project_name;
    
    
    NSMutableString* attStr = [[NSMutableString alloc] init];
    
    if ([NSString isValueableString:[model.area firstObject]]){
        [attStr appendString:[NSString stringWithFormat:@"%@ | ",[model.area firstObject]]];
    }else{
        [attStr appendString:@"暂无 | "];
    }
    
    if([NSString isValueableString:model.child_category_name]){
        [attStr appendString:[NSString stringWithFormat:@"%@ | ",model.child_category_name]];
    }else{
        [attStr appendString:@"暂无 | "];
    }
    
    if([NSString isValueableString:model.invest_stage_name]){
        [attStr appendString:[NSString stringWithFormat:@"%@",model.invest_stage_name]];
    }else{
        [attStr appendString:@"暂无"];
    }
    self.introduceLb.text = attStr.copy;
}

-(UILabel *)iconLb{
    if (_iconLb) {
        return _iconLb;
    }
    _iconLb = [[UILabel alloc] init];
    [_iconLb configText:@"" textColor:kColor(@"#FFFFFF") font:20];
    return _iconLb;
}
-(UILabel *)introduceLb{
    if (_introduceLb) {
        return _introduceLb;
    }
    _introduceLb = [[UILabel alloc] init];
    [_introduceLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _introduceLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:18];
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 4;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.image = kImage(@"loadfail_project65");
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    return _iconImgView;
}

@end

