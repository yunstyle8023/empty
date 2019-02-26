//
//  CA_HAddFileViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HAddFileViewModel : NSObject

@property (nonatomic, copy) CA_HBaseViewController * (^getControllerBlock)(void);
@property (nonatomic, copy) void (^pushBlock)(NSString * classStr, NSDictionary * kvcDic);
@property (nonatomic, copy) void (^backBlock)(BOOL isDone);

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIBarButtonItem * rightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * leftBarButtonItem;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, copy) void (^checkDirectoryBlock)(void);
@property (nonatomic, copy) void (^finishCheckBlock)(BOOL success);

@property (nonatomic, copy) void (^addShareFileBlock)(NSString *fileName, NSData *data);

@end
