//
//  CA_HShareTool.h
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/20.
//  God bless me without no bugs.
//

#import <Foundation/Foundation.h>

typedef void(^Completion)(id data, NSError *error);

@interface CA_MShareTool : NSObject

/**
 分享图片给微信好友

 @param thumbImage 缩略图
 @param shareImage 分享的图片
 @param controller 显示的控制器
 @param completion 分享之后的回调
 */
+ (void)shareImageToFriend:(UIImage*)thumbImage
                          :(UIImage*)shareImage
                          :(UIViewController*)controller
                          :(Completion)completion;
@end

