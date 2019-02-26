//
//  CA_MPersonDetailContainerCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailContainerCell.h"
#import "CA_MPersonDetailInfoVC.h"
#import "CA_MPersonModel.h"

@interface CA_MPersonDetailContainerCell()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CA_MPersonDetailInfoVC *detailInfoVC;
@property (nonatomic,assign) CGFloat height;
@end

@implementation CA_MPersonDetailContainerCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.scrollView];
    [self configScrollView];
}

- (void)configChildVC{
    self.detailInfoVC.humanID = self.humanID;
    {
        if (!_twoVC) {
            CA_MPersonDetailLogVC *vc = [CA_MPersonDetailLogVC new];
            _twoVC = vc;
            vc.humanID = self.humanID;
            [self.scrollView addSubview:vc.view];
            vc.view.frame = CGRectMake(CA_H_SCREEN_WIDTH, 0, CA_H_SCREEN_WIDTH, self.height);
        }
        self.twoVC.humanID = self.humanID;
        self.twoVC.pushBlock = _pushBlock;
    }
    
    {
        if (!_threeVC) {
            CA_MPersonDetailFileVC *vc = [CA_MPersonDetailFileVC new];
            _threeVC = vc;
            vc.fileID = self.fileID;
            vc.filePath = self.filePath;
            
            [self.scrollView addSubview:vc.view];
            vc.view.frame = CGRectMake(CA_H_SCREEN_WIDTH * 2, 0, CA_H_SCREEN_WIDTH, self.height);
        }
        self.threeVC.fileID = self.fileID;
        self.threeVC.filePath = self.filePath;
        
        self.threeVC.pushBlock = _pushBlock;
    }
}

- (void)configScrollView {
    self.detailInfoVC = [[CA_MPersonDetailInfoVC alloc] init];
    CA_H_WeakSelf(self);
    self.detailInfoVC.block = ^(CA_MPersonDetailModel *detailModel) {
        CA_H_StrongSelf(self);
        if (self.block) {
            self.block(detailModel);
        }
    };
    
    
    
    [self.scrollView addSubview:self.detailInfoVC.view];
    self.detailInfoVC.view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, self.height);
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 为了横向滑动的时候，外层的tableView不动
    if (!self.isSelectIndex) {
        if (scrollView == self.scrollView) {
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(mmtdOptionalScrollViewDidScroll:)]) {
                [self.delegate mmtdOptionalScrollViewDidScroll:scrollView];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isSelectIndex = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(mmtdOptionalScrollViewDidEndDecelerating:)]) {
            [self.delegate mmtdOptionalScrollViewDidEndDecelerating:scrollView];
        }
    }
}

#pragma mark - Init Views

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, self.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    }
    return _scrollView;
}

- (void)setObjectCanScroll:(BOOL)objectCanScroll {
    _objectCanScroll = objectCanScroll;
    
    self.detailInfoVC.vcCanScroll = objectCanScroll;
    self.twoVC.vcCanScroll = objectCanScroll;
    self.threeVC.vcCanScroll = objectCanScroll;
    
    if (!objectCanScroll) {
        [self.detailInfoVC.tableView setContentOffset:CGPointZero animated:NO];
        [self.twoVC.tableView setContentOffset:CGPointZero animated:NO];
        [self.threeVC.tableView setContentOffset:CGPointZero animated:NO];
    }
}

-(CGFloat)height{
    CGFloat _height = CA_H_SCREEN_HEIGHT - (40*CA_H_RATIO_WIDTH+3) - 48*CA_H_RATIO_WIDTH;
    if (kDevice_Is_iPhoneX) {
        _height = _height - 88 - 34;
    }else{
        _height = _height - 64;
    }
    return _height;
}

@end
