//
//  CA_HFoundAggregateSearchViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HNullView.h"

@interface CA_HFoundAggregateSearchViewManager : NSObject

@property (nonatomic, strong) UITextField *titleView;

- (UIBarButtonItem *)rightBarButtonItem:(id)target action:(SEL)action;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CA_HNullView *nullView;

- (UICollectionReusableView *)header:(NSIndexPath *)indexPath target:(id)target action:(SEL)action;

- (UITableViewHeaderFooterView *)searchHeader:(NSString *)text;
- (UITableViewHeaderFooterView *)searchFooter:(NSString *)text ActionBlock:(void (^)(id sender))block;

@end
