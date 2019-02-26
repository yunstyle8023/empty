//
//  CA_MSettingType.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 工作台的几种类型 目前只有项目 人脉圈 后续会有基金 出资人等等
 */
@interface CA_MSettingType : NSObject
extern NSString *const SettingType_Project;//项目模块
extern NSString *const SettingType_HumanResource;//人脉圈模块
extern NSString *const SettingType_NoAuthority;//暂无权限
@end
