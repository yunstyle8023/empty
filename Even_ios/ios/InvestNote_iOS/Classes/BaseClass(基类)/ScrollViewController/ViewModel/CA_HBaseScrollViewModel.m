//
//  CA_HBaseScrollViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseScrollViewModel.h"

@interface CA_HBaseScrollViewModel ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *buttonView;

@end

@implementation CA_HBaseScrollViewModel

#pragma mark --- Action

- (void)onButton:(UIButton *)sender {
    if (sender.selected == NO) {
        if (_scrollBlock) {
            _scrollBlock(sender.tag-100);
        }
    }
}

#pragma mark --- Lazy

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [UIView new];
        view.userInteractionEnabled = NO;
        view.tag = 200;
        _lineView = view;
    }
    return _lineView;
}

- (NSMutableArray *)contentViews {
    if (!_contentViews) {
        _contentViews = [NSMutableArray new];
    }
    return _contentViews;
}

- (UIView *(^)(NSArray *, UIScrollView *, UIFont *, UIColor *, UIColor *))buttonViewBlock {
    if (!_buttonViewBlock) {
        CA_H_WeakSelf(self);
        _buttonViewBlock = ^UIView *(NSArray *titles, UIScrollView *superView, UIFont *font, UIColor *normalColor, UIColor *selectColor) {
            CA_H_StrongSelf(self);
            return [self buttonView:titles superView:superView font:font normalColor:normalColor selectColor:selectColor];
        };
    }
    return _buttonViewBlock;
}

- (CA_HBaseScrollView *(^)(id))scrollViewBlcok {
    if (!_scrollViewBlcok) {
        CA_H_WeakSelf(self);
        _scrollViewBlcok = ^CA_HBaseScrollView *(id delegate) {
            CA_H_StrongSelf(self);
            CA_HBaseScrollView *scrollView = [CA_HBaseScrollView new];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.bounces = NO;
            scrollView.pagingEnabled = YES;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.delegate = delegate;
            return scrollView;
        };
    }
    return _scrollViewBlcok;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIView *)buttonView:(NSArray *)titles superView:(UIScrollView *)superView font:(UIFont *)font normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor {
    
    CGFloat width = [self width:titles superWidth:CGRectGetWidth(superView.frame) font:font];
    CGFloat totalWidth = [[titles componentsJoinedByString:@""] widthForFont:font]+width*titles.count;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    _buttonView = view;
    [_buttonView addSubview:self.lineView];
    [self.lineView removeAllSubviews];
    [superView addSubview:view];
    
    if (totalWidth < CGRectGetWidth(superView.frame)) {
        view.frame = CGRectMake((CGRectGetWidth(superView.frame)-totalWidth)/2, 0, totalWidth, CGRectGetHeight(superView.frame));
        superView.scrollEnabled = NO;
    } else {
        view.frame = CGRectMake(0, 0, totalWidth, CGRectGetHeight(superView.frame));
        superView.scrollEnabled = YES;
    }
    superView.contentSize = CGSizeMake(totalWidth, CGRectGetHeight(superView.frame));
    
    UIView *leftView = view;
    for (NSInteger i=0; i < titles.count; i++) {
        
        NSString *title = titles[i];
        CGFloat buttonWidth = [title widthForFont:font]+width;
        
        UIButton *button = [self button:title font:font normalColor:normalColor selectColor:selectColor index:i];
        
        
        if (i == 0) {
            if (titles.count == 1) {
                button.userInteractionEnabled = NO;
            } else {
                self.lineView.frame = CGRectMake(0, CGRectGetHeight(superView.frame)-2*CA_H_RATIO_WIDTH, buttonWidth, 2*CA_H_RATIO_WIDTH);
                button.selected = YES;
            }
        }
        
        
        [view addSubview:button];
        button.sd_layout
        .widthIs(buttonWidth)
        .heightIs(CGRectGetHeight(superView.frame))
        .topEqualToView(view)
        .leftSpaceToView(leftView, 0);
        
        leftView = button;
        
    }
    
    UILabel * line = [UILabel new];
    line.backgroundColor = selectColor;
    line.frame = CGRectMake((self.lineView.width-self.lineWidth)/2, 0, self.lineWidth, self.lineView.height);
    line.layer.cornerRadius = self.lineView.height/2;
    line.layer.masksToBounds = YES;
    [self.lineView addSubview:line];
    
    return view;
}

