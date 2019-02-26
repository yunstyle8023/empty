//
//  CA_HFoundSearchViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HFoundSearchViewManager : NSObject

@property (nonatomic, strong) UITextField *titleView;

- (UIBarButtonItem *)rightBarButtonItem:(id)target action:(SEL)action;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

- (UICollectionReusableView *)header:(NSIndexPath *)indexPath target:(id)target action:(SEL)action;

- (UITableViewHeaderFooterView *)searchHeader:(NSString *)text;

- (UIView *)tableBackView:(NSString *)nullText;

@end
