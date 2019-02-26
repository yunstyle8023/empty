//
//  YYPhotoGroupView.m
//
//  Created by ibireme on 14/3/9.
//  Copyright (C) 2014 ibireme. All rights reserved.
//

#import "YYPhotoBrowseView.h"

#include <sys/sysctl.h>

#import "UIView+YYAdd.h"
#import "CALayer+YYAdd.h"
#import "YYCGUtilities.h"
#define kPadding 20
#define kSystemVersionDouble [[UIDevice currentDevice].systemVersion doubleValue]

#ifndef YY_CLAMP // return the clamped value
#define YY_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

//#define kHiColor [UIColor colorWithRGBHex:0x2dd6b8]

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


@interface YYPhotoGroupItem()<NSCopying>
@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;
- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;
@end
@implementation YYPhotoGroupItem

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.frame.size.width < 1 || view.frame.size.height < 1) return NO;
    return imageSize.height / imageSize.width > view.frame.size.width / view.frame.size.height;
}

- (id)copyWithZone:(NSZone *)zone {
    YYPhotoGroupItem *item = [self.class new];
    return item;
}
@end



@interface YYPhotoGroupCell : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) YYPhotoGroupItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;
- (void)resizeSubviewSize;

@property (nonatomic, strong) PHAsset * asset;
@end

@implementation YYPhotoGroupCell

- (instancetype)init {
    self = super.init;
    if (!self) return nil;
    self.delegate = self;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.multipleTouchEnabled = YES;
    self.alwaysBounceVertical = NO;
//    self.showsVerticalScrollIndicator = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.frame = [UIScreen mainScreen].bounds;
    
    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    [self addSubview:_imageContainerView];
    
    _imageView = [YYAnimatedImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    [_imageContainerView addSubview:_imageView];
    
    _progressLayer = [CAShapeLayer layer];
   _progressLayer.size = CGSizeMake(40, 40);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 2;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _progressLayer.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)setItem:(YYPhotoGroupItem *)item {
    if (_item == item) return;
    _item = item;
    _itemDidLoad = NO;
    
    
    [self setZoomScale:1.0 animated:NO];
//    self.maximumZoomScale = 1;
    
    [_imageView cancelCurrentImageRequest];

    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_item) {
        _imageView.image = nil;
        return;
    }
    
    @weakify(self);
    
    [_imageView setImageWithURL:item.largeImageURL placeholder:item.thumbImage options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        @strongify(self);
        if (!self) return;
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        if (isnan(progress)) progress = 0;
        self.progressLayer.hidden = NO;
        self.progressLayer.strokeEnd = progress;
    } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        @strongify(self);
        if (!self) return;
        self.progressLayer.hidden = YES;
        if (stage == YYWebImageStageFinished) {
            self.maximumZoomScale = 3;
            if (image) {
                self->_itemDidLoad = YES;
                
                [self resizeSubviewSize];
                [self.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
            }
        }
    }];
    [self resizeSubviewSize];
}

- (void)setAsset:(PHAsset *)asset{
    if (_asset == asset) return;
    _asset = asset;
    _itemDidLoad = NO;
    
    
    [self setZoomScale:1.0 animated:NO];
    self.maximumZoomScale = 1;
    
    [_imageView cancelCurrentImageRequest];
    
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_asset) {
        _imageView.image = nil;
        return;
    }
    
   
    
//    [[JYAblumTool sharePhotoTool] requestImageForAsset:asset size:self.bounds.size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
//        _imageView.image = image;
//    }];
    
    @weakify(self);
    [[JYAblumTool sharePhotoTool] requestImageForAsset:asset size:PHImageManagerMaximumSize resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *image, NSDictionary *info) {
        @strongify(self);
        if (!self) return;
        if (self.asset == asset) {
            self.imageView.image = image;
            self.maximumZoomScale = 3;
            if (image) {
                self->_itemDidLoad = YES;
                
                [self resizeSubviewSize];
                [self.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
            }
        }
        
    }];
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    _imageContainerView.origin = CGPointZero;
 
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    self.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.height <= self.height) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end












@interface YYPhotoBrowseView() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toContainerView;

