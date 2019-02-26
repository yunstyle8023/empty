//
//  CA_HShareTool.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/20.
//  God bless me without no bugs.
//

#import "CA_MShareTool.h"
#import <UMSocialCore/UMSocialCore.h>
#import <WXApi.h>


@implementation CA_MShareTool

+ (void)shareImageToFriend:(UIImage*)thumbImage
                          :(UIImage*)shareImage
                          :(UIViewController*)controller
                          :(Completion)completion{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumbImage;
    //设置分享图片
    shareObject.shareImage = shareImage;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        if (completion) completion(data,error);
    }];
}


@end
