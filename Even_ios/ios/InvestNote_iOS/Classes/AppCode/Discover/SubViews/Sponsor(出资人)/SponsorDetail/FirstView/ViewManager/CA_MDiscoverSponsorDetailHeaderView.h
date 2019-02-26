//
//  CA_MDiscoverSponsorDetailHeaderView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_MDiscoverSponsorDetailModel;
@interface CA_MDiscoverSponsorDetailHeaderView : UIView
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,copy) void(^pushBlock)(NSString *tag);
-(CGFloat)configView:(CA_MDiscoverSponsorDetailModel *)model;
@end
