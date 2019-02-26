//
//  CA_HMultiSelectImagePickerList.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMultiSelectImagePickerList.h"

@interface CA_HMultiSelectImagePickerList ()

@property (nonatomic, strong) UIButton * titleView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation CA_HMultiSelectImagePickerList

#pragma mark --- Action

- (void)onTitle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark --- Lazy

- (UIButton *)titleView{
    if (!_titleView) {
        UIButton * button = [UIButton new];
        
        [button setImage:[UIImage imageNamed:@"shape3"] forState:UIControlStateNormal];
        button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [button setTitle:_buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:17]];
        [button addTarget:self action:@selector(onTitle:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.sd_resetLayout
        .centerYEqualToView(button.titleLabel.superview)
        .leftSpaceToView(button.titleLabel.superview, 3)
        .autoHeightRatio(0);
        [button.titleLabel setMaxNumberOfLinesToShow:1];
        [button.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        button.imageView.sd_resetLayout
        .widthIs(12)
        .heightEqualToWidth()
        .centerYEqualToView(button.imageView.superview)
        .leftSpaceToView(button.titleLabel, 3);
        
        [button setupAutoWidthWithRightView:button.titleLabel rightMargin:18];
        [button setupAutoHeightWithBottomView:button.imageView bottomMargin:16];
        
        _titleView = button;
    }
    return _titleView;
}

- (NSArray *)data{
    if (!_data) {
        _data = [[JYAblumTool sharePhotoTool] getPhotoAblumList];
    }
    return _data;
}

#pragma mark --- LifeCircle

//+ (instancetype)new{
//    CA_HMultiSelectImagePickerList * list = [[CA_HMultiSelectImagePickerList alloc]initWithStyle:UITableViewStyleGrouped];
//    [list upTableConfig];
//    return list;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.titleView = self.titleView;
    
    self.tableView.rowHeight = 70*CA_H_RATIO_WIDTH;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CA_H_RATIO_WIDTH, CA_H_RATIO_WIDTH)];
}

#pragma mark --- Custom

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.clipsToBounds = YES;
        
        cell.imageView.sd_resetLayout
        .widthIs(50*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(cell.imageView.superview)
        .leftSpaceToView(cell.imageView.superview, 20*CA_H_RATIO_WIDTH);
        
        cell.textLabel.font = CA_H_FONT_PFSC_Semibold(16);
        cell.textLabel.textColor = CA_H_4BLACKCOLOR;
        
        cell.textLabel.sd_resetLayout
        .centerYEqualToView(cell.textLabel.superview)
        .leftSpaceToView(cell.imageView, 10*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [cell.textLabel setMaxNumberOfLinesToShow:1];
        [cell.textLabel setSingleLineAutoResizeWithMaxWidth:280*CA_H_RATIO_WIDTH];
    }
    
    JYAblumList * list = self.data[self.data.count - indexPath.row - 1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)", list.title, list.count];
    
    [[JYAblumTool sharePhotoTool] requestImageForAsset:list.headImageAsset size:CGSizeMake(50*CA_H_RATIO_WIDTH, 50*CA_H_RATIO_WIDTH) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image,NSDictionary *info) {
        cell.imageView.image = image;
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_listBlock) {
        JYAblumList * list = self.data[self.data.count - indexPath.row - 1];
        _listBlock(list);
        [self.navigationController popViewControllerAnimated:NO];
    }
}


@end
