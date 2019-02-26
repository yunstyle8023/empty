//
//  CA_MProjectContentScrollView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_MProjectModel;
@class CA_HBrowseFoldersViewModel;

@interface CA_MProjectContentScrollView : UIScrollView

-(instancetype)initWithFrame:(CGRect)frame pId:(NSNumber *)pid;

@property (nonatomic,strong) CA_MProjectModel *model;

@property (nonatomic, strong) CA_HBrowseFoldersViewModel *viewModel;

@property (nonatomic, copy) CA_HBaseViewController *(^pushBlock)(NSString * classStr, NSDictionary * kvcDic);

@end
