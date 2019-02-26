//
//  ViewControllerasa.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSelectPersonVC.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MSelectPersonCollectionViewCell.h"

static NSString* const key = @"CA_MSelectPersonCollectionViewCell";

@interface CA_MSelectPersonVC ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate>

@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UILabel* personLb;
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UIButton* confirmBtn;
@property(nonatomic,strong)UIButton* canelBtn;
@property(nonatomic,strong)NSMutableArray* dataSource;
@end

@implementation CA_MSelectPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestData];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.personLb];
    [self.bgView addSubview:self.collectionView];
    [self.bgView addSubview:self.canelBtn];
    [self.bgView addSubview:self.confirmBtn];
}

-(void)requestData{
    [CA_HNetManager postUrlStr:CA_M_Api_ListHumanrTag parameters:@{} callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    for (NSDictionary* dic in netModel.data) {
                        CA_MProjectTagModel* model = [CA_MProjectTagModel modelWithDictionary:dic];
                        model.select = NO;
                        [self.dataSource addObject:model];
                    }
                    [self.collectionView reloadData];
                }
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}
#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MSelectPersonCollectionViewCell* personCell = [collectionView dequeueReusableCellWithReuseIdentifier:key forIndexPath:indexPath];
    if ([NSObject isValueableObject:self.dataSource]) {
        CA_MProjectTagModel* model = self.dataSource[indexPath.item];
        personCell.model = model;
    }
    return personCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CA_MProjectTagModel* model = self.dataSource[indexPath.item];
    CGFloat width = [model.tag_name widthForFont:CA_H_FONT_PFSC_Regular(14)] + 10;
    return CGSizeMake(width*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH);
//    return CGSizeMake(80*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectTagModel* model = self.dataSource[indexPath.item];
    model.select = !model.isSelect;
    [self.collectionView reloadData];
}

#pragma mark - 确定 取消按钮点击事件

- (void)confirmBtnAction{
    
    NSMutableArray* tempArr = @[].mutableCopy;
    for (CA_MProjectTagModel* model in self.dataSource) {
        if (model.isSelect) {
            [tempArr addObject:model];
        }
    }
    
    if (self.callback) {
        self.callback(tempArr);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canelBtnAction{
    if (self.callback) {
        self.callback(nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter

-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    return _dataSource;
}
-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    CA_MEqualSpaceFlowLayout* layout = [[CA_MEqualSpaceFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.delegate = self;
    CGRect rect = CGRectMake(15, 40*CA_H_RATIO_WIDTH, CA_H_SCREEN_WIDTH-30, 230*CA_H_RATIO_WIDTH);
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[CA_MSelectPersonCollectionViewCell class] forCellWithReuseIdentifier:key];
    return _collectionView;
}
-(UIButton *)confirmBtn{
    if (_confirmBtn) {
        return _confirmBtn;
    }
    _confirmBtn = [UIButton new];
    CGRect rect = CGRectMake(130*CA_H_RATIO_WIDTH, 300*CA_H_RATIO_WIDTH, 245*CA_H_RATIO_WIDTH, 44*CA_H_RATIO_WIDTH);
    _confirmBtn.frame = rect;
    [_confirmBtn configTitle:@"确定" titleColor:kColor(@"#FFFFFF") font:16];
    _confirmBtn.backgroundColor = CA_H_TINTCOLOR;
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _confirmBtn;
}
-(UIButton *)canelBtn{
    if (_canelBtn) {
        return _canelBtn;
    }
    _canelBtn = [UIButton new];
    CGRect rect = CGRectMake(0, 300*CA_H_RATIO_WIDTH, 130*CA_H_RATIO_WIDTH, 44*CA_H_RATIO_WIDTH);
    _canelBtn.frame = rect;
    [_canelBtn configTitle:@"取消" titleColor:CA_H_9GRAYCOLOR font:16];
    _canelBtn.backgroundColor = kColor(@"#F9F9F9");
    [_canelBtn addTarget:self action:@selector(canelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _canelBtn;
}
-(UILabel *)personLb{
    if (_personLb) {
        return _personLb;
    }
    _personLb = [UILabel new];
    CGRect rect = CGRectMake(15, 5, 60*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
    _personLb.frame = rect;
    [_personLb configText:@"人脉筛选" textColor:CA_H_9GRAYCOLOR font:14];
    return _personLb;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [UIView new];
    CGRect rect = CGRectMake(0, 0, kScreenWidth, 344*CA_H_RATIO_WIDTH);
    _bgView.frame = rect;
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    return _bgView;
}
@end
