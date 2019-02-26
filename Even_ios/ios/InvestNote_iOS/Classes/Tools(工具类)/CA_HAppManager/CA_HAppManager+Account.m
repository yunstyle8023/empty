//
//  CA_HAppManager+SaveAccount.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/12.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_HAppManager+Account.h"

@implementation CA_HAppManager (Account)

- (NSString*)getToken{
    return [CA_H_UserDefaults objectForKey:Token];
}

- (void)saveToken:(NSString*)token{
    [CA_H_UserDefaults setObject:token forKey:Token];
    [CA_H_UserDefaults synchronize];
}

- (BOOL)isFirstLogin{
    return [CA_H_UserDefaults boolForKey:IsFirst];
}

- (void)saveLoginStatus{
    [CA_H_UserDefaults setBool:YES forKey:IsFirst];
    [CA_H_UserDefaults synchronize];
}

- (BOOL)isDefaulSetting{
    return [CA_H_UserDefaults boolForKey:@"defaultSetting"];
}

- (void)saveDefaultSetting{
    [CA_H_UserDefaults setBool:YES forKey:@"defaultSetting"];
    [CA_H_UserDefaults synchronize];
}

-(NSString*)defaultItemKey{
    return [CA_H_UserDefaults stringForKey:@"defaultItemKey"];
}

- (void)saveDefaultItemKey:(NSString*)key{
    [CA_H_UserDefaults setObject:key forKey:@"defaultItemKey"];
    [CA_H_UserDefaults synchronize];
}

-(NSString*)defaultItem{
    return [CA_H_UserDefaults stringForKey:self.defaultItemKey];
}

- (void)saveDefaultItem:(NSString*)item{
    [CA_H_UserDefaults setObject:item forKey:self.defaultItemKey];
    [CA_H_UserDefaults synchronize];
}

-(NSString*)userName{
    return [CA_H_UserDefaults stringForKey:@"userName"];
}

-(void)setUserName:(NSString*)userName{
    [CA_H_UserDefaults setObject:userName forKey:@"userName"];
    [CA_H_UserDefaults synchronize];
}

-(NSNumber*)userId{
    return [CA_H_UserDefaults objectForKey:@"userId"];
}

-(void)setUserId:(NSNumber*)userId{
    [CA_H_UserDefaults setObject:userId forKey:@"userId"];
    [CA_H_UserDefaults synchronize];
}

-(NSString*)userPhone{
    return [CA_H_UserDefaults stringForKey:@"userPhone"];
}

-(void)setUserPhone:(NSString*)userPhone{
    [CA_H_UserDefaults setObject:userPhone forKey:@"userPhone"];
    [CA_H_UserDefaults synchronize];
}

//是否绑定了手机号
- (BOOL)isBingdPhoneNumber{
    return [CA_H_UserDefaults boolForKey:@"isBingdPhoneNumber"];
}

- (void)saveBingdPhoneNumber:(BOOL)isBingdPhoneNumber{
    [CA_H_UserDefaults setBool:isBingdPhoneNumber forKey:@"isBingdPhoneNumber"];
    [CA_H_UserDefaults synchronize];
}

- (BOOL)userWeChat{
    return [CA_H_UserDefaults boolForKey:@"userWeChat"];
}

- (void)saveUserWeChat:(BOOL)userWeChat{
    [CA_H_UserDefaults setBool:userWeChat forKey:@"userWeChat"];
    [CA_H_UserDefaults synchronize];
}

@end

