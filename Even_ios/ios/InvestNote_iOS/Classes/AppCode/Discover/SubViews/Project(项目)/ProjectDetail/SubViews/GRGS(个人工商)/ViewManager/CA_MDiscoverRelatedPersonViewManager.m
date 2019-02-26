
//
//  CA_MDiscoverRelatedPersonViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedPersonViewManager.h"
#import "CA_MDiscoverRelatedPersonTableView.h"
#import "CA_MDiscoverRelatedPersonModel.h"

@interface CA_MDiscoverRelatedPersonViewManager ()
@property (nonatomic,strong) CA_MDiscoverRelatedPersonTableView *allTableView;//全部
@property (nonatomic,strong) CA_MDiscoverRelatedPersonTableView *legalTableView;//担任法人
@property (nonatomic,strong) CA_MDiscoverRelatedPersonTableView *investmentTableView;//投资的公司
@property (nonatomic,strong) CA_MDiscoverRelatedPersonTableView *officeTableView;//任职的公司
@end

@implementation CA_MDiscoverRelatedPersonViewManager

-(UIView *)officeView{
    if (!_officeView) {
        _officeView = [UIView new];
        [_officeView addSubview:self.officeTableView];
        self.officeTableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    return _officeView;
}

-(CA_MDiscoverRelatedPersonTableView *)officeTableView{
    if (!_officeTableView) {
        _officeTableView = [CA_MDiscoverRelatedPersonTableView newTableViewGrouped];
        _officeTableView.enterprise_str = self.enterprise_str;
        _officeTableView.person_name = self.personName;
        _officeTableView.position_type = @"in_office";
        [_officeTableView requestData];
        CA_H_WeakSelf(self)
        _officeTableView.pushBlock = ^(CA_MDiscoverRelatedPersonData_list *model) {
            CA_H_StrongSelf(self)
            if (self.pushBlock) {
                self.pushBlock(model);
            }
        };
    }
    return _officeTableView;
}

-(UIView *)investmentView{
    if (!_investmentView) {
        _investmentView = [UIView new];
        [_investmentView addSubview:self.investmentTableView];
        self.investmentTableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    return _investmentView;
}

-(CA_MDiscoverRelatedPersonTableView *)investmentTableView{
    if (!_investmentTableView) {
        _investmentTableView = [CA_MDiscoverRelatedPersonTableView newTableViewGrouped];
        _investmentTableView.enterprise_str = self.enterprise_str;
        _investmentTableView.person_name = self.personName;
        _investmentTableView.position_type = @"stock_holder";
        [_investmentTableView requestData];
        CA_H_WeakSelf(self)
        _investmentTableView.pushBlock = ^(CA_MDiscoverRelatedPersonData_list *model) {
            CA_H_StrongSelf(self)
            if (self.pushBlock) {
                self.pushBlock(model);
            }
        };
    }
    return _investmentTableView;
}

-(UIView *)legalView{
    if (!_legalView) {
        _legalView = [UIView new];
        [_legalView addSubview:self.legalTableView];
        self.legalTableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    return _legalView;
}

-(CA_MDiscoverRelatedPersonTableView *)legalTableView{
    if (!_legalTableView) {
        _legalTableView = [CA_MDiscoverRelatedPersonTableView newTableViewGrouped];
        _legalTableView.enterprise_str = self.enterprise_str;
        _legalTableView.person_name = self.personName;
        _legalTableView.position_type = @"legal_person";
        [_legalTableView requestData];
        CA_H_WeakSelf(self)
        _legalTableView.pushBlock = ^(CA_MDiscoverRelatedPersonData_list *model) {
            CA_H_StrongSelf(self)
            if (self.pushBlock) {
                self.pushBlock(model);
            }
        };
    }
    return _legalTableView;
}

-(UIView *)allView{
    if (!_allView) {
        _allView = [UIView new];
        [_allView addSubview:self.allTableView];
        self.allTableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    return _allView;
}

-(CA_MDiscoverRelatedPersonTableView *)allTableView{
    if (!_allTableView) {
        _allTableView = [CA_MDiscoverRelatedPersonTableView newTableViewGrouped];
        _allTableView.enterprise_str = self.enterprise_str;
        _allTableView.person_name = self.personName;
        _allTableView.position_type = @"all";
        [_allTableView requestData];
        CA_H_WeakSelf(self)
        _allTableView.pushBlock = ^(CA_MDiscoverRelatedPersonData_list *model) {
            CA_H_StrongSelf(self)
            if (self.pushBlock) {
                self.pushBlock(model);
            }
        };
    }
    return _allTableView;
}


@end
