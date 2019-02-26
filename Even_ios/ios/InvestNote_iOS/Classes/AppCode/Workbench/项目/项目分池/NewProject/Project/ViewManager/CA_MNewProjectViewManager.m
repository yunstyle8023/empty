//
//  CA_MNewProjectViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectViewManager.h"
#import "CA_MProjectSearchView.h"
#import "CA_MNewProjectSearchView.h"
#import "CA_MNewProjectSectionView.h"
#import "CA_MNewProjectFooterView.h"
#import "CA_MNewProjectAllTypeCell.h"
#import "CA_MNewProjectAttentionCell.h"
#import "CA_MNewProjectStoreCell.h"
#import "CA_MNewProjectPlanCell.h"
#import "CA_MNewProjectAlreadyCell.h"
#import "CA_MNewProjectNoItemCell.h"
#import "CA_MEmptyView.h"

@interface CA_MNewProjectViewManager ()

@end

@implementation CA_MNewProjectViewManager

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0.;
        layout.minimumInteritemSpacing = 0.;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundView = [CA_MEmptyView newTitle:@"当前您还没有参与任何项目" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_project"];
        _collectionView.backgroundView.hidden = YES;
        [_collectionView registerClass:[CA_MNewProjectAllTypeCell class] forCellWithReuseIdentifier:@"NewProjectAllTypeCell"];
        [_collectionView registerClass:[CA_MNewProjectAttentionCell class] forCellWithReuseIdentifier:@"NewProjectAttentionCell"];
        [_collectionView registerClass:[CA_MNewProjectStoreCell class] forCellWithReuseIdentifier:@"NewProjectStoreCell"];
        [_collectionView registerClass:[CA_MNewProjectPlanCell class] forCellWithReuseIdentifier:@"NewProjectPlanCell"];
        [_collectionView registerClass:[CA_MNewProjectAlreadyCell class] forCellWithReuseIdentifier:@"NewProjectAlreadyCell"];
        [_collectionView registerClass:[CA_MNewProjectNoItemCell class] forCellWithReuseIdentifier:@"NewProjectNoItemCell"];
        
        [_collectionView registerClass:[CA_MNewProjectSearchView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewProjectSearchView"];
        [_collectionView registerClass:[CA_MNewProjectSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewProjectSectionView"];
        [_collectionView registerClass:[CA_MNewProjectFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NewProjectFooterView"];
    }
    return _collectionView;
}

-(CA_MNewProjectSearchView *)searchView{
    if (!_searchView) {
        _searchView = [CA_MNewProjectSearchView new];
    }
    return _searchView;
}

-(void)clickTitleViewBtnAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    self.titleBlock?self.titleBlock(sender):nil;
}

-(void)clickLeftBarBtnAction{
    self.leftBlock?self.leftBlock():nil;
}

-(void)clickRightBarBtnAction{
    self.rightBlock?self.rightBlock():nil;
}

-(UIBarButtonItem *)leftBarBtn{
    if (!_leftBarBtn) {
        UIButton *leftButton = [UIButton new];
        [leftButton configTitle:@"设置"
                     titleColor:CA_H_TINTCOLOR
                           font:16];
        [leftButton sizeToFit];
        [leftButton addTarget: self
                       action: @selector(clickLeftBarBtnAction)
             forControlEvents: UIControlEventTouchUpInside];
        _leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    return _leftBarBtn;
}

-(UIBarButtonItem *)rightBarBtn{
    if (!_rightBarBtn) {
        UIButton *rightButton = [UIButton new];
        [rightButton configTitle:@"添加项目"
                     titleColor:CA_H_TINTCOLOR
                           font:16];
        [rightButton sizeToFit];
        [rightButton addTarget: self
                       action: @selector(clickRightBarBtnAction)
             forControlEvents: UIControlEventTouchUpInside];
        _rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _rightBarBtn;
}

-(UIButton *)titleViewBtn{
    if (!_titleViewBtn) {
        _titleViewBtn = [UIButton new];
        [_titleViewBtn configTitle:@"项目"
                        titleColor:CA_H_4BLACKCOLOR
                              font:17];
        [_titleViewBtn setImage:kImage(@"details_down") forState:UIControlStateNormal];
        [_titleViewBtn setImage:kImage(@"details_up") forState:UIControlStateSelected];
        [self changeTitleSpace:@"项目"];
        [_titleViewBtn sizeToFit];
        [_titleViewBtn addTarget:self action:@selector(clickTitleViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _titleViewBtn.selected = NO;
    }
    return _titleViewBtn;
}

-(void)changeTitleSpace:(NSString*)item{
    CGFloat spacing = 5.0;
    CGFloat imageWidth = kImage(@"details_up").size.width;
    self.titleViewBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageWidth * 2 - spacing, 0.0, 0.0);
    CGFloat titleWidth = [item widthForFont:CA_H_FONT_PFSC_Regular(17)];
    self.titleViewBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleWidth * 2 - spacing);
}

@end
