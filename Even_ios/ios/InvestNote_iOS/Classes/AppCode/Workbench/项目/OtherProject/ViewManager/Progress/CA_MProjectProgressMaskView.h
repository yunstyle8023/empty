//
//  CA_MProjectProgressMaskView.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MProjectProgressMaskView : UIView
/// 显示的标题
@property(nonatomic,copy)NSString* title;
/// 占位文字
@property(nonatomic,copy)NSString* placeHolder;
/// 按钮显示的文字
@property(nonatomic,copy)NSString* confirmString;
/// confirm按钮点击事件
@property(nonatomic,copy)void(^confirmClick)(NSString* content);

- (void)showMaskView;

@end
