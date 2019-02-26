//
//  CA_MPersonDetailBaseCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailBaseCell.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MProjectDetailProjectInfoCollectionViewCell.h"

@interface CA_MPersonDetailBaseCell ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate>{
    CGFloat _collectionHeight;
}

@property (nonatomic,strong) UILabel *infoLb;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) CA_MPersonDetailModel *model;
@end

@implementation CA_MPersonDetailBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.infoLb];
    [self.contentView addSubview:self.collectionView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.infoLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoLb.mas_bottom).offset(20);
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(_collectionHeight);
    }];
    
}

-(CGFloat)configCell:(CA_MPersonDetailModel*)model{
    self.model = model;
    
    self.infoLb.text = model.human_detail.intro;
    
    [self.collectionView reloadData];
    
    CGFloat infoH = [self.infoLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:CA_H_SCREEN_WIDTH-40];
    
    CGFloat totalWidth = 0;
    CGFloat rows = 0;
    for (CA_MPersonTagModel* model in self.model.human_detail.tag_data) {
        CGFloat cellWidth = (10+[model.tag_name widthForFont:CA_H_FONT_PFSC_Regular(14)]+10);
        totalWidth = totalWidth + cellWidth;
        if (totalWidth >= (CA_H_SCREEN_WIDTH-40)) {
            rows += 1;
            totalWidth = cellWidth;
        }
    }
    if (rows > 0) {
        rows = rows+1;
    }else{
        if (totalWidth>0) {
            rows = 1;
        }else{
            rows = 0;
        }
    }
    
    _collectionHeight = rows*30 + (rows-1)*10;
    if (_collectionHeight<0) {
        _collectionHeight = 0;
    }
    CGFloat height = 0;
    if (_collectionHeight == 0) {
        height = infoH + 20;
    }else{
        height = infoH + 20 + _collectionHeight + 20;
    }
    [self.contentView layoutIfNeeded];
    return height;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.human_detail.tag_data.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectDetailProjectInfoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CA_MPersonTagModel* model = self.model.human_detail.tag_data[indexPath.item];
    cell.title = model.tag_name;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MPersonTagModel* model = self.model.human_detail.tag_data[indexPath.item];
    CGFloat nameWidth = [model.tag_name widthForFont:CA_H_FONT_PFSC_Regular(14)];
    return CGSizeMake(10+nameWidth+10, 30);
}

#pragma mark - getter and setter
-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    CA_MEqualSpaceFlowLayout* layout = [[CA_MEqualSpaceFlowLayout alloc] init];
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    [_collectionView registerClass:[CA_MProjectDetailProjectInfoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    return _collectionView;
}

-(UILabel *)infoLb{
    if (_infoLb) {
        return _infoLb;
    }
    _infoLb = [UILabel new];
    _infoLb.numberOfLines = 0;
    [_infoLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _infoLb;
}

@end
