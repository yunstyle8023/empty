//
//  CA_HChooseTagMenuViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HChooseTagMenuViewModel.h"

#import "CA_HSpacingFlowLayout.h"
#import "CA_HScreeningTagCell.h"

#import "CA_HBrowseFoldersModel.h"

#import "NSString+CA_HStringCheck.h"

@interface CA_HChooseTagMenuViewModel ()

@property (nonatomic, strong) NSArray<CA_HFileTagModel *> *oldTags;

@property (nonatomic, strong) NSMutableArray<CA_HFileTagModel *> *data;

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSURLSessionDataTask *dataTask;

@end

@implementation CA_HChooseTagMenuViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (UICollectionView *(^)(id))collectionViewBlock {
    if (!_collectionViewBlock) {
        CA_H_WeakSelf(self);
        _collectionViewBlock = ^UICollectionView *(id delegate) {
            CA_H_StrongSelf(self);
            return [self collectionViewWithDelegate:delegate];
        };
    }
    return _collectionViewBlock;
}

- (UIView *(^)(id, SEL, UIView *))menuViewBlock {
    if (!_menuViewBlock) {
        CA_H_WeakSelf(self);
        _menuViewBlock = ^UIView *(id target, SEL action, UIView *contentView) {
            CA_H_StrongSelf(self);
            return [self menuViewWithTarget:target action:action contentView:contentView];
        };
    }
    return _menuViewBlock;
}

- (void (^)(void))requestBlock {
    if (!_requestBlock) {
        CA_H_WeakSelf(self);
        _requestBlock = ^ {
            CA_H_StrongSelf(self);
            [self requestListTag];
        };
    }
    return _requestBlock;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

- (void (^)(NSArray *))reloadDataBlock {
    if (!_reloadDataBlock) {
        CA_H_WeakSelf(self);
        _reloadDataBlock = ^(NSArray *dara) {
            CA_H_StrongSelf(self);
            [self.data removeAllObjects];
            [self.data addObjectsFromArray:dara];
            [self.collectionView reloadData];
        };
    }
    return _reloadDataBlock;
}

- (void (^)(NSString *))addDataBlock {
    if (!_addDataBlock) {
        CA_H_WeakSelf(self);
        _addDataBlock = ^(NSString * tagStr) {
            CA_H_StrongSelf(self);
            [self createNewTag:tagStr];
        };
    }
    return _addDataBlock;
}

- (void (^)(NSArray *))oldTagsBlock {
    if (!_oldTagsBlock) {
        CA_H_WeakSelf(self);
        _oldTagsBlock = ^ (NSArray *tags) {
            CA_H_StrongSelf(self);
            self.oldTags = tags;
        };
    }
    return _oldTagsBlock;
}

- (void (^)(UIButton *))clickBlock {
    if (!_clickBlock) {
        CA_H_WeakSelf(self);
        _clickBlock = ^ (UIButton *sender) {
            CA_H_StrongSelf(self);
            switch (sender.tag) {
                case 101://添加
//                    if (self.collectionView.indexPathsForSelectedItems.count >= 3) {
//                        if (self.showMassageBlock) {
//                            self.showMassageBlock(CA_H_LAN(@"最多选择三个标签"));
//                        }
//                    } else {
                        if (self.addNewTagBlock) {
                            self.addNewTagBlock();
                        }
//                    }
                    break;
                case 102://完成
                    if (self.dataCorrectionBlock) {
                        
                        
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"item" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        
                        NSArray *selectedArray = [self.collectionView.indexPathsForSelectedItems sortedArrayUsingDescriptors:sortDescriptors];
                        
                        NSMutableArray *mutArray = [NSMutableArray new];
                        for (NSIndexPath *indexPath in selectedArray) {
                            [mutArray addObject:self.data[indexPath.item]];
                        }
                        
                        self.dataCorrectionBlock(mutArray);
                        [self close];
                    }
                    break;
                default:
                    [self close];
                    break;
            }
        };
    }
    return _clickBlock;
}

- (void (^)(void))showBlock {
    if (!_showBlock) {
        CA_H_WeakSelf(self);
        _showBlock = ^{
            CA_H_StrongSelf(self);
            [self show];
        };
    }
    return _showBlock;
}


- (NSInteger (^)(NSInteger))numberOfItemsBlock {
    if (!_numberOfItemsBlock) {
        CA_H_WeakSelf(self);
        _numberOfItemsBlock = ^NSInteger (NSInteger section) {
            CA_H_StrongSelf(self);
            self.collectionView.backgroundView.hidden = (self.data.count>0);
            return self.data.count;
        };
    }
    return _numberOfItemsBlock;
}

- (CGSize (^)(NSIndexPath *))sizeForItemBlock {
    if (!_sizeForItemBlock) {
        CA_H_WeakSelf(self);
        _sizeForItemBlock = ^CGSize (NSIndexPath *indexPath) {
            CA_H_StrongSelf(self);
            NSString *str = self.data[indexPath.item].tag_name;
            CGFloat width = [str widthForFont:CA_H_FONT_PFSC_Regular(14)];
            return CGSizeMake(width+20*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH);
        };
    }
    return _sizeForItemBlock;
}

- (void (^)(UICollectionViewCell *, NSIndexPath *))cellForItemBlock {
    if (!_cellForItemBlock) {
        CA_H_WeakSelf(self);
        _cellForItemBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
            CA_H_StrongSelf(self);
            CA_HScreeningTagCell *tagCell = (id)cell;
            tagCell.textLabel.text = self.data[indexPath.item].tag_name;
        };
    }
    return _cellForItemBlock;
}

