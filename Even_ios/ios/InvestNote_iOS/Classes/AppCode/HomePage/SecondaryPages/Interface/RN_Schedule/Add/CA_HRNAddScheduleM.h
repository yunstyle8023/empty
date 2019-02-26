//
//  CA_HRNAddScheduleM.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface CA_HRNAddScheduleM : RCTEventEmitter <RCTBridgeModule>

@property (nonatomic, copy) RCTResponseSenderBlock callBack;

@end

NS_ASSUME_NONNULL_END
