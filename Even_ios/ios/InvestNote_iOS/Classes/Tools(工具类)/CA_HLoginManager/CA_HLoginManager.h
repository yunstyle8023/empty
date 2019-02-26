//
//  CA_HLoginManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HLoginManager : NSObject

+ (void)loginOrganization: (NSDictionary *) parameters callBack: (void(^)(CA_HNetModel * netModel)) callBack;

@end
