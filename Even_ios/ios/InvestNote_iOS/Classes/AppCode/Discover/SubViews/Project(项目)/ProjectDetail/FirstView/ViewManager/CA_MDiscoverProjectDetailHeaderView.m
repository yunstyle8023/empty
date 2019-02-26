//
//  CA_MDiscoverProjectDetailHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailHeaderView.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MProjectDetailProjectInfoCollectionViewCell.h"
#import "CA_MDiscoverProjectDetailModel.h"

@interface CA_MDiscoverProjectDetailHeaderView ()


<
UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate
>

@property (nonatomic,strong) UIImageView *sloganImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) CA_MDiscoverProjectDetailModel *model;

@end

@implementation CA_MDiscoverProjectDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
    }
    return self;
}

- (void)upView{
    self.backgroundColor = kColor(@"#FFFFFF");
    [self addSubview:self.sloganImgView];
    [self addSubview:self.titleLb];
    [self addSubview:self.detailLb];
    [self addSubview:self.collectionView];
    
    [self setConstraints];
}

-(void)setConstraints{
    
    self.sloganImgView.sd_layout
    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.titleLb.sd_layout
    .topEqualToView(self.sloganImgView)
    .leftSpaceToView(self.sloganImgView, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH - 50*2*CA_H_RATIO_WIDTH];
    
    self.detailLb.sd_layout
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.titleLb)
    .autoHeightRatio(0);
    [self.detailLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH - 50*2*CA_H_RATIO_WIDTH];
    
//    self.collectionView.sd_layout
//    .topSpaceToView(self.detailLb, 5*2*CA_H_RATIO_WIDTH)
//    .leftEqualToView(self.detailLb)
//    .widthIs(CA_H_SCREEN_WIDTH - 50*2*CA_H_RATIO_WIDTH)
//    .heightIs(_collectionViewHeight);
    
}

-(CGFloat)configView:(CA_MDiscoverProjectDetailModel *)model{
    
    self.model = model;
    
    [self.sloganImgView setImageWithURL:[NSURL URLWithString:model.project_logo] placeholder:kImage(@"loadfail_project50")];
    self.titleLb.text = model.project_name;
    
    NSMutableString *str = [NSMutableString string];
    
    if ([NSString isValueableString:model.project_area]) {
        [str appendString:[NSString stringWithFormat:@"%@ ",model.project_area]];
    }
    
    if ([NSString isValueableString:model.project_invest_stage]) {
        [str appendString:[NSString stringWithFormat:@"%@ ",model.project_invest_stage]];
    }
    
    [str appendString:@" "];
    
    self.detailLb.text = str;
    
    [self.collectionView reloadData];
    
    CGFloat totalWidth = 0.;
    CGFloat collectionViewHeight = 0.;
    CGFloat maxWidth = CA_H_SCREEN_WIDTH - 50*2*CA_H_RATIO_WIDTH;
    int rows = 1;
    if ([NSObject isValueableObject:model.tag_list]) {
        for (NSString *title in model.tag_list) {
            
            CGFloat cellWidth = [title widthForFont:CA_H_FONT_PFSC_Regular(12)] + 4*2*CA_H_RATIO_WIDTH*2;
            
            if (cellWidth > maxWidth) {
                cellWidth = maxWidth;
            }
            
            if (totalWidth + cellWidth > maxWidth) {
                rows++;
                totalWidth = cellWidth;
            }else{
                totalWidth += (cellWidth+ 3*2*CA_H_RATIO_WIDTH);
            }
        }
    
        collectionViewHeight = rows * (12*2*CA_H_RATIO_WIDTH) + (rows-1)*(3*2*CA_H_RATIO_WIDTH);
    }
    
    self.collectionView.sd_layout
    .topSpaceToView(self.detailLb, 5*2*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.detailLb)
    .widthIs(CA_H_SCREEN_WIDTH - 50*2*CA_H_RATIO_WIDTH)
    .heightIs(collectionViewHeight);
    
    return collectionViewHeight;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.tag_list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectDetailProjectInfoCollectionViewCell *tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagCell" forIndexPath:indexPath];
    tagCell.font = CA_H_FONT_PFSC_Regular(12);
    tagCell.title = self.model.tag_list[indexPath.item];
    return tagCell;
}

#pragma mark - UICollectionViewDelegate | CA_MEqualSpaceFlowLayoutDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.pushBlock) {
        self.pushBlock(indexPath, self.model.tag_list[indexPath.item]);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat maxWidth = CA_H_SCREEN_WIDTH - 50*2*CA_H_RATIO_WIDTH;
    CGFloat cellWidth = [self.model.tag_list[indexPath.item] widthForFont:CA_H_FONT_PFSC_Regular(12)] + 4*2*2*CA_H_RATIO_WIDTH;
    if (cellWidth >= maxWidth) {
        cellWidth = maxWidth;
    }
    return CGSizeMake(cellWidth, 12*2*CA_H_RATIO_WIDTH);
}

#pragma mark - getter and setter

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        CA_MEqualSpaceFlowLayout *layout = [[CA_MEqualSpaceFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 3*2*CA_H_RATIO_WIDTH;
        layout.minimumInteritemSpacing = 3*2*CA_H_RATIO_WIDTH;
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = kColor(@"#FFFFFF");
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[CA_MProjectDetailProjectInfoCollectionViewCell class] forCellWithReuseIdentifier:@"tagCell"];
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
                        font:20];
    }
    return _titleLb;
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
