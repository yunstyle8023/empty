//
//  NSObject+XuSong.m
//  demo
//
//  Created by yezhuge on 2017/12/1.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "NSObject+XuSong.h"

@implementation NSObject (XuSong)
- (void)dispatch_after_withSeconds:(float)seconds actions:(void(^)(void))actions{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        actions();
    });
}
@end
