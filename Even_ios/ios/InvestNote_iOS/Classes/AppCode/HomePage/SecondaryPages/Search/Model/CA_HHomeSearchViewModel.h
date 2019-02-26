//
//  CA_HHomeSearchViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/28.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HHomeSearchViewModel : NSObject

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * data;

@property (nonatomic, strong) UITextField * titleView;

@property (nonatomic, strong) UIBarButtonItem * rightBarButtonItem;

@property (nonatomic, copy) CA_HBaseViewController * (^getControllerBlock)(void);

@property (nonatomic, copy) void (^backBlock)(void);

// 跳转
@property (nonatomic, copy) void (^pushBlock)(NSString * classStr, NSDictionary * kvcDic);

- (void)setButtonTitle:(NSString *)text;

@end
