//
//  UITableView+CA_HTableView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CA_HTableView)


/**
 自定义创建方法

 @return tableView
 */
+ (instancetype)newTableViewPlain;
+ (instancetype)newTableViewGrouped;


@end
