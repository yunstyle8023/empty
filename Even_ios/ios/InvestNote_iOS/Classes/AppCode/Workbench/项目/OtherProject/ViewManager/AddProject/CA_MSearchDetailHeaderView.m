//
//  CA_MSearchDetailHeaderView.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MSearchDetailHeaderView.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MProjectDetailProjectInfoCollectionViewCell.h"

@interface CA_MSearchDetailHeaderView()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate
>
{
    CGFloat _tagCollectionViewHeight;
}

@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UILabel* detailLb;
@property(nonatomic,strong)UICollectionView* tagCollectionView;
@end

@implementation CA_MSearchDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = kColor(@"#FFFFFF");
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLb];
    [self addSubview:self.detailLb];
    [self addSubview:self.tagCollectionView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(20);
        //
        make.width.height.mas_equalTo(50);
    }];
    
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
    }];
    
    [self.detailLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(5);
    }];
    
    [self.tagCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLb.mas_bottom).offset(10);
        make.leading.mas_equalTo(self).offset(20);
        make.trailing.mas_equalTo(self).offset(-20);
        make.height.mas_equalTo(_tagCollectionViewHeight);
    }];
}

-(void)setModel:(CA_MSelectModelDetail *)model{
    _model = model;
    
    [self.iconImgView setImageWithURL:[NSURL URLWithString:model.project_logo] placeholder:kImage(@"loadfail_project50")];
    
    self.titleLb.text = model.project_name;
    
    NSMutableString* str = [NSMutableString string];
    if ([NSString isValueableString:model.project_area]) {
        [str appendString:model.project_area];
    }else{
        [str appendString:@"暂无"];
    }
    [str appendString:@" | "];
    if ([NSObject isValueableObject:model.project_category]) {
        [str appendString:[model.project_category firstObject]];
    }else{
        [str appendString:@"暂无"];
    }
    [str appendString:@" | "];
    if ([NSString isValueableString:model.project_invest_stage]) {
        [str appendString:model.project_invest_stage];
    }else{
        [str appendString:@"暂无"];
    }
    self.detailLb.text = str;
    
    CGFloat width = 0;
    
    if (self.model.tag_list.count>=3) {//最多展示3个标签
        for (int i=0;i<3;i++) {
            NSString* tagStr = self.model.tag_list[i];
            CGFloat tagStrW = [tagStr widthForFont:CA_H_FONT_PFSC_Regular(14)];
            width = (8+tagStrW+8)+10;
        }
    }
    
    if (width > (CA_H_SCREEN_WIDTH-40)) {
        _tagCollectionViewHeight = 24 * 2 + 10;
    }else{
        _tagCollectionViewHeight = 24;
    }
    
    if (self.block) {
        self.block(_tagCollectionViewHeight>24?2:1);
    }
    
    [self layoutIfNeeded];
    
    [self.tagCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.model.tag_list.count>=3) {
        return 3;
    }
    return self.model.tag_list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectDetailProjectInfoCollectionViewCell* tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagCell" forIndexPath:indexPath];
    tagCell.title = self.model.tag_list[indexPath.item];
    return tagCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString* title = self.model.tag_list[indexPath.item];
    CGFloat titleH = [title widthForFont:CA_H_FONT_PFSC_Regular(14)];
    return CGSizeMake(8+titleH+8, 24);
}

#pragma mark - getter and setter
-(UICollectionView *)tagCollectionView{
    if (_tagCollectionView) {
        return _tagCollectionView;
    }
    CA_MEqualSpaceFlowLayout* layout = [[CA_MEqualSpaceFlowLayout alloc] init];
    layout.delegate = self;
    _tagCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _tagCollectionView.dataSource = self;
    _tagCollectionView.delegate = self;
    _tagCollectionView.backgroundColor = kColor(@"#FFFFFF");
    [_tagCollectionView registerClass:[CA_MProjectDetailProjectInfoCollectionViewCell class] forCellWithReuseIdentifier:@"tagCell"];
    return _tagCollectionView;
}
-(UILabel *)detailLb{
    if (_detailLb) {
        return _detailLb;
    }
    _detailLb = [[UILabel alloc] init];
    [_detailLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _detailLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImgView.layer.cornerRadius = 4;
    _iconImgView.layer.masksToBounds = YES;
    return _iconImgView;
}

@end
