//
//  CA_MDiscoverProjectDetailViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailViewManager.h"
#import "CA_MDiscoverProjectDetailHeaderView.h"
#import "CA_MDiscoverProjectDetailAddView.h"
#import "CA_MDiscoverProjectDetailInfoCell.h"
#import "CA_MDiscoverProjectDetailFinancInfoCell.h"
#import "CA_MDiscoverProjectDetailCorePersonCell.h"
#import "CA_MDiscoverProjectDetailProductCell.h"
#import "CA_MDiscoverProjectDetailNewsCell.h"
#import "CA_MDiscoverProjectDetailRelatedProductCell.h"
#import "CA_MDiscoverProjectDetailModel.h"

@implementation CA_MDiscoverProjectDetailViewManager


-(UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = kColor(@"#FFFFFF");
    [_scrollView addSubview:self.tableView];
    return _scrollView;
}

-(void)setModel:(CA_MDiscoverProjectDetailModel *)model{
    _model = model;
    
    CGFloat collectionViewHeight = [self.headerView configView:model];
    
    CGFloat nameHeight =  [model.project_name heightForFont:CA_H_FONT_PFSC_Regular(20) width:CA_H_SCREEN_WIDTH - 50*2*CA_H_RATIO_WIDTH];
    
    CGFloat detailHeight = [@"标准高度" heightForFont:CA_H_FONT_PFSC_Regular(14) width:CA_H_SCREEN_WIDTH - 50*2*CA_H_RATIO_WIDTH];
    
    CGFloat totalHeight = 5*2*CA_H_RATIO_WIDTH +nameHeight+2*2*CA_H_RATIO_WIDTH+detailHeight+5*2*CA_H_RATIO_WIDTH;
    if ([NSObject isValueableObject:model.tag_list]) {
        totalHeight += collectionViewHeight+10*2*CA_H_RATIO_WIDTH;
    }else{
        totalHeight += 5*2*CA_H_RATIO_WIDTH;
    }
    
    self.headerView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, totalHeight);
    self.tableView.tableHeaderView = self.headerView;
    [CA_HShadow dropShadowWithView:self.headerView
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 36*2*CA_H_RATIO_WIDTH)];
        _tableView.scrollEnabled = NO;
        _tableView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, CA_H_SCREEN_HEIGHT);
        
        [_tableView registerClass:[CA_MDiscoverProjectDetailInfoCell class] forCellReuseIdentifier:@"InfoCell"];
        [_tableView registerClass:[CA_MDiscoverProjectDetailFinancInfoCell class] forCellReuseIdentifier:@"FinancInfoCell"];
        [_tableView registerClass:[CA_MDiscoverProjectDetailCorePersonCell class] forCellReuseIdentifier:@"CorePersonCell"];
        [_tableView registerClass:[CA_MDiscoverProjectDetailProductCell class] forCellReuseIdentifier:@"ProductCell"];
        [_tableView registerClass:[CA_MDiscoverProjectDetailNewsCell class] forCellReuseIdentifier:@"NewsCel"];
        [_tableView registerClass:[CA_MDiscoverProjectDetailRelatedProductCell class] forCellReuseIdentifier:@"RelatedProjectCell"];
    }
    return _tableView;
}

-(CA_MDiscoverProjectDetailHeaderView *)headerView{
    if (!_headerView) {
        CGRect rect = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, (31+10)*2*CA_H_RATIO_WIDTH);
        _headerView = [[CA_MDiscoverProjectDetailHeaderView alloc] initWithFrame:rect];
    }
    return _headerView;
}

-(CA_MDiscoverProjectDetailAddView *)addView{
    if (!_addView) {
        CGRect rect = CGRectMake(CA_H_SCREEN_WIDTH/2 - 62*CA_H_RATIO_WIDTH, CA_H_SCREEN_HEIGHT - (kDevice_Is_iPhoneX?88:64) - (10+21)*2*CA_H_RATIO_WIDTH , 62*2*CA_H_RATIO_WIDTH, 21*2*CA_H_RATIO_WIDTH);
        _addView = [[CA_MDiscoverProjectDetailAddView alloc] initWithFrame:rect];
        _addView.hidden = YES;
    }
    return _addView;
}

-(UIButton *)titleView{
    if (_titleView) {
        return _titleView;
    }
    _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleView configTitle:@"" titleColor:CA_H_4BLACKCOLOR font:17];
    _titleView.frame = CGRectMake(0, 0, 200*CA_H_RATIO_WIDTH, 44);
    _titleView.titleLabel.alpha = 0.01f;
    return _titleView;
}

-(void)clickSharBarBtnAction{
    if (self.delegate
        &&
        [self.delegate respondsToSelector:@selector(clickSharBarBtnClick)]) {
        [self.delegate clickSharBarBtnClick];
    }
}

-(void)clickShotBarBtnAction{
    if (self.delegate
        &&
        [self.delegate respondsToSelector:@selector(clickShotBarBtnClick)]) {
        [self.delegate clickShotBarBtnClick];
    }
}


-(UIBarButtonItem *)sharBarBtnItem{
    if (!_sharBarBtnItem) {
        UIButton * sharButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sharButton setImage:kImage(@"share_icon2") forState:UIControlStateNormal];
        [sharButton sizeToFit];
        [sharButton addTarget: self action: @selector(clickSharBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
        _sharBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sharButton];
    }
    return _sharBarBtnItem;
}

-(UIBarButtonItem *)shotBarBtnItem{
    if (!_shotBarBtnItem) {
        UIButton * shotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shotButton setImage:kImage(@"pic_share") forState:UIControlStateNormal];
        [shotButton sizeToFit];
        [shotButton addTarget: self action: @selector(clickShotBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
        _shotBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shotButton];
    }
    return _shotBarBtnItem;
}

@end
