//
//  CA_MCustomAccessoryView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MCustomAccessoryView : UIView

@property(nonatomic,strong)UIView* bgView;

@property(nonatomic,strong)UILabel* titleLb;

@property(nonatomic,strong)UIImageView* arrowImgView;

@property(nonatomic,copy)dispatch_block_t tapBlock;

@end
