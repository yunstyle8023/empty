//
//  CA_HAddButton.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/6/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HAddButton : UIButton

+ (CA_HAddButton *)newAdd;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, copy) NSString *selectString;

@property (nonatomic, strong) NSArray<NSDictionary *> *items;//title:NSString,image:UIImage,size:NSString,font:UIFont
@property (nonatomic, copy) void (^onItemBlock)(NSInteger index, NSDictionary *itemDic, UIButton *item);

@property (nonatomic, copy) void (^onButtonBlock)(CA_HAddButton *sender);

- (void)showShadowLayer;
@property (nonatomic, assign) BOOL noItemAnimate;

@end