@property (nonatomic, strong) UIImage *snapshotImage;
@property (nonatomic, strong) UIImage *snapshorImageHideFromView;

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blurBackground;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *cells;
//@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, strong) UIButton * saveButton;
@property (nonatomic, strong) UILabel * pageLabel;
@property (nonatomic, assign) CGFloat pagerCurrentPage;
@property (nonatomic, assign) BOOL fromNavigationBarHidden;

@property (nonatomic, assign) NSInteger fromItemIndex;
@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;
@end

@implementation YYPhotoBrowseView
- (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (void)ca_hSaveImage:(UIButton *)sender{
    
    YYPhotoGroupCell * cell = [self cellForPage:[self currentPage]];
    
    UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (error) {
        [self showHUD:CA_H_LAN(@"保存失败")];
    } else {
        [self showHUD:CA_H_LAN(@"保存成功")];
    }
}


- (instancetype)initWithGroupItems:(NSArray *)groupItems {
    self = [super init];
    if (groupItems.count == 0) return nil;
    _groupItems = groupItems.copy;
    _blurEffectBackground = YES;
    
    NSString *model = [self machineModel];
    static NSMutableSet *oldDevices;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oldDevices = [NSMutableSet new];
        [oldDevices addObject:@"iPod1,1"];
        [oldDevices addObject:@"iPod2,1"];
        [oldDevices addObject:@"iPod3,1"];
        [oldDevices addObject:@"iPod4,1"];
        [oldDevices addObject:@"iPod5,1"];
        
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,2"];
        [oldDevices addObject:@"iPhone2,1"];
        [oldDevices addObject:@"iPhone3,1"];
        [oldDevices addObject:@"iPhone3,2"];
        [oldDevices addObject:@"iPhone3,3"];
        [oldDevices addObject:@"iPhone4,1"];
        
        [oldDevices addObject:@"iPad1,1"];
        [oldDevices addObject:@"iPad2,1"];
        [oldDevices addObject:@"iPad2,2"];
        [oldDevices addObject:@"iPad2,3"];
        [oldDevices addObject:@"iPad2,4"];
        [oldDevices addObject:@"iPad2,5"];
        [oldDevices addObject:@"iPad2,6"];
        [oldDevices addObject:@"iPad2,7"];
        [oldDevices addObject:@"iPad3,1"];
        [oldDevices addObject:@"iPad3,2"];
        [oldDevices addObject:@"iPad3,3"];
    });
    if ([oldDevices containsObject:model]) {
        _blurEffectBackground = NO;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    if (kSystemVersionDouble >= 7) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        _panGesture = pan;
    }
    
    
    _cells = @[].mutableCopy;
    
    _background = UIImageView.new;
    _background.frame = self.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _blurBackground = UIImageView.new;
    _blurBackground.frame = self.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _contentView = UIView.new;
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _scrollView = UIScrollView.new;
   _scrollView.frame = CGRectMake(-kPadding / 2, 0, self.width + kPadding, self.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = groupItems.count > 1;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    _pager = [[UIPageControl alloc] init];
    _pager.hidesForSinglePage = YES;
    _pager.userInteractionEnabled = NO;
    _pager.width = self.width - 36;
    _pager.height = 10;
    _pager.center = CGPointMake(self.width / 2, self.height - 18);
    _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    _pageLabel = [UILabel new];
    _pageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _pageLabel.font = CA_H_FONT_PFSC_Regular(12);
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    
    _saveButton = [UIButton new];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"download_icon"] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(ca_hSaveImage:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:_background];
    [self addSubview:_blurBackground];
    [self addSubview:_contentView];
    [_contentView addSubview:_scrollView];
    [_contentView addSubview:_pager];
    
    [_contentView addSubview:_pageLabel];
    [_contentView addSubview:_saveButton];
    
    _saveButton.sd_layout
    .widthIs(30*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .rightSpaceToView(_contentView, 15*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(_contentView, 15*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    
    return self;
}


- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion {
    if (!toContainer) return;
    
    _fromView = fromView;
    _toContainerView = toContainer;
    
    NSInteger page = -1;
    for (NSUInteger i = 0; i < self.groupItems.count; i++) {
        
        if([fromView isEqual:((YYPhotoGroupItem *)self.groupItems[i]).thumbView]){
            page = (int)i;
            break;
        }
    }
    if (page == -1) page = 0;
    _fromItemIndex = page;
    
    _snapshotImage = [_toContainerView snapshotImageAfterScreenUpdates:NO];
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    _snapshorImageHideFromView = [_toContainerView snapshotImage];
    fromView.hidden = fromViewHidden;
    
    _background.image = _snapshorImageHideFromView;
    if (_blurEffectBackground) {
        _blurBackground.image = [_snapshorImageHideFromView imageByBlurDark]; //Same to UIBlurEffectStyleDark
    } else {
        _blurBackground.image = [UIImage imageWithColor:[UIColor blackColor]];
    }
    
    NSString * countStr = [NSString stringWithFormat:@"%ld", self.groupItems.count];
    _pageLabel.sd_resetLayout
    .heightIs(21*CA_H_RATIO_WIDTH)
    .widthIs((18+12*countStr.length)*CA_H_RATIO_WIDTH)
    .topSpaceToView(_contentView, 15*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
    .leftSpaceToView(_contentView, 15*CA_H_RATIO_WIDTH);
    _pageLabel.sd_cornerRadius = @(3*CA_H_RATIO_WIDTH);
    
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", page+1, self.groupItems.count];
    _pageLabel.alpha = 0;
    _saveButton.hidden = YES;
    
    
    if (self.groupItems.count <= 1) {
        _pageLabel.hidden = YES;
    }
    
    self.size = _toContainerView.size;
    self.blurBackground.alpha = 0;
    self.pager.alpha = 0;
    self.pager.numberOfPages = self.groupItems.count;
    self.pager.currentPage = page;
    [_toContainerView addSubview:self];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.width, _scrollView.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    [UIView setAnimationsEnabled:YES];
    _fromNavigationBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    
    if (@available(iOS 9.0, *)) {
        if (_getControllerBlock) {
            UIViewController * vc = _getControllerBlock(YES);
            [vc prefersStatusBarHidden];
            [vc performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    }
    
    
    YYPhotoGroupCell *cell = [self cellForPage:self.currentPage];
    YYPhotoGroupItem *item = _groupItems[self.currentPage];
    
    if (!item.thumbClippedToTop) {
        NSString *imageKey = [[YYWebImageManager sharedManager] cacheKeyForURL:item.largeImageURL];
        if ([[YYWebImageManager sharedManager].cache getImageForKey:imageKey withType:YYImageCacheTypeMemory]) {
            cell.item = item;
        }
    }
    if (!cell.item) {
        cell.imageView.image = item.thumbImage;
        [cell resizeSubviewSize];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    if (item.thumbClippedToTop) {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
        CGRect originFrame = cell.imageContainerView.frame;
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width;
        
        cell.imageContainerView.centerX = CGRectGetMidX(fromFrame);
        cell.imageContainerView.height = fromFrame.size.height / scale;
        cell.imageContainerView.layer.transformScale = scale;
        cell.imageContainerView.centerY = CGRectGetMidY(fromFrame);
        
        float oneTime = animated ? 0.25 : 0;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _blurBackground.alpha = 1;
        }completion:NULL];
        
        _scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageContainerView.layer.transformScale = 1;
            cell.imageContainerView.frame = originFrame;
            _pager.alpha = 1;
            _pageLabel.alpha = 1;
            _saveButton.hidden = NO;
        }completion:^(BOOL finished) {
            _isPresented = YES;
            [self scrollViewDidScroll:_scrollView];
            _scrollView.userInteractionEnabled = YES;
            [self hidePager];
            if (completion) completion();
        }];
        
    } else {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell.imageContainerView];
        
        cell.imageContainerView.clipsToBounds = NO;
        cell.imageView.frame = fromFrame;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        float oneTime = animated ? 0.25 : 0;
        [UIView animateWithDuration:oneTime*2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _blurBackground.alpha = 1;
        }completion:NULL];
        
        _scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageView.frame = cell.imageContainerView.bounds;
            cell.imageView.layer.transformScale = 1.01;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.imageView.layer.transformScale = 1.0;
                _pager.alpha = 1;
                _pageLabel.alpha = 1;
                _saveButton.hidden = NO;
            }completion:^(BOOL finished) {
                cell.imageContainerView.clipsToBounds = YES;
                _isPresented = YES;
                [self scrollViewDidScroll:_scrollView];
                _scrollView.userInteractionEnabled = YES;
                [self hidePager];
                if (completion) completion();
            }];
        }];
    }
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView setAnimationsEnabled:YES];
    
    
    if (@available(iOS 11.0, *)) {
        if (_getControllerBlock) {
            UIViewController * vc = _getControllerBlock(_fromNavigationBarHidden);
            [vc prefersStatusBarHidden];
            [vc performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    }
    
    NSInteger currentPage = self.currentPage;
    YYPhotoGroupCell *cell = [self cellForPage:currentPage];
    YYPhotoGroupItem *item = _groupItems[currentPage];
    
    UIView *fromView = nil;
    if (_fromItemIndex == currentPage) {
        fromView = _fromView;
    } else {
        fromView = item.thumbView;
    }
    
    [self cancelAllImageLoad];
    _isPresented = NO;
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame = frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    
    
    
    
    if (fromView == nil) {
        self.background.image = _snapshotImage;
        [UIView animateWithDuration:animated ? 0.25 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
            self.scrollView.layer.transformScale = 0.95;
            self.scrollView.alpha = 0;
            self.pager.alpha = 0;
            _pageLabel.alpha = 0;
            _saveButton.hidden = YES;
            self.blurBackground.alpha = 0;
        }completion:^(BOOL finished) {
            self.scrollView.layer.transformScale = 1;
            [self removeFromSuperview];
            [self cancelAllImageLoad];
            if (completion) completion();
        }];
        return;
    }
    
    if (_fromItemIndex != currentPage) {
        _background.image = _snapshotImage;
        [_background.layer addFadeAnimationWithDuration:0.25 curve:UIViewAnimationCurveEaseOut];
    } else {
        _background.image = _snapshorImageHideFromView;
    }

    
    if (isFromImageClipped) {
        CGPoint off = cell.contentOffset;
        off.y = 0 - cell.contentInset.top;
        [cell setContentOffset:off animated:animated];
    }
    
    for (YYPhotoGroupCell * ce in _cells) {
        if (ce != cell) {
            ce.hidden = YES;
        }
    }
    
    
    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _pageLabel.alpha = 0;
        _saveButton.hidden = YES;
        _pager.alpha = 0.0;
        _blurBackground.alpha = 0.0;
        if (isFromImageClipped) {
            
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell];
            CGFloat scale = fromFrame.size.width / cell.imageContainerView.width * cell.zoomScale;
            CGFloat height = fromFrame.size.height / fromFrame.size.width * cell.imageContainerView.width;
            if (isnan(height)) height = cell.imageContainerView.height;
            
            cell.imageContainerView.height = height;
            cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
            cell.imageContainerView.layer.transformScale = scale;
            
        } else {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
            cell.imageContainerView.clipsToBounds = NO;
            cell.clipsToBounds = NO;
            _scrollView.clipsToBounds = NO;
            cell.imageView.contentMode = fromView.contentMode;
            cell.imageView.frame = fromFrame;
        }
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self removeFromSuperview];
            if (completion) completion();
        }];
    }];
    
    
}

