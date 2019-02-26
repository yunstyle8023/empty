
//
//  CA_MProjectDetailProjectInfoCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectDetailProjectInfoCell.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MProjectDetailProjectInfoCollectionViewCell.h"

@interface CA_MProjectDetailProjectInfoCell ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate>{
    CA_MProject_info* _infoModel;
    CGFloat _collectionViewHeight;
    CGFloat _marginHeight;
}

@property (nonatomic,strong) UILabel *sloganLb;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *introLb;
@property (nonatomic,strong) UILabel *brief_introLb;
@property (nonatomic,strong) UILabel *highlightLb;
@property (nonatomic,strong) UILabel *invest_highlightLb;
@property (nonatomic,strong) UILabel *riskLb;
@property (nonatomic,strong) UILabel *invest_riskLb;
@end

@implementation CA_MProjectDetailProjectInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self upView];
    }
    return self;
}

- (void)upView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.sloganLb];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.introLb];
    [self.contentView addSubview:self.brief_introLb];
    [self.contentView addSubview:self.highlightLb];
    [self.contentView addSubview:self.invest_highlightLb];
    [self.contentView addSubview:self.riskLb];
    [self.contentView addSubview:self.invest_riskLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.sloganLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.contentView);//.offset(10);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.sloganLb.mas_bottom).offset(20);
        make.height.mas_equalTo(_collectionViewHeight);
    }];
    
    [self.introLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(_marginHeight);
    }];
    
    [self.brief_introLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.introLb.mas_bottom).offset(10);
    }];
    
    [self.highlightLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.brief_introLb.mas_bottom).offset(20);
    }];
    
    [self.invest_highlightLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.highlightLb.mas_bottom).offset(10);
    }];
    
    [self.riskLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.invest_highlightLb.mas_bottom).offset(20);
    }];
    
    [self.invest_riskLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.riskLb.mas_bottom).offset(10);
    }];
}

-(CGFloat)configCell:(CA_MProject_info *)model{
    _infoModel = model;
    
    self.sloganLb.text = [NSString isValueableString:model.slogan]?model.slogan:@"暂无";
    [self.sloganLb changeLineSpaceWithSpace:6];
    
    [self.collectionView reloadData];
    
    self.brief_introLb.text = [NSString isValueableString:model.brief_intro]?model.brief_intro:@"暂无";
    
    self.invest_highlightLb.text = [NSString isValueableString:model.invest_highlight]?model.invest_highlight:@"暂无";
    
    self.invest_riskLb.text = [NSString isValueableString:model.invest_risk]?model.invest_risk:@"暂无";
    
    CGFloat kWidth = CA_H_SCREEN_WIDTH - 20*2;//允许的最大宽度
    CGFloat total = 0;
    CGFloat rows = 0;
    for (int i=0;i<model.tag_list.count;i++) {
        NSString* str = model.tag_list[i].tag_name;
        CGFloat strWidth = [str widthForFont:CA_H_FONT_PFSC_Regular(14)];
        CGFloat cellWidth = 10+strWidth+10+10;
        if (cellWidth >= kWidth) {
            cellWidth = kWidth;
        }
        total += cellWidth;
        if (total >= kWidth) {
            rows += 1;
            total = cellWidth;
        }
    }
    
    if (rows > 0) {
        rows = rows+1;
    }else{
        if (total>0) {
            rows = 1;
        }else{
            rows = 0;
        }
    }
    
    CGFloat tmpH = rows*30*CA_H_RATIO_WIDTH + (rows-1)*10;
    
    _collectionViewHeight = 0.;
    _collectionViewHeight = tmpH<=0 ? 0 : tmpH;
    
    _marginHeight =0.;
    _marginHeight = tmpH<=0 ? 0 : 22;
    
    CGFloat sloganH = [self getSpaceLabelHeight:self.sloganLb.text withFont:CA_H_FONT_PFSC_Regular(14) withWidth:kWidth];
    
    CGFloat introH = [self getSpaceLabelHeight:self.introLb.text withFont:CA_H_FONT_PFSC_Regular(14) withWidth:kWidth];
    
    CGFloat brief_intro_H = [self getSpaceLabelHeight:self.brief_introLb.text withFont:CA_H_FONT_PFSC_Regular(14) withWidth:kWidth];
    
    CGFloat highlightH = [self getSpaceLabelHeight:self.highlightLb.text withFont:CA_H_FONT_PFSC_Regular(14) withWidth:kWidth];
    
    CGFloat invest_highlight_H = [self getSpaceLabelHeight:self.invest_highlightLb.text withFont:CA_H_FONT_PFSC_Regular(14) withWidth:kWidth];
    
    CGFloat riskH = [self getSpaceLabelHeight:self.riskLb.text withFont:CA_H_FONT_PFSC_Regular(14) withWidth:kWidth];
    
    CGFloat invest_risk_H = [self getSpaceLabelHeight:self.invest_riskLb.text withFont:CA_H_FONT_PFSC_Regular(14) withWidth:kWidth];
    
    CGFloat totalH = sloganH + 20 + _collectionViewHeight+introH + 10
    + brief_intro_H + 20 + highlightH + 10 +invest_highlight_H + 20 + riskH + 10
    + invest_risk_H ;//+20;
    
    if (_collectionViewHeight>0) {
        totalH = totalH + 20;
    }
    
    [self layoutIfNeeded];
    
    return totalH-20;
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _infoModel.tag_list.count;
}
#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectDetailProjectInfoCollectionViewCell* infoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"infoCell" forIndexPath:indexPath];
    infoCell.title = _infoModel.tag_list[indexPath.item].tag_name;
    return infoCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tag_name = _infoModel.tag_list[indexPath.item].tag_name;
    self.pushBlock?self.pushBlock(tag_name):nil;
}

