//
//  CA_MDiscoverRelatedProjectCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_MDiscoverRelatedProjectCell : CA_HBaseTableCell
@property (nonatomic,strong) UIImageView *sloganImgView;
@property (nonatomic,strong) UILabel *sloganLb;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,copy) void(^pushBlock)(NSIndexPath *indexPath);
@end
