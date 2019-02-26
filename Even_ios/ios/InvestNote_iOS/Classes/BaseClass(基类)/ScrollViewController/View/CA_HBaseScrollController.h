//
//  CA_HBaseScrollViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

@interface CA_HBaseScrollController : CA_HBaseViewController

@property (nonatomic,assign) NSInteger currentIndex;

- (CGRect)buttonViewFrame;
- (CGRect)scrollViewFrame;
- (NSArray *)scrollViewTitles;
- (UIView *)scrollViewContentViewWithItem:(NSInteger)item;

- (UIScrollView *)customScrollView;
- (UIScrollView *)customScrollViewWithBtnFont:(CGFloat)font normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor;

-(void)didSelectIndex:(NSInteger)currentIndex;
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)cleanScrollView;

@end
