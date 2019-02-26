//
//  CA_HAlbumDetailsViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAlbumDetailsViewManager.h"

@interface CA_HAlbumDetailsViewManager ()

@end

@implementation CA_HAlbumDetailsViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        
        tableView.tableHeaderView = self.headerView;
        tableView.rowHeight = 76*CA_H_RATIO_WIDTH;
    }
    return _tableView;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:[UIColor whiteColor]];
        _label = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [UIImageView new];
        _imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }
    return _imageView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIView *)headerView {
    UIView *view = [UIView new];
    
    view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 155*CA_H_RATIO_WIDTH);
    
    [view addSubview:self.imageView];
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorHex(0x2222228B);
    [view addSubview:backView];
    backView.sd_layout
    .heightIs(42*CA_H_RATIO_WIDTH)
    .leftEqualToView(view)
    .rightEqualToView(view)
    .bottomEqualToView(view);
    
    [backView addSubview:self.label];
    self.label.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 20*CA_H_RATIO_WIDTH, 0, 20*CA_H_RATIO_WIDTH));
    
    return view;
}

#pragma mark --- Delegate

@end
