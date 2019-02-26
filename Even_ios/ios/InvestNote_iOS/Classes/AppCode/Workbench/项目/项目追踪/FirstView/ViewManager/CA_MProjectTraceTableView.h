//
//  CA_MProjectTraceTableView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MProjectTraceTableView : UITableView

@property (nonatomic,copy) void(^loadDataBlock)(NSNumber *member_type_id,BOOL is_relation,NSNumber *project_id);

@end
