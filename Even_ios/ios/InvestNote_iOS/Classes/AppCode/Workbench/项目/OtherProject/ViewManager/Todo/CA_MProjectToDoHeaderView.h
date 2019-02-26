//
//  CA_MProjectToDoHeaderView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CA_MProjectToDoHeaderViewDelegate <NSObject>
-(void)didSelect:(BOOL)isFinished;
@end

@interface CA_MProjectToDoHeaderView : UIView
@property(nonatomic,weak)id<CA_MProjectToDoHeaderViewDelegate> delegate;
@end
