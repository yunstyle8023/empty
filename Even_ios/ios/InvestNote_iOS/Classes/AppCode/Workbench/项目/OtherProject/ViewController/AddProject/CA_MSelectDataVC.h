//
//  CA_MSelectDataVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "MYPresentedController.h"

@interface CA_MSelectDataVC : MYPresentedController
@property (nonatomic,copy) NSString *requestUrl;
@property (nonatomic,copy) NSString *className;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,assign,getter=isProgress) BOOL progress;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end
