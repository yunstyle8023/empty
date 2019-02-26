
//
//  CA_MDiscoverProjectDetailFinancInfoCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailFinancInfoCell.h"
#import "CA_MDiscoverProjectDetailModel.h"
#import "CA_MDiscoverProjectDetailFinancInfoViewCell.h"
#import "CA_MEqualSpaceFlowLayout.h"

@interface CA_MDiscoverProjectDetailFinancInfoCell ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate
>

@property (nonatomic,strong) UIView *circleView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) CGFloat collectionViewHeight;
@end

@implementation CA_MDiscoverProjectDetailFinancInfoCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.collectionView];
    [self setConstraints];
}

-(void)setConstraints{
    
    self.titleLb.sd_resetLayout
    .leftSpaceToView(self.contentView, 21*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView)
    .autoHeightRatio(0);
    [self.titleLb setSingleLineAutoResizeWithMaxWidth:120*2*CA_H_RATIO_WIDTH];
    
    self.circleView.sd_resetLayout
    .centerYEqualToView(self.titleLb)
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(6*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    self.lineView.sd_resetLayout
    .topEqualToView(self.circleView)
    .centerXEqualToView(self.circleView)
    .bottomEqualToView(self.contentView)
    .widthIs(CA_H_LINE_Thickness);
    
    self.timeLb.sd_resetLayout
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .autoHeightRatio(0);
    [self.timeLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.collectionView.sd_resetLayout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(self.collectionViewHeight);
    
}

-(void)setModel:(CA_MDiscoverInvestHistory_list *)model{
    [super setModel:model];
    
    self.titleLb.text = [NSString stringWithFormat:@"%@-%@",model.invest_stage,model.invest_money];

    NSDate *invest_date = [NSDate dateWithTimeIntervalSince1970:model.invest_date.longValue];
    self.timeLb.text = [invest_date stringWithFormat:@"yyyy.MM.dd"];
    
    if ([NSObject isValueableObject:((CA_MDiscoverInvestHistory_list*)self.model).gp_list]) {
        CGFloat maxWidth = CA_H_SCREEN_WIDTH - 30*2*CA_H_RATIO_WIDTH;
        CGFloat totalWidth = 0.;
        NSInteger rows = 1;
        
        for (int i=0; i<((CA_MDiscoverInvestHistory_list*)self.model).gp_list.count; i++ ) {
            CA_MDiscoverGp_list *model = ((CA_MDiscoverInvestHistory_list*)self.model).gp_list[i];
            CGFloat cellWidth = [model.gp_name widthForFont:CA_H_FONT_PFSC_Regular(14)];
            
            if (cellWidth > maxWidth) {
                cellWidth = maxWidth;
            }
            
            if (totalWidth + cellWidth > maxWidth) {
                rows++;
                totalWidth = cellWidth;
            }else{
                totalWidth += (cellWidth+5*2*CA_H_RATIO_WIDTH);
            }
            
        }
        self.collectionViewHeight =  rows * 10*2*CA_H_RATIO_WIDTH + rows*3*2*CA_H_RATIO_WIDTH;
    }
    
    self.collectionView.sd_resetLayout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(self.collectionViewHeight);
    
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self.collectionView reloadData];
    });
    
    if (self.collectionViewHeight > 0) {
        [self setupAutoHeightWithBottomView:self.collectionView bottomMargin:10*2*CA_H_RATIO_WIDTH];
    }else {
        [self setupAutoHeightWithBottomView:self.titleLb bottomMargin:10*2*CA_H_RATIO_WIDTH];
    }
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((CA_MDiscoverInvestHistory_list*)self.model).gp_list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverProjectDetailFinancInfoViewCell *financInfoViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FinancInfoViewCell" forIndexPath:indexPath];
    financInfoViewCell.model = ((CA_MDiscoverInvestHistory_list*)self.model).gp_list[indexPath.item];
    return financInfoViewCell;
}

#pragma mark - UICollectionViewDelegate | CA_MEqualSpaceFlowLayoutDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CA_MDiscoverGp_list *model = ((CA_MDiscoverInvestHistory_list*)self.model).gp_list[indexPath.item];
    
    if (![NSString isValueableString:model.data_id]) {
        return;
    }
    
    if (self.pushBlock) {
        self.pushBlock(indexPath, ((CA_MDiscoverInvestHistory_list*)self.model).gp_list[indexPath.item]);
    } 
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MDiscoverGp_list *model = ((CA_MDiscoverInvestHistory_list*)self.model).gp_list[indexPath.item];
    CGFloat cellWidth = [model.gp_name widthForFont:CA_H_FONT_PFSC_Regular(14)];
    CGFloat maxWidth = CA_H_SCREEN_WIDTH - 30*2*CA_H_RATIO_WIDTH;
    if (cellWidth > maxWidth) {
        cellWidth = maxWidth;
    }
    return CGSizeMake(cellWidth, 10*2*CA_H_RATIO_WIDTH);
}


#pragma mark - getter and setter
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        CA_MEqualSpaceFlowLayout *layout = [CA_MEqualSpaceFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 5*2*CA_H_RATIO_WIDTH;
        layout.minimumInteritemSpacing = 5*2*CA_H_RATIO_WIDTH;
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kColor(@"#FFFFFF");
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[CA_MDiscoverProjectDetailFinancInfoViewCell class] forCellWithReuseIdentifier:@"FinancInfoViewCell"];
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
-(UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb configText:@""
                  textColor:CA_H_9GRAYCOLOR
                       font:14];
    }
    return _timeLb;
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
-(UIView *)circleView{
    if (!_circleView) {
        _circleView = [UIView new];
        _circleView.backgroundColor = CA_H_TINTCOLOR;
        _circleView.layer.cornerRadius = 6*CA_H_RATIO_WIDTH;
        _circleView.layer.masksToBounds = YES;
    }
    return _circleView;
}

@end
