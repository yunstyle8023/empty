//
//  CA_HAlbumDetailsController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAlbumDetailsController.h"

#import "CA_HAlbumDetailsModelManager.h"
#import "CA_HAlbumDetailsViewManager.h"

#import "CA_HBusinessDetailsController.h" // 企业工商利息列表

@interface CA_HAlbumDetailsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HAlbumDetailsModelManager *modelManager;
@property (nonatomic, strong) CA_HAlbumDetailsViewManager *viewManager;

@end

@implementation CA_HAlbumDetailsController

#pragma mark --- Action

- (void)onBarButton:(UIButton *)sender {
    
}

#pragma mark --- Lazy

- (CA_HAlbumDetailsModelManager *)modelManager {
    if (!_modelManager) {
        CA_HAlbumDetailsModelManager *modelManager = [CA_HAlbumDetailsModelManager new];
        _modelManager = modelManager;
    }
    return _modelManager;
}

- (CA_HAlbumDetailsViewManager *)viewManager {
    if (!_viewManager) {
        CA_HAlbumDetailsViewManager *viewManager = [CA_HAlbumDetailsViewManager new];
        _viewManager = viewManager;
        
        viewManager.tableView.delegate = self;
        viewManager.tableView.dataSource = self;
        
        viewManager.imageView.image = [UIImage imageWithColor:[UIColor greenColor]];
        viewManager.label.text = @"微软加速器-北京公布11期入选创新企业";
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)upView {
    self.title = self.modelManager.title;
    self.navigationItem.rightBarButtonItem = [CA_HFoundFactoryPattern barButtonItem:@"share_icon2" size:CGSizeMake(24, 24) target:self action:@selector(onBarButton:)];
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icons_Details5"]];
        
        cell.imageView.sd_resetLayout
        .widthIs(45*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .topSpaceToView(cell.imageView.superview, 15*CA_H_RATIO_WIDTH)
        .leftSpaceToView(cell.imageView.superview, 20*CA_H_RATIO_WIDTH);
        cell.imageView.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
        
        
        cell.textLabel.textColor = CA_H_4BLACKCOLOR;
        cell.textLabel.font = CA_H_FONT_PFSC_Regular(16);
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.sd_resetLayout
        .spaceToSuperView(UIEdgeInsetsMake(20*CA_H_RATIO_WIDTH, 75*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH));
        
        [CA_HFoundFactoryPattern lineWithView:cell left:20*CA_H_RATIO_WIDTH right:0];
    }
    
    cell.imageView.image = [UIImage imageWithColor:[UIColor lightGrayColor]];
    cell.textLabel.text = @"滴滴找油信息科技有限公司";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
    vc.modelManager.dataStr = @"成安(北京)科技发展有限公司";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
