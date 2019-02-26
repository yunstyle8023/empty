//
//  CA_MDiscoverRelatedPersonViewManager.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MDiscoverRelatedPersonData_list;
@interface CA_MDiscoverRelatedPersonViewManager : NSObject
@property (nonatomic,copy) NSString *enterprise_str;
@property (nonatomic,copy) NSString *personName;
@property (nonatomic,strong) UIView *allView;//全部
@property (nonatomic,strong) UIView *legalView;//担任法人
@property (nonatomic,strong) UIView *investmentView;//投资的公司
@property (nonatomic,strong) UIView *officeView;//任职的公司
@property (nonatomic,copy) void(^pushBlock)(CA_MDiscoverRelatedPersonData_list *model);

@end
