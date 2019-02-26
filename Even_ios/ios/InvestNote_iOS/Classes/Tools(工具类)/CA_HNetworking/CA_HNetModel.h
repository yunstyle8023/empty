//
//  CA_HNetModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CA_H_NetTypeSuccess = 0,
    CA_H_NetTypeFailure,
    CA_H_NetTypeNotReachable, // 无网络
    
} CA_H_NetType;

typedef enum : NSUInteger {
    CA_H_RefreshTypeDefine,
    CA_H_RefreshTypeFirst,
    CA_H_RefreshTypeNomore,
    CA_H_RefreshTypeFail,
} CA_H_RefreshType;

@interface CA_HNetModel : NSObject

// 返回类型
@property (nonatomic, assign) CA_H_NetType type;

// 返回参数
@property (nonatomic, strong) NSNumber *errcode;
@property (nonatomic, copy) NSString *errmsg;
@property (nonatomic, strong) id data;

// AFN返回参数
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSError *error;

// 下载完成
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSURL *filePath;

@end

@interface CA_HDataModel : NSObject

@property (nonatomic, strong) id fileData;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *mimeType;


@end
