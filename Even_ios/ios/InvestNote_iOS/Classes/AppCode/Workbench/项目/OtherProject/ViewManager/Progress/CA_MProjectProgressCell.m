//
//  CA_MProjectProgressCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MProjectProgressCell.h"
#import "CA_MProjectProgressTCollectionViewCell.h"

@interface CA_MProjectProgressCell()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
/// 进入下个阶段
@property(nonatomic,strong)UIButton* nextStageBtn;
/// 阶段撤回
@property(nonatomic,strong)UIButton* stageRecallBtn;
/// 撤销审批
@property(nonatomic,strong)UIButton* revocationBtn;
///
@property(nonatomic,strong)UIView* lineView;

@end

@implementation CA_MProjectProgressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.nextStageBtn];
    [self.contentView addSubview:self.stageRecallBtn];
    [self.contentView addSubview:self.revocationBtn];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.nextStageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.bottom.mas_equalTo(self.contentView).offset(-20);
        //
        make.width.mas_equalTo((CA_H_SCREEN_WIDTH-20*3)/2);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.stageRecallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView).offset(-20);
        //
        make.width.mas_equalTo((CA_H_SCREEN_WIDTH-20*3)/2);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.revocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-20);
        //
        make.width.mas_equalTo((CA_H_SCREEN_WIDTH-20*3)/2);
        make.height.mas_equalTo(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nextStageBtn);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.nextStageBtn.mas_top).offset(-30);
    }];
}

-(void)setMember_type_id:(NSNumber *)member_type_id{
    
    _member_type_id = member_type_id;
    
    if (!member_type_id) {
        return;
    }
    
    if (member_type_id.intValue == 0) {
        self.nextStageBtn.enabled = NO;
        [self updateButtonWithButton:self.nextStageBtn
                               title:@"进入下个阶段"
                          titleColor:kColor(@"#FFFFFF")
                                font:15
                     backgroundColor:CA_H_9GRAYCOLOR
                         borderColor:CA_H_9GRAYCOLOR
                            selecter:@selector(nextStageBtnAction)];
        
        self.stageRecallBtn.enabled = NO;
        [self updateButtonWithButton:self.stageRecallBtn
                               title:@"阶段撤回"
                          titleColor:CA_H_9GRAYCOLOR
                                font:15
                     backgroundColor:kColor(@"#FFFFFF")
                         borderColor:CA_H_9GRAYCOLOR
                            selecter:@selector(stageRecallBtnAction)];
        
        self.revocationBtn.enabled = NO;
        [self updateButtonWithButton:self.revocationBtn
                               title:@"撤销审批"
                          titleColor:CA_H_9GRAYCOLOR
                                font:15
                     backgroundColor:kColor(@"#FFFFFF")
                         borderColor:CA_H_9GRAYCOLOR
                            selecter:@selector(revocationBtnAction)];
    }

}


