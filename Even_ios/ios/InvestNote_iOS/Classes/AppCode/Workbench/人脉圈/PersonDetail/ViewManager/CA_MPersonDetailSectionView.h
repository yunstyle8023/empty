//
//  CA_MPersonDetailSectionView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MPersonDetailSectionView : UIView
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,copy) void(^changeBlock)(NSInteger index);
-(void)changeLineView:(CGFloat)x;
-(void)changeButton:(NSInteger)index;
@end