- (BOOL (^)(NSIndexPath *))shouldSelectItemBlock {
    if (!_shouldSelectItemBlock) {
        CA_H_WeakSelf(self);
        _shouldSelectItemBlock = ^BOOL (NSIndexPath *indexPath) {
            CA_H_StrongSelf(self);
            if (self.collectionView.indexPathsForSelectedItems.count >= 3) {
                if (self.showMassageBlock) {
                    self.showMassageBlock(CA_H_LAN(@"最多选择三个标签"));
                }
                return NO;
            }
            return YES;
        };
    }
    return _shouldSelectItemBlock;
}

- (void (^)(void))shuoldDoneBlock {
    if (!_shuoldDoneBlock) {
        CA_H_WeakSelf(self);
        _shuoldDoneBlock = ^{
            CA_H_StrongSelf(self);
            if (self.collectionView.indexPathsForSelectedItems.count > 0) {
                self.doneButton.enabled = YES;
            }else {
                self.doneButton.enabled = NO;
            }
        };
    }
    return _shuoldDoneBlock;
}

- (BOOL (^)(NSString *, NSString *))textFieldShouldChangeBlock {
    if (!_textFieldShouldChangeBlock) {
        CA_H_WeakSelf(self);
        _textFieldShouldChangeBlock = ^BOOL (NSString *text, NSString *string) {
            CA_H_StrongSelf(self);
            return [self textField:text shouldChange:string];
        };
    }
    return _textFieldShouldChangeBlock;
}

#pragma mark --- LifeCircle

- (void)dealloc {
    [_dataTask cancel];
    _dataTask = nil;
    NSLog(@"%@----->dealloc",[self class]);
}

#pragma mark --- Custom

- (void)requestListTag {
    CA_H_WeakSelf(self);
    _dataTask =
    [CA_HNetManager postUrlStr:CA_H_Api_ListTag parameters:nil callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                
                if ([netModel.data isKindOfClass:[NSArray class]]) {
                    NSMutableArray *mutArray = [NSMutableArray new];
                    for (NSDictionary *dic in netModel.data) {
                        [mutArray addObject:[CA_HFileTagModel modelWithDictionary:dic]];
                    }
                    self.reloadDataBlock(mutArray);
                    if (self.loadMenuBlock) {
                        self.loadMenuBlock();
                    }
                }
            }
        }
    } progress:nil];
}

- (void)show {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.menuView.frame = CGRectMake(0, CA_H_SCREEN_HEIGHT-(340*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight), CA_H_SCREEN_WIDTH, 340*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    }];
    
    
    if (self.oldTags.count) {
        
        for (NSInteger i=0; i<self.data.count; i++) {
            for (CA_HFileTagModel *model in self.oldTags) {
                if ([model.tag_id isEqualToNumber:self.data[i].tag_id]) {
                    [self.data removeObjectAtIndex:i];
                    i--;
                    break;
                }
            }
        }
        
        [self.data insertObjects:self.oldTags atIndex:0];
        
        
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadData];
        } completion:^(BOOL finished) {
            if (finished) {
                for (NSInteger i=0; i<self.oldTags.count; i++) {
                    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                }
                
                self.doneButton.enabled = YES;
            }
        }];
    }
    
}

