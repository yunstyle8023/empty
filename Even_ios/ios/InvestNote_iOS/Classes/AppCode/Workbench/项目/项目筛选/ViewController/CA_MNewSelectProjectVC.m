
//
//  CA_MNewSelectProjectVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewSelectProjectVC.h"
#import "CA_MNewSelectProjectViewManager.h"
#import "CA_MNewSelectProjectViewModel.h"
#import "CA_MNewSelectProjectOuterCell.h"
#import "CA_MNewSelectProjectInnerCell.h"
#import "CA_MNewSelectProjectConditionsModel.h"

@interface CA_MNewSelectProjectVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MNewSelectProjectViewManager *viewManager;
//@property (nonatomic,strong) CA_MNewSelectProjectViewModel *viewModel;

@end

@implementation CA_MNewSelectProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

-(void)upView{
    [self.view addSubview:self.viewManager.outerTableView];
    self.viewManager.outerTableView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .widthIs(75*2*CA_H_RATIO_WIDTH)
    .heightIs(218*2*CA_H_RATIO_WIDTH);
    
    [self.view addSubview:self.viewManager.innerTableView];
    self.viewManager.innerTableView.sd_layout
    .leftSpaceToView(self.view, 75*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(218*2*CA_H_RATIO_WIDTH);
    
    [self.view addSubview:self.viewManager.resetBtn];
    self.viewManager.resetBtn.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 218*2*CA_H_RATIO_WIDTH)
    .widthIs(65*2*CA_H_RATIO_WIDTH)
    .heightIs(22*2*CA_H_RATIO_WIDTH);
    
    [self.view addSubview:self.viewManager.finishedBtn];
    self.viewManager.finishedBtn.sd_layout
    .leftSpaceToView(self.viewManager.resetBtn, 0)
    .topSpaceToView(self.view, 218*2*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.view)
    .heightIs(22*2*CA_H_RATIO_WIDTH);
    
    [self.view addSubview:self.viewManager.lineView];
    self.viewManager.lineView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(1*2*CA_H_RATIO_WIDTH);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.viewManager.outerTableView) {
        return self.viewModel.dataSource.count;
    }else if (tableView == self.viewManager.innerTableView) {
        for (CA_MNewSelectProjectConditionsModel *model in self.viewModel.dataSource) {
            if ([model.field isEqualToString:self.viewModel.field]) {
                return model.data_list.count;
            }
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CA_HBaseTableCell *cell = nil;
    if (tableView == self.viewManager.outerTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"OuterCell"];
        cell.model = self.viewModel.dataSource[indexPath.row];
    }else if (tableView == self.viewManager.innerTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"InnerCell"];

        for (CA_MNewSelectProjectConditionsModel *model in self.viewModel.dataSource) {
            if ([model.field isEqualToString:self.viewModel.field]) {
                cell.model =  model.data_list[indexPath.row];
                break;
            }
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.viewManager.outerTableView) {
        CA_MNewSelectProjectConditionsModel *selectedModel = self.viewModel.dataSource[indexPath.row];
        for (CA_MNewSelectProjectConditionsModel *model in self.viewModel.dataSource) {
            if (selectedModel == model) {
                model.selected = YES;
            }else{
                model.selected = NO;
            }
        }
        self.viewModel.field = selectedModel.field;
        
    }else if (tableView == self.viewManager.innerTableView) {
        
        CA_MNewSelectProjectConditionsModel *fatherModel;
        
        for (CA_MNewSelectProjectConditionsModel *model in self.viewModel.dataSource) {
            if (model.isSelected) {
                fatherModel = model;
            }
        }
        
        if (fatherModel) {
            CA_MNewSelectProjectConditionsDataListModel *sonModel = fatherModel.data_list[indexPath.row];
            
            if ([fatherModel.field isEqualToString:@"user_ids"]) {
                if (sonModel.ids.intValue == 0) {//全部
                    
                    sonModel.selected = YES;
                    
                    if (sonModel.isSelected) {
                        for (CA_MNewSelectProjectConditionsDataListModel *otherModel in fatherModel.data_list) {
                            if (sonModel != otherModel) {
                                otherModel.selected = NO;
                            }
                        }
                        
                        fatherModel.selectedCount = 0;
                    }
                    
                }else{

                    CA_MNewSelectProjectConditionsDataListModel *allModel = [fatherModel.data_list firstObject];
                    allModel.selected = NO;
                    int userTotal = 0;
                    for (CA_MNewSelectProjectConditionsDataListModel *otherModel in fatherModel.data_list) {
                        if (sonModel == otherModel) {
                            otherModel.selected = !otherModel.isSelected;
                        }
                        
                        if (otherModel.isSelected) {
                            userTotal ++;
                        }
                    }
                    
                    fatherModel.selectedCount = userTotal;
                    
                    if (userTotal == 0) {
                        allModel.selected = YES;
                    }
                }
            }else{
                for (CA_MNewSelectProjectConditionsDataListModel *otherModel in fatherModel.data_list) {
                    if (sonModel == otherModel) {
                        otherModel.selected = YES;
                    }else{
                        otherModel.selected = NO;
                    }
                }
            }
        }
    }
    
    [self.viewManager.outerTableView reloadData];
    [self.viewManager.innerTableView reloadData];
}

#pragma mark - getter and setter

-(CA_MNewSelectProjectViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MNewSelectProjectViewManager new];
        _viewManager.outerTableView.dataSource = self;
        _viewManager.outerTableView.delegate = self;
        _viewManager.innerTableView.dataSource = self;
        _viewManager.innerTableView.delegate = self;
        
        CA_H_WeakSelf(self)
        _viewManager.resetBlock = ^{
            CA_H_StrongSelf(self)
            
            for (CA_MNewSelectProjectConditionsModel *model in self.viewModel.dataSource) {
                for (CA_MNewSelectProjectConditionsDataListModel *m in model.data_list) {
                    m.selected = NO;
                }
                model.selectedCount = 0;
                ((CA_MNewSelectProjectConditionsDataListModel *)[model.data_list firstObject]).selected = YES;
            }
            
            [self.viewManager.outerTableView reloadData];
            [self.viewManager.innerTableView reloadData];
            
        };
        
        _viewManager.finishedBlock = ^{
            CA_H_StrongSelf(self)

            __block BOOL isDefault = NO;//是否都是默认选项
            for (CA_MNewSelectProjectConditionsModel *model in self.viewModel.dataSource) {
                [model.data_list enumerateObjectsUsingBlock:^(CA_MNewSelectProjectConditionsDataListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx == 0) {
                        if (!obj.isSelected) {
                            isDefault = YES;
                        }
                        *stop = YES;
                    }
                }];
            }

            if (!isDefault) {
                if (!self.resultViewShow) {
                    if (self.finished) {
                        self.finished();
                    }
                }

                [self dismissViewControllerAnimated:YES completion:nil];
                return ;
            }
            
            if (self.callback) {
                self.callback(self.viewModel);
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        };
    }
    return _viewManager;
}

-(CA_MNewSelectProjectViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MNewSelectProjectViewModel new];
        _viewModel.pool_id = self.pool_id;
        CA_H_WeakSelf(self)
        _viewModel.finished = ^{
            CA_H_StrongSelf(self)
            [self.viewManager.outerTableView reloadData];
            [self.viewManager.innerTableView reloadData];
        };
    }
    return _viewModel;
}

@end











































