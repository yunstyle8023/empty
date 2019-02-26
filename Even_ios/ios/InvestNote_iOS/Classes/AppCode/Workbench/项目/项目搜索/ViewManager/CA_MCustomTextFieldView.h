//
//  CA_MCustomTextFieldView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_MCustomAccessoryView;

@protocol CA_MCustomTextFieldViewDelegate <NSObject>
-(void)jump2AddProject;
-(void)textDidChange:(NSString*)content;
-(void)keyboradChange;
@end

@interface CA_MCustomTextFieldView : UIView
<
UITextFieldDelegate
>

@property(nonatomic,strong)UITextField* txtField;

@property(nonatomic,strong)CA_MCustomAccessoryView* accessoryView;

@property(nonatomic,weak)id<CA_MCustomTextFieldViewDelegate> deleagte;

@end
