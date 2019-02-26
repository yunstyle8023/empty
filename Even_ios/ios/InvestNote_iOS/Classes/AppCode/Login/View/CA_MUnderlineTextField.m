//
//  CA_M_ UnderlineTextField.m
//  ceshi
//  Created by yezhuge on 2017/11/18.
//  God bless me without no bugs.
//

#import "CA_MUnderlineTextField.h"

@interface CA_MUnderlineTextField()
/// 底部的下划线
@property(nonatomic,strong)UIView* lineView;
@end

@implementation CA_MUnderlineTextField

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}

#pragma mark - SetupUI

- (void)setupUI{
    [self addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self);
        make.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

-(void)setUnderLineColor:(UIColor *)underLineColor{
    _underLineColor = underLineColor;
    self.lineView.backgroundColor = underLineColor;
}

#pragma mark - Getter and Setter
- (UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    return _lineView;
}
@end
