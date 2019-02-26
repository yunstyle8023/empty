//
//  CA_MEmptyView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MEmptyView.h"

@interface CA_MEmptyView ()

@property (nonatomic, copy) void (^block)(void);

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic,strong) CA_HSetLabel *label;
@property (nonatomic,strong) UILabel *messageLb;
@property (nonatomic,strong) CA_HSetButton * button;
@end

@implementation CA_MEmptyView

+ (instancetype)newTitle:(NSString *)title
             buttonTitle:(NSString *)buttonTitle
                     top:(CGFloat)top
                onButton:(void(^)(void))block
               imageName:(NSString *)imageName {
    CA_MEmptyView * view = [self new];
    view.block = block;
    [view viewTitle:title messageStr:@"" buttonTitle:buttonTitle top:top imageName:imageName];
    
    return view;
}

+ (instancetype)newTitle:(NSString *)title
              messageStr:(NSString *)messageStr
             buttonTitle:(NSString *)buttonTitle
                     top:(CGFloat)top
                onButton:(void(^)(void))block
               imageName:(NSString *)imageName {
    CA_MEmptyView * view = [self new];
    view.block = block;
    [view viewTitle:title messageStr:messageStr buttonTitle:buttonTitle top:top imageName:imageName];
    
    return view;
}

- (void)viewTitle:(NSString *)title messageStr:(NSString *)messageStr buttonTitle:(NSString *)buttonTitle top:(CGFloat)top imageName:(NSString *)imageName {
    
    self.imageView = [UIImageView new];
    if (imageName) {
        self.imageView.image = [UIImage imageNamed:imageName];
    }
    
    [self addSubview:self.imageView];
    self.imageView.sd_layout
    .widthIs(185*CA_H_RATIO_WIDTH)
    .heightIs(162*CA_H_RATIO_WIDTH)
    .centerXEqualToView(self)
    .topSpaceToView(self, top);
    
    
    self.label = [CA_HSetLabel new];
    self.label.textColor = CA_H_TINTCOLOR;
    self.label.font = CA_H_FONT_PFSC_Regular(18);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    self.label.text = title;
    
    [self addSubview:self.label];
    self.label.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.imageView, 39*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.label setMaxNumberOfLinesToShow:0];
    [self.label setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-40*CA_H_RATIO_WIDTH];
    
    
    if (![NSString isValueableString:messageStr]) {
        if ([NSString isValueableString:buttonTitle]) {
            self.button = [CA_HSetButton new];
            
            [self.button setBackgroundColor:CA_H_TINTCOLOR];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:buttonTitle];
            NSRange titleRange = {0, [title length]};
            [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone]range:titleRange];
            [title addAttribute:NSForegroundColorAttributeName value:kColor(@"#FFFFFF") range:titleRange];
            [title addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(18) range:titleRange];
            [self.button setAttributedTitle:title forState:UIControlStateNormal];
            
            [self.button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:self.button];
            
            self.button.sd_layout
            .widthIs(146*CA_H_RATIO_WIDTH)
            .heightIs(48*CA_H_RATIO_WIDTH)
            .centerXEqualToView(self)
            .topSpaceToView(self.label, 30*CA_H_RATIO_WIDTH);
            
            self.button.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
        }
    }else {
        
        self.messageLb = [UILabel new];
        [self.messageLb configText:messageStr textColor:CA_H_TINTCOLOR font:14];
        self.messageLb.textAlignment = NSTextAlignmentCenter;
        self.messageLb.alpha = 0.5;
        self.messageLb.numberOfLines = 0;
        [self addSubview:self.messageLb];
        
        self.messageLb.sd_layout
        .topSpaceToView(self.label, 5*2*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self, 28*2*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self, 28*2*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [self.messageLb setMaxNumberOfLinesToShow:0];
        
        if ([NSString isValueableString:buttonTitle]) {
            self.button = [CA_HSetButton new];
            
            [self.button setBackgroundColor:CA_H_TINTCOLOR];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:buttonTitle];
            NSRange titleRange = {0, [title length]};
            [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone]range:titleRange];
            [title addAttribute:NSForegroundColorAttributeName value:kColor(@"#FFFFFF") range:titleRange];
            [title addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(18) range:titleRange];
            [self.button setAttributedTitle:title forState:UIControlStateNormal];
            
            [self.button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:self.button];
            
            self.button.sd_layout
            .widthIs(85*2*CA_H_RATIO_WIDTH)
            .heightIs(24*2*CA_H_RATIO_WIDTH)
            .centerXEqualToView(self)
            .topSpaceToView(self.messageLb, 30*CA_H_RATIO_WIDTH);
            
            self.button.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
        }
    }
    
    
}

- (void)onButton:(UIButton *)sender{
    if (_block) {
        _block();
    }
}

- (void)updateTitle:(NSString*)title buttonTitle:(NSString *)buttonTitle imageName:(NSString*)imageName{
    self.label.text = title;
    self.button.hidden = ![NSString isValueableString:buttonTitle];
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
    
    if (![buttonTitle isEqualToString:@"重新筛选"]) {
        [self.button setBackgroundColor:CA_H_TINTCOLOR];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:buttonTitle];
        NSRange titleRange = {0, [title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:titleRange];
        [title addAttribute:NSForegroundColorAttributeName value:kColor(@"#FFFFFF") range:titleRange];
        [title addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(18) range:titleRange];
        [self.button setAttributedTitle:title forState:UIControlStateNormal];
    }else{
        [self.button setBackgroundColor:kColor(@"#FFFFFF")];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:buttonTitle];
        NSRange titleRange = {0, [title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [title addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:titleRange];
        [title addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(18) range:titleRange];
        [self.button setAttributedTitle:title forState:UIControlStateNormal];
    }
    
    self.imageView.image = kImage(imageName);
    
    
}

@end

