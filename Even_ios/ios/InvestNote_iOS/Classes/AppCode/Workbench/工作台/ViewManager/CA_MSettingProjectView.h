//
//  CA_MSettingProjectView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MSettingModel.h"

@protocol CA_MSettingProjectViewDelegate <NSObject>
@optional
-(void)changeWorkSpace;
@end

@interface CA_MSettingProjectView : UIView
@property(nonatomic,weak)id<CA_MSettingProjectViewDelegate> delegate;
@property (nonatomic,strong) CA_MSettingModel *model;
@end
