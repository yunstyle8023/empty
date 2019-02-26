//
//  CA_HMultiSelectViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMultiSelectViewModel.h"

#import "JYAblumTool.h"
#import "CA_HMultiSelectCell.h"

@interface CA_HMultiSelectViewModel () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray * data;
@property (nonatomic, strong) NSMutableArray * seletedData;
@property (nonatomic, assign) NSUInteger originalLength;

@end

@implementation CA_HMultiSelectViewModel

#pragma mark --- Action

- (void)backToImages:(NSArray *)images{
    NSLog(@"---------");
    if (CA_H_MANAGER.imageBlock) {
        for (NSArray *image in images) {
            CA_H_MANAGER.imageBlock(YES, image.firstObject, image.lastObject);
        }
    }
    CA_H_MANAGER.imageBlock = nil;
    [CA_HProgressHUD hideHud];
    _backBlock(YES);
}

- (void)imageFromeArray:(NSMutableArray *)array{
    
    NSUInteger index = array.count;
    
    if (index >= self.seletedData.count) {
        [self backToImages:array];
    }else{
        PHAsset * asset = self.seletedData[index];
        
        CA_H_WeakSelf(self);
        
        [[JYAblumTool sharePhotoTool] requestImageForAsset:asset size:PHImageManagerMaximumSize resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *image, NSDictionary *info) {
            
            if (!image) {
                [CA_HProgressHUD hideHud];
                [CA_HProgressHUD showHudStr:@"系统错误"];
                return ;
            }
            
            [[JYAblumTool sharePhotoTool] requestImageDataForAsset:asset resizeMode:PHImageRequestOptionsResizeModeNone completion:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:info];
                
                UIImage *newImage = image;
                NSData *newImageData = imageData;
                
                NSString *urlKeyStr = [info[@"PHImageFileURLKey"] absoluteString];
                NSString *ext = [urlKeyStr componentsSeparatedByString:@"."].lastObject;
                
                if (urlKeyStr&&![ext isEqualToString:urlKeyStr]) {
                    
                    NSString *theUTI = (__bridge_transfer NSString     *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)(ext), NULL);
                    
                    if (UTTypeConformsTo((__bridge CFStringRef)theUTI, kUTTypeImage)
                        &&
                        ![theUTI isEqualToString:(NSString *)kUTTypeGIF]) {
                        
                        if (!self.originalButton.selected) {
                            if (image.size.width > 720) {
                                newImage = [image imageByResizeToSize:CGSizeMake(720, 720./image.size.width *image.size.height)];
                                newImageData = newImage.imageDataRepresentation;
                            }
                        }
                        
                    }
                }
                
                
                if (imageData) [infoDic setValue:newImageData forKey:@"ca_imageData"];
                if (dataUTI) [infoDic setValue:dataUTI forKey:@"ca_dataUTI"];
                [infoDic setValue:@(orientation) forKey:@"ca_orientation"];
                
                CA_H_StrongSelf(self);
                [array addObject:@[newImage, infoDic]];
                [self imageFromeArray:array];
            }];
        }];
    }
    
}

- (void)onButton:(UIButton *)sender{
    if (_backBlock) {
        if (sender.tag == 101) {
            if (CA_H_MANAGER.imageBlock) {
                [CA_HProgressHUD showHud:nil];
                [self imageFromeArray:[NSMutableArray new]];
            }
        }else {
            _backBlock(NO);
        }
    }
}

- (void)onTitle:(UIButton *)sender{
    if (_pushBlock) {
        CA_H_WeakSelf(self);
        _pushBlock(@"CA_HMultiSelectImagePickerList", @{@"buttonTitle":self.titleView.titleLabel.text, @"listBlock":^(JYAblumList *list){
            CA_H_StrongSelf(self);
            
            [self.titleView setTitle:list.title forState:UIControlStateNormal];
            
            self.data = [[JYAblumTool sharePhotoTool] getAssetsInAssetCollection:list.assetCollection ascending:YES];
            
            [self.collectionView reloadData];
            
            [self.collectionView performBatchUpdates:^{
                
            } completion:^(BOOL finished) {
                
                NSInteger item = self.data.count-1;
                if (item >= 0) {
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                }
            }];
            
        }}, NO);
    }
}

