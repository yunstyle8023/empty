//
//  CA_MMyApproveView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CA_MMyApproveViewDelegaet <NSObject>
-(void)didSelect:(NSInteger)index;
@end

@interface CA_MMyApproveView : UIView
@property (nonatomic,weak) id<CA_MMyApproveViewDelegaet> delegate;
-(void)scroll:(CGFloat)x;
-(void)scrollDidEnd:(NSInteger)index;
@end
