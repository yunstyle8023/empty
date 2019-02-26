//
//  CA_HBusinessDetailsViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBusinessDetailsViewManager.h"

#import "CA_HSpacingFlowLayout.h"

@interface CA_HBusinessDetailsViewManager ()

@end

@implementation CA_HBusinessDetailsViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UIImage *)image {
    return [self collectionShot];
}

- (UIView *)topView {
    if (!_topView) {
        UIView *view = [UIView new];
        _topView = view;
        
        view.backgroundColor = CA_H_TINTCOLOR;
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(22) color:[UIColor whiteColor]];
        _titleLabel = label;
        
        label.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(12) color:[UIColor whiteColor]];
        _tagLabel = label;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        label.layer.cornerRadius = 3*CA_H_RATIO_WIDTH;
        label.layer.masksToBounds = YES;
    }
    return _tagLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self flowLayout]];
        _collectionView = collectionView;
        
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        collectionView.backgroundColor = [UIColor whiteColor];
        
        
        [collectionView registerClass:NSClassFromString(@"CA_HStockMarketCell") forCellWithReuseIdentifier:@"CA_HStockMarketCell"];
        [collectionView registerClass:NSClassFromString(@"CA_HApplicationReportCell") forCellWithReuseIdentifier:@"CA_HApplicationReportCell"];
        
        [collectionView registerClass:NSClassFromString(@"CA_HInformationModuleCell") forCellWithReuseIdentifier:@"CA_HInformationModuleCell"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)customTop:(NSString *)title tag:(NSString *)tag target:(id)target action:(SEL)action {
    CGSize titleSize = [title sizeForFont:CA_H_FONT_PFSC_Medium(22) size:CGSizeMake(335*CA_H_RATIO_WIDTH, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    
    self.titleLabel.frame = CGRectMake(20, 64+CA_H_MANAGER.xheight+10*CA_H_RATIO_WIDTH, 335*CA_H_RATIO_WIDTH/*titleSize.width*/, titleSize.height);
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.frame = self.titleLabel.frame;
    [self.topView addSubview:self.titleLabel];
    
    if (tag.length) {
        self.height = 58*CA_H_RATIO_WIDTH + titleSize.height;
        CGFloat width = [tag widthForFont:CA_H_FONT_PFSC_Regular(12)] + 16*CA_H_RATIO_WIDTH;
        self.tagLabel.text = tag;
        [self.topView addSubview:self.tagLabel];
        self.tagLabel.sd_layout
        .widthIs(width)
        .heightIs(23*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.topView, 20*CA_H_RATIO_WIDTH)
        .bottomSpaceToView(self.topView, 15*CA_H_RATIO_WIDTH);
    } else {
        self.height = 25*CA_H_RATIO_WIDTH + titleSize.height;
    }
    
    self.collectionView.contentInset = UIEdgeInsetsMake(self.height, 20*CA_H_RATIO_WIDTH, CA_H_MANAGER.xheight+60*CA_H_RATIO_WIDTH, 15*CA_H_RATIO_WIDTH);
    
    self.topView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, self.height+ 64+CA_H_MANAGER.xheight);
    
    
    UIButton *back = [UIButton new];
    back.tag = 100;
    [back addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"backicon_white"] forState:UIControlStateNormal];
    back.imageView.sd_resetLayout
    .widthIs(18)
    .heightEqualToWidth()
    .leftSpaceToView(back.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(back.imageView.superview);
    
    [self.topView addSubview:back];
    back.sd_layout
    .widthIs(18+50*CA_H_RATIO_WIDTH)
    .heightIs(30)
    .topSpaceToView(self.topView, CA_H_MANAGER.xheight+27)
    .leftEqualToView(self.topView);
    
    UIButton *share = [self button:@"icons_share2" tag:101 target:target action:action];
    [self.topView addSubview:share];
    share.sd_layout
    .widthIs(24)
    .heightEqualToWidth()
    .rightSpaceToView(self.topView, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.topView, CA_H_MANAGER.xheight+30);
    
    UIButton *pic = [self button:@"icons_pic_share" tag:102 target:target action:action];
    [self.topView addSubview:pic];
    pic.sd_layout
    .widthIs(24)
    .heightEqualToWidth()
    .rightSpaceToView(share, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.topView, CA_H_MANAGER.xheight+30);
    
}

- (UIButton *)button:(NSString *)imageName tag:(NSInteger)tag target:(id)target action:(SEL)action {
    UIButton *button = [UIButton new];
    button.tag = tag;
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UICollectionViewFlowLayout *)flowLayout{
    CA_HSpacingFlowLayout *flowLayout = [CA_HSpacingFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 15*CA_H_RATIO_WIDTH;
    flowLayout.maximumSpacing = 15*CA_H_RATIO_WIDTH;
    flowLayout.minimumInteritemSpacing = 15*CA_H_RATIO_WIDTH;
    
    return flowLayout;
}

- (UICollectionReusableView *)header:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if (header.subviews.count == 0) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(18) color:CA_H_4BLACKCOLOR];
        label.tag = 101;
        [header addSubview:label];
        label.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    UILabel *label = [header viewWithTag:101];
    switch (indexPath.section) {
        case 0:
            label.text = @"上市信息";
            break;
        case 1:
            label.text = @"基本信息";
            break;
        case 2:
            label.text = @"风险信息";
            break;
        case 3:
            label.text = @"企业报告";
            break;
        default:
            label.text = @"";
            break;
    }
    
    return header;
}

#pragma mark --- Delegate

- (UIImage *)collectionShot {
    
    self.collectionView.sd_closeAutoLayout = YES;
    
    CGSize contentSize = CGSizeMake(self.collectionView.width, self.collectionView.contentSize.height+self.height+26*CA_H_RATIO_WIDTH);
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(contentSize.width, contentSize.height+64+CA_H_MANAGER.xheight), YES, 0.0);
    
    //保存collectionView当前的偏移量
    CGPoint savedContentOffset = self.collectionView.contentOffset;
    CGRect saveFrame = self.collectionView.frame;
    
    //将collectionView的偏移量设置为(0,0)
    self.collectionView.contentOffset = CGPointMake(0, -self.height);
    self.collectionView.frame = CGRectMake(0, 64+CA_H_MANAGER.xheight, contentSize.width, contentSize.height);
    [self.collectionView.delegate scrollViewDidScroll:self.collectionView];
    
    //在当前上下文中渲染出collectionView
    [self.collectionView.superview.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //恢复collectionView的偏移量
    self.collectionView.contentOffset = savedContentOffset;
    self.collectionView.frame = saveFrame;
    [self.collectionView.delegate scrollViewDidScroll:self.collectionView];
    
    UIGraphicsEndImageContext();
    
    self.collectionView.sd_closeAutoLayout = NO;
    
    if (image != nil) {
        return [image imageByCropToRect:CGRectMake(0, 64+CA_H_MANAGER.xheight-6*CA_H_RATIO_WIDTH, contentSize.width, contentSize.height)];
    }else {
        return nil;
    }
}

@end
