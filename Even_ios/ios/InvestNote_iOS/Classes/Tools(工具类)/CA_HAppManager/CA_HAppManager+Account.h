//
//  CA_HAppManager+SaveAccount.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/12.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_HAppManager.h"

@interface CA_HAppManager (Account)
//获取token
- (NSString*)getToken;
//保存token
- (void)saveToken:(NSString*)token;
//是否是第一次登录
- (BOOL)isFirstLogin;
- (void)saveLoginStatus;
//设置第一次进入的工作台(有无权限/显示的界面)
- (BOOL)isDefaulSetting;
- (void)saveDefaultSetting;
//设置默认的界面(项目/人脉圈等)

-(NSString*)defaultItemKey;
- (void)saveDefaultItemKey:(NSString*)key;

-(NSString*)defaultItem;
- (void)saveDefaultItem:(NSString*)item;

-(NSString*)userName;
-(void)setUserName:(NSString*)userName;

-(NSNumber*)userId;
-(void)setUserId:(NSNumber*)userId;

-(NSString*)userPhone;
-(void)setUserPhone:(NSString*)userPhone;

- (BOOL)userWeChat;
- (void)saveUserWeChat:(BOOL)userWeChat;


//是否绑定了手机号
- (BOOL)isBingdPhoneNumber;
- (void)saveBingdPhoneNumber:(BOOL)isBingdPhoneNumber;

@end