- (void)dismiss {
    [self dismissAnimated:YES completion:nil];
}


- (void)cancelAllImageLoad {
    [_cells enumerateObjectsUsingBlock:^(YYPhotoGroupCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.imageView cancelCurrentImageRequest];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCellsForReuse];
    
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.width;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    
    for (NSInteger i = page - 1; i <= page + 1; i++) { // preload left and right cell
        if (i >= 0 && i < self.groupItems.count) {
            YYPhotoGroupCell *cell = [self cellForPage:i];
            if (!cell) {
                YYPhotoGroupCell *cell = [self dequeueReusableCell];
                cell.page = i;
                cell.left = (self.width + kPadding) * i + kPadding / 2;
                
                if (_isPresented) {
                    cell.item = self.groupItems[i];
                }
                [self.scrollView addSubview:cell];
            } else {
                if (_isPresented && !cell.item) {
                    cell.item = self.groupItems[i];
                }
            }
        }
    }
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _groupItems.count ? (int)_groupItems.count - 1 : intPage;
    _pager.currentPage = intPage;
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", intPage+1, self.groupItems.count];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _pager.alpha = 1;
        _pageLabel.alpha = 1;
        _saveButton.hidden = NO;
    }completion:^(BOOL finish) {
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self hidePager];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidePager];
}


