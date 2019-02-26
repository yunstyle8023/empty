//
//  CA_HAppManager+File.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/7.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager+File.h"


@implementation CA_HDocument

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    if ([contents isKindOfClass:[NSFileWrapper class]]) {
        [CA_HProgressHUD showHudStr:@"文件类型错误"];
        return NO;
    }
    self.data = contents;
    return YES;
}

@end

@implementation CA_HAppManager (File)

- (void)browseDocument:(NSURL *)fileUrl viewController:(UIViewController *)viewController noShare:(BOOL)noShare {
    
    if (![QLPreviewController canPreviewItem:fileUrl]) {
        return;
    }
    
    QLPreviewController *myQlPreViewController = [[QLPreviewController alloc]init];
//    myQlPreViewController.title = fileName;
    self.fileUrl = fileUrl;
    myQlPreViewController.delegate =self;
    myQlPreViewController.dataSource =self;
    [myQlPreViewController setCurrentPreviewItemIndex:0];
    
    //此处可以带导航栏跳转、也可以不带导航栏跳转、也可以拿到View进行Add
    CA_H_DISPATCH_MAIN_THREAD(^{
        [viewController presentViewController:myQlPreViewController animated:YES completion:noShare?(^{
            
            NSArray *bars = [self findAllToolBarsFromView:myQlPreViewController.view];
            for (UIToolbar *bar in bars) {
                bar.hidden = YES;
                [[bar rac_valuesForKeyPath:@"hidden" observer:self] subscribeNext:^(id  _Nullable x) {
                    if (![x boolValue]) {
                        bar.hidden = YES;
                    }
                }];
            }
        }):nil];
    });
    
    [self.mainWindow.rootViewController setValue:myQlPreViewController forKey:@"documentShare"];
    
    if (noShare) {
        //隐藏QL分享
        [myQlPreViewController.navigationItem setRightBarButtonItem:[UIBarButtonItem new]];
    }
}

- (NSArray *)findAllToolBarsFromView:(UIView *)view {
    NSMutableArray * bars = [[NSMutableArray alloc]initWithCapacity:0];
    for (UIView * view2 in view.subviews) {
        if ([view2 isKindOfClass:[UIToolbar class]]) {
            [bars addObject:view2];
        }
        [bars addObjectsFromArray:[self findAllToolBarsFromView:view2]];
    }
    return bars;
}


#pragma mark - QLPreviewController代理
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return self.fileUrl;
//    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
//    NSString * filePath = [path stringByAppendingString:controller.title];
//    return [NSURL fileURLWithPath:filePath];
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller{
    [self.mainWindow.rootViewController setValue:nil forKey:@"documentShare"];
    NSLog(@"预览界面已经消失");
}

//文件内部链接点击不进行外部跳转
- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item{
    return NO;
}


- (void)presentDocumentPicker:(UIViewController *)viewController{
//    NSArray *documentTypes =
//    @[(NSString *)kUTTypeContent,
//      (NSString *)kUTTypeText,
//      (NSString *)kUTTypeSourceCode,
//      (NSString *)kUTTypeImage,
//      (NSString *)kUTTypeAudiovisualContent,
//      (NSString *)kUTTypePDF,
//      @"com.apple.keynote.key",
//      @"com.microsoft.word.doc",
//      @"com.microsoft.excel.xls",
//      @"com.microsoft.powerpoint.ppt"];
    NSArray *documentTypes = @[@"public.content",
                               @"public.text",
                               @"public.source-code ",
                               @"public.image",
                               @"public.audiovisual-content",
                               @"com.adobe.pdf",
                               @"com.apple.keynote.key",
                               @"com.microsoft.word.doc",
                               @"com.microsoft.excel.xls",
                               @"com.microsoft.powerpoint.ppt",
                               @"dyn.age81e2pw",//rar
                               @"dyn.age8xs8u",//7z
                               @"public.zip-archive",
                               @"public.html",
                               @"com.apple.iwork.pages.pages",
                               @"com.apple.iwork.numbers.numbers",
                               @"com.apple.iwork.keynote.key"];
    
//    txt|html|pdf|xls|xlsx|numbers|doc|docx|pages|ppt|pptx|key|jpg|jpeg|png|gif|zip|rar|7z
    
//    https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
    
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes
                                                                                                                          inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    documentPickerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [viewController presentViewController:documentPickerViewController animated:YES completion:nil];
}


#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
//    NSString *fileName = [array lastObject];
//    fileName = [fileName stringByRemovingPercentEncoding];

    [self downloadWithDocumentURL:url callBack:^(id obj) {
        NSData *data = obj;

        if (self.fileBlock) {
            self.fileBlock(url.absoluteString, data);
            self.fileBlock = nil;
        }
    }];

}

#pragma mark --- Custom

- (void)downloadWithDocumentURL:(NSURL*)url callBack:(void (^)(id obj))block {
    
    CA_HDocument *iCloudDoc = [[CA_HDocument alloc]initWithFileURL:url];
    
    [iCloudDoc openWithCompletionHandler:^(BOOL success) {
        if (success) {
            
            [iCloudDoc closeWithCompletionHandler:^(BOOL success) {
                NSLog(@"关闭成功");
            }];
            
            if (block) {
                block(iCloudDoc.data);
            }
            
        }
    }];
}


@end
