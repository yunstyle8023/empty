//
//  CA_MNewSelectProjectViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MNewSelectProjectViewModel : NSObject
@property (nonatomic,strong) NSNumber *pool_id;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString *field;
@property (nonatomic,copy) dispatch_block_t finished;
@end
