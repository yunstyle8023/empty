//
//  CA_MFiltrateItemVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MFiltrateItemVC.h"
#import "CA_MFiltrateItemViewManager.h"
#import "CA_MFiltrateItemViewModel.h"
#import "CA_MFiltrateItemPanelView.h"
#import "CA_MFiltrateItemChooseView.h"
#import "CA_MFiltrateItemUITableView.h"
#import "CA_MFiltrateItemCell.h"
#import "CA_HBaseModel.h"

@interface CA_MFiltrateItemVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) CA_MFiltrateItemViewManager *viewManager;

@property (nonatomic,strong) CA_MFiltrateItemViewModel *viewModel;

@property (nonatomic,assign) NSInteger outsideRow;

@property (nonatomic,assign) NSInteger centerRow;

@property (nonatomic,assign) NSInteger insideRow;

@property (nonatomic,assign) CGFloat outsideWidth;

@property (nonatomic,assign) CGFloat centerWidth;

@property (nonatomic,assign) CGFloat insideWidth;

@end

@implementation CA_MFiltrateItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.outsideWidth = 75*2*CA_H_RATIO_WIDTH;
    
    self.centerWidth = 113*2*CA_H_RATIO_WIDTH;
    
    self.insideWidth = 0;
    
    [self upView];
    
    [self setConstraints];
}

-(void)upView{
    
    self.viewManager.panelView.titleLb.text = self.titleStr;
    
    [self.view addSubview:self.viewManager.panelView];

    [self.view addSubview:self.viewManager.outsideTableView];

    [self.view addSubview:self.viewManager.centerTableView];

    [self.view addSubview:self.viewManager.insideTableView];

    [self.view addSubview:self.viewManager.chooseView];
    
    [self.view addSubview:self.viewManager.maskView];
}

-(void)setConstraints{
    
    self.viewManager.panelView.sd_resetLayout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.viewManager.outsideTableView.sd_resetLayout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 27*2*CA_H_RATIO_WIDTH+1*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.view)
    .widthIs(self.outsideWidth);
    
    self.viewManager.centerTableView.sd_resetLayout
    .leftEqualToView(self.viewManager.outsideTableView).offset(self.viewManager.outsideTableView.mj_w)
    .topSpaceToView(self.view, 27*2*CA_H_RATIO_WIDTH+1*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.view)
    .widthIs(self.centerWidth);
    
    self.viewManager.insideTableView.sd_resetLayout
    .leftEqualToView(self.viewManager.centerTableView).offset(self.viewManager.centerTableView.mj_w)
    .topSpaceToView(self.view, 27*2*CA_H_RATIO_WIDTH+1*CA_H_RATIO_WIDTH)
    .bottomEqualToView(self.view)
    .widthIs(self.insideWidth);
    
    self.viewManager.chooseView.sd_resetLayout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(26*2*CA_H_RATIO_WIDTH);
    
