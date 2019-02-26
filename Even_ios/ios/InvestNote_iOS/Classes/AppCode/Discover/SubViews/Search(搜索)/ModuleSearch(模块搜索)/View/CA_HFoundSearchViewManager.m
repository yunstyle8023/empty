//
//  CA_HFoundSearchViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundSearchViewManager.h"

#import "CA_HSpacingFlowLayout.h"
#import "CA_HNullView.h"

@interface CA_HFoundSearchViewManager ()

@property (nonatomic, strong) UIView *nullBackView;

@end

@implementation CA_HFoundSearchViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITextField *)titleView {
    if (!_titleView) {
        UITextField *textField = [UITextField new];
        _titleView = textField;
        
        textField.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 20);
        
        textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        textField.textColor = CA_H_4BLACKCOLOR;
        textField.placeholder = CA_H_LAN(@"搜索");
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
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        tableView.backgroundView = self.collectionView;
        
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self flowLayout]];
        _collectionView = collectionView;
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 20*CA_H_RATIO_WIDTH, CA_H_MANAGER.xheight, 20*CA_H_RATIO_WIDTH);
        
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = NO;
        
        [collectionView registerClass:NSClassFromString(@"CA_HSearchCollectionViewCell") forCellWithReuseIdentifier:@"cell"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header0"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header1"];
    }
    return _collectionView;
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
        UILabel *label = [UILabel new];
        label.tag = 101;
        [header.contentView addSubview:label];
        label.sd_layout
        .widthIs(200*CA_H_RATIO_WIDTH)
        .heightIs(17*CA_H_RATIO_WIDTH)
        .topSpaceToView(header.contentView, 15*CA_H_RATIO_WIDTH)
        .leftSpaceToView(header.contentView, 20*CA_H_RATIO_WIDTH);
        [CA_HFoundFactoryPattern lineWithView:header left:20*CA_H_RATIO_WIDTH right:0];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(12);
    
    UILabel *label = [header.contentView viewWithTag:101];
    label.attributedText = attrStr;
    
    return header;
}

- (UIView *)tableBackView:(NSString *)nullText {
    if (self.titleView.text.length>1) {
        if (!_nullBackView) {
            _nullBackView = [CA_HNullView newTitle:nullText buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:nil/*@"empty_search"*/];
        }
        return _nullBackView;
    } else {
        return self.collectionView;
    }
}

#pragma mark --- Delegate

@end
