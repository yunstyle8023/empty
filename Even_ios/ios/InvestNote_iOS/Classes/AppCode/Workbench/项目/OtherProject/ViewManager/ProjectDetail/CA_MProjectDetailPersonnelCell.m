//
//  CA_MProjectDetailPersonnelCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MProjectDetailPersonnelCell.h"
#import "CA_MProjectDetailAddPersonnelCollectionViewCell.h"
#import "CA_MProjectDetailNormalPersonnelCollectionViewCell.h"
#import "CA_MProjectDetailModel.h"

static NSString* const addKey = @"CA_MProjectDetailAddPersonnelCollectionViewCell";
static NSString* const normalKey = @"CA_MProjectDetailNormalPersonnelCollectionViewCell";

@interface CA_MProjectDetailPersonnelCell()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView* collectionView;
@end

@implementation CA_MProjectDetailPersonnelCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.collectionView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
}

-(void)setPersons:(NSArray *)persons{
    _persons = persons;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.persons.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CA_MProjectDetailAddPersonnelCollectionViewCell* addCell = [collectionView dequeueReusableCellWithReuseIdentifier:addKey forIndexPath:indexPath];
        CA_H_WeakSelf(self);
        addCell.block = ^{
            CA_H_StrongSelf(self);
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(didSelect:person:)]) {
//                CA_MProject_person* model = self.persons[indexPath.item-1];
                [self.delegate didSelect:YES person:nil];
            }
        };
        return addCell;
    }
    CA_MProjectDetailNormalPersonnelCollectionViewCell* normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:normalKey forIndexPath:indexPath];
    if ([NSObject isValueableObject:self.persons]) {
        normalCell.model = self.persons[indexPath.item-1];
    }
    return normalCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BOOL result = indexPath.row == 0 ? YES : NO;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didSelect:person:)]) {
        [self.delegate didSelect:result person:result?nil:self.persons[indexPath.item-1]];
    }
}


-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(110* CA_H_RATIO_WIDTH, 166 * CA_H_RATIO_WIDTH);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10 * CA_H_RATIO_WIDTH;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(20, 166 * CA_H_RATIO_WIDTH);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[CA_MProjectDetailAddPersonnelCollectionViewCell class] forCellWithReuseIdentifier:addKey];
    [_collectionView registerClass:[CA_MProjectDetailNormalPersonnelCollectionViewCell class] forCellWithReuseIdentifier:normalKey];
    return _collectionView;
}

@end

