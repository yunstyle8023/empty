

//
//  CA_MApproveStatusDetailCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MApproveStatusDetailCell.h"
#import "CA_MMyApproveDetailModel.h"

@interface CA_MApproveTagView : UIView
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *titleColor;
@end

@interface CA_MApproveTagView ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *tagLb;
@end


@implementation CA_MApproveTagView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.bgView];
    [self addSubview:self.tagLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.tagLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bgView);
    }];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.tagLb.text = title;
}

-(void)setTitleColor:(NSString *)titleColor{
    _titleColor = titleColor;
    self.bgView.backgroundColor = kColor(titleColor);
}

-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.layer.cornerRadius = 11;
    _bgView.layer.masksToBounds = YES;
    return _bgView;
}
-(UILabel *)tagLb{
    if (_tagLb) {
        return _tagLb;
    }
    _tagLb = [[UILabel alloc] init];
    [_tagLb configText:@"" textColor:kColor(@"#FFFFFF") font:12];
    return _tagLb;
}
@end

@interface CA_MApproveStatusDetailCell ()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) CA_MApproveTagView *tagView;
@end

@implementation CA_MApproveStatusDetailCell

- (void)upView{
    [super upView];
    self.backgroundColor = kColor(@"#F8F8F8");
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(15);
        make.top.mas_equalTo(self.contentView).offset(10);
        //
        make.width.height.mas_equalTo(30);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(5);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.leading.mas_equalTo(self.titleLb.mas_trailing).offset(10);
        //
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(22);
    }];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconImgView);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
}

-(void)setModel:(CA_MResult_detail *)model{
    NSString* url = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.avatar];
    [self.iconImgView setImageWithURL:[NSURL URLWithString:url] placeholder:kImage(@"head30")];
    self.titleLb.text = model.chinese_name;
    //positive: 同意, negative: 不同意, abstenting: 弃权
    NSString* tagTitle = @"";
    if ([model.result_english_status isEqualToString:@"positive"]){
        tagTitle = @"通过";
    }else if ([model.result_english_status isEqualToString:@"negative"]){
        tagTitle = @"驳回";
    }else if ([model.result_english_status isEqualToString:@"abstenting"]){
        tagTitle = @"弃权";
    }
    
    self.tagView.title = tagTitle;
    self.tagView.titleColor = model.result_status_color;
    self.detailLb.text = model.result_commit;
}

#pragma mark - getter and setter
-(CA_MApproveTagView *)tagView{
    if (_tagView) {
        return _tagView;
    }
    _tagView = [CA_MApproveTagView new];
    return _tagView;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [UILabel new];
    _detailLb.numberOfLines = 0;
    [_detailLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _detailLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [UILabel new];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 30/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    return _iconImgView;
}
@end
