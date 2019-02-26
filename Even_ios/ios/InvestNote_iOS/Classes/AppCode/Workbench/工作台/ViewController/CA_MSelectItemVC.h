//
//  CA_MSelectItemVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "MYPresentedController.h"

@interface CA_MSelectItemVC : MYPresentedController
@property (nonatomic,copy) NSString *currentItemKey;
@property (nonatomic,copy) void(^block)(NSString* itemKey,NSString* item);
@end
