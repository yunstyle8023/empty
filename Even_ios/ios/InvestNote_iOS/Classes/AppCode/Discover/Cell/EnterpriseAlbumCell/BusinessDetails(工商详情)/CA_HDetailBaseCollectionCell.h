//
//  CA_HDetailBaseCollectionCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HDetailBaseCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIView *backView;
- (void)upView;
@property (nonatomic, strong) id model;
@property (nonatomic, copy) void (^block)(void);

@end
