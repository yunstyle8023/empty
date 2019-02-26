//
//  CA_MProjectPersonCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectPersonCell.h"
#import "CA_MProjectTagLabel.h"
#import "CA_MPersonModel.h"
#import "CA_MProjectPersonCollectionCell.h"

@interface CA_MProjectPersonCell ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIView *deleteBgView;
@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong)UIImageView* selectImgView;
@end

@implementation CA_MProjectPersonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.deleteBgView];
        [self.deleteBgView addSubview:self.deleteBtn];
        
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.nameLb];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.selectImgView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.deleteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset([UIScreen mainScreen].bounds.size.width);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(1);
        make.width.equalTo(self.contentView);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.top.equalTo(self.deleteBgView);
        make.bottom.equalTo(self.deleteBgView);
        make.left.equalTo(self.deleteBgView).offset(-5);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.leading.mas_equalTo(self.contentView).offset(20);
        //
        make.width.height.mas_equalTo(50);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(10);
    }];
   
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLb);
        make.leading.mas_equalTo(self.nameLb.mas_trailing).offset(5);
        make.trailing.mas_equalTo(self.selectImgView).offset(-10);
        make.height.mas_equalTo(20*CA_H_RATIO_WIDTH);
    }];
    
}


-(void)setModel:(CA_MPersonModel *)model{
    _model = model;

    NSString* urlStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.avatar];
    [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"head65")];

    self.nameLb.text = model.chinese_name;
    
    self.selectImgView.hidden = model.isSelected;
    //
    [self.collectionView reloadData];
}

-(void)setProjectModel:(CA_MProjectModel *)projectModel{
    _projectModel = projectModel;
    
    NSString *urlStr = projectModel.project_logo;
    urlStr = ^{
        if ([urlStr hasPrefix:@"http://"]
            ||
            [urlStr hasPrefix:@"https://"]) {
            return urlStr;
        }
        return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
    }();
    
    [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"head50")];

    self.nameLb.text = projectModel.project_name;
    
    self.selectImgView.hidden = projectModel.isSelected;
    //
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([NSObject isValueableObject:self.model.tag_data]) {
        CGFloat total = 0;
        for (int i=0;i< self.model.tag_data.count;i++) {
            CA_MPersonTagModel* tag = self.model.tag_data[i];
            CGFloat font = 12*CA_H_RATIO_WIDTH;
            CGFloat width = [tag.tag_name widthForFont:[UIFont systemFontOfSize:font]] + 10;
            total += width;
            if (total>=190*CA_H_RATIO_WIDTH) {
                return i;
            }
        }
    }
    return self.model.tag_data.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectPersonCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CA_MPersonTagModel* tag = self.model.tag_data[indexPath.item];
    cell.model = tag;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MPersonTagModel* tag = self.model.tag_data[indexPath.item];
    
//    NSLog(@"tag.tag_name == %@",tag.tag_name);
    CGFloat font = 12*CA_H_RATIO_WIDTH;
    CGFloat width = [tag.tag_name widthForFont:[UIFont systemFontOfSize:font]];
    CGFloat height = [tag.tag_name heightForFont:CA_H_FONT_PFSC_Regular(12) width:CA_H_SCREEN_WIDTH];
    return CGSizeMake(width + 10, 20);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        self.block();
    }
}

#pragma mark - getter and setter

-(UIButton *)deleteBtn{
    if (_deleteBtn) {
        return _deleteBtn;
    }
    _deleteBtn = [UIButton new];
    [_deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
    return _deleteBtn;
}

-(UIView *)deleteBgView{
    if (_deleteBgView) {
        return _deleteBgView;
    }
    _deleteBgView  = [UIView new];
    _deleteBgView.backgroundColor = CA_H_F8COLOR;
    return _deleteBgView;
}

-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[CA_MProjectPersonCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    CA_H_WeakSelf(self);
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        CA_H_StrongSelf(self);
        if (self.block) {
            self.block();
        }
    }];
    [_collectionView addGestureRecognizer:tapGesture];
    return _collectionView;
}
-(UIImageView *)selectImgView{
    if (_selectImgView) {
        return _selectImgView;
    }
    _selectImgView = [[UIImageView alloc] init];
    _selectImgView.image = kImage(@"choose");
    _selectImgView.hidden = YES;
    return _selectImgView;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UILabel *)nameLb{
    if (_nameLb) {
        return _nameLb;
    }
    _nameLb = [[UILabel alloc] init];
    [_nameLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _nameLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 50/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    return _iconImgView;
}


@end
