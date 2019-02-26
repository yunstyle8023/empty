//
//  CA_MProjectAddMemberVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

@interface CA_MProjectAddMemberVC : CA_HBaseViewController
@property (nonatomic,strong) NSNumber *project_id;
@property (nonatomic,assign,getter=isAddManage) BOOL addManage;
@property (nonatomic,copy) dispatch_block_t block;
@property (nonatomic,copy) NSString *member_type;
@end
