//
//  CA_HFoundAggregateSearchViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundAggregateSearchViewManager.h"

#import "CA_HSpacingFlowLayout.h"

@interface CA_HFoundAggregateSearchViewManager ()

@end

@implementation CA_HFoundAggregateSearchViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITextField *)titleView {
    if (!_titleView) {
        UITextField *textField = [UITextField new];
        _titleView = textField;
        
        textField.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 20);
        
        textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        textField.textColor = CA_H_4BLACKCOLOR;
        textField.placeholder = @"请输入项目、机构、企业名称等";
        textField.returnKeyType = UIReturnKeySearch;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15*CA_H_RATIO_WIDTH, 20)];
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.backgroundColor = CA_H_F8COLOR;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        tableView.backgroundView = self.collectionView;
        
        [tableView registerClass:NSClassFromString(@"CA_HFoundProjectListCell") forCellReuseIdentifier:@"cell0"];
        [tableView registerClass:NSClassFromString(@"CA_HFoundEnterpriseSearchCell") forCellReuseIdentifier:@"cell1"];
        [tableView registerClass:NSClassFromString(@"CA_HFoundLpSearchCell") forCellReuseIdentifier:@"cell2"];
        [tableView registerClass:NSClassFromString(@"CA_HFoundGpSearchCell") forCellReuseIdentifier:@"cell3"];
        
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self flowLayout]];
        _collectionView = collectionView;
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 20*CA_H_RATIO_WIDTH, CA_H_MANAGER.xheight, 20*CA_H_RATIO_WIDTH);
        
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.bounces = NO;
        
        [collectionView registerClass:NSClassFromString(@"CA_HSearchCollectionViewCell") forCellWithReuseIdentifier:@"cell"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header0"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header1"];
    }
    return _collectionView;
}

- (CA_HNullView *)nullView {
    if (!_nullView) {
        CA_HNullView *view = [CA_HNullView newTitle:@"没有搜索到相关信息" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:nil];
        _nullView = view;
        
        view.backgroundColor = [UIColor whiteColor];
    }
    return _nullView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIBarButtonItem *)rightBarButtonItem:(id)target action:(SEL)action {
    UIButton * rightBtn = [UIButton new];
    rightBtn.frame = CGRectMake(0, 0, 32, 44);
    
    [rightBtn setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
    [rightBtn setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.titleLabel.sd_resetLayout
    .centerYEqualToView(rightBtn)
    .rightEqualToView(rightBtn)
    .autoHeightRatio(0);
    
    return [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

- (UICollectionViewFlowLayout *)flowLayout{
    CA_HSpacingFlowLayout *flowLayout = [CA_HSpacingFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 10*CA_H_RATIO_WIDTH;
    flowLayout.minimumInteritemSpacing = 10*CA_H_RATIO_WIDTH;
    flowLayout.maximumSpacing = 10*CA_H_RATIO_WIDTH;
    
    return flowLayout;
}

- (UICollectionReusableView *)header:(NSIndexPath *)indexPath target:(id)target action:(SEL)action {
    NSString *identifier = [NSString stringWithFormat:@"header%ld", indexPath.section];
    UICollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (!header.subviews.count) {
        
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        label.text = indexPath.section?@"最近浏览":@"最近搜索";
        [header addSubview:label];
        label.sd_layout
        .widthIs(80*CA_H_RATIO_WIDTH)
        .heightIs(20*CA_H_RATIO_WIDTH)
        .leftEqualToView(header)
        .topSpaceToView(header, 20*CA_H_RATIO_WIDTH);
        
        UIButton *button = [UIButton new];
        button.tag = 100+indexPath.section;
        [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
        [button setTitle:@"清空" forState:UIControlStateNormal];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:button];
        button.sd_layout
        .widthIs(68*CA_H_RATIO_WIDTH)
        .heightIs(20*CA_H_RATIO_WIDTH)
        .rightEqualToView(header).offset(20*CA_H_RATIO_WIDTH)
        .topSpaceToView(header, 20*CA_H_RATIO_WIDTH);
    }
    
    return header;
}

- (UITableViewHeaderFooterView *)searchHeader:(NSString *)text {
    UITableViewHeaderFooterView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"header"];
        
        header.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        label.tag = 101;
        [header.contentView addSubview:label];
        label.sd_layout
        .widthIs(300*CA_H_RATIO_WIDTH)
        .heightIs(20*CA_H_RATIO_WIDTH)
        .topSpaceToView(header.contentView, 20*CA_H_RATIO_WIDTH)
        .leftSpaceToView(header.contentView, 20*CA_H_RATIO_WIDTH);
        [CA_HFoundFactoryPattern lineWithView:header left:20*CA_H_RATIO_WIDTH right:0];
    }
    
    UILabel *label = [header.contentView viewWithTag:101];
    label.text = text;
    
    return header;
}

- (UITableViewHeaderFooterView *)searchFooter:(NSString *)text ActionBlock:(void (^)(id sender))block {
    UITableViewHeaderFooterView *footer = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (!footer) {
        footer = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"footer"];
        footer.backgroundColor = CA_H_F8COLOR;
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:block];
        [view addGestureRecognizer:tap];
        
        [footer.contentView addSubview:view];
        view.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 10*CA_H_RATIO_WIDTH, 0));
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"search_icon"];
        
        [view addSubview:imageView];
        imageView.sd_layout
        .widthIs(15*CA_H_RATIO_WIDTH)
        .heightIs(14*CA_H_RATIO_WIDTH)
        .topSpaceToView(view, 13*CA_H_RATIO_WIDTH)
        .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH);
        
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
        label.tag = 101;
        [view addSubview:label];
        label.sd_layout
        .widthIs(200*CA_H_RATIO_WIDTH)
        .heightIs(20*CA_H_RATIO_WIDTH)
        .topSpaceToView(view, 10*CA_H_RATIO_WIDTH)
        .leftSpaceToView(imageView, 6*CA_H_RATIO_WIDTH);
        
        UIImageView *shape = [UIImageView new];
        shape.image = [UIImage imageNamed:@"shape5"];
        [view addSubview:shape];
        shape.sd_layout
        .widthIs(14*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .topSpaceToView(view, 13*CA_H_RATIO_WIDTH)
        .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH);
    }
    
    UILabel *label = [footer.contentView.subviews.lastObject viewWithTag:101];
    label.text = text;
    
    return footer;
}

#pragma mark --- Delegate

@end
