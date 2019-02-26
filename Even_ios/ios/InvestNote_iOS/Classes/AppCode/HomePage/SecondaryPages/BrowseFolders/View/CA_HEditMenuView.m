//
//  CA_HEditMenuView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HEditMenuView.h"

#import "CA_HEditMenuCell.h"

@interface CA_HEditMenuView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSDictionary * imageDic;

@end

@implementation CA_HEditMenuView

#pragma mark --- Action

- (void)onButton:(UIButton *)sender{
    if (_clickBlock) {
        _clickBlock(sender.tag - 100);
        _clickBlock = nil;
    }
}

#pragma mark --- Lazy

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self flowLayout]];
        
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = NO;
        [collectionView registerClass:[CA_HEditMenuCell class] forCellWithReuseIdentifier:@"cell"];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSDictionary *)imageDic{
    if (!_imageDic) {
        _imageDic = @{@"发送给朋友":@"WeChat_icon",
                      @"标签":@"tag_icon",
                      @"下载":@"download_icon2",
                      @"移动":@"move_icon2",
                      @"重命名":@"name_icon",
                      @"删除":@"delete_icon3"};
    }
    return _imageDic;
}

- (UIView *)contentView{
    if (!_contentView) {
        UIView * view = [UIView new];
        
        view.frame = CGRectMake(0, self.mj_h, self.mj_w, 155*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = CA_H_BACKCOLOR;
        [view addSubview:bottomLine];
        bottomLine.sd_layout
        .heightIs(CA_H_LINE_Thickness)
        .bottomSpaceToView(view, 52*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
        .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH)
        .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH);
        
        [view addSubview:self.cancelButton];
        
        self.cancelButton.sd_layout
        .heightIs(52*CA_H_RATIO_WIDTH)
        .leftEqualToView(view)
        .rightEqualToView(view)
        .topSpaceToView(bottomLine, 0);
        
        
        [view addSubview:self.collectionView];
        self.collectionView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 67*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight, 0));
        
        _contentView = view;
    }
    return _contentView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        UIButton * button = [UIButton new];
        
        button.tag = 99;
        [button.titleLabel setFont:CA_H_FONT_PFSC_Regular(16)];
        [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [button setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelButton = button;
    }
    return _cancelButton;
}

#pragma mark --- LifeCircle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_clickBlock) {
        _clickBlock(-1);
        _clickBlock = nil;
    }
}


#pragma mark --- Custom

- (void)upView{
    self.backgroundColor = [UIColor clearColor];
    
    UIToolbar * toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.alpha = 0.35;
    [self addSubview:toolbar];
    [self sendSubviewToBack:toolbar];
    toolbar.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    self.hidden = YES;
}

- (void)showMenu:(BOOL)animated{
    [self.collectionView reloadData];
    self.hidden = NO;
    CGFloat height = (87*ceil(self.data.count/5.0))*CA_H_RATIO_WIDTH + 67*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight;
    self.contentView.frame = CGRectMake(0, self.mj_h, self.mj_w, height);
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        self.contentView.frame = CGRectMake(0, self.mj_h-height, self.mj_w, height);
    }];
}

- (void)hideMenu:(BOOL)animated{
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        self.contentView.mj_y = self.mj_h;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UICollectionViewFlowLayout *)flowLayout{
    UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 7.5*CA_H_RATIO_WIDTH;
//    flowLayout.maximumSpacing = 7.5*CA_H_RATIO_WIDTH;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10*CA_H_RATIO_WIDTH, 0, 9*CA_H_RATIO_WIDTH);
    flowLayout.itemSize = CGSizeMake(65*CA_H_RATIO_WIDTH, 87*CA_H_RATIO_WIDTH);
    
    return flowLayout;
}

#pragma mark --- Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CA_HEditMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString * text = self.data[indexPath.item];
    cell.imageView.image = [UIImage imageNamed:self.imageDic[text]];
    cell.textLabel.text = CA_H_LAN(text);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_clickBlock) {
        _clickBlock(indexPath.item);
        _clickBlock = nil;
    }
}


@end
