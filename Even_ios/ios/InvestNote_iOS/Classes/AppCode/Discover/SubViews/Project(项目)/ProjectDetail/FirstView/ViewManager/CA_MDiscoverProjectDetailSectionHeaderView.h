//
//  CA_MDiscoverProjectDetailSectionHeaderView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MDiscoverProjectDetailSectionHeaderView : UIView
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) BOOL showArrowImg;
@property (nonatomic,copy) dispatch_block_t didSelected;
@end
