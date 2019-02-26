//
//  CA_MDiscoverInvestmentDetailViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CA_MDiscoverInvestmentDetailModel;

@interface CA_MDiscoverInvestmentDetailViewModel : NSObject
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) NSString *data_id;
@property (nonatomic,strong) NSMutableArray *headerTitles;
@property (nonatomic,strong) CA_MDiscoverInvestmentDetailModel *detailModel;
@property (nonatomic,copy) dispatch_block_t finishedBlock;
@property (nonatomic,assign,getter=isFinished) BOOL finished;
@end
