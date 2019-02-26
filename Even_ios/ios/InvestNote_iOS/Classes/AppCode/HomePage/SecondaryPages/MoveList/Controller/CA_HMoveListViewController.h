//
//  CA_HMoveListViewController.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"
#import "CA_HMoveListViewModel.h"
#import "CA_HMoveListModel.h"

@interface CA_HMoveListViewController : CA_HBaseViewController

@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic,copy) NSString *naviTitle;

@property (nonatomic, copy) void (^backBlock)(CA_MProjectModel *model);

@property (nonatomic, copy) void (^noteTypeBlock)(CA_MProjectModel *model, CA_HNoteTypeModel *typeModel);

@property (nonatomic, copy) void (^doneBlock)(NSString *objectType, CA_MProjectModel *model, void (^)(void));

@property (nonatomic, copy) void (^addBlock)(CA_MProjectModel *model,NSString* content);

@end
