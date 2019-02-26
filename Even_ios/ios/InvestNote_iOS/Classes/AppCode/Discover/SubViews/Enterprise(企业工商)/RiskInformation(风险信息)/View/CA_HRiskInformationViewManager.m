//
//  CA_HRiskInformationViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRiskInformationViewManager.h"

@interface CA_HRiskInformationViewManager ()

@end

@implementation CA_HRiskInformationViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self flowLayout]];
        _collectionView = collectionView;
        
        collectionView.alwaysBounceVertical = YES;
//        collectionView.contentInset = UIEdgeInsetsMake(20*CA_H_RATIO_WIDTH, 0, 20*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight, 0);
        
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        collectionView.backgroundColor = [UIColor whiteColor];
        
        [collectionView registerClass:NSClassFromString(@"CA_HRiskInformationCollectionCell") forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UICollectionViewFlowLayout *)flowLayout{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 20*CA_H_RATIO_WIDTH;
    
    if (@available(iOS 10.0, *)) {
        flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    } else {
        flowLayout.estimatedItemSize = CGSizeMake(335*CA_H_RATIO_WIDTH, 0);
    }
    
    flowLayout.sectionInset = UIEdgeInsetsMake(20*CA_H_RATIO_WIDTH, 19*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight, 19*CA_H_RATIO_WIDTH);
    
    return flowLayout;
}


#pragma mark --- Delegate

@end