- (void)hidePager {
        [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
            _pager.alpha = 0;
            _pageLabel.alpha = 0;
        }completion:^(BOOL finish) {
        }];
}

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (YYPhotoGroupCell *cell in _cells) {
        if (cell.superview) {
            if (cell.left > _scrollView.contentOffset.x + _scrollView.width * 2||
                cell.right < _scrollView.contentOffset.x - _scrollView.width) {
                [cell removeFromSuperview];
                cell.page = -1;
                cell.item = nil;
            }else if (cell.left > _scrollView.contentOffset.x + _scrollView.width ||
                      cell.right < _scrollView.contentOffset.x ) {
                [cell setZoomScale:1];
            }
        }
    }
}

/// dequeue a reusable cell
- (YYPhotoGroupCell *)dequeueReusableCell {
    YYPhotoGroupCell *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [YYPhotoGroupCell new];
    cell.frame = self.bounds;
    cell.imageContainerView.frame = self.bounds;
    cell.imageView.frame = cell.bounds;
    cell.page = -1;
    cell.item = nil;
    [_cells addObject:cell];
    return cell;
}

/// get the cell for specified page, nil if the cell is invisible
- (YYPhotoGroupCell *)cellForPage:(NSInteger)page {
    for (YYPhotoGroupCell *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}

- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    if (page >= _groupItems.count) page = (NSInteger)_groupItems.count - 1;
    if (page < 0) page = 0;
    return page;
}

