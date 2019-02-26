
//
//  CA_MDiscoverSponsorDetailItemCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailItemCell.h"
#import "CA_MDiscoverSponsorDetailItemViewCell.h"
#import "CA_MDiscoverSponsorDetailModel.h"

@interface CA_MDiscoverSponsorDetailItemCell ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) CGFloat collectionViewHeight;
@property (nonatomic,strong) NSArray *datas;
@end

@implementation CA_MDiscoverSponsorDetailItemCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.collectionView];
    self.collectionView.sd_resetLayout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(CA_H_SCREEN_WIDTH - (10*2*CA_H_RATIO_WIDTH)*2)
    .heightIs(self.collectionViewHeight);
//    .spaceToSuperView(UIEdgeInsetsMake(10*2*CA_H_RATIO_WIDTH,
//                                       10*2*CA_H_RATIO_WIDTH,
//                                       10*2*CA_H_RATIO_WIDTH,
//                                       10*2*CA_H_RATIO_WIDTH));
}

-(CGFloat)configCell:(NSArray *)datas{

    self.datas = datas;
    
    //寻找最大高度
    NSMutableArray *heights = @[].mutableCopy;
    for (CA_MDiscoverSponsorLp_moudle *model in self.datas) {
        CGFloat height = [model.module_name heightForFont:CA_H_FONT_PFSC_Regular(14) width:38*2*CA_H_RATIO_WIDTH];
        [heights addObject:[NSNumber numberWithFloat:height]];
    }
    CGFloat maxValue = [[heights valueForKeyPath:@"@max.floatValue"] floatValue];
    
    self.collectionViewHeight = 38*2*CA_H_RATIO_WIDTH +  5*2*CA_H_RATIO_WIDTH + maxValue;
    
    self.collectionView.sd_resetLayout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(CA_H_SCREEN_WIDTH - (10*2*CA_H_RATIO_WIDTH)*2)
    .heightIs(self.collectionViewHeight+5);
    
    [self.collectionView reloadData];
    
    return self.collectionViewHeight + (10*2*CA_H_RATIO_WIDTH)*2;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverSponsorDetailItemViewCell *itemViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemViewCell" forIndexPath:indexPath];
    itemViewCell.model = self.datas[indexPath.item];
    return itemViewCell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverSponsorLp_moudle *model = self.datas[indexPath.item];
    if( model.total_count.intValue == 0){
        return;
    }
    if (self.pushBlock) {
        self.pushBlock(self.datas[indexPath.item]);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(38*2*CA_H_RATIO_WIDTH, self.collectionViewHeight);
}

#pragma mark - getter and setter

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 5*2*CA_H_RATIO_WIDTH;
        layout.minimumInteritemSpacing = 0.;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CA_MDiscoverSponsorDetailItemViewCell class] forCellWithReuseIdentifier:@"ItemViewCell"];
    }
    return _collectionView;
}

@end
