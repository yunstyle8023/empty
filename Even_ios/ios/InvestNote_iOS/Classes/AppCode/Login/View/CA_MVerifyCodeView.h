//
//  CA_MVerifyCodeView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IsCorrect)(BOOL isCorrect);

@interface CA_MVerifyCodeView : UIView
@property(nonatomic,copy)IsCorrect isCorrect;
-(void)showInView:(UIView*)superView;
@end
