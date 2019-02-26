//
//  CA_HAddMenuView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/25.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HAddMenuView : UIView

@property (nonatomic, strong) NSArray * data;

@property (nonatomic, copy) void (^clickBlock)(NSInteger item);

- (void)showMenu:(BOOL)animated;
- (void)hideMenu:(BOOL)animated;

// custom

@property (nonatomic, assign) CGPoint ca_anchorPoint;
@property (nonatomic, assign) CATransform3D ca_transform;
@property (nonatomic, copy) NSString * cellClass;
@property (nonatomic, copy) void (^cellBlock)(UITableViewCell * cell, NSIndexPath * indexPath);
@property (nonatomic, copy) void (^tableLayoutBlock)(UITableView * tableView);

@end