-(void)setModel:(CA_MProjectProgressModel *)model{
    _model = model;
    
    if ([model.current_status isEqualToString:@"pending"]) {//# 当前阶段状态  pending 是提起审批的状态，processing 是未提起审批的状态
        self.revocationBtn.hidden = NO;
        self.nextStageBtn.hidden = YES;
        self.stageRecallBtn.hidden = YES;
    }else{
        self.revocationBtn.hidden = YES;
        self.nextStageBtn.hidden = NO;
        self.stageRecallBtn.hidden = NO;
    }
    
    if (self.revocationBtn.isHidden) {
        //当前就是最后一步 需要把进入下个阶段按钮禁用
        if (model.current_node_id == [model.procedure_view lastObject].procedure_id) {
            self.nextStageBtn.enabled = NO;
            [self updateButtonWithButton:self.nextStageBtn
                                   title:@"进入下个阶段"
                              titleColor:CA_H_9GRAYCOLOR
                                    font:15
                         backgroundColor:kColor(@"#FFFFFF")
                             borderColor:CA_H_9GRAYCOLOR
                                selecter:@selector(nextStageBtnAction)];
        }else{
            self.nextStageBtn.enabled = YES;
            [self updateButtonWithButton:self.nextStageBtn
                                   title:@"进入下个阶段"
                              titleColor:kColor(@"#FFFFFF")
                                    font:15
                         backgroundColor:CA_H_TINTCOLOR
                             borderColor:nil
                                selecter:@selector(nextStageBtnAction)];
        }
        
        //如果当前是第一步 阶段撤回的按钮禁用
        if (model.current_node_id == [model.procedure_view firstObject].procedure_id) {
            self.stageRecallBtn.enabled = NO;
            [self updateButtonWithButton:self.stageRecallBtn
                                   title:@"阶段撤回"
                              titleColor:CA_H_9GRAYCOLOR
                                    font:15
                         backgroundColor:kColor(@"#FFFFFF")
                             borderColor:CA_H_9GRAYCOLOR
                                selecter:@selector(stageRecallBtnAction)];
        }else{
            self.stageRecallBtn.enabled = YES;
            [self updateButtonWithButton:self.stageRecallBtn
                                   title:@"阶段撤回"
                              titleColor:CA_H_TINTCOLOR
                                    font:15
                         backgroundColor:kColor(@"#FFFFFF")
                             borderColor:CA_H_TINTCOLOR
                                selecter:@selector(stageRecallBtnAction)];
        }
    }else{
        //如果当前是第一步 阶段撤回的按钮禁用
        if (model.current_node_id == [model.procedure_view firstObject].procedure_id) {
            self.revocationBtn.enabled = NO;
            [self updateButtonWithButton:self.revocationBtn
                                   title:@"撤销审批"
                              titleColor:CA_H_9GRAYCOLOR
                                    font:15
                         backgroundColor:kColor(@"#FFFFFF")
                             borderColor:CA_H_9GRAYCOLOR
                                selecter:@selector(revocationBtnAction)];
        }else{
            self.revocationBtn.enabled = YES;
            [self updateButtonWithButton:self.revocationBtn
                                   title:@"撤销审批"
                              titleColor:CA_H_TINTCOLOR
                                    font:15
                         backgroundColor:kColor(@"#FFFFFF")
                             borderColor:CA_H_TINTCOLOR
                                selecter:@selector(revocationBtnAction)];
        }
    }
    
    
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.procedure_view.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectProgressTCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    cell.currentID = self.model.current_node_id;
    cell.model = self.model.procedure_view[indexPath.item];
    if (indexPath.item == 0) {
        cell.leftLine.hidden = YES;
        cell.rightLine.hidden = NO;
    }else{
        cell.leftLine.hidden = NO;
        cell.rightLine.hidden = NO;
    }
    if (indexPath.item == self.model.procedure_view.count-1) {
        cell.rightLine.hidden = YES;
    }else{
        cell.rightLine.hidden = NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_Mprocedure_viewModel *model = self.model.procedure_view[indexPath.item];
    CGFloat width = [model.procedure_name widthForFont:CA_H_FONT_PFSC_Regular(14)];
    CGFloat result = (width+20)>(CA_H_SCREEN_WIDTH/5)?(width+20):(CA_H_SCREEN_WIDTH/5);
    return CGSizeMake(result, collectionView.mj_h);
}
//阶段撤回
-(void)stageRecallBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stageRecallBtnClick)]) {
        [self.delegate stageRecallBtnClick];
    }
}
//进入下个阶段
-(void)nextStageBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextStageBtnClick)]) {
        [self.delegate nextStageBtnClick];
    }
}
//撤销审批
-(void)revocationBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(revocationBtnClick)]) {
        [self.delegate revocationBtnClick];
    }
}

#pragma mark - getter and setter
-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[CA_MProjectProgressTCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    return _collectionView;
}

-(void)updateButtonWithButton:(UIButton*)button
                        title:(NSString*)title
                       titleColor:(UIColor*)titleColor
                                  font:(CGFloat)font
                       backgroundColor:(UIColor*)backgroundColor
                           borderColor:(UIColor*)borderColor
                         selecter:(SEL)sel{
    [button configTitle:title titleColor:titleColor font:font];
    button.backgroundColor = backgroundColor;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    if (borderColor) {
        button.layer.borderColor = borderColor.CGColor;
        button.layer.borderWidth = 0.5;
    }
    [button addTarget:self
               action:sel
     forControlEvents:UIControlEventTouchUpInside];
}

-(UIButton *)revocationBtn{
    if (_revocationBtn) {
        return _revocationBtn;
    }
    _revocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self updateButtonWithButton:_revocationBtn
                                            title:@"撤销审批"
                                      titleColor:CA_H_TINTCOLOR
                                            font:15
                                 backgroundColor:kColor(@"#FFFFFF")
                                     borderColor:CA_H_TINTCOLOR
                                        selecter:@selector(revocationBtnAction)];
    _revocationBtn.hidden = YES;
    return _revocationBtn;
}
-(UIButton *)stageRecallBtn{
    if (_stageRecallBtn) {
        return _stageRecallBtn;
    }
    _stageRecallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self updateButtonWithButton:_stageRecallBtn
                                             title:@"阶段撤回"
                                      titleColor:CA_H_TINTCOLOR
                                            font:15
                                 backgroundColor:kColor(@"#FFFFFF")
                                     borderColor:CA_H_TINTCOLOR
                                        selecter:@selector(stageRecallBtnAction)];
    return _stageRecallBtn;
}
-(UIButton *)nextStageBtn{
    if (_nextStageBtn) {
        return _nextStageBtn;
    }
    _nextStageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self updateButtonWithButton:_nextStageBtn
                                           title:@"进入下个阶段"
                                       titleColor:kColor(@"#FFFFFF")
                                             font:15
                                  backgroundColor:CA_H_TINTCOLOR
                                      borderColor:nil
                                         selecter:@selector(nextStageBtnAction)];
    return _nextStageBtn;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
@end
