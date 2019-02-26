//
//  CA_MNewPersonViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MNewPersonViewModel : NSObject
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) dispatch_block_t finishedBlock;
@property (nonatomic,copy) dispatch_block_t refreshBlock;
@property (nonatomic,copy) dispatch_block_t loadMoreBlock;
//@property (nonatomic,copy) dispatch_block_t deleteBlock;
@property (nonatomic,strong) NSMutableArray *tagList;
-(void)deletePersonWithId:(NSNumber *)human_id success:(dispatch_block_t)deleteBlock;
@end
