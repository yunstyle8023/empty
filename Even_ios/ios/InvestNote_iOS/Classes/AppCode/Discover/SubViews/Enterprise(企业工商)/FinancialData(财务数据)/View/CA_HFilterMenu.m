//
//  CA_HFilterMenu.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFilterMenu.h"

@interface CA_HFilterMenu ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation CA_HFilterMenu

#pragma mark --- Lazy

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.backgroundColor = CA_H_BACKCOLOR;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH);
        _tableView.tableHeaderView = view;
        
        _tableView.rowHeight = 40*CA_H_RATIO_WIDTH;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)setData:(NSArray *)data{
    _data = data;
    if (data) {
        self.tableView.frame = CGRectMake(0, 0, self.mj_w, 0);
    }
}

#pragma mark --- LifeCircle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_clickBlock) {
        _clickBlock(-1);
    }
}


#pragma mark --- Custom

- (void)upView{
    self.backgroundColor = [UIColor clearColor];
    _maxHeight = CA_H_SCREEN_HEIGHT;
    
    UIToolbar * toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.alpha = 0.35;
    [self addSubview:toolbar];
    [self sendSubviewToBack:toolbar];
    toolbar.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    self.hidden = YES;
}

- (void)showMenu:(BOOL)animated{
    self.hidden = NO;
    CGFloat height = MIN((40*self.data.count+11)*CA_H_RATIO_WIDTH, _maxHeight);
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.mj_w, height);
        [self.tableView reloadData];
    }];
}

- (void)hideMenu:(BOOL)animated{
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.mj_w, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark --- Table

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString * identifier = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setFont:CA_H_FONT_PFSC_Regular(14)];
        
        cell.textLabel
        .sd_resetLayout.spaceToSuperView(UIEdgeInsetsMake(0, 20*CA_H_RATIO_WIDTH, 0, 20*CA_H_RATIO_WIDTH));
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    if ([cell.textLabel.text isEqualToString:self.selectStr]) {
        cell.textLabel.textColor = CA_H_TINTCOLOR;
    } else {
        cell.textLabel.textColor = CA_H_4BLACKCOLOR;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 40*CA_H_RATIO_WIDTH;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (_clickBlock) {
        _clickBlock(row);
    }
}

@end
