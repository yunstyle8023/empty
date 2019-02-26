//
//  CA_MApproveDetailFooterView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CA_MApproveDetailFooterViewDelegate <NSObject>
-(void)operationClick:(NSInteger)index;
@end

@interface CA_MApproveDetailFooterView : UIView
@property (nonatomic,weak) id<CA_MApproveDetailFooterViewDelegate> delegate;
@end