- (void)showHUD:(NSString *)msg {
    if (!msg.length) return;
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = [msg sizeWithFont:font constrainedToSize:CGSizeMake(200, 200) lineBreakMode:NSLineBreakByCharWrapping];//[msg sizeForFont:font size:CGSizeMake(200, 200) mode:NSLineBreakByCharWrapping];
    UILabel *label = [UILabel new];
    label.size = CGSizePixelCeil(size);
    label.font = font;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    
    UIView *hud = [UIView new];
    hud.size = CGSizeMake(label.width + 20, label.height + 20);
    hud.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.650];
    hud.clipsToBounds = YES;
    hud.layer.cornerRadius = 8;
    
    label.center = CGPointMake(hud.width / 2, hud.height / 2);
    [hud addSubview:label];
    
    hud.center = CGPointMake(self.width / 2, self.height / 2);
    hud.alpha = 0;
    [self addSubview:hud];
    
    [UIView animateWithDuration:0.4 animations:^{
        hud.alpha = 1;
    }];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.4 animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
        }];
    });
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    if (!_isPresented) return;
    YYPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (tile) {
        if (tile.zoomScale > 1) {
            [tile setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [g locationInView:tile.imageView];
            CGFloat newZoomScale = tile.maximumZoomScale;
            CGFloat xsize = self.width / newZoomScale;
            CGFloat ysize = self.height / newZoomScale;
            [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

- (void)longPress {
    if (!_isPresented) return;
    
    YYPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (!tile.imageView.image) return;
    
    // try to save original image data if the image contains multi-frame (such as GIF/APNG)
    id imageItem = [tile.imageView.image imageDataRepresentation];
    YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem));
    if (type != YYImageTypePNG &&
        type != YYImageTypeJPEG &&
        type != YYImageTypeGIF) {
        imageItem = tile.imageView.image;
    }
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[imageItem] applicationActivities:nil];
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.sourceView = self;
    }

    UIViewController *toVC = self.toContainerView.viewController;
    if (!toVC) toVC = self.viewController;
    [toVC presentViewController:activityViewController animated:YES completion:nil];
}

- (void)pan:(UIPanGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [g locationInView:self];
            } else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [g locationInView:self];
            
            if (_scrollView.top + p.y < 0) {
                return;
            }
            
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            _scrollView.top = deltaY;
            _scrollView.left = p.x - _panGestureBeginPoint.x;
            
            CGFloat alphaDelta = CA_H_SCREEN_HEIGHT/2;//160;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            alpha = YY_CLAMP(alpha, 0, 1);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                _blurBackground.alpha = alpha;
                _pager.alpha = alpha;
                _pageLabel.alpha = alpha;
                _saveButton.hidden = YES;
            } completion:nil];
            
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [g velocityInView:self];
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                
                [self dismiss];
                
                
            } else {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _scrollView.top = 0;
                    _scrollView.left = -kPadding / 2;
                    _blurBackground.alpha = 1;
                    _pager.alpha = 1;
                    _pageLabel.alpha = 1;
                    _saveButton.hidden = NO;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        } break;
        case UIGestureRecognizerStateCancelled : {
            _scrollView.top = 0;
            _scrollView.left = -kPadding / 2;
            _blurBackground.alpha = 1;
        }
        default:break;
    }
}

