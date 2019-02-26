//
//  CA_HBusinessInformationController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessInformationController.h"

#import "CA_HBusinessInformationViewManager.h"

#import "CA_HBusinessInformationBasicCell.h"
#import "CA_HGeneralSituationHeader.h"

#import "CA_HBusinessDetailsController.h"

@interface CA_HBusinessInformationController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HBusinessInformationViewManager *viewManager;

@end

@implementation CA_HBusinessInformationController

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HBusinessInformationModelManager *)modelManager {
    if (!_modelManager) {
        CA_HBusinessInformationModelManager *modelManager = [CA_HBusinessInformationModelManager new];
        _modelManager = modelManager;
        
        CA_H_WeakSelf(self);
        modelManager.loadDetailBlock = ^(BOOL success) {
            CA_H_StrongSelf(self);
            if (success) {
                if (!self.viewManager.tableView.superview) {
                    [self upView];
                }
            }
            [CA_HProgressHUD hideHud:self.view];
        };
    }
    return _modelManager;
}

- (CA_HBusinessInformationViewManager *)viewManager {
    if (!_viewManager) {
        CA_HBusinessInformationViewManager *viewManager = [CA_HBusinessInformationViewManager new];
        _viewManager = viewManager;
        
        viewManager.tableView.delegate = self;
        viewManager.tableView.dataSource = self;
    }
    return _viewManager;
}

#pragma mark --- LifeCircle

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern showShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CA_HProgressHUD loading:self.view];
    [self.modelManager loadDetail];
}

#pragma mark --- Custom

- (void)upView {
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return ceilf([self.modelManager data:section].count/2.0);
    }
    return [self.modelManager data:section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HBusinessInformationContentModel *model = [self.modelManager data:indexPath.section][indexPath.row];
    NSString *classStr = nil;
    switch (indexPath.section) {
        case 0:{
            CGFloat height0 = [model.name heightForFont:CA_H_FONT_PFSC_Regular(14) width:96*CA_H_RATIO_WIDTH];
            CGFloat height1 = [model.content heightForFont:CA_H_FONT_PFSC_Regular(14) width:198*CA_H_RATIO_WIDTH];
            return MAX(height0, height1)+20*CA_H_RATIO_WIDTH;
        }break;
        case 1:{
            return 180*CA_H_RATIO_WIDTH;
        }break;
        case 2:{
            return 69*CA_H_RATIO_WIDTH;
        }break;
        case 3:{
            classStr = @"CA_HBusinessInformationChangeCell";
        }break;
        case 4:{
            classStr = @"CA_HBusinessInformationBranchCell";
        }break;
        default:
            return 0;
    }
    
    CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:NSClassFromString(classStr) contentViewWidth:tableView.width];
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.modelManager data:section].count) {
        return 65*CA_H_RATIO_WIDTH;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CA_HGeneralSituationHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableAttributedString *countText = [NSMutableAttributedString new];
    switch (section) {
        case 0:
            [text appendString:@"基本信息"];
            break;
        case 1:
            [text appendString:@"股东（发起人）"];
            [countText appendString:[NSString stringWithFormat:@"（%@）", self.modelManager.model.partners_data_count]];
            break;
        case 2:
            [text appendString:@"主要人员"];
            [countText appendString:[NSString stringWithFormat:@"（%@）", self.modelManager.model.main_member_data_count]];
            break;
        case 3:
            [text appendString:@"变更记录"];
            [countText appendString:[NSString stringWithFormat:@"（%@）", self.modelManager.model.change_data_count]];
            break;
        case 4:
            [text appendString:@"分支机构"];
            break;
        default:
            break;
    }
    
    text.font = CA_H_FONT_PFSC_Medium(18);
    text.color = CA_H_4BLACKCOLOR;
    
    countText.font = CA_H_FONT_PFSC_Regular(16);
    countText.color = CA_H_9GRAYCOLOR;
    
    [text appendAttributedString:countText];
    
    header.label.attributedText = text;
    header.line.hidden = (section < 2);
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"cell%ld", indexPath.section];
    
    CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.section == 2) {
        NSArray *array = [self.modelManager data:indexPath.section];
        if (array.count > indexPath.row*2+1) {
            cell.model = @[array[indexPath.row*2],array[indexPath.row*2+1]];
        } else {
            cell.model = @[array[indexPath.row*2]];
        }
    } else {
        cell.model = [self.modelManager data:indexPath.section][indexPath.row];
    }
    
    if (indexPath.section == 0) {
        ((CA_HBusinessInformationBasicCell *)cell).topLine.hidden = (indexPath.row!=0);
    }
    
    if (indexPath.section > 2) {
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
        vc.modelManager.dataStr = [[self.modelManager data:indexPath.section][indexPath.row] name];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
