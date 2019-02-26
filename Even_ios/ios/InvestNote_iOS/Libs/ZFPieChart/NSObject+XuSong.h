//
//  NSObject+XuSong.h
//  demo
//
//  Created by yezhuge on 2017/12/1.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XuSong)
- (void)dispatch_after_withSeconds:(float)seconds actions:(void(^)(void))actions;
@end
