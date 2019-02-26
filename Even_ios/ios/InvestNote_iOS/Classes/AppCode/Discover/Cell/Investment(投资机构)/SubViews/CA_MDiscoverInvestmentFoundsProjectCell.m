
//
//  CA_MDiscoverInvestmentFoundsProjectCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentFoundsProjectCell.h"
#import "CA_MDiscoverInvestmentManageFoundsModel.h"
#import "CA_MProjectDetailProjectInfoCollectionViewCell.h"

@interface CA_MDiscoverInvestmentFoundsProjectCell ()
@property (nonatomic,strong) UILabel *introLb;
@property (nonatomic,strong) CA_MDiscoverInvestmentPublic_Investment_EventdModel *eventModel;
@end

@implementation CA_MDiscoverInvestmentFoundsProjectCell

-(void)setupView{
    [super setupView];
    [self.contentView addSubview:self.introLb];
}

-(void)setConstraints{
    [super setConstraints];
    
    self.introLb.sd_layout
    .leftEqualToView(self.titleLb)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.collectionView, 5*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.introLb setMaxNumberOfLinesToShow:2];
}

-(void)setModel:(CA_MDiscoverInvestmentPublic_Investment_EventdModel *)model{
    
    self.eventModel = model;
    
    [self.sloganImgView setImageWithURL:[NSURL URLWithString:model.project_logo] placeholder:kImage(@"loadfail_project50")];
    self.titleLb.text = model.project_name;
    self.detailLb.text = [NSString stringWithFormat:@"%@ %@ %@",[NSString isValueableString:model.project_round]?model.project_round:@"暂无",
     [NSString isValueableString:model.found_date]?model.found_date:@"暂无",
     [NSString isValueableString:model.invest_money]?model.invest_money:@"暂无"];
    self.introLb.text = [NSString isValueableString:model.project_intro]?model.project_intro:@"暂无";
    
    [self.collectionView reloadData];
    
    [self setupAutoHeightWithBottomView:self.introLb bottomMargin:5*2*CA_H_RATIO_WIDTH];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([NSObject isValueableObject:self.eventModel.tag_list]) {
        CGFloat totalWidth = 0.;
        CGFloat maxWidth = CA_H_SCREEN_WIDTH-(38+10)*2*CA_H_RATIO_WIDTH;
        int rows = 0;
        for (int i=0; i<self.eventModel.tag_list.count; i++) {
            NSString *title = self.eventModel.tag_list[i];
            CGFloat cellWidth = [title widthForFont:CA_H_FONT_PFSC_Regular(12)] + 4*2*CA_H_RATIO_WIDTH*2 + 3*2*CA_H_RATIO_WIDTH;
            if (totalWidth >= maxWidth) {
                rows = i;
                break;
            }
            totalWidth += cellWidth;
        }
        return rows==0?self.eventModel.tag_list.count:rows;
    }
    
    return 0;
}
#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectDetailProjectInfoCollectionViewCell* infoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"infoCell" forIndexPath:indexPath];
    infoCell.font = CA_H_FONT_PFSC_Regular(12);
    infoCell.title = self.eventModel.tag_list[indexPath.item];
    return infoCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.pushBlock) {
        self.pushBlock(indexPath, self.eventModel.tag_list[indexPath.item]);
    }
}
#pragma mark - CA_MEqualSpaceFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.eventModel.tag_list[indexPath.item];
    CGFloat cellWidth = [title widthForFont:CA_H_FONT_PFSC_Regular(12)] + 4*2*CA_H_RATIO_WIDTH*2;
    //    if (cellWidth >= (CA_H_SCREEN_WIDTH-38-10)*2*CA_H_RATIO_WIDTH) {
    //        cellWidth = (CA_H_SCREEN_WIDTH-38-10)*2*CA_H_RATIO_WIDTH;
    //    }
    return CGSizeMake(cellWidth, 12*2*CA_H_RATIO_WIDTH);
}


-(UILabel *)introLb{
    if (!_introLb) {
        _introLb = [UILabel new];
        _introLb.numberOfLines = 2;
        [_introLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _introLb;
}

@end
