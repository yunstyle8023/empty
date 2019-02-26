

//
//  CA_MDiscoverInvestmentFoundsCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentFoundsCell.h"
#import "CA_MDiscoverInvestmentFoundsViewCell.h"
#import "CA_MDiscoverInvestmentManageFoundsModel.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverInvestmentFoundsCell ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong) UILabel *investor;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) CA_MDiscoverInvestmentInvestment_FundModel *investModel;
@end

@implementation CA_MDiscoverInvestmentFoundsCell

-(void)setupView{
    [super setupView];
    [self.contentView addSubview:self.investor];
    [self.contentView addSubview:self.collectionView];
}

-(void)setConstrains{
    [super setConstrains];
    
    self.investor.sd_layout
    .leftEqualToView(self.time)
    .topSpaceToView(self.time, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.investor setSingleLineAutoResizeWithMaxWidth:0];
    
    self.collectionView.sd_layout
    .leftEqualToView(self.timeLb)
    .topSpaceToView(self.time, 8*2*CA_H_RATIO_WIDTH)
    .widthIs(103*2*CA_H_RATIO_WIDTH)
    .heightIs(0);

}

-(void)setModel:(CA_MDiscoverInvestmentInvestment_FundModel *)model{
//    [super setModel:model];
    
    self.investModel = model;
    
    self.titleLb.text = model.enterprise_name;
    
    self.legal.text = @"法定代表人";
    self.legalLb.text = [NSString isValueableString:model.oper_name]?model.oper_name:@"暂无";
    
    self.money.text = @"注册资本";
    self.moneyLb.text = [NSString isValueableString:model.regist_capi]?model.regist_capi:@"暂无";
    
    self.time.text = @"成立日期";
    self.timeLb.text = [NSString isValueableString:model.found_date]?model.found_date:@"暂无";
    
    self.investor.text = @"投资方";
    
    if ([NSObject isValueableObject:model.investor_list]) {
        CGFloat collectionViewHeight = 0.;
        for (CA_MDiscoverInvestmentInvestor_ListModel *investor in model.investor_list) {
            NSString *title = [NSString stringWithFormat:@"%@(%@)",investor.enterprise_name,investor.ratio];
            CGFloat titleH = [title heightForFont:CA_H_FONT_PFSC_Regular(16) width:103*2*CA_H_RATIO_WIDTH];
            collectionViewHeight += (titleH + 3*2*CA_H_RATIO_WIDTH);
        }
        collectionViewHeight -= 3*2*CA_H_RATIO_WIDTH;
        self.collectionView.sd_resetLayout
        .leftEqualToView(self.timeLb)
        .topSpaceToView(self.time, 8*2*CA_H_RATIO_WIDTH)
        .widthIs(103*2*CA_H_RATIO_WIDTH)
        .heightIs(collectionViewHeight);
        [self setupAutoHeightWithBottomView:self.collectionView bottomMargin:8*2*CA_H_RATIO_WIDTH];
    }else{
        self.collectionView.sd_resetLayout
        .leftEqualToView(self.timeLb)
        .topSpaceToView(self.time, 8*2*CA_H_RATIO_WIDTH)
        .widthIs(0.)
        .heightIs(0.);
        [self setupAutoHeightWithBottomView:self.investor bottomMargin:8*2*CA_H_RATIO_WIDTH];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.investModel.investor_list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverInvestmentFoundsViewCell *foundsViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InvestmentFoundsViewCell" forIndexPath:indexPath];
    
    if (indexPath.item <= self.investModel.investor_list.count-1) {
        CA_MDiscoverInvestmentInvestor_ListModel *model = (CA_MDiscoverInvestmentInvestor_ListModel*)self.investModel.investor_list[indexPath.item];
        NSMutableString *mutStr = [[NSMutableString alloc] initWithString:model.enterprise_name];
        if ([NSString isValueableString:model.ratio]) {
            [mutStr appendString:[NSString stringWithFormat:@"(%@)",model.ratio]];
        }
        foundsViewCell.title = mutStr.copy;
    }
    return foundsViewCell;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDelegateFlowLayout

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectItem) {
        self.didSelectItem(indexPath.item);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item <= self.investModel.investor_list.count-1) {
        CA_MDiscoverInvestmentInvestor_ListModel *model = (CA_MDiscoverInvestmentInvestor_ListModel*)self.investModel.investor_list[indexPath.item];
        NSString *title = [NSString stringWithFormat:@"%@(%@)",model.enterprise_name,model.ratio];
        
        CGFloat height = [title heightForFont:CA_H_FONT_PFSC_Regular(16) width:103*2*CA_H_RATIO_WIDTH];
        return CGSizeMake(103*2*CA_H_RATIO_WIDTH, height);
    }
    return CGSizeZero;
}

#pragma mark - getter and setter
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 3*2*CA_H_RATIO_WIDTH;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = kColor(@"#FFFFFF");
        [_collectionView registerClass:[CA_MDiscoverInvestmentFoundsViewCell class] forCellWithReuseIdentifier:@"InvestmentFoundsViewCell"];
    }
    return _collectionView;
}
-(UILabel *)investor{
    if (!_investor) {
        _investor = [UILabel new];
        [_investor configText:@""
                    textColor:CA_H_6GRAYCOLOR
                         font:16];
    }
    return _investor;
}
@end
