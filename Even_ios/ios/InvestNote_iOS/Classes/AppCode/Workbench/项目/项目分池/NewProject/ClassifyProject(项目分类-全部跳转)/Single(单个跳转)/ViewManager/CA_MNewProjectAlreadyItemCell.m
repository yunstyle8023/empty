
//
//  CA_MNewProjectAlreadyItemCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectAlreadyItemCell.h"
#import "CA_MNewProjectAlreadyCollectionViewCell.h"
#import "CA_MProjectModel.h"

@interface CA_MNewProjectAlreadyItemCell ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@end

@implementation CA_MNewProjectAlreadyItemCell

-(void)upView{
    [super upView];
    
    [self.contentView addSubview:self.sologImgView];
    self.sologImgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    [self.contentView addSubview:self.iconLb];
    self.iconLb.sd_layout
    .leftEqualToView(self.sologImgView)
    .rightEqualToView(self.sologImgView)
    .centerYEqualToView(self.sologImgView)
    .autoHeightRatio(0);
    
    [self.contentView addSubview:self.importBtn];
    self.importBtn.sd_layout
    .leftEqualToView(self.sologImgView)
    .bottomEqualToView(self.sologImgView)
    .rightEqualToView(self.sologImgView)
    .heightIs(9*2*CA_H_RATIO_WIDTH);
    
    [self.contentView addSubview:self.titleLb];
    self.titleLb.sd_layout
    .leftSpaceToView(self.sologImgView, 5*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.sologImgView)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-50*2*CA_H_RATIO_WIDTH];
    
    [self.contentView addSubview:self.detailLb];
    self.detailLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    
    [self.contentView addSubview:self.collectionView];
    self.collectionView.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.detailLb, 4*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    
    [self.contentView addSubview:self.lineView];
    self.lineView.sd_layout
    .leftEqualToView(self.titleLb)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
    
}

-(void)setModel:(CA_MProjectModel *)model{
    [super setModel:model];
    
    self.iconLb.hidden = [NSString isValueableString:model.project_logo];
    self.iconLb.text = [model.project_name substringToIndex:1];
    
    if ([NSString isValueableString:model.project_logo]) {
        NSString* logoUrl = @"";
        if ([model.project_logo hasPrefix:@"http"]) {
            logoUrl = model.project_logo;
        }else{
            logoUrl = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.project_logo];
        }
        
        [self.sologImgView setImageURL:[NSURL URLWithString:logoUrl]];
        self.sologImgView.backgroundColor = CA_H_BACKCOLOR;
    }else {
        [self.sologImgView setImageURL:[NSURL URLWithString:@""]];
        self.sologImgView.backgroundColor = kColor(model.project_color);
    }
    
    self.titleLb.text = model.project_name;
    
    if (model.total_amount.num.doubleValue >= 100000000) {
        NSString *resultStr = [self convertNumberToString:(model.total_amount.num.doubleValue/100000000)];
        self.detailLb.text = [NSString stringWithFormat:@"总投资金额：%@亿%@ 总占股：%@%%",resultStr,model.total_amount.unit_cn,model.stock_ratio];
    }else {
        NSString *resultStr = [self convertNumberToString:(model.total_amount.num.doubleValue/10000)];
        self.detailLb.text = [NSString stringWithFormat:@"总投资金额：%@万%@ 总占股：%@%%",resultStr,model.total_amount.unit_cn,model.stock_ratio];
    }
    
    self.importBtn.hidden = ![NSString isValueableString:model.project_status];
    [self.importBtn setTitle:model.project_status forState:UIControlStateNormal];

    [self.collectionView reloadData];
    self.collectionView.hidden = ![NSObject isValueableObject:model.risk_tag_list];
    if ([NSObject isValueableObject:model.risk_tag_list]) {
        [self setupAutoHeightWithBottomView:self.collectionView bottomMargin:5*2*CA_H_RATIO_WIDTH];
    }else {
        [self setupAutoHeightWithBottomView:self.sologImgView bottomMargin:5*2*CA_H_RATIO_WIDTH];
    }
    
}

-(NSString *)convertNumberToString:(double)number{
    NSString * numberStr = [NSString stringWithFormat:@"%0.4f",number];
    return [[numberStr numberValue] stringValue];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((CA_MProjectModel *)self.model).risk_tag_list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MNewProjectAlreadyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewProjectAlreadyCollectionViewCell" forIndexPath:indexPath];
    cell.model = ((CA_MProjectModel *)self.model).risk_tag_list[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectRisk_Tag_ListModel *model = ((CA_MProjectModel *)self.model).risk_tag_list[indexPath.item];
    CGFloat cellWidth = [model.tag_name widthForFont:CA_H_FONT_PFSC_Light(12)]+3*2*CA_H_RATIO_WIDTH*2;
    return CGSizeMake(cellWidth, 10*2*CA_H_RATIO_WIDTH);
}

#pragma mark - getter and setter

-(UIButton *)importBtn{
    if (!_importBtn) {
        _importBtn = [UIButton new];
        [_importBtn configTitle:@""
                     titleColor:[UIColor whiteColor]
                           font:10];
        _importBtn.backgroundColor = CA_H_TINTCOLOR;
        _importBtn.alpha = 0.85;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                                  CGRectMake(0, 0, 25*2*CA_H_RATIO_WIDTH, 9*2*CA_H_RATIO_WIDTH) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2*2*CA_H_RATIO_WIDTH, 2*2*CA_H_RATIO_WIDTH)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, 25*2*CA_H_RATIO_WIDTH, 9*2*CA_H_RATIO_WIDTH);
        maskLayer.path = maskPath.CGPath;
        _importBtn.layer.mask = maskLayer;
    }
    return _importBtn;
}

-(UILabel *)iconLb{
    if (!_iconLb) {
        _iconLb = [UILabel new];
        _iconLb.textAlignment = NSTextAlignmentCenter;
        [_iconLb configText:@""
                  textColor:kColor(@"#FFFFFF")
                       font:20];
    }
    return _iconLb;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 3*2*CA_H_RATIO_WIDTH;
        layout.minimumInteritemSpacing = 0.;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CA_MNewProjectAlreadyCollectionViewCell class] forCellWithReuseIdentifier:@"NewProjectAlreadyCollectionViewCell"];
    }
    return _collectionView;
}

-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [UILabel new];
        [_detailLb configText:@""
                    textColor:CA_H_9GRAYCOLOR
                         font:14];
    }
    return _detailLb;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}

-(UIImageView *)sologImgView{
    if (!_sologImgView) {
        _sologImgView = [UIImageView new];
        _sologImgView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _sologImgView.layer.masksToBounds = YES;
        _sologImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sologImgView;
}

@end
