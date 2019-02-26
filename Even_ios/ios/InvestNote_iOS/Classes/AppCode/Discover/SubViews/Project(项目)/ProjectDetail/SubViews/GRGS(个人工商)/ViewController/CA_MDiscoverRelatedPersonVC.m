//
//  CA_MDiscoverRelatedPersonVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedPersonVC.h"
#import "CA_MDiscoverRelatedPersonViewManager.h"
#import "CA_HBusinessDetailsController.h"
#import "CA_MDiscoverRelatedPersonModel.h"

@interface CA_MDiscoverRelatedPersonVC ()
@property (nonatomic, strong) CA_MDiscoverRelatedPersonViewManager *viewManager;
@end

@implementation CA_MDiscoverRelatedPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upView];
}

- (void)upView{
    self.navigationItem.title = self.personName;
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)ca_layoutContentView {
    [super ca_layoutContentView];
    [self customScrollView];
}

- (NSArray *)scrollViewTitles {
    return @[CA_H_LAN(@"全部"),
             CA_H_LAN(@"担任法人"),
             CA_H_LAN(@"投资的公司"),
             CA_H_LAN(@"任职的公司")];
}

- (UIView *)scrollViewContentViewWithItem:(NSInteger)item {
    switch (item) {
        case 0:
            return self.viewManager.allView;//全部
        case 1:
            return self.viewManager.legalView;//担任法人
        case 2:
            return self.viewManager.investmentView;//投资的公司
        case 3:
            return self.viewManager.officeView;//任职的公司
        default:
            return [UIView new];
    }
}

#pragma mark - getter and setter

- (CA_MDiscoverRelatedPersonViewManager *)viewManager {
    if (!_viewManager) {
        _viewManager = [CA_MDiscoverRelatedPersonViewManager new];
        _viewManager.enterprise_str = self.enterprise_str;
        _viewManager.personName = self.personName;
        CA_H_WeakSelf(self)
        _viewManager.pushBlock = ^(CA_MDiscoverRelatedPersonData_list *model) {
            CA_H_StrongSelf(self)
            CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
            vc.modelManager.dataStr = model.enterprise_name;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _viewManager;
}

@end
