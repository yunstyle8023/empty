//
//  AdminViewController.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MAddTagVC.h"
#import "CA_MEqualSpaceFlowLayout.h"
#import "CA_MSelectPersonCollectionViewCell.h"
#import "CA_MProjectTagModel.h"

static NSString* const tagKey = @"CA_MSelectPersonCollectionViewCell";

@interface CA_MAddTagVC ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CA_MEqualSpaceFlowLayoutDelegate>

@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIButton* cancelBtn;
@property(nonatomic,strong)UIButton* confirmBtn;
@property(nonatomic,strong)UIView* lineView;
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)NSMutableArray* dataSource;
@end

@implementation CA_MAddTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestData];
}

-(void)setupUI{
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.confirmBtn];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.collectionView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(283*CA_H_RATIO_WIDTH);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(20);
        make.top.mas_equalTo(self.bgView).offset((52*CA_H_RATIO_WIDTH-self.cancelBtn.mj_h)/2);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView).offset(-20);
        make.top.mas_equalTo(self.bgView).offset((52*CA_H_RATIO_WIDTH-self.cancelBtn.mj_h)/2);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(20);
        make.trailing.mas_equalTo(self.bgView).offset(-20);
        make.top.mas_equalTo(self.bgView).offset(52*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(1);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(20);
        make.trailing.mas_equalTo(self.bgView).offset(-20);
        make.bottom.mas_equalTo(self.bgView).offset(-20);
        make.top.mas_equalTo(self.lineView).offset(20);
    }];
}

-(void)requestData{
    [CA_HNetManager postUrlStr:CA_M_Api_ListHumanrTag parameters:@{} callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    for (NSDictionary* dic in netModel.data) {
                        CA_MProjectTagModel* model = [CA_MProjectTagModel modelWithDictionary:dic];
                        
                        if ([NSObject isValueableObject:self.selectedTags]) {
                            for (int i =0;i<self.selectedTags.count;i++) {
                                if (((NSNumber*)self.selectedTags[i]).intValue == model.human_tag_id.intValue) {
                                    model.select = YES;
                                    break;
                                }else{
                                    model.select = NO;
                                }
                            }
                        }
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
    CA_MSelectPersonCollectionViewCell* tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:tagKey forIndexPath:indexPath];
    CA_MProjectTagModel* model = self.dataSource[indexPath.item];
    tagCell.model = model;
    return tagCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CA_MProjectTagModel* model = self.dataSource[indexPath.item];
    CGFloat width = [model.tag_name widthForFont:CA_H_FONT_PFSC_Regular(14)] + 10;
    CGFloat kWidth = CA_H_SCREEN_WIDTH - 20*2 -10 ;
    if (width>=kWidth) {
        width = kWidth;
    }
    return CGSizeMake(width, 30*CA_H_RATIO_WIDTH);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectTagModel* model = self.dataSource[indexPath.item];
    model.select = !model.isSelect;
    [collectionView reloadData];
}

-(void)confirmBtnAction{
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

-(void)cancelBtnAction{
    if (self.callback) {
        self.callback(nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - getter and setter

-(UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    CA_MEqualSpaceFlowLayout* layout = [[CA_MEqualSpaceFlowLayout alloc] init];
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 5;
    _collectionView.backgroundColor = kColor(@"#FFFFFF");
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[CA_MSelectPersonCollectionViewCell class] forCellWithReuseIdentifier:tagKey];
    return _collectionView;
}
-(UIButton *)cancelBtn{
    if (_cancelBtn) {
        return _cancelBtn;
    }
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn configTitle:@"取消" titleColor:CA_H_9GRAYCOLOR font:16];
    [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _cancelBtn;
}
-(UIButton *)confirmBtn{
    if (_confirmBtn) {
        return _confirmBtn;
    }
    _confirmBtn = [[UIButton alloc] init];
    [_confirmBtn configTitle:@"完成" titleColor:CA_H_TINTCOLOR font:16];
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _confirmBtn;
}
-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    return _dataSource;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = kColor(@"#EEEEEE");
    return _lineView;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    return _bgView;
}
@end
