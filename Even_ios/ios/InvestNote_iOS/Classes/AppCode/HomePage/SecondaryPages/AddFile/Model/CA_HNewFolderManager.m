//
//  CA_HNewFolderManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNewFolderManager.h"

#import "NSString+CA_HStringCheck.h"

@implementation CA_HNewFolderManager

#pragma mark --- 文件夹重命名

+ (void)renameFolder:(NSNumber *)parentId parentPath:(NSArray *)parentPath fileId:(NSNumber *)fileId folderName:(NSString *)folderName callBack:(void(^)(CA_HNetModel * netModel))callBack controller:(UIViewController *)controller {
    
    [controller presentAlertTitle:CA_H_LAN(@"重命名")
                          message:nil
                          buttons:@[CA_H_LAN(@"取消"),CA_H_LAN(@"确定")]
                       clickBlock:^(UIAlertController *alert, NSInteger index) {
                           if (index == 1) {
                               NSString *text = [alert.textFields.firstObject text];
                               [self renameFolder:text parentId:parentId parentPath:parentPath fileId:fileId folderName:folderName callBack:callBack controller:controller];
                           }
                       }
                 countOfTextField:1
                   textFieldBlock:^(UITextField *textField, NSInteger index) {
                       
                       NSString * text = CA_H_LAN(@"文件夹名称");
                       textField.placeholder = text;
                       textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                       textField.text = folderName;
                       [textField performSelector:@selector(selectAllText) withObject:nil afterDelay:0.1];
                       
                   }];
}

+ (void)renameFolder:(NSString *)newFolderName parentId:(NSNumber *)parentId parentPath:(NSArray *)parentPath fileId:(NSNumber *)fileId folderName:(NSString *)folderName callBack:(void(^)(CA_HNetModel * netModel))callBack controller:(UIViewController *)controller {
    
    if ([newFolderName isEqualToString:folderName]) {
        return;
    }
    
    if (newFolderName.length==0
        ||
        newFolderName.length>=30
        ||
        ![newFolderName checkFileTag]
        ||
        [newFolderName isEqualToString:@"系统默认"]) {
        [controller presentAlertTitle:nil message:CA_H_LAN(@"命名规则不符合系统要求，请重新命名") buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
        return ;
    }
    
    if (!(parentId&&fileId&&parentPath)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return ;
    }
    
    NSDictionary *parameters = @{@"parent_id": parentId,
                                 @"parent_path":parentPath,
                                 @"file_id": fileId,
                                 @"new_name": newFolderName};
    [CA_HNetManager postUrlStr:CA_H_Api_RenameDirectory parameters:parameters callBack:callBack progress:nil];
}

#pragma mark --- 删除文件夹

+ (void)deleteFolder:(NSNumber *)parentId fileId:(NSNumber *)fileId filePath:(NSArray *)filePath callBack:(void(^)(CA_HNetModel * netModel))callBack controller:(UIViewController *)controller {
    [controller presentAlertTitle:nil message:CA_H_LAN(@"是否确认删除文件夹？") buttons:@[CA_H_LAN(@"取消"),@[CA_H_LAN(@"确认删除")]] clickBlock:^(UIAlertController *alert, NSInteger index) {
        if (index == 1) {
            [self deleteFolder:parentId fileId:fileId filePath:filePath callBack:callBack];
        }
    }];
}

+ (void)deleteFolder:(NSNumber *)parentId fileId:(NSNumber *)fileId filePath:(NSArray *)filePath callBack:(void(^)(CA_HNetModel * netModel))callBack {
    
    if (!(parentId&&fileId&&filePath)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return ;
    }
    
    NSDictionary *parameters = @{@"parent_id": parentId,
                                 @"file_id": fileId,
                                 @"file_path": filePath};
    [CA_HNetManager postUrlStr:CA_H_Api_DeleteDirectory parameters:parameters callBack:callBack progress:nil];
}

#pragma mark --- 新建文件夹

+ (void)newFolder:(NSNumber *)parentId parentPath:(NSArray *)parentPath callBack:(void (^)(CA_HNetModel *))callBack controller:(UIViewController *)controller {
    if (parentPath.count > 7) {
        [controller presentAlertTitle:nil message:CA_H_LAN(@"子文件层数已满，不支持新建文件夹") buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
        return;
    }
    
    [controller presentAlertTitle:CA_H_LAN(@"新建文件夹")
                                     message:nil
                                     buttons:@[CA_H_LAN(@"取消"),CA_H_LAN(@"确定")]
                                  clickBlock:^(UIAlertController *alert, NSInteger index) {
                                      if (index == 1) {
                                          NSString *text = [alert.textFields.firstObject text];
                                          [self newFolder:text parentId:parentId parentPath:parentPath callBack:callBack controller:controller];
                                      }
                                  }
                            countOfTextField:1
                              textFieldBlock:^(UITextField *textField, NSInteger index) {
                                  
                                  NSString * text = CA_H_LAN(@"新建文件夹");
                                  textField.placeholder = text;
                                  textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                                  textField.text = text;
                                  [textField performSelector:@selector(selectAllText) withObject:nil afterDelay:0.1];
                                  
                              }];
}

+ (NSURLSessionDataTask *)newFolder:(NSString *)folderName
                           parentId:(NSNumber *)parentId
                         parentPath:(NSArray *)parentPath
                           callBack:(void(^)(CA_HNetModel * netModel))callBack
                         controller:(UIViewController *)controller {
    
    
    if (folderName.length==0
        ||
        folderName.length>=30
        ||
        ![folderName checkFileTag]
        ||
        [folderName isEqualToString:@"系统默认"]) {
        [controller presentAlertTitle:nil message:CA_H_LAN(@"命名规则不符合系统要求，请重新命名") buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
        return nil;
    }
    
    if (!(parentId&&parentPath)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return nil;
    }
    
    NSDictionary *parameters = @{@"parent_id": parentId,
                                 @"parent_path": parentPath,
                                 @"file_name": folderName};
    return [CA_HNetManager postUrlStr:CA_H_Api_CreateDirectory parameters:parameters callBack:callBack progress:nil];
}

@end
