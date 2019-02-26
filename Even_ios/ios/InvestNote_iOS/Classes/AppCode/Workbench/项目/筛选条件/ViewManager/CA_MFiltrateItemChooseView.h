//
//  CA_MFiltrateItemChooseView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MFiltrateItemChooseView : UIView

@property (nonatomic,copy) dispatch_block_t cancelBlock;

@property (nonatomic,copy) dispatch_block_t confirmBlock;

@end
