//
//  CA_MPersonDetailBottomView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CA_MPersonDetailBottomViewDelegate <NSObject>
-(void)wechatClick;
-(void)mssageClick;
-(void)telClick;
@end

@interface CA_MPersonDetailBottomView : UIView
@property (nonatomic,weak) id<CA_MPersonDetailBottomViewDelegate> delegate;
@end