@end







@interface CA_HChoosePhotoBrowseView() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
//@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toContainerView;

@property (nonatomic, strong) UIImage *snapshotImage;
@property (nonatomic, strong) UIImage *snapshorImageHideFromView;

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blurBackground;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *cells;

@property (nonatomic, strong) UILabel * pageLabel;
@property (nonatomic, assign) CGFloat pagerCurrentPage;

@property (nonatomic, assign) NSInteger fromItemIndex;
@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) CALayer *subLayer;
@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, copy) NSUInteger (^selectedBlock)(NSInteger isSelected, PHAsset *asset);

@end

@implementation CA_HChoosePhotoBrowseView

- (void)onChooseButton:(UIButton *)sender{
    if (_selectedBlock) {
        self.number = _selectedBlock(!sender.selected, self.groupItems[[self currentPage]]);
        
    }
}

- (void)setNumber:(NSUInteger)number{
    _number = number;

    CA_H_WeakSelf(self);
    CA_H_DISPATCH_MAIN_THREAD((^{
        CA_H_StrongSelf(self);
        if (number > 0) {
            [self.chooseButton setTitle:[NSString stringWithFormat:@"%ld", number] forState:UIControlStateNormal];
            self.chooseButton.selected = YES;
        }else{
            [self.chooseButton setTitle:@"" forState:UIControlStateNormal];
            self.chooseButton.selected = NO;
        }
    }));
}

- (CALayer *)subLayer {
    if (!_subLayer) {
        CALayer *subLayer=[CALayer layer];
        _subLayer = subLayer;
        
        UIColor *shadowColor = [UIColor blackColor];
        
        subLayer.cornerRadius = 2*CA_H_RATIO_WIDTH;
        
        UIImage *image = [[UIImage imageNamed:@"pic_choose_big_icon"] imageByResizeToSize:CGSizeMake(24*CA_H_RATIO_WIDTH, 24*CA_H_RATIO_WIDTH)];
        subLayer.backgroundColor= [UIColor colorWithPatternImage:image].CGColor;
        subLayer.masksToBounds = NO;
        subLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.5;//阴影透明度，默认0
        subLayer.shadowRadius = 6*CA_H_RATIO_WIDTH;//阴影半径，默认3
        
        [self.layer insertSublayer:subLayer below:self.chooseButton.layer];
    }
    return _subLayer;
}

