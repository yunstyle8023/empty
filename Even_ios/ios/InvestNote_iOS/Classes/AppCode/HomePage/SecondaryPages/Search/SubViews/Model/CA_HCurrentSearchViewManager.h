//
//  CA_HCurrentSearchViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HCurrentSearchViewManager : NSObject

@property (nonatomic, strong) UITextField * titleView;

- (UIBarButtonItem *)rightBarButtonItem:(id)target action:(SEL)action;

@property (nonatomic, strong) UITableView * tableView;

@end
