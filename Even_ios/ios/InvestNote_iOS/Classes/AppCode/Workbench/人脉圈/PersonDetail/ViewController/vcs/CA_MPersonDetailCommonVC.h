//
//  CA_MPersonDetailInfoVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

@interface CA_MPersonDetailCommonVC : CA_HBaseViewController

@property (nonatomic, assign) BOOL vcCanScroll;

@property (nonatomic,strong) UITableView *tableView;

- (void)requestData;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
