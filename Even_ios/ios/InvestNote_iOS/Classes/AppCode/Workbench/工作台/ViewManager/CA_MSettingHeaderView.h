//
//  CA_MSettingHeaderView.h
//  InvestNote_iOS
//  Created by yezhuge on 2017/11/25.
//  God bless me without no bugs.
//

#import <UIKit/UIKit.h>

@interface CA_MSettingHeaderView : UIView

@property(nonatomic,copy)NSString* title;

@property(nonatomic,copy)NSString* titleColor;

@property(nonatomic,assign)CGFloat font;

@property (nonatomic,assign) BOOL notFoundBtnHidden;

@property (nonatomic,copy) void(^notFoundBlock)(UIButton *sender);

@end