- (UIButton *)chooseButton{
    if (!_chooseButton) {
        UIButton *button = [UIButton new];
        _chooseButton = button;
        
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        
        [button setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
        [button.titleLabel setFont:CA_H_FONT_PFSC_Semibold(14)];
        
        [button addTarget:self action:@selector(onChooseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        CA_H_WeakSelf(self);
        button.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(self);
            self.subLayer.frame= frame;
        };
        
        [self addSubview:button];
        
        button.sd_layout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .topSpaceToView(self, 20*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self, 20*CA_H_RATIO_WIDTH);
        
//        button.sd_cornerRadius = @(2*CA_H_RATIO_WIDTH);
        button.layer.cornerRadius = 2*CA_H_RATIO_WIDTH;
        button.layer.masksToBounds = YES;
        
    }
    return _chooseButton;
}

- (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (instancetype)initWithGroupAssets:(NSArray *)groupAssets page:(NSInteger)page view:(UIView *)view selectedBlock:(NSUInteger (^)(NSInteger isSelected, PHAsset *asset))selectedBlock{
    
    self = [super init];
    if (groupAssets.count == 0) return nil;
    _selectedBlock = selectedBlock;
    _groupItems = groupAssets.copy;
    _blurEffectBackground = YES;
    
    NSString *model = [self machineModel];
    static NSMutableSet *oldDevices;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oldDevices = [NSMutableSet new];
        [oldDevices addObject:@"iPod1,1"];
        [oldDevices addObject:@"iPod2,1"];
        [oldDevices addObject:@"iPod3,1"];
        [oldDevices addObject:@"iPod4,1"];
        [oldDevices addObject:@"iPod5,1"];
        
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,2"];
        [oldDevices addObject:@"iPhone2,1"];
        [oldDevices addObject:@"iPhone3,1"];
        [oldDevices addObject:@"iPhone3,2"];
        [oldDevices addObject:@"iPhone3,3"];
        [oldDevices addObject:@"iPhone4,1"];
        
        [oldDevices addObject:@"iPad1,1"];
        [oldDevices addObject:@"iPad2,1"];
        [oldDevices addObject:@"iPad2,2"];
        [oldDevices addObject:@"iPad2,3"];
        [oldDevices addObject:@"iPad2,4"];
        [oldDevices addObject:@"iPad2,5"];
        [oldDevices addObject:@"iPad2,6"];
        [oldDevices addObject:@"iPad2,7"];
        [oldDevices addObject:@"iPad3,1"];
        [oldDevices addObject:@"iPad3,2"];
        [oldDevices addObject:@"iPad3,3"];
    });
    if ([oldDevices containsObject:model]) {
        _blurEffectBackground = NO;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = view.bounds;
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    
    _cells = @[].mutableCopy;
    
    _background = UIImageView.new;
    _background.frame = self.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _blurBackground = UIImageView.new;
    _blurBackground.frame = self.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _contentView = UIView.new;
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _scrollView = UIScrollView.new;
    _scrollView.frame = CGRectMake(-kPadding / 2, 0, self.width + kPadding, self.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = groupAssets.count > 1;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    _pager = [[UIPageControl alloc] init];
    _pager.hidesForSinglePage = YES;
    _pager.userInteractionEnabled = NO;
    _pager.width = self.width - 36;
    _pager.height = 10;
    _pager.center = CGPointMake(self.width / 2, self.height - 18);
    _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    _pageLabel = [UILabel new];
    _pageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _pageLabel.font = CA_H_FONT_PFSC_Regular(12);
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self addSubview:_background];
    [self addSubview:_blurBackground];
    [self addSubview:_contentView];
    [_contentView addSubview:_scrollView];
    [_contentView addSubview:_pager];
    
    [_contentView addSubview:_pageLabel];
    
    
    [self show:page view:view];
    
    return self;
}

- (void)show:(NSInteger)page view:(UIView *)view{
    if (!view) return;
    
    _toContainerView = view;
    
    _fromItemIndex = page<0?0:page;
    
    _snapshotImage = [view snapshotImageAfterScreenUpdates:NO];
    
    _snapshorImageHideFromView = [view snapshotImage];
    _background.image = _snapshorImageHideFromView;
    if (_blurEffectBackground) {
        _blurBackground.image = [_snapshorImageHideFromView imageByBlurDark]; //Same to UIBlurEffectStyleDark
    } else {
        _blurBackground.image = [UIImage imageWithColor:[UIColor blackColor]];
    }
    
    NSString * countStr = [NSString stringWithFormat:@"%ld", self.groupItems.count];
    _pageLabel.sd_resetLayout
    .heightIs(21*CA_H_RATIO_WIDTH)
    .widthIs((18+12*countStr.length)*CA_H_RATIO_WIDTH)
    .topSpaceToView(_contentView, 15*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight)
    .leftSpaceToView(_contentView, 15*CA_H_RATIO_WIDTH);
    _pageLabel.sd_cornerRadius = @(3*CA_H_RATIO_WIDTH);
    
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", _fromItemIndex+1, self.groupItems.count];
    _pageLabel.alpha = 0;
    
    
    if (self.groupItems.count <= 1) {
        _pageLabel.hidden = YES;
    }
    
    self.size = view.size;
    self.blurBackground.alpha = 0;
    self.pager.alpha = 0;
    self.pager.numberOfPages = self.groupItems.count;
    self.pager.currentPage = _fromItemIndex;
    [view addSubview:self];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.width, _scrollView.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    [UIView setAnimationsEnabled:YES];
    
    
    YYPhotoGroupCell *cell = [self cellForPage:self.currentPage];
    PHAsset *asset = _groupItems[self.currentPage];
    cell.asset = asset;
    
    _blurBackground.alpha = 1;
    cell.imageContainerView.clipsToBounds = NO;
    cell.imageContainerView.layer.transformScale = 1;
    cell.imageContainerView.frame = view.bounds;
    cell.imageView.frame = cell.imageContainerView.bounds;
    _pager.alpha = 1;
    _pageLabel.alpha = 1;
    _isPresented = YES;
    [self scrollViewDidScroll:_scrollView];
    _scrollView.userInteractionEnabled = YES;
    [self hidePager];
    
    if (_selectedBlock) {
        self.number = _selectedBlock(2, self.groupItems[[self currentPage]]);
    }
}

- (void)cancelAllImageLoad {
    [_cells enumerateObjectsUsingBlock:^(YYPhotoGroupCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.imageView cancelCurrentImageRequest];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCellsForReuse];
    
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.width;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    
    for (NSInteger i = page - 1; i <= page + 1; i++) { // preload left and right cell
        if (i >= 0 && i < self.groupItems.count) {
            YYPhotoGroupCell *cell = [self cellForPage:i];
            if (!cell) {
                YYPhotoGroupCell *cell = [self dequeueReusableCell];
                cell.page = i;
                cell.left = (self.width + kPadding) * i + kPadding / 2;
                
                if (_isPresented) {
                    cell.asset = self.groupItems[i];
                }
                [self.scrollView addSubview:cell];
            } else {
                if (_isPresented && !cell.item) {
                    cell.asset = self.groupItems[i];
                }
            }
        }
    }
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _groupItems.count ? (int)_groupItems.count - 1 : intPage;
    _pager.currentPage = intPage;
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", intPage+1, self.groupItems.count];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _pager.alpha = 1;
        _pageLabel.alpha = 1;
    }completion:^(BOOL finish) {
    }];
    
    if (_selectedBlock) {
        self.number = _selectedBlock(2, self.groupItems[intPage]);
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self hidePager];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidePager];
}