- (void)onOriginal:(UIButton *)sender{
    sender.selected = !sender.selected;
}

#pragma mark --- Lazy

- (UIButton *)titleView{
    if (!_titleView) {
        UIButton * button = [UIButton new];
        
        [button setImage:[UIImage imageNamed:@"shape3"] forState:UIControlStateNormal];
        [button setTitle:CA_H_LAN(@"所有照片") forState:UIControlStateNormal];
        [button setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:17]];
        [button addTarget:self action:@selector(onTitle:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.sd_resetLayout
        .centerYEqualToView(button.titleLabel.superview)
        .leftSpaceToView(button.titleLabel.superview, 3)
        .autoHeightRatio(0);
        [button.titleLabel setMaxNumberOfLinesToShow:1];
        [button.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        button.imageView.sd_resetLayout
        .widthIs(12)
        .heightEqualToWidth()
        .centerYEqualToView(button.imageView.superview)
        .leftSpaceToView(button.titleLabel, 3);
        
        [button setupAutoWidthWithRightView:button.titleLabel rightMargin:18];
        [button setupAutoHeightWithBottomView:button.imageView bottomMargin:16];
        
        _titleView = button;
    }
    return _titleView;
}

- (UIBarButtonItem *)leftBarButtonItem{
    if (!_leftBarButtonItem) {
        
        UIButton * button = [UIButton new];
        button.tag = 100;
        
        [button setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
        [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 70-titleSize.width)];
        
        button.frame = CGRectMake(0, 0, 70, 44);
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
    }
    return _leftBarButtonItem;
}

- (UIBarButtonItem *)rightBarButtonItem{
    if (!_rightBarButtonItem) {
        
        UIButton * button = [UIButton new];
        button.tag = 101;
        
        [button setTitle:CA_H_LAN(@"完成") forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
        
        [button setBackgroundImage:[UIImage imageWithColor:CA_H_TINTCOLOR] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:CA_H_BACKCOLOR] forState:UIControlStateDisabled];
        
        button.layer.cornerRadius = 2;
        button.clipsToBounds = YES;
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setupAutoWidthWithRightView:button.titleLabel rightMargin:10];
        [button setupAutoHeightWithBottomView:button.titleLabel bottomMargin:3];
        
        _rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        button.enabled = NO;
    }
    return _rightBarButtonItem;
}

- (UIButton *)originalButton{
    if (!_originalButton) {
        UIButton * button = [UIButton new];
        
        [button setImage:[UIImage imageNamed:@"fullimage_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"fullimage2_icon"] forState:UIControlStateSelected];
        
        [button.titleLabel setFont:CA_H_FONT_PFSC_Regular(16)];
        [button setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
        [button setTitle:CA_H_LAN(@"原图") forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(onOriginal:) forControlEvents:UIControlEventTouchUpInside];
        
        
        button.imageView.sd_resetLayout
        .widthIs(16*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(button.imageView.superview)
        .leftSpaceToView(button.imageView.superview, 10*CA_H_RATIO_WIDTH);
        
        button.titleLabel.sd_resetLayout
        .centerYEqualToView(button.titleLabel.superview)
        .leftSpaceToView(button.imageView, 10*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [button.titleLabel setMaxNumberOfLinesToShow:1];
        [button.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _originalButton = button;
    }
    return _originalButton;
}

- (NSMutableArray *)seletedData{
    if (!_seletedData) {
        _seletedData = [NSMutableArray new];
    }
    return _seletedData;
}

- (NSArray *)data{
    if (!_data) {
        _data = [[JYAblumTool sharePhotoTool] getAllAssetInPhotoAblumWithAscending:YES];
    }
    return _data;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self flowLayout]];
        
        collectionView.backgroundColor = [UIColor clearColor];
        
//        collectionView.allowsMultipleSelection = YES;
        
        [collectionView registerClass:[CA_HMultiSelectCell class] forCellWithReuseIdentifier:@"cell"];
        
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [collectionView performBatchUpdates:^{
            
        } completion:^(BOOL finished) {
            NSInteger item = self.data.count-1;
            if (item >= 0) {
                [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        }];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark --- LifeCircle


#pragma mark --- Custom

- (UICollectionViewFlowLayout *)flowLayout{
    UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = CA_H_RATIO_WIDTH;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(93*CA_H_RATIO_WIDTH, 93*CA_H_RATIO_WIDTH);
    
    return flowLayout;
}

- (NSUInteger)selected:(PHAsset *)asset{
    
    if (self.seletedData.count == self.maxSelected) {
        if (self.getControllerBlock) {
            
            [self.getControllerBlock() presentAlertTitle:nil message:[NSString stringWithFormat:CA_H_LAN(@"您最多只能选择%ld张照片"), self.maxSelected] buttons:@[CA_H_LAN(@"确定")] clickBlock:^(UIAlertController *alert, NSInteger index) {
                
            }];
        }
        return 0;
    }
    
    NSLock *lock = [NSLock new];
    [[JYAblumTool sharePhotoTool] requestImageDataForAsset:asset resizeMode:PHImageRequestOptionsResizeModeNone completion:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        [lock lock];
        self.originalLength += imageData.length;
        [lock unlock];
        if (self.seletedData.count > 0) {
            [self.originalButton setTitle:[NSString stringWithFormat:CA_H_LAN(@"原图(%.1fM)"),self.originalLength/1024.0/1024.0] forState:UIControlStateNormal];
        }else{
            [self.originalButton setTitle:CA_H_LAN(@"原图") forState:UIControlStateNormal];
        }
    }];
//    [[JYAblumTool sharePhotoTool] requestImageForAsset:asset size:PHImageManagerMaximumSize resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *image, NSDictionary *info) {
//        [lock lock];
//        self.originalLength += image.imageDataRepresentation.length;
//        [lock unlock];
//        if (self.seletedData.count > 0) {
//            [self.originalButton setTitle:[NSString stringWithFormat:CA_H_LAN(@"原图(%.1fM)"),self.originalLength/1024.0/1024.0] forState:UIControlStateNormal];
//        }else{
//            [self.originalButton setTitle:CA_H_LAN(@"原图") forState:UIControlStateNormal];
//        }
//    }];
    
    [self.seletedData addObject:asset];
    [self changeRightBarButton];
    return self.seletedData.count;
}

- (NSUInteger)unSelected:(PHAsset *)asset{
    for (NSUInteger i = [self.seletedData indexOfObject:asset] + 1; i < self.seletedData.count; i++) {
        
        NSUInteger item = [self.data indexOfObject:self.seletedData[i]];
        
        if (item != NSNotFound) {
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
            
            CA_HMultiSelectCell *selectedCell = (id)[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
            selectedCell.number = i;
        }
        
    }
    
    NSLock *lock = [NSLock new];
    [[JYAblumTool sharePhotoTool] requestImageDataForAsset:asset resizeMode:PHImageRequestOptionsResizeModeNone completion:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        [lock lock];
        self.originalLength -= imageData.length;
        [lock unlock];
        if (self.seletedData.count > 0) {
            [self.originalButton setTitle:[NSString stringWithFormat:CA_H_LAN(@"原图(%.1fM)"),self.originalLength/1024.0/1024.0] forState:UIControlStateNormal];
        }else{
            [self.originalButton setTitle:CA_H_LAN(@"原图") forState:UIControlStateNormal];
        }
    }];
//    [[JYAblumTool sharePhotoTool] requestImageForAsset:asset size:PHImageManagerMaximumSize resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *image,NSDictionary *info) {
//        [lock lock];
//        self.originalLength -= image.imageDataRepresentation.length;
//        [lock unlock];
//        if (self.seletedData.count > 0) {
//            [self.originalButton setTitle:[NSString stringWithFormat:CA_H_LAN(@"原图(%.1fM)"),self.originalLength/1024.0/1024.0] forState:UIControlStateNormal];
//        }else{
//            [self.originalButton setTitle:CA_H_LAN(@"原图") forState:UIControlStateNormal];
//        }
//    }];
    
    [self.seletedData removeObject:asset];
    [self changeRightBarButton];
    return 0;
}

- (void)changeRightBarButton{
    
    NSUInteger count = self.seletedData.count;
    UIButton * button = self.rightBarButtonItem.customView;
    
    if (count > 0) {
        [button setTitle:[NSString stringWithFormat:CA_H_LAN(@"完成(%ld)"), count] forState:UIControlStateNormal];
        button.enabled = YES;
    }else{
        [button setTitle:CA_H_LAN(@"完成") forState:UIControlStateNormal];
        button.enabled = NO;
    }
}

#pragma mark --- Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return self.data.count;
    }else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                self.data = nil;
                CA_H_DISPATCH_MAIN_THREAD(^{
                    [collectionView reloadData];
                    [collectionView performBatchUpdates:^{
                        
                    } completion:^(BOOL finished) {
                        NSInteger item = self.data.count-1;
                        if (item >= 0) {
                            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                        }
                    }];
                });
            }
        }];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CA_HMultiSelectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    PHAsset * asset = self.data[indexPath.item];
    
    CGSize size = [self getSizeWithAsset:asset];
    
    [[JYAblumTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        cell.imageView.image = image;
    }];
    
    NSUInteger item = [self.seletedData indexOfObject:asset];
    
    if (item == NSNotFound) {
        cell.number = 0;
    }else {
        cell.number = item + 1;
    }
    
    CA_H_WeakSelf(self);
    cell.selectedBlock = ^NSUInteger(BOOL isSelected) {
        CA_H_StrongSelf(self);
        
        if (isSelected) {
            return [self selected:asset];
        }else{
            return [self unSelected:asset];
        }
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_pushBlock) {
        _pushBlock(@"CA_HMultiSelectPhotoBrowserController", @{@"viewModel":self}, YES);
    }
}

#pragma mark - 获取图片及图片尺寸的相关方法

- (CGSize)getSizeWithAsset:(PHAsset *)asset{
    
    CGFloat width  = (CGFloat)asset.pixelWidth;
    
    CGFloat height = (CGFloat)asset.pixelHeight;
    
    CGFloat scale = width/height;
    
    CGFloat sizeWidth = 93*CA_H_RATIO_WIDTH*2.0;
    if (scale < 1) {
        return CGSizeMake(sizeWidth, sizeWidth/scale);
    }else {
        return CGSizeMake(sizeWidth*scale, sizeWidth);
    }
    
//    return CGSizeMake(self.collectionView.frame.size.height*scale, self.collectionView.frame.size.height);
}


#pragma mark --- PhotoBrowser

- (void)showPhotoBrowser:(UIView *)view{
    
    CA_H_WeakSelf(self);
    CA_HChoosePhotoBrowseView * photoView = [[CA_HChoosePhotoBrowseView alloc]initWithGroupAssets:self.data page:[[self.collectionView indexPathsForSelectedItems].firstObject item] view:view selectedBlock:^NSUInteger(NSInteger isSelected, PHAsset *asset) {
        CA_H_StrongSelf(self);
        
        if (isSelected == 2) {
            NSInteger index = [self.seletedData indexOfObject:asset];
            if (index == NSNotFound) {
                return 0;
            }else{
                return index+1;
            }
        }else if (isSelected) {
            return [self selected:asset];
        }else{
            return [self unSelected:asset];
        }
    }];
    
    photoView.blurEffectBackground = NO;
    photoView.pager.hidden = YES;
    
}


@end
