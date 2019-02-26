//
//  CA_MProjectSelectResultView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CA_MProjectSelectResultViewDelegate <NSObject>
@optional
- (void)cancelClick;
@end

@interface CA_MProjectSelectResultView : UIView
@property(nonatomic,copy)NSString* title;
@property(nonatomic,weak)id<CA_MProjectSelectResultViewDelegate>delegate;
@end