- (void)hidePager {
    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        _pager.alpha = 0;
        _pageLabel.alpha = 0;
    }completion:^(BOOL finish) {
    }];
}

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (YYPhotoGroupCell *cell in _cells) {
        if (cell.superview) {
            if (cell.left > _scrollView.contentOffset.x + _scrollView.width * 2||
                cell.right < _scrollView.contentOffset.x - _scrollView.width) {
                [cell removeFromSuperview];
                cell.page = -1;
                cell.asset = nil;
            }else if (cell.left > _scrollView.contentOffset.x + _scrollView.width ||
                      cell.right < _scrollView.contentOffset.x ) {
                [cell setZoomScale:1];
            }
        }
    }
}

/// dequeue a reusable cell
- (YYPhotoGroupCell *)dequeueReusableCell {
    YYPhotoGroupCell *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [YYPhotoGroupCell new];
    cell.frame = self.bounds;
    cell.imageContainerView.frame = self.bounds;
    cell.imageView.frame = cell.bounds;
    cell.page = -1;
    cell.asset = nil;
    [_cells addObject:cell];
    return cell;
}

/// get the cell for specified page, nil if the cell is invisible
- (YYPhotoGroupCell *)cellForPage:(NSInteger)page {
    for (YYPhotoGroupCell *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}

- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    if (page >= _groupItems.count) page = (NSInteger)_groupItems.count - 1;
    if (page < 0) page = 0;
    return page;
}


- (void)doubleTap:(UITapGestureRecognizer *)g {
    if (!_isPresented) return;
    YYPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (tile) {
        if (tile.zoomScale > 1) {
            [tile setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [g locationInView:tile.imageView];
            CGFloat newZoomScale = tile.maximumZoomScale;
            CGFloat xsize = self.width / newZoomScale;
            CGFloat ysize = self.height / newZoomScale;
            [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

- (void)longPress {
    if (!_isPresented) return;
    
    YYPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (!tile.imageView.image) return;
    
    // try to save original image data if the image contains multi-frame (such as GIF/APNG)
    id imageItem = [tile.imageView.image imageDataRepresentation];
    YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem));
    if (type != YYImageTypePNG &&
        type != YYImageTypeJPEG &&
        type != YYImageTypeGIF) {
        imageItem = tile.imageView.image;
    }
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[imageItem] applicationActivities:nil];
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.sourceView = self;
    }
    
    UIViewController *toVC = self.toContainerView.viewController;
    if (!toVC) toVC = self.viewController;
    [toVC presentViewController:activityViewController animated:YES completion:nil];
}

@end