- (void)close {
    [UIView animateWithDuration:0.25 animations:^{
        self.menuView.frame = CGRectMake(0, CA_H_SCREEN_HEIGHT, CA_H_SCREEN_WIDTH, 340*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    } completion:^(BOOL finished) {
        if (self.dismissMenuBlock) {
            self.dismissMenuBlock();
        }
    }];
}

- (UIView *)menuViewWithTarget:(id)target action:(SEL)action contentView:(UIView *)contentView {
    UIView *view = [UIView new];
    
    view.frame = CGRectMake(0, CA_H_SCREEN_HEIGHT, CA_H_SCREEN_WIDTH, 340*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *topLine = [UIView new];
    topLine.backgroundColor = CA_H_BACKCOLOR;
    [view addSubview:topLine];
    topLine.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .topSpaceToView(view, 52*CA_H_RATIO_WIDTH)
    .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH);
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = CA_H_BACKCOLOR;
    [view addSubview:bottomLine];
    bottomLine.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomSpaceToView(view, 52*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
    .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH);
    
    
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton new];
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        switch (i) {
            case 0:
                button.tag = 100;
                [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
                [button setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
                
                button.sd_layout
                .heightIs(52*CA_H_RATIO_WIDTH)
                .leftEqualToView(view)
                .rightEqualToView(view)
                .topSpaceToView(bottomLine, 0);
                break;
            case 1:
                button.tag = 101;
                [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
                [button setTitle:CA_H_LAN(@"添加新标签") forState:UIControlStateNormal];
                
                button.sd_layout
                .leftEqualToView(view)
                .topEqualToView(view)
                .bottomEqualToView(topLine);
                [button setupAutoWidthWithRightView:button.titleLabel rightMargin:20*CA_H_RATIO_WIDTH];
                break;
            case 2:
                _doneButton = button;
                button.tag = 102;
                button.enabled = NO;
                [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
                [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateDisabled];
                [button setTitle:CA_H_LAN(@"完成") forState:UIControlStateNormal];
                
                button.sd_layout
                .rightEqualToView(view)
                .topEqualToView(view)
                .bottomEqualToView(topLine);
                [button setupAutoWidthWithRightView:button.titleLabel rightMargin:20*CA_H_RATIO_WIDTH];
                break;
            default:
                break;
        }
    }
    
    [view addSubview:contentView];
    contentView.sd_layout
    .topSpaceToView(topLine, 0)
    .bottomSpaceToView(bottomLine, 0)
    .leftEqualToView(view)
    .rightEqualToView(view);
    
    _menuView = view;
    
    return view;
}

- (UICollectionView *)collectionViewWithDelegate:(id)delegate {
    
    CA_HSpacingFlowLayout * flowLayout = [CA_HSpacingFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 10*CA_H_RATIO_WIDTH;
    flowLayout.minimumInteritemSpacing = 5*CA_H_RATIO_WIDTH;
    flowLayout.maximumSpacing = 5*CA_H_RATIO_WIDTH;
    flowLayout.sectionInset = UIEdgeInsetsMake(20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = NO;
    
    collectionView.backgroundView = [self nullView];
    collectionView.backgroundView.hidden = YES;
    
    collectionView.allowsMultipleSelection = YES;
    
    [collectionView registerClass:[CA_HScreeningTagCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    collectionView.delegate = delegate;
    collectionView.dataSource = delegate;
    
    
    _collectionView = collectionView;
    
    return collectionView;
}

- (UIView *)nullView {
    UIView *view = [UIView new];
    
    UILabel *label = [UILabel new];
    
    label.font = CA_H_FONT_PFSC_Regular(16);
    label.textColor = CA_H_9GRAYCOLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = CA_H_LAN(@"暂无任何标签，请手动添加");
    
    [view addSubview:label];
    label.sd_layout
    .centerXEqualToView(view)
    .centerYEqualToView(view)
    .maxWidthIs(CA_H_SCREEN_WIDTH-40*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [label sizeToFit];
    
    
    return view;
}

- (BOOL)textField:(NSString *)text shouldChange:(NSString *)string{
    
    if (!string.length) {
        return YES;
    }
    
//    if (text.length>= 10) {
//        if (self.showMassageBlock) {
//            self.showMassageBlock(CA_H_LAN(@"最多不超过10个字"));
//        }
//        return NO;
//    }
    
    if (![string checkFileTag]) {
        if (self.showMassageBlock) {
            self.showMassageBlock(CA_H_LAN(@"只能输入中英文或数字"));
        }
        return NO;
    }
    
    return YES;
}

- (void)createNewTag:(NSString *)tagStr {
    
    if (!tagStr.length) return;
    
    CA_H_WeakSelf(self);
    _dataTask =
    [CA_HNetManager postUrlStr:CA_H_Api_CreateFileTags parameters:@{@"tag_name":tagStr} callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    
                    CA_HFileTagModel *tagModel = [CA_HFileTagModel modelWithDictionary:netModel.data];
                    [self addNewTag:tagModel];
                }
            }
        }
        
    } progress:nil];
}

- (void)addNewTag:(CA_HFileTagModel *)tagModel {
    
    NSInteger index = NSNotFound;
    for (NSInteger i=0; i<self.data.count; i++) {
        if ([tagModel.tag_id isEqualToNumber:self.data[i].tag_id]) {
            index = i;
            break;
        }
    }
    
    NSIndexPath *indexPathZero = [NSIndexPath indexPathForItem:0 inSection:0];
    
    [self.collectionView performBatchUpdates:^{
        
        if (index == NSNotFound) {
            [self.data insertObject:tagModel atIndex:0];
            [self.collectionView insertItemsAtIndexPaths:@[indexPathZero]];
        }else {
            [self.data removeObjectAtIndex:index];
            [self.data insertObject:tagModel atIndex:0];
            NSIndexPath *atIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.collectionView moveItemAtIndexPath:atIndexPath toIndexPath:indexPathZero];
        }
        
        
    } completion:^(BOOL finished) {
        if (finished
            &&
            self.collectionView.indexPathsForSelectedItems.count < 3) {
            [self.collectionView selectItemAtIndexPath:indexPathZero animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            self.doneButton.enabled = YES;
        }
    }];
    
}

#pragma mark --- Delegate


@end
