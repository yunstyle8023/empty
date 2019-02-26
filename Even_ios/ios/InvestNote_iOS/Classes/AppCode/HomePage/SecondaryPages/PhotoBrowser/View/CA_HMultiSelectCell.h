//
//  CA_HMultiSelectCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HMultiSelectCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) NSUInteger number;

@property (nonatomic, copy) NSUInteger (^selectedBlock)(BOOL isSelected);

@end
