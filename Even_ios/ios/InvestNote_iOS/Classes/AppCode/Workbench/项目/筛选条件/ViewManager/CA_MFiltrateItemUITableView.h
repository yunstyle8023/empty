//
//  CA_MFiltrateItemUITableView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MFiltrateItemUITableView : UITableView

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,copy) NSString *keyName;

@property (nonatomic,strong) UIColor *cellColor;

@end
