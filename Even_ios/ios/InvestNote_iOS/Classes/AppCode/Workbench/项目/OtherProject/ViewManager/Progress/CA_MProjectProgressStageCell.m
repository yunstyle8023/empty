
//
//  CA_MProjectProgressStageCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectProgressStageCell.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MProjectProgressStageCollectionCell.h"

@interface CA_MProjectProgressStageCell ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate
>{
    CGFloat _collectionViewHeight;
}

/// 原点
@property(nonatomic,strong)UIView* circleView;
@property(nonatomic,strong)UIView* circleBgView;
/// 细线
@property(nonatomic,strong)UIView* lineView;
/// 时间
@property(nonatomic,strong)UILabel* timeLb;
/// 项目状态(项目激活/放弃项目...)
@property(nonatomic,strong)UILabel* stateLb;
/// 申请人
@property (nonatomic,strong) UILabel *applyLb;
/// 操作人头像
@property (nonatomic,strong) UIImageView *iconImgView;
/// 操作人
@property(nonatomic,strong)UILabel* personLb;
/// 理由
@property(nonatomic,strong)UILabel* reasonLb;

@property(nonatomic,strong)UILabel* approveLb;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) CA_MProcedure_logModel *model;
@end

@implementation CA_MProjectProgressStageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
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
    [self.contentView addSubview:self.applyLb];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.personLb];
    [self.contentView addSubview:self.reasonLb];
    [self.contentView addSubview:self.approveLb];
    [self.contentView addSubview:self.collectionView];
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
    
    [self.applyLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonLb.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.reasonLb);
    }];
    
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.applyLb);
        make.leading.mas_equalTo(self.applyLb.mas_trailing).offset(5);
        //
        make.width.height.mas_equalTo(20);
    }];
    
    [self.personLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(5);
        //        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.approveLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.applyLb);
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconImgView);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
        make.height.mas_equalTo(_collectionViewHeight);
    }];
    
}

- (CGFloat)configCell:(CA_MProcedure_logModel*)model
            indexPath:(NSIndexPath*)indexPath
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
    
    self.reasonLb.text = model.procedure_comment;
    
    [self.iconImgView setImageWithURL:[NSURL URLWithString:model.creator.avatar]
                          placeholder:kImage(@"head20")];
    
    self.personLb.text = model.creator.chinese_name;
    
    CGFloat width = 0;
    for (CA_MApproval_user* user in self.model.approval_user_list) {
        width += 20 + 5 + [user.chinese_name widthForFont:CA_H_FONT_PFSC_Regular(14)] + 10;
    }
    NSInteger row = ceil((width-10)/230.0);
    
    NSLog(@"row == %ld",(long)row);
    _collectionViewHeight = row*20 + (row-1)*10;
    if (_collectionViewHeight<=0) {
        _collectionViewHeight = 0;
    }
    
    [self.collectionView reloadData];
    
    CGFloat timeH = [self.timeLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
    CGFloat stateH = [self.stateLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
    CGFloat reasonH = [self.reasonLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
//    CGFloat personH = [self.personLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
    return timeH+10+stateH+10+reasonH+10+20+10+_collectionViewHeight+20;
}

#pragma mark - UICollectionViewDataSource

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MApproval_user* user = self.model.approval_user_list[indexPath.item];
    CGFloat width = 20 + 5 + [user.chinese_name widthForFont:CA_H_FONT_PFSC_Regular(14)];
    return CGSizeMake(width, 20);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.approval_user_list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectProgressStageCollectionCell* stageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stageCell" forIndexPath:indexPath];
    stageCell.model = self.model.approval_user_list[indexPath.item];
    return stageCell;
}

#pragma mark - Getter and Setter
-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    CA_MEqualSpaceFlowLayout* layout = [[CA_MEqualSpaceFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    [_collectionView registerClass:[CA_MProjectProgressStageCollectionCell class] forCellWithReuseIdentifier:@"stageCell"];
    return _collectionView;
}
-(UILabel *)approveLb{
    if (_approveLb) {
        return _approveLb;
    }
    _approveLb = [[UILabel alloc] init];
    [_approveLb configText:@"审批人:" textColor:CA_H_9GRAYCOLOR font:14];
    [_approveLb sizeToFit];
    return _approveLb;
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
-(UILabel *)applyLb{
    if (_applyLb) {
        return _applyLb;
    }
    _applyLb = [[UILabel alloc] init];
    [_applyLb configText:@"申请人:" textColor:CA_H_9GRAYCOLOR font:14];
    [_applyLb sizeToFit];
    return _applyLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 20 / 2;
    _iconImgView.layer.masksToBounds = YES;
    return _iconImgView;
}
-(UILabel *)personLb{
    if (_personLb) {
        return _personLb;
    }
    _personLb = [[UILabel alloc] init];
    [_personLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _personLb;
}
-(UILabel *)stateLb{
    if (_stateLb) {
        return _stateLb;
    }
    _stateLb = [[UILabel alloc] init];
    [_stateLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
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
