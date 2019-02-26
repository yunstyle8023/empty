//
//  CA_MDiscoverSponsorDetailBottomView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MDiscoverSponsorDetailBottomView : UIView
@property (nonatomic,strong) NSNumber *count;
@property (nonatomic,assign) BOOL isLook;
@property (nonatomic,copy) dispatch_block_t selectBlock;
@end
