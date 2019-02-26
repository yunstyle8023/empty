//
//  CA_MSettingProjectView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingProjectView.h"
#import "CA_MSettingProjectCollectionViewCell.h"
#import "CA_MSettingType.h"

@interface CA_MSettingProjectView ()
<UICollectionViewDataSource,
UICollectionViewDelegate
>

@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* iconLb;
@property(nonatomic,strong)UILabel* nameLb;
@property(nonatomic,strong)UILabel* positionLb;
@property(nonatomic,strong)UIView* bgView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong)UILabel* messageLb;
@property(nonatomic,strong)UILabel* defaultLb;
@property(nonatomic,strong)UIButton* confirmBtn;

@end

@implementation CA_MSettingProjectView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.iconLb];
        [self addSubview:self.nameLb];
        [self addSubview:self.positionLb];
        [self addSubview:self.bgView];
        [self addSubview:self.collectionView];
        [self addSubview:self.messageLb];
        [self addSubview:self.defaultLb];
        [self addSubview:self.confirmBtn];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(70*CA_H_RATIO_WIDTH);
        //
        make.width.height.mas_equalTo(75);
    }];
    [self.iconLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.iconImgView);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
    }];
    [self.positionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLb.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.positionLb.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(335*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(330*CA_H_RATIO_WIDTH);
    }];
//    [self.bgView addShadowColor:CA_H_SHADOWCOLOR
//                    withOpacity:0.8
//                   shadowRadius:10
//                andCornerRadius:10];
    
    [CA_HShadow dropShadowWithView:self.bgView
                            offset:CGSizeMake(0, 0)
                            radius:10
                             color:CA_H_SHADOWCOLOR
                           opacity:0.8];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView).offset(-148);
        make.leading.trailing.mas_equalTo(self.bgView);
        make.height.mas_equalTo(75);
    }];
    
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(25);
        make.leading.mas_equalTo(self.bgView).offset(20);
        make.trailing.mas_equalTo(self.bgView).offset(-20);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView).offset(-25);
        make.centerX.mas_equalTo(self.bgView);
        make.width.mas_equalTo(110*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(48*CA_H_RATIO_WIDTH);
    }];
    [self.defaultLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).offset(-25);
        make.centerX.mas_equalTo(self.bgView);
    }];
}

-(void)setModel:(CA_MSettingModel *)model{
    _model = model;
    
    if ([NSString isValueableString:model.avatar.avatar]) {
        NSString* urlStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.avatar.avatar];
        [self.iconImgView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:kImage(@"head75")];
        self.iconImgView.backgroundColor = kColor(@"#FFFFFF");
        //
        self.iconLb.hidden = YES;
        self.iconLb.text = @"";
    }else{
        self.iconImgView.image = nil;
        self.iconImgView.backgroundColor = kColor(model.avatar.avatar_color);
        //
        self.iconLb.hidden = NO;
        self.iconLb.text = [model.avatar.chinese_name substringToIndex:1];
    }

    self.nameLb.text = model.avatar.chinese_name;

    self.positionLb.text = model.avatar.role;

    self.defaultLb.text = [NSString stringWithFormat:@"当前选择默认：%@",[model.mod_list firstObject].mod_name];

    [self.collectionView reloadData];
    
    if([[CA_H_MANAGER defaultItemKey] isEqualToString:SettingType_NoAuthority]){
        self.confirmBtn.enabled = NO;
        self.confirmBtn.backgroundColor = CA_H_BACKCOLOR;
    }else{
        self.confirmBtn.enabled = YES;
        self.confirmBtn.backgroundColor = CA_H_TINTCOLOR;
    }
    
}


-(void)confirmBtnAction{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(changeWorkSpace)]) {
        [self.delegate changeWorkSpace];
    }
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.mod_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MSettingProjectCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.model.mod_list[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    CA_MSettingListModel *model = self.model.mod_list[indexPath.row];
    model.selected = YES;
    //
    self.defaultLb.text = [NSString stringWithFormat:@"当前选择默认：%@",model.mod_name];
    //保存默认设置
    [CA_H_MANAGER saveDefaultItemKey:model.mod_type];
    [CA_H_MANAGER saveDefaultItem:model.mod_name];
    
    for (CA_MSettingListModel *m in self.model.mod_list) {
        if (m != model) {
            m.selected = NO;
        }
    }
    [collectionView reloadData];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    NSInteger numberOfItems = [collectionView numberOfItemsInSection:0];
    CGFloat combinedItemWidth = (numberOfItems * collectionViewLayout.itemSize.width) + ((numberOfItems - 1)*collectionViewLayout.minimumInteritemSpacing);
    CGFloat padding = (collectionView.frame.size.width - combinedItemWidth)/2;
    padding = padding>0 ? padding :0 ;
    return UIEdgeInsetsMake(0, padding,0, padding);
}

#pragma mark - getter and setter
-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 32;
    layout.itemSize = CGSizeMake(45, 75);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    [_collectionView registerClass:[CA_MSettingProjectCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    return _collectionView;
}
-(UIButton *)confirmBtn{
    if (_confirmBtn) {
        return _confirmBtn;
    }
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn configTitle:@"确定" titleColor:kColor(@"#FFFFFF") font:18];
    _confirmBtn.backgroundColor = CA_H_TINTCOLOR;
    _confirmBtn.layer.cornerRadius = 4;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _confirmBtn;
}
-(UILabel *)defaultLb{
    if (_defaultLb) {
        return _defaultLb;
    }
    _defaultLb = [[UILabel alloc] init];
    [_defaultLb configText:@"" textColor:CA_H_TINTCOLOR font:14];
    return _defaultLb;
}
-(UILabel *)iconLb{
    if (_iconLb) {
        return _iconLb;
    }
    _iconLb = [[UILabel alloc] init];
    [_iconLb configText:@"" textColor:kColor(@"#FFFFFF") font:20];
    return _iconLb;
}
-(UILabel *)messageLb{
    if (_messageLb) {
        return _messageLb;
    }
    _messageLb = [[UILabel alloc] init];
    NSString* title = @"根据角色权限，您可访问如下模块，请选择下次进入页面时的默认展示信息";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:CA_H_FONT_PFSC_Regular(15),NSForegroundColorAttributeName:CA_H_4BLACKCOLOR, NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:title attributes:dic];
    _messageLb.attributedText = attributeStr;
    _messageLb.numberOfLines = 0;
    return _messageLb;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
    return _bgView;
}
-(UILabel *)positionLb{
    if (_positionLb) {
        return _positionLb;
    }
    _positionLb = [[UILabel alloc] init];
    [_positionLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _positionLb;
}
-(UILabel *)nameLb{
    if (_nameLb) {
        return _nameLb;
    }
    _nameLb = [[UILabel alloc] init];
    [_nameLb configText:@"" textColor:CA_H_4BLACKCOLOR font:18];
    return _nameLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 75/2;
    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.image = kImage(@"head75");
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    return _iconImgView;
}
@end
