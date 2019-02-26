//
//  CA_MProjectNotFoundView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MProjectNotFoundView : UIView

@property (nonatomic,copy) void(^finishedBlock)(UIButton *sender);

-(void)showView;

-(void)hideView;


@end
