//
//  CA_HSelectMenuView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/30.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HSelectMenuView.h"

@interface CA_HSelectMenuView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end
@implementation CA_HSelectMenuView

#pragma mark --- Lazy

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewPlain];
        _tableView.backgroundColor = CA_H_BACKCOLOR;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (void)setData:(NSArray *)data{
    _data = data;
    if (data) {
        self.tableView.frame = CGRectMake(0, self.mj_h, self.mj_w, 0);
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
        _clickBlock = nil;
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
    toolbar.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    self.hidden = YES;
}

- (void)showMenu:(BOOL)animated{
    self.hidden = NO;
    CGFloat height = MIN((60+52*self.data.count)*CA_H_RATIO_WIDTH + CA_H_MANAGER.xheight, _maxHeight);
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        self.tableView.frame = CGRectMake(0, self.mj_h-height, self.mj_w, height);
        [self.tableView reloadData];
    }];
}

- (void)hideMenu:(BOOL)animated{
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        self.tableView.frame = CGRectMake(0, self.mj_h, self.mj_w, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark --- Table

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString * identifier = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if (indexPath.row) {
            [cell.textLabel setTextColor:CA_H_TINTCOLOR];
        }else{
            [cell.textLabel setTextColor:CA_H_9GRAYCOLOR];
        }
        
        [cell.textLabel setFont:CA_H_FONT_PFSC_Regular(16)];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        if (indexPath.section) {
            cell.textLabel.text = CA_H_LAN(@"取消");
            cell.textLabel.sd_resetLayout
            .heightIs(55*CA_H_RATIO_WIDTH)
            .topEqualToView(cell.textLabel.superview)
            .leftEqualToView(cell.textLabel.superview)
            .rightEqualToView(cell.textLabel.superview);
            
        }else{
            cell.textLabel.text = CA_H_LAN(self.data[indexPath.row]);
            cell.textLabel.sd_resetLayout.spaceToSuperView(UIEdgeInsetsZero);
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return 1;
    }else{
        return self.data.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5*CA_H_RATIO_WIDTH;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        return 55*CA_H_RATIO_WIDTH +CA_H_MANAGER.xheight;
    }else {
        return 52*CA_H_RATIO_WIDTH;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (indexPath.section) {
        row = -1;
    }
    if (_clickBlock) {
        _clickBlock(row);
        _clickBlock = nil;
    }
}


@end
