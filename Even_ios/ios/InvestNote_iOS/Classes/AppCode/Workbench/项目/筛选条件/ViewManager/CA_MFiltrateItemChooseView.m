//
//  CA_MFiltrateItemChooseView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MFiltrateItemChooseView.h"

@interface CA_MFiltrateItemChooseView ()

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIButton *confirmBtn;

@end

@implementation CA_MFiltrateItemChooseView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstraints];
    }
    return self;
}

-(void)upView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
}

-(void)setConstraints{
    self.cancelBtn.sd_layout
    .leftSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self, 3*2*CA_H_RATIO_WIDTH)
    .heightIs(20*2*CA_H_RATIO_WIDTH)
    .widthIs(88*2*CA_H_RATIO_WIDTH);
    
    self.confirmBtn.sd_layout
    .rightSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self, 3*2*CA_H_RATIO_WIDTH)
    .heightIs(20*2*CA_H_RATIO_WIDTH)
    .widthIs(88*2*CA_H_RATIO_WIDTH);
}

#pragma mark - getter and setter

-(void)cancelBtnAction:(UIButton *)sender{
    self.cancelBlock?self.cancelBlock():nil;
}

-(void)confirmBtnAction:(UIButton *)sender{
    self.confirmBlock?self.confirmBlock():nil;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [self createBtnWithTitle:@"取消"
                                   titleColor:CA_H_9GRAYCOLOR
                              backGroundColor:kColor(@"#F9F9F9")
                                     selector:@selector(cancelBtnAction:)];
    }
    return _cancelBtn;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [self createBtnWithTitle:@"完成" titleColor:[UIColor whiteColor] backGroundColor:CA_H_TINTCOLOR selector:@selector(confirmBtnAction:)];
    }
    return _confirmBtn;
}

-(UIButton *)createBtnWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                backGroundColor:(UIColor *)backGroundColor
                       selector:(SEL)selector{
    UIButton *button = [UIButton new];
    button.backgroundColor = backGroundColor;
    button.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
    button.layer.masksToBounds = YES;
    [button configTitle:title
             titleColor:titleColor
                   font:16];
    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
