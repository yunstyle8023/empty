//
//  CA_MSettingPanelEditCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

@interface CA_MSettingPanelEditCell : CA_HBaseTableCell
@property (nonatomic,copy) void(^switchBlock)(UISwitch *sender);
@end
