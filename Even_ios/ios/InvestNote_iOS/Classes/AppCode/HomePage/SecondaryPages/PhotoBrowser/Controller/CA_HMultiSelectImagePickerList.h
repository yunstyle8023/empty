//
//  CA_HMultiSelectImagePickerList.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JYAblumTool.h"

@interface CA_HMultiSelectImagePickerList : UITableViewController

@property (nonatomic, copy) void (^listBlock)(JYAblumList *list);

@property (nonatomic, copy) NSString * buttonTitle;

@end
