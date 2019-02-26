//
//  CA_MProjectContentSelectView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_MProjectModel;

@interface CA_MProjectContentSelectView : UIView

@property (nonatomic,strong) CA_MProjectModel *model;

@property (nonatomic,strong) NSMutableArray<UIButton *> *buttons;

@property(nonatomic,strong) UIView *lineView;

@property (nonatomic,assign) NSInteger currenIndex;

@property (nonatomic,copy) void(^didSelect)(NSInteger index);

@property (nonatomic,copy) dispatch_block_t jumpBlock;

-(void)didScroll:(CGFloat)x;

-(void)didEndScroll:(CGFloat)x;

-(void)buttonAction:(UIButton *)sender;

@end
