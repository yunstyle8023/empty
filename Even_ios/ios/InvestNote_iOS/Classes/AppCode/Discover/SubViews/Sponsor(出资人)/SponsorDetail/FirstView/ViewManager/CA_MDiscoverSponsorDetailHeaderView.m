
//
//  CA_MDiscoverSponsorDetailHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailHeaderView.h"
#import "CA_MProjectDetailProjectInfoCollectionViewCell.h"
#import "CA_MDiscoverSponsorDetailModel.h"
#import "CA_MEqualSpaceFlowLayout.h"

@interface CA_MDiscoverSponsorDetailHeaderView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate
>

@property (nonatomic,strong) CA_MDiscoverSponsorDetailModel *model;
@end

@implementation CA_MDiscoverSponsorDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        [self setConstrains];
    }
    return self;
}

-(void)upView{
    self.backgroundColor = CA_H_TINTCOLOR;
    [self addSubview:self.titleLb];
    [self addSubview:self.detailLb];
    [self addSubview:self.collectionView];
}

-(void)setConstrains{
    
    self.titleLb.sd_layout
    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
//    .rightSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.titleLb setMaxNumberOfLinesToShow:0];
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-10*2*CA_H_RATIO_WIDTH-10*2*CA_H_RATIO_WIDTH];
    
    self.detailLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 5*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
    self.collectionView.sd_layout
    .leftEqualToView(self.detailLb)
    .topSpaceToView(self.detailLb, 8*2*CA_H_RATIO_WIDTH)
    .widthIs(CA_H_SCREEN_WIDTH - (10*2*CA_H_RATIO_WIDTH)*2)
    .heightIs(12*2*CA_H_RATIO_WIDTH);
}

-(CGFloat)configView:(CA_MDiscoverSponsorDetailModel *)model{
    
    self.model = model;

    self.titleLb.text = model.base_info.lp_name;
    [self.titleLb sizeToFit];
    
    NSMutableString *str = [NSMutableString string];
    
    if ([NSString isValueableString:model.base_info.lp_area]) {
        [str appendString:[NSString stringWithFormat:@"%@ ",model.base_info.lp_area]];
    }
    
    if ([NSString isValueableString:model.base_info.found_date]) {
        [str appendString:[NSString stringWithFormat:@"%@ ",model.base_info.found_date]];
    }
    
    [str appendString:@" "];
    
    self.detailLb.text = str;
    
    CGFloat titleH = [self.titleLb.text
                      heightForFont:CA_H_FONT_PFSC_Regular(22)
                      width:CA_H_SCREEN_WIDTH - (10*2*CA_H_RATIO_WIDTH)*2];
    
    CGFloat detailH = [self.detailLb.text
                       heightForFont:CA_H_FONT_PFSC_Regular(14)
                                width:CA_H_SCREEN_WIDTH - (10*2*CA_H_RATIO_WIDTH)*2];
    
    CGFloat height = 5*2*CA_H_RATIO_WIDTH + titleH;
    
    if ([NSString isValueableString:self.detailLb.text]) {
        height += (5*2*CA_H_RATIO_WIDTH+detailH + 8*2*CA_H_RATIO_WIDTH);
    }else {
        height += 5*2*CA_H_RATIO_WIDTH;
    }
    
    self.collectionView.hidden = ![NSObject isValueableObject:model.base_info.tags];
    
    CGFloat totalWidth =0.;
    int rows = 1;
    for (NSString* title in self.model.base_info.tags) {
        
        CGFloat cellWidth = [title widthForFont:CA_H_FONT_PFSC_Regular(12)] + (4*2*CA_H_RATIO_WIDTH)*2;
        
        if (cellWidth > (CA_H_SCREEN_WIDTH - 40)) {
            cellWidth = (CA_H_SCREEN_WIDTH - 40);
        }
        
        if (totalWidth + cellWidth > (CA_H_SCREEN_WIDTH - 40)) {
            rows++;
            totalWidth = cellWidth;
        }else{
          totalWidth += (cellWidth+ 3*2*CA_H_RATIO_WIDTH);
        }
        
    }
    
    CGFloat collectionViewHeight = rows*12*2*CA_H_RATIO_WIDTH + (rows-1)*3*2*CA_H_RATIO_WIDTH;
    
    if ([NSString isValueableString:self.detailLb.text]) {
        self.collectionView.sd_resetLayout
        .leftEqualToView(self.detailLb)
        .topSpaceToView(self.detailLb, 8*2*CA_H_RATIO_WIDTH)
        .widthIs(CA_H_SCREEN_WIDTH - (10*2*CA_H_RATIO_WIDTH)*2)
        .heightIs(collectionViewHeight);
    }else {
        self.collectionView.sd_resetLayout
        .leftEqualToView(self.titleLb)
        .topSpaceToView(self.titleLb, 8*2*CA_H_RATIO_WIDTH)
        .widthIs(CA_H_SCREEN_WIDTH - (10*2*CA_H_RATIO_WIDTH)*2)
        .heightIs(collectionViewHeight);
    }
    
    [self.collectionView reloadData];
    
    if ([NSObject isValueableObject:model.base_info.tags]) {
        height = height + collectionViewHeight + 8*2*CA_H_RATIO_WIDTH;
    }
    
    return height;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.base_info.tags.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectDetailProjectInfoCollectionViewCell *infoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InfoCollectionViewCell" forIndexPath:indexPath];
    infoCell.title = self.model.base_info.tags[indexPath.item];
    infoCell.font = CA_H_FONT_PFSC_Regular(12);
    [infoCell configCellWithTitleColor:kColor(@"#FFFFFF")
                       backgroundColor:CA_H_TINTCOLOR
                           borderColor:kColor(@"#FFFFFF")];
    return infoCell;
}

#pragma mark - UICollectionViewDelegate | CA_MEqualSpaceFlowLayoutDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pushBlock) {
        self.pushBlock(self.model.base_info.tags[indexPath.item]);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = [self.model.base_info.tags[indexPath.item] widthForFont:CA_H_FONT_PFSC_Regular(12)] + (4*2*CA_H_RATIO_WIDTH)*2;
    if (cellWidth > (CA_H_SCREEN_WIDTH - 40)) {
        cellWidth = (CA_H_SCREEN_WIDTH - 40);
    }
    return CGSizeMake(cellWidth, 12*2*CA_H_RATIO_WIDTH);
}

#pragma mark - getter and setter
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        CA_MEqualSpaceFlowLayout *layout = [[CA_MEqualSpaceFlowLayout alloc] init];
        layout.minimumLineSpacing = 3*2*CA_H_RATIO_WIDTH;
        layout.minimumInteritemSpacing = 3*2*CA_H_RATIO_WIDTH;
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = CA_H_TINTCOLOR;
        _collectionView.hidden = YES;
        [_collectionView registerClass:[CA_MProjectDetailProjectInfoCollectionViewCell class] forCellWithReuseIdentifier:@"InfoCollectionViewCell"];
    }
    return _collectionView;
}
-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [UILabel new];
        [_detailLb configText:@""
                   textColor:kColor(@"#FFFFFF")
                        font:14];
    }
    return _detailLb;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 0;
        _titleLb.alpha = 0.;
        [_titleLb configText:@""
                   textColor:kColor(@"#FFFFFF")
                        font:22];
    }
    return _titleLb;
}

@end
