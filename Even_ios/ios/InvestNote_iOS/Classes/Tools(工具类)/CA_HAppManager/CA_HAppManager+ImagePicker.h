//
//  CA_HAppManager+ImagePicker.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/1.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager.h"

@interface CA_HAppManager (ImagePicker) <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// 从摄像头获取图片或视频
- (void)selectImageFromCamera:(UIViewController *)viewController;
// 从相册获取图片或视频
- (void)selectImageFromAlbum:(UIViewController *)viewController;
// 多选
- (void)multiSelectImage:(UIViewController *)viewController maxSelected:(NSUInteger)maxSelected;
@end
