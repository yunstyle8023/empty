//
//  CA_MProjectDetailProjectInfoCollectionViewCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MProjectDetailProjectInfoCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) UIFont *font;
-(void)configCellWithTitleColor:(UIColor*)titleColor
                backgroundColor:(UIColor *)backgroundColor
                    borderColor:(UIColor*)borderColor;
@end