- (CGFloat)width:(NSArray *)titles superWidth:(CGFloat)superWidth font:(UIFont *)font{
    
    NSString *totalTitle = [titles componentsJoinedByString:@""];
    CGFloat width = [totalTitle widthForFont:font];
    
    if (width+30*CA_H_RATIO_WIDTH*titles.count >= superWidth) {
        return 30*CA_H_RATIO_WIDTH;
    }
    
    if (width+60*CA_H_RATIO_WIDTH*titles.count <= superWidth) {
        return 60*CA_H_RATIO_WIDTH;
    }
    
    return (superWidth-width)/titles.count;
}

- (UIButton *)button:(NSString *)title font:(UIFont *)font normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor index:(NSInteger)index {
    UIButton * button = [UIButton new];
    button.tag = 100+index;
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:selectColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (CGFloat)lineWidth {
    return 16*CA_H_RATIO_WIDTH;
}

#pragma mark --- scroll

- (void (^)(UIScrollView *))scrollViewDidScrollBlock {
    if (!_scrollViewDidScrollBlock) {
        CA_H_WeakSelf(self);
        _scrollViewDidScrollBlock = ^(UIScrollView * scrollView) {
            CA_H_StrongSelf(self);
            [self scrollViewDidScroll:scrollView];
        };
    }
    return _scrollViewDidScrollBlock;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIButton *buttonL = nil;
    UIButton *buttonR = nil;
    for (UIButton * btn in self.buttonView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (CGRectContainsPoint(btn.frame, self.lineView.origin)) {
                buttonL = btn;
            }
            if (CGRectContainsPoint(btn.frame, CGPointMake(self.lineView.right, 0))) {
                buttonR = btn;
            }
            if (buttonL&&buttonR) {
                break;
            }
        }
    }
    
    if (!buttonR) buttonR = buttonL;
    if (!buttonL) buttonL = buttonR;
    
    CGFloat change = scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds) - (buttonL.tag-100);
    self.lineView.left = buttonL.left+buttonL.width*change;
    self.lineView.width = buttonL.width*(1-change)+buttonR.width*change;
    
    UIScrollView *superView = (id)self.buttonView.superview;
    if (self.lineView.right-superView.contentOffset.x > superView.width-2*CA_H_RATIO_WIDTH) {
        if ((self.lineView.right < superView.contentSize.width+62*CA_H_RATIO_WIDTH)) {
            [UIView animateWithDuration:0.25 animations:^{
                [superView setContentOffset:CGPointMake(MIN(self.lineView.right+self.lineView.width, superView.contentSize.width)-superView.width, 0)];
            }];
        }
    }else if (self.lineView.left < superView.contentOffset.x+62*CA_H_RATIO_WIDTH){
        if (self.lineView.left > - 2*CA_H_RATIO_WIDTH) {
            [UIView animateWithDuration:0.25 animations:^{
                [superView setContentOffset:CGPointMake(MAX(self.lineView.left-self.lineView.width, 0), 0)];
            }];
        }
    }
    
    for (UIButton * btn in self.buttonView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (CGRectContainsPoint(btn.frame, self.lineView.center)) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
    }
    

    UILabel *line = (id)self.lineView.subviews.firstObject;
    line.mj_w = (1-2*fabs(change-0.5))*(self.lineView.mj_w-self.lineWidth) + self.lineWidth;
    line.centerX = self.lineView.mj_w/2.0;
}


@end