//    self.viewManager.maskView.sd_resetLayout
//    .leftEqualToView(self.view)
//    .rightEqualToView(self.view)
//    .topSpaceToView(self.view, 27*2*CA_H_RATIO_WIDTH+1*CA_H_RATIO_WIDTH)
//    .bottomEqualToView(self.viewManager.chooseView).offset(-26*2*CA_H_RATIO_WIDTH);
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.viewModel.isFinished) {
        if (tableView == self.viewManager.outsideTableView) {
            return self.viewModel.dataSource.count;
        }
        else if (tableView == self.viewManager.centerTableView) {
            CA_HBaseModel* model = [self.viewModel.dataSource objectAtIndex:self.outsideRow];
            NSArray *array = [model valueForKey:@"children"];
            return array.count;
        }
        else if (tableView == self.viewManager.insideTableView) {
            CA_HBaseModel* model = [self.viewModel.dataSource objectAtIndex:self.outsideRow];
            NSArray *array = [model valueForKey:@"children"];
            CA_HBaseModel* rowModel = [array objectAtIndex:self.centerRow];
            NSArray *rowArray = [rowModel valueForKey:@"children"];
            return rowArray.count;
        }
    }
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MFiltrateItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"FiltrateItemCell"];
    itemCell.className = self.className;
    itemCell.keyName = self.keyName;

    if (tableView == self.viewManager.outsideTableView) {
        itemCell.backgroundColor = kColor(@"#FFFFFF");
        itemCell.model = self.viewModel.dataSource[indexPath.row];
    }
    else if (tableView == self.viewManager.centerTableView) {
        itemCell.backgroundColor = kColor(@"#FAFAFA");
        itemCell.model = [[self.viewModel.dataSource objectAtIndex:self.outsideRow]
                          valueForKey:@"children"][indexPath.row];
    }
    else if (tableView == self.viewManager.insideTableView) {
        itemCell.backgroundColor = kColor(@"#F8F8F8");
        itemCell.model = [[[[self.viewModel.dataSource objectAtIndex:self.outsideRow]
                            valueForKey:@"children"] objectAtIndex:self.centerRow]
                          valueForKey:@"children"][indexPath.row];
    }
    return itemCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.viewManager.outsideTableView) {
        if (self.outsideRow == indexPath.row) return;
        self.outsideRow = indexPath.row;
        self.centerRow = 0;
        self.insideRow = 0;
        
        [self.viewModel.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.outsideRow == idx) {
                [obj setValue:@"1" forKey:@"selected"];
            }else {
                [obj setValue:@"0" forKey:@"selected"];
            }
        }];
        
        CA_HBaseModel* model = [self.viewModel.dataSource objectAtIndex:self.outsideRow];
        NSArray *array = [model valueForKey:@"children"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                [obj setValue:@"1" forKey:@"selected"];
            }else {
                [obj setValue:@"0" forKey:@"selected"];
            }
        }];
        
        CA_HBaseModel* rowModel = [array objectAtIndex:self.centerRow];
        NSArray *rowArray = [rowModel valueForKey:@"children"];
        [rowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                [obj setValue:@"1" forKey:@"selected"];
            }else {
                [obj setValue:@"0" forKey:@"selected"];
            }
        }];
        
        if ([NSObject isValueableObject:rowArray]) {
            self.outsideWidth = 43*2*CA_H_RATIO_WIDTH;
            self.centerWidth = 70*2*CA_H_RATIO_WIDTH;
            self.insideWidth = 75*2*CA_H_RATIO_WIDTH;
        }else {
            self.outsideWidth = 75*2*CA_H_RATIO_WIDTH;
            self.centerWidth = 113*2*CA_H_RATIO_WIDTH;
            self.insideWidth = 0*2*CA_H_RATIO_WIDTH;
        }
        
        [self setConstraints];
    }
    else if (tableView == self.viewManager.centerTableView) {
        if (self.centerRow == indexPath.row) return;
        self.centerRow = indexPath.row;
        self.insideRow = 0;
        
        CA_HBaseModel* model = [self.viewModel.dataSource objectAtIndex:self.outsideRow];
        NSArray *array = [model valueForKey:@"children"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.centerRow == idx) {
                [obj setValue:@"1" forKey:@"selected"];
            }else {
                [obj setValue:@"0" forKey:@"selected"];
            }
        }];
        
        CA_HBaseModel* rowModel = [array objectAtIndex:self.centerRow];
        NSArray *rowArray = [rowModel valueForKey:@"children"];
        [rowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                [obj setValue:@"1" forKey:@"selected"];
            }else {
                [obj setValue:@"0" forKey:@"selected"];
            }
        }];
        
        if ([NSObject isValueableObject:rowArray]) {
            self.outsideWidth = 43*2*CA_H_RATIO_WIDTH;
            self.centerWidth = 70*2*CA_H_RATIO_WIDTH;
            self.insideWidth = 75*2*CA_H_RATIO_WIDTH;
        }else {
            self.outsideWidth = 75*2*CA_H_RATIO_WIDTH;
            self.centerWidth = 113*2*CA_H_RATIO_WIDTH;
            self.insideWidth = 0*2*CA_H_RATIO_WIDTH;
        }
        
        [self setConstraints];
    }
    else if (tableView == self.viewManager.insideTableView) {
        if (self.insideRow == indexPath.row) return;
        self.insideRow = indexPath.row;
        
        CA_HBaseModel* model = [self.viewModel.dataSource objectAtIndex:self.outsideRow];
        NSArray *array = [model valueForKey:@"children"];
        CA_HBaseModel* rowModel = [array objectAtIndex:self.centerRow];
        NSArray *rowArray = [rowModel valueForKey:@"children"];
        [rowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == self.insideRow) {
                [obj setValue:@"1" forKey:@"selected"];
            }else {
                [obj setValue:@"0" forKey:@"selected"];
            }
        }];
    }
    
    [self.viewManager.outsideTableView reloadData];
    [self.viewManager.centerTableView reloadData];
    [self.viewManager.insideTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = nil;
    
    if (tableView == self.viewManager.outsideTableView) {
        model = self.viewModel.dataSource[indexPath.row];
        NSString *titleStr = [model valueForKey:self.keyName];
        return [titleStr heightForFont:CA_H_FONT_PFSC_Regular(16) width:self.outsideWidth -(10+5)*2*CA_H_RATIO_WIDTH]+10*2*CA_H_RATIO_WIDTH;
    }
    else if (tableView == self.viewManager.centerTableView) {
        CA_HBaseModel* model = [self.viewModel.dataSource objectAtIndex:self.outsideRow];
        NSArray *array = [model valueForKey:@"children"];
        model = array[indexPath.row];
        NSString *titleStr = [model valueForKey:self.keyName];
        return [titleStr heightForFont:CA_H_FONT_PFSC_Regular(16) width:self.centerWidth-(10+5)*2*CA_H_RATIO_WIDTH]+10*2*CA_H_RATIO_WIDTH;
    }
    else if (tableView == self.viewManager.insideTableView) {
        CA_HBaseModel* model = [self.viewModel.dataSource objectAtIndex:self.outsideRow];
        NSArray *array = [model valueForKey:@"children"];
        CA_HBaseModel* rowModel = [array objectAtIndex:self.centerRow];
        NSArray *rowArray = [rowModel valueForKey:@"children"];
        model = rowArray[indexPath.row];
        NSString *titleStr = [model valueForKey:self.keyName];
        return [titleStr heightForFont:CA_H_FONT_PFSC_Regular(16) width:self.insideWidth-(10+5)*2*CA_H_RATIO_WIDTH]+10*2*CA_H_RATIO_WIDTH;
    }

    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 26*2*CA_H_RATIO_WIDTH+10*2*CA_H_RATIO_WIDTH;
}

