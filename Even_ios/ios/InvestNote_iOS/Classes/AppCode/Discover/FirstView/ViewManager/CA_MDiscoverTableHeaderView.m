
//
//  CA_MDiscoverTableHeaderView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverTableHeaderView.h"
#import "CA_MDiscoverCollectionCell.h"
#import "CA_MDiscoverModel.h"

static  NSString * const discoverKey = @"CA_MDiscoverCollectionCell";

@interface CA_MDiscoverTableHeaderView ()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *lineView;
@end

@implementation CA_MDiscoverTableHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.collectionView];
    [self addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.lineView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(CA_H_LINE_Thickness);
    
    self.collectionView.sd_layout
    .topSpaceToView(self, 0*2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self, 23*2*CA_H_RATIO_WIDTH)
    .widthIs(CA_H_SCREEN_WIDTH - (23*2*CA_H_RATIO_WIDTH)*2)
    .bottomSpaceToView(self, 10*2*CA_H_RATIO_WIDTH);
}

-(void)setDataList:(NSArray<CA_MModuleModel *> *)dataList{
    _dataList = dataList;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.lineView.hidden = self.dataList.count == 0;
    return self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverCollectionCell *discoverCell = [collectionView dequeueReusableCellWithReuseIdentifier:discoverKey forIndexPath:indexPath];
    discoverCell.model = self.dataList[indexPath.item];
    return discoverCell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pushBlock) {
        self.pushBlock(indexPath, self.dataList[indexPath.item]);
    }
}

#pragma mark - getter and setter
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(28*2*CA_H_RATIO_WIDTH, 41*2*CA_H_RATIO_WIDTH);
        layout.minimumInteritemSpacing = 34*CA_H_RATIO_WIDTH;
        layout.minimumLineSpacing = 10*2*CA_H_RATIO_WIDTH;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kColor(@"#FFFFFF");
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[CA_MDiscoverCollectionCell class] forCellWithReuseIdentifier:discoverKey];
    }
    return _collectionView;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_BACKCOLOR;
    }
    return _lineView;
}
@end
