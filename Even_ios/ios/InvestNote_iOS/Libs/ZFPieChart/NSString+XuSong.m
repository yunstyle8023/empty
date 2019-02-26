//
//  NSString+XuSong.m
//  demo
//
//  Created by yezhuge on 2017/12/1.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "NSString+XuSong.h"

@implementation NSString (XuSong)

- (CGRect)stringWidthRectWithSize:(CGSize)size fontOfSize:(CGFloat)font{
    NSDictionary * attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:font]};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

+ (BOOL)isValueableString:(NSString *)content{
    if (content != nil && (NSNull *)content != [NSNull null] && ![@"" isEqualToString:content]){
        return YES;
    }
    return NO;
}
@end