#pragma mark - getter and setter

-(CA_MFiltrateItemViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MFiltrateItemViewManager new];
        [_viewManager setDelegate:self];
        CA_H_WeakSelf(self)
        _viewManager.chooseView.cancelBlock = ^{
            CA_H_StrongSelf(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        _viewManager.chooseView.confirmBlock = ^{
            CA_H_StrongSelf(self)
            if ([NSObject isValueableObject:self.viewModel.dataSource]) {
                CA_HBaseModel* model = self.viewModel.dataSource[self.outsideRow];
                CA_HBaseModel* childModel = [model valueForKey:@"children"][self.centerRow];
                CA_HBaseModel* resultModel = nil;
                if ([self.urlStr isEqualToString:CA_M_Api_ListProjectValutionmethod]) {
                    resultModel = [[childModel valueForKey:@"children"] objectAtIndex:self.insideRow];
                }

                NSLog(@"当前所选择值: %@|%@",[model valueForKey:self.keyName],[childModel valueForKey:self.keyName]);

                if (self.callback) {
                    if ([self.className isEqualToString:@"CA_MCityModel"]) {
                        self.callback([NSString stringWithFormat:@"%@-%@",[model valueForKey:self.keyName],[childModel valueForKey:self.keyName]]);
                    }else if ([self.className isEqualToString:@"CA_MValutionModel"]){
                        if (resultModel) {
                            self.callback(resultModel);
                        }else {
                            self.callback(childModel);
                        }
                    }else{
                        self.callback(@[model,childModel]);
                    }
                }
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _viewManager;
}

-(CA_MFiltrateItemViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MFiltrateItemViewModel new];
        _viewModel.loadingView = self.viewManager.maskView;
        _viewModel.urlStr = self.urlStr;
        _viewModel.className = self.className;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(NSMutableArray *dataSource){
            CA_H_StrongSelf(self)
            if ([NSObject isValueableObject:dataSource]) {
                
                CA_HBaseModel *firstModel = [dataSource firstObject];
                if ([NSObject isValueableObject:[[firstModel valueForKey:@"children"][0] valueForKey:@"children"]]) {
                    self.outsideWidth = 43*2*CA_H_RATIO_WIDTH;
                    self.centerWidth = 70*2*CA_H_RATIO_WIDTH;
                    self.insideWidth = 75*2*CA_H_RATIO_WIDTH;

                }else {
                    self.outsideWidth = 75*2*CA_H_RATIO_WIDTH;
                    self.centerWidth = 113*2*CA_H_RATIO_WIDTH;
                    self.insideWidth = 0*2*CA_H_RATIO_WIDTH;
                }

                [self setConstraints];
                
                [self.viewManager.outsideTableView reloadData];
                [self.viewManager.centerTableView reloadData];
                [self.viewManager.insideTableView reloadData];
                
            }
        };
    }
    return _viewModel;
}

@end










