//
//  CA_MFiltrateItemViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class CA_MFiltrateItemUITableView;
@class CA_MFiltrateItemPanelView;
@class CA_MFiltrateItemChooseView;

@interface CA_MFiltrateItemViewManager : NSObject

@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,strong) CA_MFiltrateItemPanelView *panelView;

@property (nonatomic,strong) CA_MFiltrateItemChooseView *chooseView;

@property (nonatomic,strong) UITableView *outsideTableView;

@property (nonatomic,strong) UITableView *centerTableView;

@property (nonatomic,strong) UITableView *insideTableView;

-(void)setDelegate:(UIViewController *)vc;

@end
