
//
//  CA_MProjectProgressSuccessCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectProgressSuccessCell.h"
#import "CA_MProjectProgressSuccessTableCell.h"

@interface CA_MProjectProgressSuccessCell ()
<
UITableViewDataSource,
UITableViewDelegate
>{
    CGFloat _tableViewHeight;
}

/// 原点
@property(nonatomic,strong)UIView* circleView;
@property(nonatomic,strong)UIView* circleBgView;
/// 细线
@property (nonatomic,strong) UIView *lineView;
/// 时间
@property (nonatomic,strong) UILabel *timeLb;
/// 项目状态(项目激活/放弃项目...)
@property (nonatomic,strong) UILabel *stateLb;
/// 审批意见 原因
@property (nonatomic,strong) UILabel *reasonLb;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) CA_MProcedure_logModel *model;

@end

@implementation CA_MProjectProgressSuccessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.circleBgView];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.stateLb];
    [self.contentView addSubview:self.reasonLb];
    [self.contentView addSubview:self.tableView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.circleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.height.width.mas_equalTo(18);
    }];
    
    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.circleBgView);
        make.height.width.mas_equalTo(12);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.circleView);
        make.width.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.circleView);
        make.leading.mas_equalTo(self.circleView.mas_trailing).offset(10);
    }];
    
    [self.stateLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLb.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.timeLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.reasonLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stateLb.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.stateLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.stateLb);
        make.top.mas_equalTo(self.reasonLb.mas_bottom).offset(10);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(_tableViewHeight);
    }];
    
}

-(CGFloat)configCell:(CA_MProcedure_logModel*)model
           indexPath:(NSIndexPath *)indexPath
            totalRow:(NSInteger)totalRow{
    
    self.model = model;
    
    if (indexPath.row == 0) {
        self.circleBgView.hidden = NO;
    }else{
        self.circleBgView.hidden = YES;
    }
    
    if (indexPath.row == totalRow - 1) {
        self.lineView.hidden = YES;
    }else{
        self.lineView.hidden = NO;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ts_create.longValue];
    self.timeLb.text = [date stringWithFormat:@"yyyy.MM.dd HH:mm"];//@"2017.12.12  18:00"
    
    self.stateLb.text = model.procedure_log_title;
    
    self.reasonLb.text = model.sub_title;
    
    if ([NSObject isValueableObject:model.approval_result_list]) {
        _tableViewHeight = model.approval_result_list.count*32;
    }else{
        _tableViewHeight = 0;
    }
    
    CGFloat timeH = [self.timeLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
    CGFloat stateH = [self.stateLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
    CGFloat personH = [self.reasonLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];;
    
    
    [self.tableView reloadData];
    [self.contentView layoutIfNeeded];
    
    CGFloat resultHeight =  timeH + 10 + stateH + 10 + personH;
    
    if ([NSObject isValueableObject:model.approval_result_list]) {
        resultHeight = resultHeight + 10 + _tableViewHeight + 10;
    }else{
        resultHeight = resultHeight + 20;
    }
    
    return resultHeight;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.approval_result_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectProgressSuccessTableCell* successCell = [tableView dequeueReusableCellWithIdentifier:@"successCell"];
    successCell.model = self.model.approval_result_list[indexPath.row];
    return successCell;
}


#pragma mark - Getter and Setter
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#FFFFFF");
    _tableView.rowHeight = 20+12;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[CA_MProjectProgressSuccessTableCell class] forCellReuseIdentifier:@"successCell"];
    return _tableView;
}
-(UILabel *)reasonLb{
    if (_reasonLb) {
        return _reasonLb;
    }
    _reasonLb = [[UILabel alloc] init];
    [_reasonLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    _reasonLb.numberOfLines = 0;
    return _reasonLb;
}
-(UILabel *)stateLb{
    if (_stateLb) {
        return _stateLb;
    }
    _stateLb = [[UILabel alloc] init];
    [_stateLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    _reasonLb.numberOfLines = 0;
    return _stateLb;
}
-(UILabel *)timeLb{
    if (_timeLb) {
        return _timeLb;
    }
    _timeLb = [[UILabel alloc] init];
    [_timeLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _timeLb;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UIView *)circleView{
    if (_circleView) {
        return _circleView;
    }
    _circleView = [UIView new];
    _circleView.layer.cornerRadius = 6;
    _circleView.layer.masksToBounds = YES;
    _circleView.backgroundColor = CA_H_TINTCOLOR;
    return _circleView;
}
-(UIView *)circleBgView{
    if (_circleBgView) {
        return _circleBgView;
    }
    _circleBgView = [UIView new];
    _circleBgView.layer.cornerRadius = 9;
    _circleBgView.layer.masksToBounds = YES;
    _circleBgView.backgroundColor = kColor(@"#D3D8F9");
    return _circleBgView;
}
@end
