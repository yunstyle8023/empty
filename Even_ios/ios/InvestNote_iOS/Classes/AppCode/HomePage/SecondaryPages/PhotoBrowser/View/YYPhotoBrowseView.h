//
//  YYPhotoGroupView.h
//
//  Created by ibireme on 14/3/9.
//  Copyright (C) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JYAblumTool.h"

/// Single picture's info.
@interface YYPhotoGroupItem : NSObject
@property (nonatomic, strong) UIView *thumbView; ///< thumb image, used for animation position calculation
@property (nonatomic, assign) CGSize largeImageSize;
@property (nonatomic, strong) NSURL *largeImageURL;
@end


/// Used to show a group of images.
/// One-shot.
@interface YYPhotoBrowseView : UIView
@property (nonatomic, readonly) NSArray *groupItems; ///< Array<YYPhotoGroupItem>
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, assign) BOOL blurEffectBackground; ///< Default is YES
@property (nonatomic, strong) UIPageControl *pager;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGroupItems:(NSArray *)groupItems;

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismiss;

@property (nonatomic, copy) UIViewController * (^getControllerBlock)(BOOL statusBarHidden);
@end



@interface CA_HChoosePhotoBrowseView : UIView

@property (nonatomic, readonly) NSArray *groupItems; ///< Array<YYPhotoGroupItem>
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, assign) BOOL blurEffectBackground; ///< Default is YES
@property (nonatomic, strong) UIPageControl *pager;

- (instancetype)initWithGroupAssets:(NSArray *)groupAssets page:(NSInteger)page view:(UIView *)view selectedBlock:(NSUInteger (^)(NSInteger isSelected, PHAsset *asset))selectedBlock;

@end
