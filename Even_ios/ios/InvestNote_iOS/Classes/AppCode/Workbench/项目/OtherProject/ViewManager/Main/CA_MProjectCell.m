//
//  CA_MProjectCell.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/6.
//  God bless me without no bugs.
//

#import "CA_MProjectCell.h"
#import "CA_MProjectModel.h"
#import "CA_MProjectTagView.h"

@interface CA_MProjectCell()

@end

@implementation CA_MProjectCell

#pragma mark - Init

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - SetupUI

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.iconLb];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.typeLb];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView).offset(10);
        //
        make.width.height.mas_equalTo(50);
    }];
    
    [self.iconLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.iconImgView);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(10);
        make.top.mas_equalTo(self.iconImgView).offset(1);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.leading.mas_equalTo(self.titleLb.mas_trailing).offset(10);
        //
        //        make.width.mas_equalTo(62);
        make.height.mas_equalTo(20);
    }];
    
    [self.typeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(4);
    }];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.typeLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.typeLb.mas_bottom).offset(4);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.detailLb);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
}

#pragma mark - Public

-(void)setModel:(CA_MProjectModel*)model{
    _model = model;
    
    if ([NSString isValueableString:model.project_logo]) {
        
        NSString* urlStr = @"";
        if ([model.project_logo hasPrefix:@"http"]) {
            urlStr = model.project_logo;
        }else{
            urlStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.project_logo];
        }
        
        [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"loadfail_project50")];
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
    
    if (model.project_name.length>10) {
        self.titleLb.text = [NSString stringWithFormat:@"%@...",[model.project_name substringToIndex:9]];
    }else{
       self.titleLb.text = model.project_name;
    }
    
    self.tagView.tagLb.text = model.procedure_name;
    if ([NSString isValueableString:model.brief_intro]) {
        self.typeLb.text = model.brief_intro;
    }else {
        self.typeLb.text = @"暂无";
    }
    self.detailLb.text = [NSString stringWithFormat:@"%@-%@ | %@-%@ | %@",
                          [model.project_area firstObject],
                          [model.project_area lastObject],
                          model.category.parent_category_name,
                          model.category.child_category_name,
                          model.invest_stage];
}


#pragma mark - Getter and Setter
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 4;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    return _iconImgView;
}
-(UILabel *)iconLb{
    if (_iconLb) {
        return _iconLb;
    }
    _iconLb = [[UILabel alloc] init];
    [_iconLb configText:@"" textColor:kColor(@"#FFFFFF") font:20];
    return _iconLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
-(CA_MProjectTagView *)tagView{
    if (_tagView) {
        return _tagView;
    }
    _tagView = [[CA_MProjectTagView alloc] init];
    return _tagView;
}
-(UILabel *)typeLb{
    if (_typeLb) {
        return _typeLb;
    }
    _typeLb = [[UILabel alloc] init];
    [_typeLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _typeLb;
}
-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [[UILabel alloc] init];
    [_detailLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _detailLb;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
@end

