//
//  CA_HLocationManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HLocationManager.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>


@implementation CA_HLocationManager


+ (id)singleLocation:(void(^)(NSArray *location))block {
    
    AMapLocationManager *locationManager = [AMapLocationManager new];
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    locationManager.reGeocodeTimeout = 2;
    
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (!block) return ;
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                block(@[]);
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            block(@[regeocode.country?:@"", regeocode.province?:@""]);
        }else {
            block(@[]);
        }
    }];
    
    return locationManager;
}


@end
