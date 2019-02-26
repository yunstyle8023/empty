//
//  CA_HAppManager+ImagePicker.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/1.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager+ImagePicker.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "CA_HMultiSelectImagePicker.h"

@implementation CA_HAppManager (ImagePicker) 

#pragma mark --- 多选
- (void)multiSelectImage:(UIViewController *)viewController maxSelected:(NSUInteger)maxSelected{
    
    CA_HMultiSelectImagePicker * imagePicker = [CA_HMultiSelectImagePicker new];
    imagePicker.maxSelected = maxSelected;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:imagePicker];
    
    [viewController presentViewController:nvc animated:YES completion:nil];
}


#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera:(UIViewController *)viewController
{
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.delegate = self;
    //录制视频时长，默认10s
//    self.imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    self.imagePickerController.mediaTypes = @[/*(NSString *)kUTTypeMovie,*/(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
//    self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
//    self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum:(UIViewController *)viewController
{
    //NSLog(@"相册");
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.delegate = self;
    self.imagePickerController.mediaTypes = @[/*(NSString *)kUTTypeMovie,*/(NSString *)kUTTypeImage];
    
    [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (self.imageBlock) {
        self.imageBlock(NO, nil, nil);
        self.imageBlock = nil;
    }
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        if (self.imageBlock) {
            self.imageBlock(YES, info[UIImagePickerControllerOriginalImage], info);
            self.imageBlock = nil;
        }
        
//        self.imageView.image = info[UIImagePickerControllerEditedImage];
//        //压缩图片
//        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
//        //保存图片至相册
//        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//        //上传图片
//        [self uploadImageWithData:fileData];
        
    }else{
//        //如果是视频
//        NSURL *url = info[UIImagePickerControllerMediaURL];
//        //播放视频
//        _moviePlayer.contentURL = url;
//        [_moviePlayer play];
//        //保存视频至相册（异步线程）
//        NSString *urlStr = [url path];
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
//
//                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//            }
//        });
//        NSData *videoData = [NSData dataWithContentsOfURL:url];
//        //视频上传
//        [self uploadVideoWithData:videoData];
    }
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

@end
