//
//  CA_MProjectSearchView.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/6.
//  God bless me without no bugs.
//

#import "CA_MProjectSearchView.h"

@interface CA_MProjectSearchView()
@property(nonatomic,strong)CA_HSetButton* searchBtn;
@end

@implementation CA_MProjectSearchView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - SetupUI

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.searchBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.leading.mas_equalTo(self).offset(20);
        make.trailing.mas_equalTo(self).offset(-20);
    }];
}

#pragma mark - Public

#pragma mark - Private
- (void)searchBtnAction:(CA_HSetButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jump2SearchPage)]) {
        [self.delegate jump2SearchPage];
    }
}
#pragma mark - Getter and Setter
-(CA_HSetButton *)searchBtn{
    if (_searchBtn) {
        return _searchBtn;
    }
    _searchBtn = [[CA_HSetButton alloc] init];
    _searchBtn.backgroundColor = CA_H_F8COLOR;
    [_searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [_searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateHighlighted];
    _searchBtn.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    [_searchBtn setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [_searchBtn setTitle:@" 搜索" forState:UIControlStateNormal];
    _searchBtn.layer.cornerRadius = 6;
    _searchBtn.layer.masksToBounds = YES;
    [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return _searchBtn;
}
@end
