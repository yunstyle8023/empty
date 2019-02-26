
//
//  CA_MApproveStatusCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//




#import "CA_MApproveStatusCell.h"
#import "CA_MApproveStatusDetailCell.h"
#import "CA_MMyApproveDetailModel.h"

static NSString* const statusKey = @"CA_MApproveStatusDetailCell";

@interface CA_MApproveStatusCell ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation CA_MApproveStatusCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.tableView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.bottom.mas_equalTo(self.contentView);
    }];
}

-(CGFloat)configCell:(NSArray*)datas{
    self.dataSource = datas.mutableCopy;
    [self.tableView reloadData];
    
    CGFloat totalHeight = 0.;
    for (CA_MResult_detail* model in datas) {
        NSString *commitStr = [NSString isValueableString:model.result_commit]?model.result_commit:@"暂无";
        CGFloat commitheight = [commitStr heightForFont:CA_H_FONT_PFSC_Regular(14) width:CA_H_SCREEN_WIDTH-100];
        totalHeight += (commitheight +31*2*CA_H_RATIO_WIDTH);
    }
//    return 37*CA_H_RATIO_WIDTH + datas.count*(87*CA_H_RATIO_WIDTH);
    return 37*CA_H_RATIO_WIDTH + totalHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MApproveStatusDetailCell* statusCell = [tableView dequeueReusableCellWithIdentifier:statusKey];
    CA_MResult_detail* model = self.dataSource[indexPath.row];
    statusCell.model = model;
    return statusCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MResult_detail* model = self.dataSource[indexPath.row];
    NSString *commitStr = [NSString isValueableString:model.result_commit]?model.result_commit:@"暂无";
    CGFloat commitheight = [commitStr heightForFont:CA_H_FONT_PFSC_Regular(14) width:CA_H_SCREEN_WIDTH-100];
    return commitheight +31*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        UIView* header = [UIView new];
        header.backgroundColor = kColor(@"#F8F8F8");
        UILabel* titleLb = [UILabel new];
        [titleLb configText:@"审批情况" textColor:CA_H_4BLACKCOLOR font:16];
        [header addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(header).offset(15);
            make.bottom.mas_equalTo(header);
        }];
        header;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - getter and setter
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kColor(@"#F8F8F8");
//    _tableView.rowHeight = 87*CA_H_RATIO_WIDTH;
    _tableView.layer.cornerRadius = 2;
    _tableView.layer.masksToBounds = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[CA_MApproveStatusDetailCell class] forCellReuseIdentifier:statusKey];
    return _tableView;
}

@end
