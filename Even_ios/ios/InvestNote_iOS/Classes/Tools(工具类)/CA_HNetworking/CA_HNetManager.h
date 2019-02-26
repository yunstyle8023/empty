//
//  CA_HNetManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HNetModel.h"

@interface CA_HNetManager : NSObject

// 使用AFN框架来检测网络状态的改变
+ (void)AFNReachability;

// 网络请求

/**
    Get Post Data Download
 
 @param urlStr url
 @param parameters 请求参数
 @param callBack 请求结果回调
 @param progress 传输进度
        exparam 上传文件 仅用于上传
 */
+ (NSURLSessionDataTask *)getUrlStr: (NSString *) urlStr
       parameters: (NSDictionary *) parameters
         callBack: (void(^)(CA_HNetModel * netModel)) callBack
         progress: (void (^)(NSProgress * requestProgress)) progress;
+ (NSURLSessionDataTask *)postUrlStr: (NSString *) urlStr
        parameters: (NSDictionary *) parameters
          callBack: (void(^)(CA_HNetModel * netModel)) callBack
          progress: (void (^)(NSProgress * requestProgress)) progress;
+ (NSURLSessionDataTask *)dataUrlStr: (NSString *) urlStr
        parameters: (NSDictionary *) parameters
          callBack: (void(^)(CA_HNetModel * netModel)) callBack
          progress: (void (^)(NSProgress * requestProgress)) progress
           exparam: (NSArray *) exparam;
+ (NSURLSessionDownloadTask *)downloadUrlStr: (NSString *) urlStr
            parameters: (NSDictionary *) parameters
              callBack: (void(^)(CA_HNetModel * netModel)) callBack
              progress: (void (^)(NSProgress * requestProgress)) progress;


+ (NSURLSessionDataTask *)updateFile: (NSArray *) exparam
                            callBack: (void(^)(CA_HNetModel * netModel)) callBack
                            progress: (void (^)(NSProgress * requestProgress)) progress;

+ (NSURLSessionDownloadTask *)downloadUrlStr: (NSString *) urlStr
                                        path: (NSString *) path
                                    callBack: (void(^)(CA_HNetModel * netModel)) callBack
                                    progress: (void (^)(NSProgress * requestProgress)) progress;

+ (void)logout;

@end
