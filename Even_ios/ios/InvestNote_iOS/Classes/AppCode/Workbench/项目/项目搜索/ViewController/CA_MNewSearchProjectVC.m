//
//  CA_MNewSearchProjectVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewSearchProjectVC.h"
#import "CA_MNewSearchProjectViewManager.h"
#import "CA_MNewSearchProjectViewModel.h"
#import "CA_MAddProjectCell.h"
#import "CA_MSettingHeaderView.h"
#import "CA_MProjectNotFoundView.h"
#import "CA_MCustomTextFieldView.h"
#import "CA_MCustomAccessoryView.h"
#import "CA_MAddProjectVC.h"
#import "CA_MSelectProjectNetModel.h"
#import "CA_MSelectModel.h"
#import "CA_MNoSearchDataView.h"

@interface CA_MNewSearchProjectVC ()
<
UITableViewDataSource,
UITableViewDelegate,
CA_MCustomTextFieldViewDelegate
>

@property (nonatomic,strong) CA_MNewSearchProjectViewManager *viewManager;

@property (nonatomic,strong) CA_MNewSearchProjectViewModel *viewModel;

@end

@implementation CA_MNewSearchProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

-(void)upView{
    
    self.navigationItem.leftBarButtonItem = self.viewManager.leftBarButton;
    
    self.navigationItem.title = self.viewModel.title;
    
    [self.view addSubview:self.viewManager.tableView];
    self.viewManager.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(22*2*CA_H_RATIO_WIDTH, 0, 0, 0));
    
    [self.view addSubview:self.viewManager.noSearchDataView];
    self.viewManager.noSearchDataView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(22*2*CA_H_RATIO_WIDTH, 0, 0, 0));
    
    [self.view addSubview:self.viewManager.txtFieldView];
    self.viewManager.txtFieldView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .widthIs(CA_H_SCREEN_WIDTH)
    .heightIs(22*2*CA_H_RATIO_WIDTH);
    [CA_HFoundFactoryPattern showShadowWithView:self.viewManager.txtFieldView];
    
}

#pragma mark - CustomTextFieldViewDelegate

-(void)jump2AddProject{
    [self.viewManager.txtFieldView.txtField resignFirstResponder];
    CA_MAddProjectVC* addProjectVC = [[CA_MAddProjectVC alloc] init];
    [self.navigationController pushViewController:addProjectVC animated:YES];
}

-(void)textDidChange:(NSString *)content{
    
    self.viewManager.noSearchDataView.hidden = YES;
    
    if (!self.viewModel.isFinished) return;
    
    if (![NSString isValueableString:content]) {
        [self.viewModel.dataSource removeAllObjects];
        [self.viewManager.tableView reloadData];
        return;
    }

    self.viewModel.netModel.search_str = content;
    
    self.viewModel.refreshBlock();

}

-(void)keyboradChange{
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.mj_footer.hidden = ![NSObject isValueableObject:self.viewModel.dataSource];
    return self.viewModel.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MAddProjectCell* addCell = [tableView dequeueReusableCellWithIdentifier:@"AddProjectCell"];
    addCell.model = (id)self.viewModel.dataSource[indexPath.row];
    return addCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CA_MSelectModel* model = self.viewModel.dataSource[indexPath.row];

    NSString *message = [NSString stringWithFormat:@"确定关联\"%@\"项目？",model.project_name];
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
    [messageAtt addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(0, message.length)];
    [messageAtt addAttribute:NSForegroundColorAttributeName value:CA_H_4BLACKCOLOR range:NSMakeRange(0, message.length)];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert setValue:messageAtt forKey:@"attributedMessage"];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              CA_H_WeakSelf(self)
                                                              self.viewModel.relevanceBlock(self.project_id, model.data_id, ^{
                                                                  CA_H_StrongSelf(self)
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                      self.finishedBlock?self.finishedBlock():nil;
                                                                  }];
                                                              });
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.viewManager.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter

-(CA_MNewSearchProjectViewManager *)viewManager{
    if (!_viewManager) {
        _viewManager = [CA_MNewSearchProjectViewManager new];
        _viewManager.tableView.dataSource = self;
        _viewManager.tableView.delegate = self;
        _viewManager.txtFieldView.deleagte = self;
        [_viewManager.txtFieldView.txtField becomeFirstResponder];
        CA_H_WeakSelf(self)
        _viewManager.leftBarButtonBlock = ^(UIButton *sender) {
            CA_H_StrongSelf(self)
            [self.viewManager.txtFieldView.txtField resignFirstResponder];
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        _viewManager.headerView.notFoundBlock = ^(UIButton *sender) {
            CA_H_StrongSelf(self)
            [self.viewManager.txtFieldView.txtField resignFirstResponder];
            [self.viewManager.notFoundView showView];
        };
        _viewManager.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self)
            self.viewModel.loadMoreDataBlock();
        }];
    }
    return _viewManager;
}

-(CA_MNewSearchProjectViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MNewSearchProjectViewModel new];
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isHasData) {
          CA_H_StrongSelf(self)
            
            if (self.viewManager.noSearchDataView.isHidden) {
                self.viewManager.tableView.backgroundView.hidden = [NSObject isValueableObject:self.viewModel.dataSource];
                self.viewManager.headerView.hidden = ![NSObject isValueableObject:self.viewModel.dataSource];
                if (isHasData) {
                    [self.viewManager.tableView.mj_footer endRefreshing];
                }else {
                    [self.viewManager.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.viewManager.tableView reloadData];
            }
 
        };
    }
    return _viewModel;
}

@end























