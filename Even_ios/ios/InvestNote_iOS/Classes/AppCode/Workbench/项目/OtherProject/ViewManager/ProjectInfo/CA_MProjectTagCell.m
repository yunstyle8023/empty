//
//  CA_MProjectTagCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTagCell.h"
#import "CA_MProjectTagCollectionViewCell.h"
#import "CA_MProjectAddTagCollectionViewCell.h"
#import "CA_MEqualSpaceFlowLayout.h"


static NSString* const tagKey = @"CA_MProjectTagCollectionViewCell";
static NSString* const addTagKey = @"CA_MProjectAddTagCollectionViewCell";


@interface CA_MProjectTagCell()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate>

@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UIView* lineView;
@property(nonatomic,strong)NSMutableArray* datas;
@end

@implementation CA_MProjectTagCell

- (void)upView{
    [super upView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView).offset(20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(20);
        make.bottom.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (CGFloat)configCell:(NSString*)title tags:(NSArray*)datas{
    
    self.titleLb.text = title;
    self.datas = datas.mutableCopy;
    [self.collectionView reloadData];
    
    CGFloat kWidth = CA_H_SCREEN_WIDTH - 40;//允许的最大宽度
    CGFloat total = 96*CA_H_RATIO_WIDTH+10;
    CGFloat rows = 1;
    for (int i=0;i<self.datas.count;i++) {
        NSString* str = self.datas[i];
        CGFloat strWidth = [str widthForFont:CA_H_FONT_PFSC_Regular(14)];
        UIImage* img = kImage(@"xTag");
        CGFloat cellWidth = 10+strWidth+6+img.size.width+10+10;
        if (cellWidth >= kWidth) {
            cellWidth = kWidth;
        }
        
        NSLog(@"str ======= %@ ,cellWidth ========= %f",str,cellWidth);
        
        total = total + cellWidth;
        if (total >= kWidth-30) {
            rows += 1;
            total = 96*CA_H_RATIO_WIDTH+10;
        }
    }
    
    NSLog(@"ceilf(rows) == %f",rows);
    
    CGFloat otherHeight = 20+25*CA_H_RATIO_WIDTH+20+20+1;
    
    CGFloat collectionHeight = rows*30*CA_H_RATIO_WIDTH + (rows-1)*10;
    
    return collectionHeight+otherHeight;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.datas.count) {
        CA_MProjectAddTagCollectionViewCell* addTagCell = [collectionView dequeueReusableCellWithReuseIdentifier:addTagKey forIndexPath:indexPath];
        return addTagCell;
    }
    CA_MProjectTagCollectionViewCell* tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:tagKey forIndexPath:indexPath];
    tagCell.title = self.datas[indexPath.item];
    return tagCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.datas.count) {
        return CGSizeMake(96*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH);
    }
    NSString* title = self.datas[indexPath.item];
    CGFloat strWidth = [title widthForFont:CA_H_FONT_PFSC_Regular(14)];
    UIImage* img = kImage(@"xTag");
    CGFloat cellWidth = 10+strWidth+6+img.size.width+10+10;
    if (cellWidth>=CA_H_SCREEN_WIDTH - 20*2) {
        cellWidth = CA_H_SCREEN_WIDTH - 20*2;
    }
    return CGSizeMake(cellWidth, 30*CA_H_RATIO_WIDTH);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.datas.count) {
        if ([self.delegate respondsToSelector:@selector(addTag)]) {
            [self.delegate addTag];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(delTag:)]) {
            [self.delegate delTag:indexPath.item];
        }
    }
}

#pragma mark - getter and setter

-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    CA_MEqualSpaceFlowLayout* layout = [[CA_MEqualSpaceFlowLayout alloc] init];
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[CA_MProjectTagCollectionViewCell class] forCellWithReuseIdentifier:tagKey];
    [_collectionView registerClass:[CA_MProjectAddTagCollectionViewCell class] forCellWithReuseIdentifier:addTagKey];
    return _collectionView;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
@end

