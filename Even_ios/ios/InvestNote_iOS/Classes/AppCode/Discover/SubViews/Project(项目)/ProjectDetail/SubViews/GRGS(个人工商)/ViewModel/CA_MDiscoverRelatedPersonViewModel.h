//
//  CA_MDiscoverRelatedPersonViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MDiscoverRelatedPersonViewModel : NSObject
@property (nonatomic,copy) NSString *personName;
@property (nonatomic,strong) NSMutableArray *itemNames;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) dispatch_block_t finishedBlock;
@end
