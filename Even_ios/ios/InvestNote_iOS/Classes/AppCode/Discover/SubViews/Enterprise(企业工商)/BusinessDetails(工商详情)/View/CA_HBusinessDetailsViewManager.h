//
//  CA_HBusinessDetailsViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HBusinessDetailsViewManager : NSObject

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tagLabel;
- (void)customTop:(NSString *)title tag:(NSString *)tag target:(id)target action:(SEL)action;

@property (nonatomic, strong) UICollectionView *collectionView;
- (UICollectionReusableView *)header:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *headerImage;

@end
