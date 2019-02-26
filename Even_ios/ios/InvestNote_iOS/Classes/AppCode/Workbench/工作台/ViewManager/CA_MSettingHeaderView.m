//
//  CA_MSettingHeaderView.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/11/25.
//  God bless me without no bugs.
//

#import "CA_MSettingHeaderView.h"

@interface CA_MSettingHeaderView()

@property(nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UIButton *notFoundBtn;
@end

@implementation CA_MSettingHeaderView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - SetupUI

- (void)setupUI{
    self.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:self.titleLb];
    [self addSubview:self.notFoundBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.notFoundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self).offset(-20);
    }];
}

#pragma mark - Public

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

-(void)setTitleColor:(NSString *)titleColor{
    _titleColor = titleColor;
    self.titleLb.textColor = kColor(titleColor);
}

-(void)setFont:(CGFloat)font{
    _font = font;
    self.titleLb.font = CA_H_FONT_PFSC_Regular(font);
}

-(void)setNotFoundBtnHidden:(BOOL)notFoundBtnHidden{
    _notFoundBtnHidden = notFoundBtnHidden;
    self.notFoundBtn.hidden = notFoundBtnHidden;
}

#pragma mark - Private

-(void)notFoundBtnAction:(UIButton *)sender{
    _notFoundBlock?_notFoundBlock(sender):nil;
}

#pragma mark - Getter and Setter

-(UIButton *)notFoundBtn{
    if (!_notFoundBtn) {
        _notFoundBtn = [UIButton new];
        _notFoundBtn.hidden = YES;
        [_notFoundBtn configTitle:@"找不到？"
                       titleColor:CA_H_TINTCOLOR
                             font:14];
        [_notFoundBtn addTarget:self
                         action:@selector(notFoundBtnAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _notFoundBtn;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
    }
    return _titleLb;
}
@end
