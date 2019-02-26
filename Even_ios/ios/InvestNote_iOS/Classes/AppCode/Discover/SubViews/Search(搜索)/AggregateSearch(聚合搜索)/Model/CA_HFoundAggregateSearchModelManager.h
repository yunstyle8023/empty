//
//  CA_HFoundAggregateSearchModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HFoundSearchModel.h"

@interface CA_HFoundAggregateSearchModelManager : NSObject

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) NSArray *recentSearch;
@property (nonatomic, strong) NSArray *recentBrowse;
@property (nonatomic, strong) CA_HFoundSearchAggregationModel *model;


@property (nonatomic, copy) void (^finishBlock)(void);
- (void)loadMore;

- (NSArray *)data:(NSInteger)section;
- (NSString *)headerTitle:(NSInteger)section;
- (NSString *)count:(NSInteger)section;

- (void)saveSearch:(NSString *)text;
- (void)saveBrowse:(NSDictionary *)dic;
- (void)cleanSearch;
- (void)cleanBrowse;

@end
