//
//  CA_HNetManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/20.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HNetManager.h"

// 登录
#import "CA_HLoginManager.h"

//退出登录

// 无权限跳转工作台
#import "CA_MChangeWorkSpace.h"
#import "CA_MSettingProjectVC.h"


typedef enum : NSUInteger {
    CA_H_NetMethod_Post = 0,
    CA_H_NetMethod_Get,
    CA_H_NetMethod_Data,
    CA_H_NetMethod_Download,
    
} CA_H_NetMethod;

@implementation CA_HNetManager

+ (NSURLSessionDataTask *)getUrlStr: (NSString *) urlStr
       parameters: (NSDictionary *) parameters
         callBack: (void(^)(CA_HNetModel * netModel)) callBack
         progress: (void (^)(NSProgress * requestProgress)) progress{
    
    CA_H_DISPATCH_MAIN_THREAD(^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    return (id)
    [self requestWithURLString:urlStr parameters:parameters callBack:^(CA_HNetModel * netModel) {
        CA_H_DISPATCH_MAIN_THREAD(^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (callBack) {
            NSLog(@"data:--------------->%@\nerrcode:--------------->%@\nerrmsg:--------------->%@\nerror:--------------->%@",netModel.data,netModel.errcode,netModel.errmsg,netModel.error);
            callBack(netModel);
        }
    } progress:progress exparam:nil method:CA_H_NetMethod_Get];
    
}

+ (NSURLSessionDataTask *)postUrlStr: (NSString *) urlStr
        parameters: (NSDictionary *) parameters
          callBack: (void(^)(CA_HNetModel * netModel)) callBack
          progress: (void (^)(NSProgress * requestProgress)) progress{
    
    CA_H_DISPATCH_MAIN_THREAD(^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    return (id)
    [self requestWithURLString:urlStr parameters:parameters callBack:^(CA_HNetModel * netModel) {
        CA_H_DISPATCH_MAIN_THREAD(^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (callBack) {
            NSLog(@"data:--------------->%@\nerrcode:--------------->%@\nerrmsg:--------------->%@\nerror:--------------->%@",netModel.data,netModel.errcode,netModel.errmsg,netModel.error);
            callBack(netModel);
        }
    } progress:progress exparam:nil method:CA_H_NetMethod_Post];
    
}

+ (NSURLSessionDataTask *)dataUrlStr: (NSString *) urlStr
        parameters: (NSDictionary *) parameters
          callBack: (void(^)(CA_HNetModel *)) callBack
          progress: (void (^)(NSProgress * requestProgress)) progress
           exparam: (NSArray *) exparam{
    CA_H_DISPATCH_MAIN_THREAD(^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    return (id)
    [self requestWithURLString:urlStr parameters:parameters callBack:^(CA_HNetModel * netModel) {
        CA_H_DISPATCH_MAIN_THREAD(^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (callBack) {
            NSLog(@"data:--------------->%@\nerrcode:--------------->%@\nerrmsg:--------------->%@\nerror:--------------->%@",netModel.data,netModel.errcode,netModel.errmsg,netModel.error);
            callBack(netModel);
        }
    } progress:progress exparam:exparam method:CA_H_NetMethod_Data];
}

+ (NSURLSessionDownloadTask *)downloadUrlStr: (NSString *) urlStr
            parameters: (NSDictionary *) parameters
              callBack: (void(^)(CA_HNetModel *)) callBack
              progress: (void (^)(NSProgress * requestProgress)) progress{
    CA_H_DISPATCH_MAIN_THREAD(^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    return (id)
    [self requestWithURLString:urlStr parameters:parameters callBack:^(CA_HNetModel * netModel) {
        CA_H_DISPATCH_MAIN_THREAD(^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (callBack) {
            NSLog(@"data:--------------->%@\nerrcode:--------------->%@\nerrmsg:--------------->%@\nerror:--------------->%@",netModel.data,netModel.errcode,netModel.errmsg,netModel.error);
            callBack(netModel);
        }
    } progress:progress exparam:nil method:CA_H_NetMethod_Download];
}


+ (NSURLSessionTask *)requestWithURLString: (NSString *) URLString
                  parameters: (NSDictionary *) parameters
                    callBack: (void(^)(CA_HNetModel * netModel)) callBack
                    progress: (void (^)(NSProgress * requestProgress)) progress
                     exparam: (NSArray *) exparam
                      method: (CA_H_NetMethod) method{
    
    if (!parameters) {
        parameters = @{};
    }
    
    if (CA_H_MANAGER.status == AFNetworkReachabilityStatusNotReachable) {
        CA_HNetModel * model = [CA_HNetModel new];
        model.type = CA_H_NetTypeNotReachable;
        callBack(model);
        return nil;
    }
    
//    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString * url = [NSString stringWithFormat:@"%@%@%@", CA_H_SERVER_API, URLString, CA_H_SERVER_PATH];

    NSLog(@"\n请求地址为:--------------->%@",url);
    
    NSMutableDictionary * parametersDic = [NSMutableDictionary new];
    [parametersDic setValuesForKeysWithDictionary:parameters];
    
    NSLog(@"\n请求参数为:--------------->%@",parametersDic);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSString* token = CA_H_MANAGER.getToken;

    if (token.length) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",CA_H_Version] forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:@"4" forHTTPHeaderField:@"device-typ"];
    [manager.requestSerializer setValue:[CA_H_UserDefaults valueForKey:Channel_Id] forHTTPHeaderField:@"channel-id"];
    
    NSLog(@"manager.requestSerializer.HTTPRequestHeaders =======  %@",manager.requestSerializer.HTTPRequestHeaders);
    
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    switch (method) {
            
        case CA_H_NetMethod_Get:{
            return
            [manager GET:url parameters:parametersDic progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress) {
                    progress(downloadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                CA_HNetModel *  model = [CA_HNetModel modelWithDictionary:responseObject];
                model.task = task;
                model.type = CA_H_NetTypeSuccess;
                
                [self dealWithURLString:URLString parameters:parameters callBack:callBack progress:progress exparam:exparam method:method model:model];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                CA_HNetModel *  model = [CA_HNetModel new];
                model.task = task;
                model.error = error;
                model.type = CA_H_NetTypeFailure;
                callBack(model);
                
            }];
        }break;
            
        case CA_H_NetMethod_Data:{
            return
            [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                //上传
                if (exparam) {
                    for (CA_HDataModel * dataModel in exparam) {
                        [formData appendPartWithFileData:dataModel.fileData name:dataModel.name fileName:dataModel.fileName mimeType:dataModel.mimeType];
                    }
                }
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progress) {
                    progress(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                CA_HNetModel *  model = [CA_HNetModel modelWithDictionary:responseObject];
                model.task = task;
                model.type = CA_H_NetTypeSuccess;
                
                [self dealWithURLString:URLString parameters:parameters callBack:callBack progress:progress exparam:exparam method:method model:model];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                CA_HNetModel *  model = [CA_HNetModel new];
                model.task = task;
                model.error = error;
                model.type = CA_H_NetTypeFailure;
                callBack(model);
                
            }];
        }break;
            
        case CA_H_NetMethod_Download:{
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSURLSessionDownloadTask *dataTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                
                /**
                 *  下载进度
                 */
                if (progress) {
                    progress(downloadProgress);
                }
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                
                /**
                 *  设置保存目录
                 */
                
                return nil;
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                
                /**
                 *  下载完成
                 */
                CA_HNetModel *  model = [CA_HNetModel new];
                model.response = response;
                model.error = error;
                model.filePath = filePath;
                model.type = CA_H_NetTypeSuccess;
                
                [self dealWithURLString:URLString parameters:parameters callBack:callBack progress:progress exparam:exparam method:method model:model];
                
            }];
            
            [dataTask resume];
            
            return dataTask;
        }break;
            
        default:{
            CA_H_WeakSelf(progress);
            return
            [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                CA_H_StrongSelf(progress)
                if (progress) {
                    progress(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                CA_HNetModel *  model = [CA_HNetModel modelWithDictionary:responseObject];
                model.task = task;
                model.type = CA_H_NetTypeSuccess;
                
                [self dealWithURLString:URLString parameters:parameters callBack:callBack progress:progress exparam:exparam method:method model:model];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                CA_HNetModel *  model = [CA_HNetModel new];
                model.task = task;
                model.error = error;
                model.type = CA_H_NetTypeFailure;
                callBack(model);
                
            }];
        }break;
    }
    
}

+ (NSURLSessionDownloadTask *)downloadUrlStr: (NSString *) urlStr
                                        path: (NSString *) path
                                    callBack: (void(^)(CA_HNetModel * netModel)) callBack
                                    progress: (void (^)(NSProgress * requestProgress)) progress {
    
    if (CA_H_MANAGER.status == AFNetworkReachabilityStatusNotReachable) {
        CA_HNetModel * model = [CA_HNetModel new];
        model.type = CA_H_NetTypeNotReachable;
        callBack(model);
        return nil;
    }
    
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *url = ^{
         if ([urlStr hasPrefix:@"http://"]
             ||
             [urlStr hasPrefix:@"https://"]) {
             return urlStr;
         }
         return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
     }();
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString* token = CA_H_MANAGER.getToken;
    
    if (token.length) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    if (token.length) {
        [request setValue:token forHTTPHeaderField:@"token"];
    }
    
    NSURLSessionDownloadTask *dataTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        /**
         *  下载进度
         */
        if (progress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        /**
         *  设置保存目录
         */
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        /**
         *  下载完成
         */
        CA_HNetModel *  model = [CA_HNetModel new];
        model.response = response;
        model.error = error;
        model.filePath = filePath;
        model.type = CA_H_NetTypeSuccess;
        
        if (token.length&&model.errcode.integerValue == NSNotFound) {
            // token 错误/失效
            [CA_HLoginManager loginOrganization:[CA_H_UserDefaults objectForKey:NSLoginAccount] callBack:^(CA_HNetModel *netModel) {
                if (netModel.type == CA_H_NetTypeSuccess
                    &&
                    netModel.errcode.integerValue == 0) {
                    [self downloadUrlStr:urlStr path:path callBack:callBack progress:progress];
                }else{
                    callBack(model);
                    [self handleErrcode:netModel.errcode];
                }
            }];
        }else {
            callBack(model);
            [self handleErrcode:model.errcode];
        }
        
    }];
    
    [dataTask resume];
    
    return dataTask;
    
}

+ (NSURLSessionDataTask *)updateFile: (NSArray *) exparam
                            callBack: (void(^)(CA_HNetModel * netModel)) callBack
                            progress: (void (^)(NSProgress * requestProgress)) progress {
    if (CA_H_MANAGER.status == AFNetworkReachabilityStatusNotReachable) {
        CA_HNetModel * model = [CA_HNetModel new];
        model.type = CA_H_NetTypeNotReachable;
        callBack(model);
        return nil;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, CA_H_Api_UpdateFile];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString* token = CA_H_MANAGER.getToken;
    
    if (token.length) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    return
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传
        if (exparam) {
            for (CA_HDataModel * dataModel in exparam) {
                [formData appendPartWithFileData:dataModel.fileData name:dataModel.name fileName:dataModel.fileName mimeType:dataModel.mimeType];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CA_HNetModel *  model = [CA_HNetModel modelWithDictionary:responseObject];
        model.task = task;
        model.type = CA_H_NetTypeSuccess;
        
        if (token.length&&model.errcode.integerValue == NSNotFound) {
            // token 错误/失效
            [CA_HLoginManager loginOrganization:[CA_H_UserDefaults objectForKey:NSLoginAccount] callBack:^(CA_HNetModel *netModel) {
                if (netModel.type == CA_H_NetTypeSuccess
                    &&
                    netModel.errcode.integerValue == 0) {
                    [self updateFile:exparam callBack:callBack progress:progress];
                }else{
                    callBack(model);
                    [self handleErrcode:netModel.errcode];
                }
            }];
        }else {
            callBack(model);
            [self handleErrcode:model.errcode];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        CA_HNetModel *  model = [CA_HNetModel new];
        model.task = task;
        model.error = error;
        model.type = CA_H_NetTypeFailure;
        callBack(model);
        
    }];
}


// token 错误/失效 内部处理
+ (void)dealWithURLString: (NSString *) URLString
               parameters: (NSDictionary *) parameters
                 callBack: (void(^)(CA_HNetModel * netModel)) callBack
                 progress: (void (^)(NSProgress * requestProgress)) progress
                  exparam: (NSArray *) exparam
                   method: (CA_H_NetMethod) method
                    model: (CA_HNetModel *)model {
    
    NSString* token = CA_H_MANAGER.getToken;
    if (token.length&&model.errcode.integerValue == NSNotFound) {
        // token 错误/失效
        [CA_HLoginManager loginOrganization:[CA_H_UserDefaults objectForKey:NSLoginAccount] callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess
                &&
                netModel.errcode.integerValue == 0) {
                [self requestWithURLString:URLString parameters:parameters callBack:callBack progress:progress exparam:exparam method:method];
            }else{
                callBack(model);
                [self handleErrcode:netModel.errcode];
            }
        }];
    }else {
        callBack(model);
        [self handleErrcode:model.errcode];
    }
}

+ (void)handleErrcode:(NSNumber *)errcode {
    NSInteger err = errcode.integerValue;
    if (err == 12011) {
        [self logout];
    } else if (err >= 10002 && err <= 10006) { // 模块权限
        [CA_MChangeWorkSpace changeWorkSpace:[CA_MSettingProjectVC new]];
    }
}

+ (void)logout {
    
//清空token
    [CA_H_MANAGER saveToken:nil];
    
//删除记录的密码
    NSDictionary* accountStr =  [CA_H_UserDefaults objectForKey:NSLoginAccount];
    if ([NSObject isValueableObject:accountStr]) {
        NSDictionary* parameters = @{@"username": accountStr[@"username"],
                                     @"password": @""};
        [CA_H_UserDefaults setObject:parameters forKey:NSLoginAccount];
    }

//切换登录页面
    [CA_H_MANAGER showLoginWindow:YES completion:^(BOOL finished) {
        for (UINavigationController *nvc in [(UITabBarController *)CA_H_MANAGER.mainWindow.rootViewController viewControllers]) {
            if ([nvc isKindOfClass:NSClassFromString(@"CA_MNavigationController")]) {
                [nvc popToRootViewControllerAnimated:NO];
            }
        }
    }];
}


//使用AFN框架来检测网络状态的改变
+ (void)AFNReachability {
    
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.监听网络状态的改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        CA_H_MANAGER.status = status;
    }];
    //3.开始监听
    [manager startMonitoring];
    
}


@end
