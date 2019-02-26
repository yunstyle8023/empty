//
//  CA_MSettingPanelViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JXMovableCellTableView;
@interface CA_MSettingPanelViewManager : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIBarButtonItem *rightBarBtn;
@property (nonatomic,copy) dispatch_block_t rightBlock;
@property (nonatomic,strong) JXMovableCellTableView *tableView;
@end
