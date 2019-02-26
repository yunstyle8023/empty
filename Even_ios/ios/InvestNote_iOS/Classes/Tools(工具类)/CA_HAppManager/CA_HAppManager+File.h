//
//  CA_HAppManager+File.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/7.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager.h"

#import <QuickLook/QuickLook.h>

@interface CA_HDocument : UIDocument

@property (nonatomic, strong) NSData *data;

@end

@interface CA_HAppManager (File) <UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource>

- (void)presentDocumentPicker:(UIViewController *)viewController;

- (void)browseDocument:(NSURL *)fileUrl viewController:(UIViewController *)viewController noShare:(BOOL)noShare;
@end
