//
//  CA_HFoundSearchModelManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HFoundSearchModel.h"

typedef enum : NSUInteger {
    CA_HFoundSearchTypeProject = 0,
    CA_HFoundSearchTypeEnterprise,
    CA_HFoundSearchTypeLp,
    CA_HFoundSearchTypeGp
} CA_HFoundSearchType;

@interface CA_HFoundSearchModelManager : NSObject

@property (nonatomic, strong) CA_HFoundSearchModel *model;

@property (nonatomic, assign) CA_HFoundSearchType type;

@property (nonatomic, copy) NSString *recentSearchKey;
@property (nonatomic, copy) NSString *recentBrowseKey;
@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, copy) NSString *cellClassStr;
@property (nonatomic, copy) NSString *countText;
@property (nonatomic, copy) NSString *nullText;
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, copy) NSString *searchHolder;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *headerText;

@property (nonatomic, strong) NSArray *recentSearch;
@property (nonatomic, strong) NSArray *recentBrowse;
@property (nonatomic, strong) NSMutableArray *data;


- (void)saveSearch:(NSString *)text;
- (void)saveBrowse:(NSDictionary *)dic;
- (void)cleanSearch;
- (void)cleanBrowse;

@property (nonatomic, copy) void (^finishBlock)(BOOL noMore);
- (void)loadMore;

@end
