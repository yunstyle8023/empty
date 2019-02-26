//
//  CA_HBaseScrollViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseScrollController.h"

#import "CA_HBaseScrollViewModel.h"

@interface CA_HBaseScrollController () <UIScrollViewDelegate>

@property (nonatomic, strong) CA_HBaseScrollViewModel *_viewModel;

@property (nonatomic, strong) CA_HBaseScrollView *_scrollView;
@property (nonatomic, strong) UIScrollView *_buttonScrollView;
@property (nonatomic, strong) UIView *_buttonView;

@property (nonatomic, strong) UIFont *_font;
@property (nonatomic, strong) UIColor *_normalColor;
@property (nonatomic, strong) UIColor *_selectColor;

@end

@implementation CA_HBaseScrollController


#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HBaseScrollViewModel *)_viewModel {
    if (!__viewModel) {
        CA_HBaseScrollViewModel *model = [CA_HBaseScrollViewModel new];
        
        CA_H_WeakSelf(self);
        model.scrollBlock = ^(NSInteger index) {
            CA_H_StrongSelf(self);
            self.currentIndex = index;
            [self didSelectIndex:self.currentIndex];
            [self._scrollView setContentOffset:CGPointMake(CGRectGetWidth(self._scrollView.frame)*index, 0) animated:YES];
        };
        
        __viewModel = model;
    }
    return __viewModel;
}

- (UIFont *)_font {
    if (!__font) {
        __font = CA_H_FONT_PFSC_Regular(16);
    }
    return __font;
}

- (UIColor *)_normalColor {
    if (!__normalColor) {
        __normalColor = CA_H_9GRAYCOLOR;
    }
    return __normalColor;
}

- (UIColor *)_selectColor {
    if (!__selectColor) {
        __selectColor = CA_H_TINTCOLOR;
    }
    return __selectColor;
}

- (CA_HBaseScrollView *)_scrollView {
    if (!__scrollView) {
        CA_HBaseScrollView *scrollView = self._viewModel.scrollViewBlcok(self);
        CA_H_WeakSelf(self);
        scrollView.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(self);
            [self contentView:frame];
        };
        UIGestureRecognizer * screenEdgePanGestureRecognizer = self.navigationController.interactivePopGestureRecognizer;
        if(screenEdgePanGestureRecognizer)
            [scrollView.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
        __scrollView = scrollView;
    }
    return __scrollView;
}

- (UIScrollView *)_buttonScrollView {
    if (!__buttonScrollView) {
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.frame = self.buttonViewFrame;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor whiteColor];
        
        __buttonScrollView = scrollView;
    }
    return __buttonScrollView;
}

- (UIView *)_buttonView {
    if (!__buttonView) {
        __buttonView = self._viewModel.buttonViewBlock(self.scrollViewTitles, self._buttonScrollView, self._font, self._normalColor, self._selectColor);
    }
    return __buttonView;
}

#pragma mark --- LifeCircle

-(void)didSelectIndex:(NSInteger)currentIndex{
    
}

#pragma mark --- Custom

- (void)cleanScrollView {
    [__scrollView removeFromSuperview];
    __scrollView = nil;
    [__buttonView removeFromSuperview];
    __buttonView = nil;
    [__buttonScrollView removeFromSuperview];
    __buttonScrollView = nil;
    UIView *shadowView = [self.view viewWithTag:88899];
    [shadowView removeFromSuperview];
}

- (void)contentView:(CGRect)frame {
    for (NSInteger i=0; i<self.scrollViewTitles.count; i++) {
        UIView *view;
        if (i>=self._viewModel.contentViews.count) {
            view = [self scrollViewContentViewWithItem:i];
            if (!view.superview) {
                [self._viewModel.contentViews addObject:view];
                [self._scrollView addSubview:view];
            }
        } else {
            view = self._viewModel.contentViews[i];
        }
        view.frame = CGRectMake(i*CGRectGetWidth(frame), 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    }
    self._scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame)*self.scrollViewTitles.count, CGRectGetHeight(frame));
    
    if (!self._buttonScrollView.superview) {
        UIView * shadowView = [UIView new];
        shadowView.tag = 88899;
        shadowView.backgroundColor = [UIColor whiteColor];
        CGRect shadowFrame = frame;
        shadowFrame.origin.y -= CGRectGetHeight(self._buttonScrollView.frame);
        shadowFrame.size.height = CGRectGetHeight(self._buttonScrollView.frame);
        if (shadowFrame.size.height < 3) {
            CGFloat sheight = 3-shadowFrame.size.height;
            shadowFrame.origin.y -= sheight;
            shadowFrame.size.height += sheight;
        }
        shadowView.frame = shadowFrame;
        [CA_HShadow dropShadowWithView:shadowView
                                offset:CGSizeMake(0, 3)
                                radius:3
                                 color:CA_H_SHADOWCOLOR
                               opacity:0.3];
        
        [self.view addSubview:shadowView];
        [self.view addSubview:self._buttonScrollView];
    } else {
        UIView * shadowView = [self.view viewWithTag:88899];
        CGRect shadowFrame = frame;
        shadowFrame.origin.y -= CGRectGetHeight(self._buttonScrollView.frame);
        shadowFrame.size.height = CGRectGetHeight(self._buttonScrollView.frame);
        if (shadowFrame.size.height < 3) {
            CGFloat sheight = 3-shadowFrame.size.height;
            shadowFrame.origin.y -= sheight;
            shadowFrame.size.height += sheight;
        }
        shadowView.frame = shadowFrame;
    }
}

- (UIScrollView *)customScrollView {
    return [self customScrollViewWithBtnFont:0 normalColor:nil selectColor:nil];
}
- (UIScrollView *)customScrollViewWithBtnFont:(CGFloat)font normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor {
    
    if (__scrollView) {
        return __scrollView;
    }
    
    if (font > 0) self._font = CA_H_FONT_PFSC_Regular(font);
    if (normalColor) self._normalColor = normalColor;
    if (selectColor) self._selectColor = selectColor;
    
    
    [self.view addSubview:self._scrollView];
    
    CGRect scrollViewFrame = self.scrollViewFrame;
    if (CGRectIsEmpty(scrollViewFrame)) {
        self._scrollView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(CGRectGetHeight(self._buttonScrollView.frame), 0, 0, 0));
    } else {
        self._scrollView.frame = scrollViewFrame;
        [self contentView:scrollViewFrame];
    }
    
    [self _buttonView];
    
    [self.view layoutSubviews];
    
    return self._scrollView;
}

- (CGRect)buttonViewFrame {
    return CGRectMake(15*CA_H_RATIO_WIDTH, 0, CA_H_SCREEN_WIDTH-30*CA_H_RATIO_WIDTH, 36*CA_H_RATIO_WIDTH);
}

- (CGRect)scrollViewFrame {
    return CGRectNull;
}

- (NSArray *)scrollViewTitles {
    return @[];
}

- (UIView *)scrollViewContentViewWithItem:(NSInteger)item {
    return [UIView new];
}

#pragma mark --- Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(self._scrollView.contentOffset.x > 1){
        return NO;
    }else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

#pragma mark --- Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self._scrollView) {
        
        [self.view endEditing:YES];
        self._viewModel.scrollViewDidScrollBlock(scrollView);
        return;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.currentIndex = scrollView.contentOffset.x / CA_H_SCREEN_WIDTH;
}

@end