#pragma mark - CA_MEqualSpaceFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString* name = _infoModel.tag_list[indexPath.item].tag_name;
    CGFloat cellWidth = [name widthForFont:CA_H_FONT_PFSC_Regular(14)] + 10 +10;
    if (cellWidth >= CA_H_SCREEN_WIDTH - 20*2) {
        cellWidth = CA_H_SCREEN_WIDTH - 20*2;
    }
    return CGSizeMake(cellWidth, 30*CA_H_RATIO_WIDTH);
}

#pragma mark - getter and setter

-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    CA_MEqualSpaceFlowLayout* layout = [[CA_MEqualSpaceFlowLayout alloc] init];
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    [_collectionView registerClass:[CA_MProjectDetailProjectInfoCollectionViewCell class] forCellWithReuseIdentifier:@"infoCell"];
    return _collectionView;
}
-(UILabel *)invest_riskLb{
    if (_invest_riskLb) {
        return _invest_riskLb;
    }
    _invest_riskLb = [[UILabel alloc] init];
    _invest_riskLb.numberOfLines = 0;
    [_invest_riskLb configText:@"暂无" textColor:CA_H_4BLACKCOLOR font:14];
    [_invest_riskLb changeLineSpaceWithSpace:6];
    return _invest_riskLb;
}
-(UILabel *)invest_highlightLb{
    if (_invest_highlightLb) {
        return _invest_highlightLb;
    }
    _invest_highlightLb = [[UILabel alloc] init];
    _invest_highlightLb.numberOfLines = 0;
    [_invest_highlightLb configText:@"暂无" textColor:CA_H_4BLACKCOLOR font:14];
    [_invest_highlightLb changeLineSpaceWithSpace:6];
    return _invest_highlightLb;
}
-(UILabel *)brief_introLb{
    if (_brief_introLb) {
        return _brief_introLb;
    }
    _brief_introLb = [[UILabel alloc] init];
    _brief_introLb.numberOfLines = 0;
    [_brief_introLb configText:@"暂无" textColor:CA_H_4BLACKCOLOR font:14];
    [_brief_introLb changeLineSpaceWithSpace:6];
    return _brief_introLb;
}
-(UILabel *)riskLb{
    if (_riskLb) {
        return _riskLb;
    }
    _riskLb = [[UILabel alloc] init];
    [_riskLb configText:@"投资风险" textColor:CA_H_9GRAYCOLOR font:16];
    return _riskLb;
}
-(UILabel *)highlightLb{
    if (_highlightLb) {
        return _highlightLb;
    }
    _highlightLb = [[UILabel alloc] init];
    [_highlightLb configText:@"投资亮点" textColor:CA_H_9GRAYCOLOR font:16];
    return _highlightLb;
}
-(UILabel *)introLb{
    if (_introLb) {
        return _introLb;
    }
    _introLb = [[UILabel alloc] init];
    [_introLb configText:@"项目介绍" textColor:CA_H_9GRAYCOLOR font:16];
    return _introLb;
}
-(UILabel *)sloganLb{
    if (_sloganLb) {
        return _sloganLb;
    }
    _sloganLb = [[UILabel alloc] init];
    _sloganLb.numberOfLines = 0;
    [_sloganLb configText:@"暂无" textColor:CA_H_4BLACKCOLOR font:14];
    //    [_sloganLb changeLineSpaceWithSpace:6];
    return _sloganLb;
}

@end

