//
//  CA_HNoteFileView.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HNoteFileView : UIView

+ (instancetype)newWith:(NSString *)type;

- (void)setDuration:(NSNumber *)duration;
- (void)setFileName:(NSString *)fileName;

@end
