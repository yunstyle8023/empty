//
//  CA_HRemarkViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HRemarkViewModel : NSObject

@property (nonatomic, copy) void (^backBlock)(NSString * text);
@property (nonatomic, strong) YYTextView * textView;

@property (nonatomic, strong) UIBarButtonItem * rightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * leftBarButtonItem;

@end
