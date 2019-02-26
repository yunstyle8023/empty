//
//  CA_MApproveStandardCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MApproveStandardCell.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MApproveStandardCollectionCell.h"

@interface CA_MApproveStandardCell ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate>
{
    CGFloat _collectionviewHeight;
}

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) NSArray *array;
@end

@implementation CA_MApproveStandardCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(10);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
//        make.bottom.mas_equalTo(self.contentView).offset(-0.5);
        make.height.mas_equalTo(_collectionviewHeight);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
}

-(CGFloat)configCellTitle:(NSString *)title values:(NSArray *)values{
    self.titleLb.text = title;
    self.array = values;
    [self.collectionView reloadData];
    
    for (NSString* value in values) {
        CGFloat cellHeight = [value heightForFont:CA_H_FONT_PFSC_Regular(16) width:CA_H_SCREEN_WIDTH-40];
        _collectionviewHeight += cellHeight;
    }
    [self.contentView layoutIfNeeded];
    
    return 46+16+_collectionviewHeight;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MApproveStandardCollectionCell* standardCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    standardCell.title = self.array[indexPath.item];
    return standardCell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - CA_MEqualSpaceFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString* value = self.array[indexPath.item];
    CGFloat cellHeight = [value heightForFont:CA_H_FONT_PFSC_Regular(16) width:CA_H_SCREEN_WIDTH-40];
    return CGSizeMake(CA_H_SCREEN_WIDTH-40, cellHeight);
}

#pragma mark - getter and setter
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [UIView new];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    [_collectionView registerClass:[CA_MApproveStandardCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    return _collectionView;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    _titleLb.numberOfLines = 0;
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}


@end
