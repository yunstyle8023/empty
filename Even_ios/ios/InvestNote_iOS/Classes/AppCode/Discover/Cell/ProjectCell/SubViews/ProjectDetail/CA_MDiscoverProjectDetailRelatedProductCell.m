//
//  CA_MDiscoverProjectDetailRelatedProductCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailRelatedProductCell.h"
#import "CA_MDiscoverProjectDetailModel.h"
#import "CA_MProjectDetailProjectInfoCollectionViewCell.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MDiscoverProjectDetailModel.h"

@interface CA_MDiscoverProjectDetailRelatedProductCell ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate>

@end

@implementation CA_MDiscoverProjectDetailRelatedProductCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
        [self setConstraints];
    }
    return self;
}

-(void)setupView{
    [self.contentView addSubview:self.sloganImgView];
    [self.contentView addSubview:self.sloganLb];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.detailLb];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.lineView];
}

-(void)setConstraints{
    
    self.sloganImgView.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(23*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.sloganLb.sd_layout
    .centerXEqualToView(self.sloganImgView)
    .centerYEqualToView(self.sloganImgView)
    .autoHeightRatio(0);
    [self.sloganLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.titleLb.sd_layout
    .leftSpaceToView(self.sloganImgView, 10)
    .topEqualToView(self.sloganImgView)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:1];
    
    self.detailLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 4)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
    self.collectionView.sd_layout
    .leftEqualToView(self.detailLb)
    .topSpaceToView(self.detailLb, 10)
    .heightIs(12*2*CA_H_RATIO_WIDTH)
    .widthIs(CA_H_SCREEN_WIDTH-(38+10)*2*CA_H_RATIO_WIDTH);
    
    self.lineView.sd_layout
    .leftEqualToView(self.detailLb)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(CA_H_LINE_Thickness);
}

-(void)setModel:(CA_MDiscoverCompatible_project_list *)model{
    [super setModel:model];
    
    [self.sloganImgView setImageWithURL:[NSURL URLWithString:model.project_logo] placeholder:kImage(@"loadfail_project50")];
    
    self.titleLb.text = model.project_name;
    
    self.detailLb.text = [NSString stringWithFormat:@"%@ %@",[NSString isValueableString:model.project_location]?model.project_location:@"暂无",[NSString isValueableString:model.project_last_round]?model.project_last_round:@"暂无"];
    
    [self.collectionView reloadData];
    
    if ([NSObject isValueableObject:((CA_MDiscoverCompatible_project_list*)self.model).project_tag_list]) {
        self.collectionView.hidden = NO;
        [self setupAutoHeightWithBottomView:self.collectionView bottomMargin:8*2*CA_H_RATIO_WIDTH];
    }else {
        self.collectionView.hidden = YES;
        [self setupAutoHeightWithBottomView:self.detailLb bottomMargin:8*2*CA_H_RATIO_WIDTH];
    }
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([NSObject isValueableObject:((CA_MDiscoverCompatible_project_list*)self.model).project_tag_list]) {
        CGFloat totalWidth = 0.;
        CGFloat maxWidth = CA_H_SCREEN_WIDTH-(38+10)*2*CA_H_RATIO_WIDTH;
        int rows = 0;
        for (int i=0; i<((CA_MDiscoverCompatible_project_list*)self.model).project_tag_list.count; i++) {
            NSString *title = ((CA_MDiscoverCompatible_project_list*)self.model).project_tag_list[i];
            CGFloat cellWidth = [title widthForFont:CA_H_FONT_PFSC_Regular(12)] + 4*2*CA_H_RATIO_WIDTH*2 + 3*2*CA_H_RATIO_WIDTH;
            if (totalWidth >= maxWidth) {
                rows = i;
                break;
            }
            totalWidth += cellWidth;
        }
        return rows==0?((CA_MDiscoverCompatible_project_list*)self.model).project_tag_list.count:rows;
    }
    
    return 0;
}
#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectDetailProjectInfoCollectionViewCell* infoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"infoCell" forIndexPath:indexPath];
    infoCell.font = CA_H_FONT_PFSC_Regular(12);
    infoCell.title = ((CA_MDiscoverCompatible_project_list*)self.model).project_tag_list[indexPath.item];
    return infoCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.pushBlock) {
        self.pushBlock(indexPath, ((CA_MDiscoverCompatible_project_list*)self.model).project_tag_list[indexPath.item]);
    }
}
#pragma mark - CA_MEqualSpaceFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = ((CA_MDiscoverCompatible_project_list*)self.model).project_tag_list[indexPath.item];
    CGFloat cellWidth = [title widthForFont:CA_H_FONT_PFSC_Regular(12)] + 4*2*CA_H_RATIO_WIDTH*2;
//    if (cellWidth >= (CA_H_SCREEN_WIDTH-38-10)*2*CA_H_RATIO_WIDTH) {
//        cellWidth = (CA_H_SCREEN_WIDTH-38-10)*2*CA_H_RATIO_WIDTH;
//    }
    return CGSizeMake(cellWidth, 12*2*CA_H_RATIO_WIDTH);
}

#pragma mark - getter and setter
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        CA_MEqualSpaceFlowLayout* layout = [[CA_MEqualSpaceFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 3*2*CA_H_RATIO_WIDTH;
        layout.minimumInteritemSpacing = 3*2*CA_H_RATIO_WIDTH;
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
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
        _titleLb.numberOfLines = 1;
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
        _sloganImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sloganImgView;
}

@end
