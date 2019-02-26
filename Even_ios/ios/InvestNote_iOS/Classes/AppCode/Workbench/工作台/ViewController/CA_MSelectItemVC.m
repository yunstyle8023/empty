
//
//  CA_MSelectItemVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSelectItemVC.h"
#import "CA_MSettingProjectCollectionViewCell.h"
#import "CA_MSettingModel.h"
#import "CA_MSettingType.h"

@interface CA_MSelectItemVC ()
<UICollectionViewDataSource,
UICollectionViewDelegate
>{
    CA_MSettingListModel* _currentModel;
}

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *defaultBtn;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) CA_MSettingModel *model;

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@end

@implementation CA_MSelectItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestData];
}

-(void)setupUI{
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.collectionView];
    [self.bgView addSubview:self.indicatorView];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.defaultBtn];
    [self.bgView addSubview:self.confirmBtn];
}

-(void)requestData{
    [self.indicatorView startAnimating];
    [CA_HNetManager postUrlStr:CA_M_Api_ListWorkTable parameters:@{} callBack:^(CA_HNetModel *netModel) {
        [self.indicatorView stopAnimating];
        [self.indicatorView setHidesWhenStopped:YES];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {

                    self.model = [CA_MSettingModel modelWithDictionary:netModel.data];
                    for (int i=0; i<self.model.mod_list.count; i++) {
                        CA_MSettingListModel* listModel = self.model.mod_list[i];
                        if ([listModel.mod_type isEqualToString:self.currentItemKey]) {
                            listModel.selected = YES;
                            _currentModel = listModel;
                        }else{
                            listModel.selected = NO;
                        }
                    }

                    [self.collectionView reloadData];
                }
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}

-(void)confirmBtnAction{

    if (!_currentModel) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (![_currentModel.mod_type isEqualToString:SettingType_NoAuthority]) {
        if (self.defaultBtn.isSelected) {
            //保存默认的选择
            [CA_H_MANAGER saveDefaultItemKey:_currentModel.mod_type];
            [CA_H_MANAGER saveDefaultItem:_currentModel.mod_name];
        }
        
        if (self.block) {
            self.block(_currentModel.mod_type, _currentModel.mod_name);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)defaultBtnAction:(UIButton*)button{
    button.selected = !button.isSelected;
}

#pragma mark - UICollectionViewDataSource

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
    if ([model.mod_type isEqualToString:SettingType_NoAuthority]) {
        return;
    }
    model.selected = YES;
    _currentModel = model;
    
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
-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = self.collectionView.center;
    }
    return _indicatorView;
}
-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 32;
    layout.itemSize = CGSizeMake(45, 75);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGRect rect = CGRectMake(0, 15, CA_H_SCREEN_WIDTH, 95*CA_H_RATIO_WIDTH);
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[CA_MSettingProjectCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    return _collectionView;
}
-(UIButton *)defaultBtn{
    if (_defaultBtn) {
        return _defaultBtn;
    }
    CGRect rect = CGRectMake(0, 110*CA_H_RATIO_WIDTH, 260*CA_H_RATIO_WIDTH, 40*CA_H_RATIO_WIDTH);
    _defaultBtn = [[UIButton alloc] initWithFrame:rect];
    [_defaultBtn configTitle:@"同时设为默认" titleColor:CA_H_4BLACKCOLOR font:14];
    [_defaultBtn setImage:kImage(@"unfinished2") forState:UIControlStateNormal];
    [_defaultBtn setImage:kImage(@"unfinished2") forState:UIControlStateHighlighted];
    [_defaultBtn setImage:kImage(@"finished2") forState:UIControlStateSelected];
    _defaultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_defaultBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [_defaultBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    _defaultBtn.backgroundColor = kColor(@"#FFFFFF");
    _defaultBtn.selected = NO;
    [_defaultBtn addTarget:self action:@selector(defaultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return _defaultBtn;
}
-(UIButton *)confirmBtn{
    if (_confirmBtn) {
        return _confirmBtn;
    }
    CGRect rect = CGRectMake(260*CA_H_RATIO_WIDTH, 109*CA_H_RATIO_WIDTH, 116*CA_H_RATIO_WIDTH, 41*CA_H_RATIO_WIDTH);
    _confirmBtn = [[UIButton alloc] initWithFrame:rect];
    [_confirmBtn configTitle:@"确定切换" titleColor:kColor(@"#FFFFFF") font:14];
    _confirmBtn.backgroundColor = kColor(@"#7796EA");
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _confirmBtn;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    CGRect rect = CGRectMake(0, 109*CA_H_RATIO_WIDTH, 260*CA_H_RATIO_WIDTH, 1);
    _lineView = [[UIView alloc] initWithFrame:rect];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    CGRect rect = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 150*CA_H_RATIO_WIDTH);
    _bgView = [[UIView alloc] initWithFrame:rect];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    return _bgView;
}

@end
