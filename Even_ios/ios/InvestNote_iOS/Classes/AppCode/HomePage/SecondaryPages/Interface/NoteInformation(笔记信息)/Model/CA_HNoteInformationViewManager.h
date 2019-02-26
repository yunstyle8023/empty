//
//  CA_HNoteInformationViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_HNoteInformationViewManager : NSObject

@property (nonatomic, strong) UIView * informationView;

- (void)setTopStrings:(NSArray<NSString *> *)topStrings;

- (void)setBottomStrings:(NSArray<NSString *> *)bottomStrings;

@end
