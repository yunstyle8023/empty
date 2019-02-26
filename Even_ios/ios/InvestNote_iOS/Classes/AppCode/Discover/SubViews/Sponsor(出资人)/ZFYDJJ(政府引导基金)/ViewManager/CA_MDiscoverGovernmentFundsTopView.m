//
//  CA_MDiscoverGovernmentFundsTopView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverGovernmentFundsTopView.h"

@interface CA_MDiscoverGovernmentFundsTopView ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSArray *titleCodeArr;

@property (nonatomic,strong) NSMutableArray *buttons;

@property (nonatomic,strong) UIButton *currentButton;

@end

@implementation CA_MDiscoverGovernmentFundsTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.bgView];
        self.bgView.sd_layout
        .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
        .topSpaceToView(self, 8*2*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
        .heightIs(18*2*CA_H_RATIO_WIDTH);
        
        [self addSubview:self.lineView];
        self.lineView.sd_layout
        .leftSpaceToView(self, 11*2*CA_H_RATIO_WIDTH)
        .topSpaceToView(self, 9*2*CA_H_RATIO_WIDTH)
        .heightIs(16*2*CA_H_RATIO_WIDTH)
        .widthIs(41*2*CA_H_RATIO_WIDTH);
        
        
        CGFloat width = (CA_H_SCREEN_WIDTH -10*2*CA_H_RATIO_WIDTH*2)/self.titles.count;
        
        [self.titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [self createButton:obj];
            [self addSubview:button];
            button.sd_layout
            .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH+width*idx)
            .topSpaceToView(self, 8*2*CA_H_RATIO_WIDTH)
            .heightIs(18*2*CA_H_RATIO_WIDTH)
            .widthIs(width);
            
            button.selected = idx == 0?YES:NO;

            button.tag = idx;
            
            [self.buttons addObject:button];
        }];
        
        self.currentButton = [self.buttons firstObject];
        
    }
    return self;
}

-(void)buttonAction:(UIButton *)sender{
    
    if (self.currentButton == sender) return;
    self.currentButton = sender;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.centerX = self.currentButton.centerX;
    } completion:^(BOOL finished) {
        
        for (UIButton *button in self.buttons) {
            button.selected = (button == self.currentButton?YES:NO);
        }
        
        self.didSelectedItem?self.didSelectedItem(self.titleCodeArr[self.currentButton.tag]):nil;
    }];
 
}

#pragma mark - getter and setter

-(UIButton *)createButton:(NSString *)buttonTitle{
    UIButton *button = [UIButton new];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateSelected];
    [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    button.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    [button addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = @[].mutableCopy;
    }
    return _buttons;
}

-(NSArray *)titleCodeArr{
    return @[@"all",@"beijing",@"shanghai",@"shenzhen"];
}

-(NSArray *)titles{
    return @[@"全部",@"北京市",@"上海市",@"深圳市"];
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColor(@"#FFFFFF");
        _lineView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = CA_H_F8COLOR;
        _bgView.layer.cornerRadius = 3*2*CA_H_RATIO_WIDTH;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

@end
