

//
//  CA_MDiscoverRelatedProjectCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedProjectCell.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MProjectDetailProjectInfoCollectionViewCell.h"

@interface CA_MDiscoverRelatedProjectCell ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate>

@end

@implementation CA_MDiscoverRelatedProjectCell


-(void)upView{
    [super upView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.sloganImgView];
    [self.contentView addSubview:self.sloganLb];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.collectionView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.lineView.sd_resetLayout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
    
    self.sloganImgView.sd_resetLayout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .widthIs(23*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.sloganLb.sd_resetLayout
    .centerXEqualToView(self.sloganImgView)
    .centerYEqualToView(self.sloganImgView)
    .autoHeightRatio(0);
    [self.sloganLb setSingleLineAutoResizeWithMaxWidth:0];

    self.titleLb.sd_resetLayout
    .leftSpaceToView(self.sloganImgView, 10)
    .topEqualToView(self.sloganImgView)
    .autoHeightRatio(0);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:140*CA_H_RATIO_WIDTH];

    self.detailLb.sd_resetLayout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 4)
    .autoHeightRatio(0);
    [self.detailLb setSingleLineAutoResizeWithMaxWidth:140*CA_H_RATIO_WIDTH];

    self.collectionView.sd_resetLayout
    .leftEqualToView(self.detailLb)
    .topSpaceToView(self.detailLb, 10)
    .heightIs(12*2*CA_H_RATIO_WIDTH)
    .widthIs((CA_H_SCREEN_WIDTH-38-10)*2*CA_H_RATIO_WIDTH);
    
}

-(void)setModel:(NSObject *)model{
    [super setModel:model];
    
    self.sloganImgView.backgroundColor = kRandomColor;
    self.sloganLb.text = @"美";
    self.titleLb.text = @"美团打车";
    self.detailLb.text = @"北京·西城区 D轮";
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.model.count;
    return 3;
}
#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectDetailProjectInfoCollectionViewCell* infoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"infoCell" forIndexPath:indexPath];
    infoCell.title = @"测试标签";
    return infoCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.pushBlock) {
        self.pushBlock(indexPath);
    }
}
#pragma mark - CA_MEqualSpaceFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = [@"测试标签" widthForFont:CA_H_FONT_PFSC_Regular(14)] + 10 +10;
    if (cellWidth >= (CA_H_SCREEN_WIDTH-38-10)*2*CA_H_RATIO_WIDTH) {
        cellWidth = (CA_H_SCREEN_WIDTH-38-10)*2*CA_H_RATIO_WIDTH;
    }
    return CGSizeMake(cellWidth, 12*2*CA_H_RATIO_WIDTH);
}

#pragma mark - getter and setter

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        CA_MEqualSpaceFlowLayout* layout = [[CA_MEqualSpaceFlowLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kColor(@"#FFFFFF");
        [_collectionView registerClass:[CA_MProjectDetailProjectInfoCollectionViewCell class] forCellWithReuseIdentifier:@"infoCell"];
    }
    return _collectionView;
}
-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [[UILabel alloc] init];
        [_detailLb configText:@""
                    textColor:CA_H_9GRAYCOLOR
                         font:14];
    }
    return _detailLb;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        [_titleLb configText:@""
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _titleLb;
}
-(UILabel *)sloganLb{
    if (!_sloganLb) {
        _sloganLb = [[UILabel alloc] init];
        [_sloganLb configText:@""
                    textColor:kColor(@"#FFFFFF")
                         font:20];
    }
    return _sloganLb;
}
-(UIImageView *)sloganImgView{
    if (!_sloganImgView) {
        _sloganImgView = [UIImageView new];
        _sloganImgView.layer.cornerRadius = 4;
        _sloganImgView.layer.masksToBounds = YES;
    }
    return _sloganImgView;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
@end
