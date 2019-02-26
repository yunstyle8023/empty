//
//  CA_MDiscoverInvestmentTopView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentTopView.h"

@interface CA_MDiscoverInvestmentTopView ()

@end

@implementation CA_MDiscoverInvestmentTopView

-(instancetype)initWithAreaBtnTitle:(NSString *)areaBtnTitle
                      typeBtnTitle:(NSString *)typeBtnTitle{
    if (self = [super init]) {
        self.backgroundColor = kColor(@"#FFFFFF");
        [self.firstBtn setTitle:areaBtnTitle forState:UIControlStateNormal];
        [self.secondBtn setTitle:typeBtnTitle forState:UIControlStateNormal];
        
        [self addSubview:self.firstBtn];
        self.firstBtn.sd_layout
        .centerYEqualToView(self)
        .leftSpaceToView(self, 35*2*CA_H_RATIO_WIDTH)
        .widthIs(40*2*CA_H_RATIO_WIDTH+20)
        .heightIs(20*2*CA_H_RATIO_WIDTH);
        
        [self addSubview:self.secondBtn];
        self.secondBtn.sd_layout
        .centerYEqualToView(self)
        .rightSpaceToView(self, 35*2*CA_H_RATIO_WIDTH)
        .widthIs(40*2*CA_H_RATIO_WIDTH+20)
        .heightIs(20*2*CA_H_RATIO_WIDTH);
        
        [self.buttons addObject:self.firstBtn];
        [self.buttons addObject:self.secondBtn];

    }
    return self;
}

-(instancetype)initWithAreaBtnTitle:(NSString *)areaBtnTitle
                       typeBtnTitle:(NSString *)typeBtnTitle
                      roundBtnTitle:(NSString *)roundBtnTitle
                       timeBtnTitle:(NSString *)timeBtnTitle{
    if (self = [super init]) {
        self.backgroundColor = kColor(@"#FFFFFF");
        [self.firstBtn setTitle:areaBtnTitle forState:UIControlStateNormal];
        [self.secondBtn setTitle:typeBtnTitle forState:UIControlStateNormal];
        [self.thirdBtn setTitle:roundBtnTitle forState:UIControlStateNormal];
        [self.fourBtn setTitle:timeBtnTitle forState:UIControlStateNormal];
        
        CGFloat width = 36*2*CA_H_RATIO_WIDTH;
        CGFloat padding = 10*2*CA_H_RATIO_WIDTH;
        CGFloat margin = (CA_H_SCREEN_WIDTH - padding*2 - width*4)/3;
        
        [self addSubview:self.firstBtn];
        self.firstBtn.sd_layout
        .centerYEqualToView(self)
        .leftSpaceToView(self, padding)
        .widthIs(width)
        .heightIs(20*2*CA_H_RATIO_WIDTH);
        
        [self addSubview:self.secondBtn];
        self.secondBtn.sd_layout
        .centerYEqualToView(self)
        .leftSpaceToView(self, padding+width+margin)
        .widthIs(width)
        .heightIs(20*2*CA_H_RATIO_WIDTH);
        
        [self addSubview:self.thirdBtn];
        self.thirdBtn.sd_layout
        .centerYEqualToView(self)
        .leftSpaceToView(self, padding+width*2+margin*2)
        .widthIs(width)
        .heightIs(20*2*CA_H_RATIO_WIDTH);
        
        [self addSubview:self.fourBtn];
        self.fourBtn.sd_layout
        .centerYEqualToView(self)
        .leftSpaceToView(self, padding+width*3+margin*3)
        .widthIs(width)
        .heightIs(20*2*CA_H_RATIO_WIDTH);
        
        [self.buttons addObject:self.firstBtn];
        [self.buttons addObject:self.secondBtn];
        [self.buttons addObject:self.thirdBtn];
        [self.buttons addObject:self.fourBtn];
        
    }
    return self;
}

-(void)buttonAction:(UIButton *)button{
    button.selected = !button.isSelected;
    if (self.didSelected) {
        self.didSelected(button);
    }
}

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = @[].mutableCopy;
    }
    return _buttons;
}

-(UIButton *)createBtn{
    UIButton *button = [UIButton new];
    [button setImage:kImage(@"shape3") forState:UIControlStateNormal];
    [button setImage:kImage(@"shape4") forState:UIControlStateSelected];
    [button setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
    [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateSelected];
    
    button.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.sd_resetLayout
    .centerYEqualToView(button.titleLabel.superview)
    .centerXEqualToView(button.titleLabel).offset(-11*CA_H_RATIO_WIDTH)
    .heightIs(20);
    button.titleLabel.numberOfLines = 1;
    [button.titleLabel setMaxNumberOfLinesToShow:1];
    
    button.imageView.sd_resetLayout
    .widthIs(12*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .centerYEqualToView(button.imageView.superview)
    .leftSpaceToView(button.titleLabel, 5*CA_H_RATIO_WIDTH);
    
    button.selected = NO;
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(UIButton *)fourBtn{
    if (!_fourBtn) {
        _fourBtn = [self createBtn];
        _fourBtn.tag = 100+4;
    }
    return _fourBtn;
}

-(UIButton *)thirdBtn{
    if (!_thirdBtn) {
        _thirdBtn = [self createBtn];
        _thirdBtn.tag = 100+3;
    }
    return _thirdBtn;
}

-(UIButton *)secondBtn{
    if (!_secondBtn) {
        _secondBtn = [self createBtn];
        _secondBtn.tag = 100+2;
    }
    return _secondBtn;
}

-(UIButton *)firstBtn{
    if (!_firstBtn) {
        _firstBtn = [self createBtn];
        _firstBtn.tag = 100+1;
    }
    return _firstBtn;
}

@end
