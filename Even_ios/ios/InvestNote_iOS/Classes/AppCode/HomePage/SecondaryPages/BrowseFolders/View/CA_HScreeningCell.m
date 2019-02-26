//
//  CA_HScreeningCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/26.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HScreeningCell.h"

#import "CA_HScreeningTagCell.h"

@interface CA_HScreeningCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * allButton;

@end

@implementation CA_HScreeningCell

#pragma mark --- Action

- (void)onButton:(UIButton *)sender{
    
    NSArray * array = [self.collectionView indexPathsForSelectedItems];
    
    switch (sender.tag) {
        case 100:{
            for (NSIndexPath * selectedIndexPath in array) {
                [self.collectionView deselectItemAtIndexPath:selectedIndexPath animated:NO];
            }
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }break;
        case 101:{
            if (_doneBlock) {
                _doneBlock();
            }
        }break;
        case 102:{
            sender.selected = !sender.selected;
            if (sender.selected) {
                [UIView animateWithDuration:0.25 animations:^{
                    sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    sender.imageView.transform = CGAffineTransformIdentity;
                }];
            }
            
            [self.collectionView reloadData];
            for (NSIndexPath * selectedIndexPath in array) {
                [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
            
//            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
//            for (NSIndexPath * selectedIndexPath in array) {
//                if (selectedIndexPath.section == 0) {
//                    [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//                }
//            }
        }break;
            
        default:
            break;
    }
}

#pragma mark --- Lazy

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self flowLayout]];
        
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = NO;
        
        collectionView.allowsMultipleSelection = YES;
        
        [collectionView registerClass:[CA_HScreeningTagCell class] forCellWithReuseIdentifier:@"cell"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"header0"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"header1"];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [collectionView addSubview:self.allButton];
        self.allButton.sd_layout
        .widthIs(130*CA_H_RATIO_WIDTH)
        .heightIs(35*CA_H_RATIO_WIDTH)
        .topEqualToView(collectionView)
        .rightEqualToView(collectionView);
        
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIButton *)allButton{
    if (!_allButton) {
        UIButton * button = [UIButton new];
        button.tag = 102;
        
        [button setImage:[UIImage imageNamed:@"shape3"] forState:UIControlStateNormal];
        [button setTitle:CA_H_LAN(@"全部") forState:UIControlStateNormal];
        [button setTitle:CA_H_LAN(@"收起") forState:UIControlStateSelected];
        [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [button.titleLabel setFont:CA_H_FONT_PFSC_Regular(12)];
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.sd_resetLayout
        .bottomEqualToView(button.titleLabel.superview)
        .rightSpaceToView(button.titleLabel.superview, 32*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [button.titleLabel setMaxNumberOfLinesToShow:1];
        [button.titleLabel setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
        
        button.imageView.sd_resetLayout
        .widthIs(12*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(button.titleLabel)
        .leftSpaceToView(button.titleLabel, 5*CA_H_RATIO_WIDTH);
        
        _allButton = button;
    }
    return _allButton;
}

#pragma mark --- Custom

- (void)upView{
    [super upView];
    
    UIView * bottomeView = [self bottomView];
    [self.contentView addSubview:bottomeView];
    bottomeView.sd_layout
    .heightIs(44*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    [self.contentView addSubview:self.collectionView];
    self.collectionView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomSpaceToView(bottomeView, 0);
}

- (void)setModel:(NSObject *)model{
    [super setModel:model];
}

- (UIView *)bottomView{
    UIView * view = [UIView new];
    view.backgroundColor = CA_H_F8COLOR;
    
    CAGradientLayer * layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(130*CA_H_RATIO_WIDTH, 1, 245*CA_H_RATIO_WIDTH, 44*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    layer.colors = @[(__bridge id)CA_H_TINTCOLOR.CGColor,
                     (__bridge id)CA_H_TINTCOLOR.CGColor];
    
    [view.layer addSublayer:layer];
    
    UIButton * reset = [self button:CA_H_LAN(@"重置") titleColor:CA_H_9GRAYCOLOR tag:100];
    UIButton * done = [self button:CA_H_LAN(@"完成") titleColor:[UIColor whiteColor] tag:101];
    
    [view addSubview:reset];
    [view addSubview:done];
    
    reset.sd_layout
    .widthIs(130*CA_H_RATIO_WIDTH)
    .heightIs(44*CA_H_RATIO_WIDTH)
    .leftEqualToView(view)
    .topEqualToView(view);
    
    done.sd_layout
    .heightIs(44*CA_H_RATIO_WIDTH)
    .leftSpaceToView(reset, 0)
    .rightEqualToView(view)
    .topEqualToView(view);

    return view;
}

- (UIButton *)button:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag{
    UIButton * button = [UIButton new];
    
    button.tag = tag;
    [button.titleLabel setFont:CA_H_FONT_PFSC_Regular(16)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UICollectionViewFlowLayout *)flowLayout{
    UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 10*CA_H_RATIO_WIDTH;
    flowLayout.minimumInteritemSpacing = 8*CA_H_RATIO_WIDTH;
    flowLayout.sectionInset = UIEdgeInsetsMake(15*CA_H_RATIO_WIDTH, 15*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 14*CA_H_RATIO_WIDTH);
    flowLayout.itemSize = CGSizeMake(80*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH);
    
    return flowLayout;
}

#pragma mark --- Collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.allButton.selected?13:MIN(8, 13);
    }
    return 7;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section) {
        return CGSizeMake(collectionView.mj_w, 40*CA_H_RATIO_WIDTH);
    }
    return CGSizeMake(collectionView.mj_w, 35*CA_H_RATIO_WIDTH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = [NSString stringWithFormat:@"header%ld", indexPath.section];
    
    UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (!view.subviews.count) {
        
        UILabel * label = [UILabel new];
        label.font = CA_H_FONT_PFSC_Regular(14);
        label.textColor = CA_H_9GRAYCOLOR;
        
        [view addSubview:label];
        label.sd_layout
        .leftSpaceToView(view, 15*CA_H_RATIO_WIDTH)
        .bottomEqualToView(view)
        .autoHeightRatio(0);
        [label setMaxNumberOfLinesToShow:1];
        [label setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
        
        if (indexPath.section) {
            label.text = CA_H_LAN(@"按类型");
            
            UIView *line = [UIView new];
            line.backgroundColor = CA_H_BACKCOLOR;
            [view addSubview:line];
            line.sd_layout
            .heightIs(CA_H_LINE_Thickness)
            .leftEqualToView(view)
            .rightEqualToView(view)
            .topEqualToView(view);
            
        }else{
            label.text = CA_H_LAN(@"按标签");
        }
    }
    
    
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CA_HScreeningTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.item) {
        if (indexPath.section) {
            cell.textLabel.text = @"PDF";
        }else{
            cell.textLabel.text = @"投资机构...";
        }
    }else{
        cell.textLabel.text = CA_H_LAN(@"全部");
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (indexPath.item == 0) {
        
        NSArray * indexPaths = [collectionView indexPathsForSelectedItems];
        
        for (NSIndexPath * selectedIndexPath in indexPaths) {
            if (selectedIndexPath.section == indexPath.section) {
                [collectionView deselectItemAtIndexPath:selectedIndexPath animated:NO];
            }
        }
    }else {
        [collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section] animated:NO];
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * array = [collectionView indexPathsForSelectedItems];
    
    NSInteger i = 0;
    for (NSIndexPath * selectedIndexPath in array) {
        if (selectedIndexPath.section == indexPath.section) {
            i++;
        }
    }
    if (i < 2) {
        if (indexPath.item) {
            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }else{
            return NO;
        }
    }
    
    return YES;
}

@end
