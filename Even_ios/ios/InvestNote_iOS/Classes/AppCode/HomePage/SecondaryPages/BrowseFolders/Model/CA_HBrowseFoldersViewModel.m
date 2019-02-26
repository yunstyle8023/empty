//
//  CA_HBrowseFoldersViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/26.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBrowseFoldersViewModel.h"

#import "CA_HEditMenuView.h"
#import "CA_HFolderFileCell.h"

#import "CA_HNewFolderManager.h"
#import "CA_HNewFileManager.h"

// 标签
#import "CA_HChooseTagMenuController.h"

// 上传文件
#import "CA_HAddFileModel.h"

// 分享
#import <WXApi.h>
#import "CA_HShareToFriendController.h"

#import "CA_HDownloadCenterViewModel.h"

@interface CA_HBrowseFoldersViewModel ()

@end

@implementation CA_HBrowseFoldersViewModel

#pragma mark --- Action

- (void)addBarButton:(UIBarButtonItem *)sender{
    if (_getControllerBlock) {
        NSArray *buttons = @[CA_H_LAN(@"新建文件夹"),
                             CA_H_LAN(@"选择图片"),
                             CA_H_LAN(@"拍摄照片"),
                             CA_H_LAN(@"浏览"),];
        CA_H_WeakSelf(self);
        [_getControllerBlock() presentActionSheetTitle:nil message:nil buttons:buttons clickBlock:^(UIAlertController *alert, NSInteger index) {
            CA_H_StrongSelf(self);
            [self onSheet:index];
        }];
    }
}

- (void)onSheet:(NSInteger)index{
    
    if (index == 0) {
        [self createDirectory];
        return;
    }
    
    CA_H_WeakSelf(self);
    if (index == 3) {
        
        CA_H_MANAGER.fileBlock = ^(NSString *filePath, NSData *data) {
            CA_H_StrongSelf(self);
            CA_HAddFileModel *model = [CA_HAddFileModel new];
            model.type = CA_H_AddFileTypeDocument;
            model.filePath = filePath;
            model.file = data;
            
            [self addFile:model];
        };
        [CA_H_MANAGER presentDocumentPicker:self.getControllerBlock()];
        return;
    }
    
    CA_H_MANAGER.imageBlock = ^(BOOL success, UIImage *image, NSDictionary *info) {
        CA_H_StrongSelf(self);
        if (success) {
            
            NSURL *url = info[@"PHImageFileURLKey"];
            if (!url) {
                url = info[@"UIImagePickerControllerImageURL"];
            }
            
            CA_HAddFileModel *model = [CA_HAddFileModel new];
            model.type = CA_H_AddFileTypeImage;
            NSData *imageData = info[@"ca_imageData"];
            model.file =  imageData?:image.imageDataRepresentation;
            if (url) {
                NSString *filePath = url.absoluteString;
                if ([filePath hasSuffix:@".HEIC"]) {
                    filePath = [filePath stringByReplacingCharactersInRange:NSMakeRange(filePath.length-4, 4) withString:@"jpeg"];
                }
                model.filePath = filePath;
            } else {
                model.file = UIImageJPEGRepresentation(image, 1);
                model.fileName = [[[info[UIImagePickerControllerMediaMetadata][@"{TIFF}"][@"DateTime"] stringByReplacingOccurrencesOfString:@" " withString:@"T"]stringByReplacingOccurrencesOfString:@":" withString:@"-"] stringByAppendingString:@".jpeg"];
            }
            
            [self addFile:model];
            
        }
        
    };
    switch (index) {
        case 1:
            [CA_H_MANAGER multiSelectImage:_getControllerBlock() maxSelected:9];
            break;
        case 2:
            [CA_H_MANAGER selectImageFromCamera:_getControllerBlock()];
            break;
        default:
            break;
    }
}

- (void)addFile:(CA_HAddFileModel *)model{
    
    model.parent_id = self.model.file_id;
    model.parent_path = self.model.file_path;
    
//    [self.updateFileManager.contents addObject:model];
//    self.updateFileManager.updateBlock();
    
    CA_H_WeakSelf(self);
    [self.updateFileManager saveToTmp:model success:^{
        CA_H_StrongSelf(self);
        
        [self.updateFileManager update:model];
        
        [self.tableView.uploads addObject:model];
        NSInteger row = self.tableView.uploads.count - 1;
        [self.tableView insertRow:row inSection:0 withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView scrollToRow:row inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
    } failed:^{
        
    }];
}


#pragma mark --- Lazy

- (CA_HUpdateFileManager *)updateFileManager {
    if (!_updateFileManager) {
        _updateFileManager = [CA_HUpdateFileManager new];
    }
    return _updateFileManager;
}

- (UIBarButtonItem *)rightNavBarButton{

    NSInteger index = [_model.path_option indexOfObject:@"create"];
    if (index == NSNotFound) {
        return nil;
    }
    
    if (!_rightNavBarButton) {
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:kImage(@"add") forState:UIControlStateNormal];
        [rightButton setImage:kImage(@"add") forState:UIControlStateHighlighted];
        [rightButton sizeToFit];
        [rightButton addTarget: self action: @selector(addBarButton:) forControlEvents: UIControlEventTouchUpInside];
        _rightNavBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//        _rightNavBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBarButton:)];
    }
    return _rightNavBarButton;
}

- (CA_HListFileModel *)listFileModel {
    if (!_listFileModel) {
        CA_HListFileModel *model = [CA_HListFileModel new];
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(BOOL success, BOOL noMore) {
            CA_H_StrongSelf(self);
            [self.tableView.mj_header endRefreshing];
            if (noMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            if (success) {
                
                if (self.listFileModel.page_num.integerValue == 1) {
                    [self.tableView.data removeAllObjects];
                }
                [self.tableView.data addObjectsFromArray:self.listFileModel.data_list];
                [self.tableView reloadData];
            }
            
            if (self.getControllerBlock) {
                [CA_HProgressHUD hideHud:self.getControllerBlock().view];
            }
            [CA_HProgressHUD performSelector:@selector(hideHud:) withObject:self.tableView afterDelay:0.5];
        };
        
        _listFileModel = model;
    }
    return _listFileModel;
}

- (CA_HFileListTableView *)tableView{
    if (!_tableView) {
        CA_HFileListTableView * tableView = [CA_HFileListTableView newTableViewGrouped];
        tableView.searchType = CA_HFileSearchTypeButton;
        
        CA_H_WeakSelf(self)
        tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.listFileModel.loadDataBlock(self.model.file_path, nil);
        }];
        
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            [self.listFileModel loadMore];
        }];
        
        
        tableView.editBlock = ^(UITableViewCell * editCell) {
            CA_H_StrongSelf(self);
            CA_HEditMenuView * menuView = [CA_HEditMenuView new];
            menuView.frame = CA_H_MANAGER.mainWindow.bounds;
            
            NSArray * data;
            if ([editCell isKindOfClass:NSClassFromString(@"CA_HFolderFileCell")]) {
                CA_HBrowseFoldersModel *mod = (id)[(id)editCell model];
                if ([mod.path_option indexOfObject:@"handle"] != NSNotFound) {
                    data = @[@"发送给朋友",
                             @"标签",
                             @"下载",
                             @"移动",
                             @"重命名",
                             @"删除"];
                } else if ([mod.path_option indexOfObject:@"share"] != NSNotFound) {
                    data = @[@"发送给朋友",
                             @"下载"];
                }
                NSMutableArray *mut = [NSMutableArray arrayWithArray:data];
                if (![WXApi isWXAppInstalled]) {
                    [mut removeObject:@"发送给朋友"];
                }
                if (mod.isDownLoad == 1) {
                    [mut removeObject:@"下载"];
                }
                data = mut;
            }else {
                data = @[@"重命名",
                         @"删除"];
            }
            
            CA_H_WeakSelf(self);
            CA_H_WeakSelf(menuView);
            menuView.clickBlock = ^(NSInteger item) {
                CA_H_StrongSelf(menuView);
                CA_H_StrongSelf(self);
                if (item < 0) {
                    
                }else{
                    [self menu:data item:item cell:(id)editCell];
                }
                [menuView hideMenu:YES];
            };
            
            if (data.count > 0) {
                menuView.data = data;
                [CA_H_MANAGER.mainWindow addSubview:menuView];
                [menuView showMenu:YES];
            } else {
                [CA_HProgressHUD showHudStr:@"当前文件没有可执行操作！"];
            }
        };
        
        [tableView nullTitle:_model.file_path.count>2?@"暂无文件":_model.null_msg buttonTitle:nil top:135*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_file"];
//        self.listFileModel.loadDataBlock(_model.file_path);
        
        tableView.pushBlock = ^(NSIndexPath *indexPath) {
            CA_H_StrongSelf(self);
            if (indexPath) {
                if (indexPath.section == 0) {
                    return ;
                }
                CA_HBrowseFoldersModel *model = self.tableView.data[indexPath.row];
                if ([model.file_type isEqualToString:@"directory"]) {
                    if (self.pushBlock) {
                        self.pushBlock(@"CA_HBrowseFoldersViewController", @{@"model":model});
                    }
                } else if ([model.file_type isEqualToString:@"file"]){
                    [self browseDocument:model isShare:NO];
                }
            }else{
                if (self.onSearchBlock) {
                    self.onSearchBlock();
                }
            }
        };
        
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark --- LifeCircle

- (void)dealloc {
    
}

#pragma mark --- Custom

- (void)browseDocument:(CA_HBrowseFoldersModel *)model isShare:(BOOL)isShare {
    
    if (!_getControllerBlock) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homeDocumentPath = NSHomeDirectory();
    NSString *filePath;
    
    if (model.isDownLoad == 1) {
        filePath = [[homeDocumentPath stringByAppendingPathComponent:CA_H_FileDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", model.file_id, [CA_HDownloadCenterViewModel fileName:model.file_name transcoding:YES]]];
    } else {
        
        NSString *path = [[homeDocumentPath stringByAppendingPathComponent:CA_H_FileCachesDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/", model.file_id]];
        
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        filePath = [path stringByAppendingString:[CA_HDownloadCenterViewModel fileName:model.file_name transcoding:YES]];
    }
    
    
    if ([fileManager fileExistsAtPath:filePath]) {
        if (isShare) {
            [self shareFilePath:filePath];
        } else {
            [CA_H_MANAGER browseDocument:[NSURL fileURLWithPath:filePath] viewController:self.getControllerBlock() noShare:NO];
        }
        
    } else {
        
        if (isShare) {
            CA_HShareToFriendController *shareVC = [CA_HShareToFriendController new];
            shareVC.viewModel.model = model;
            [self.getControllerBlock() presentViewController:shareVC animated:NO completion:nil];
            
            CA_H_WeakSelf(shareVC);
            NSURLSessionDownloadTask *dataTask =
            [CA_HNetManager downloadUrlStr:model.storage_path path:filePath callBack:^(CA_HNetModel *netModel) {
                CA_H_StrongSelf(shareVC);
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (!netModel.error) {
                        shareVC.viewModel.progress = 2;
                        return ;
                    }
                }
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                }
                
            } progress:^(NSProgress *requestProgress) {
                CA_H_StrongSelf(shareVC);
                shareVC.viewModel.progress = 1.0*requestProgress.completedUnitCount/requestProgress.totalUnitCount;
            }];
            
            CA_H_WeakSelf(self);
            shareVC.viewModel.shareBlock = ^ (BOOL success) {
                CA_H_StrongSelf(self);
                if (success) {
                    [self shareFilePath:filePath];
                } else {
                    [dataTask cancel];
                }
            };
            
        } else {
            [CA_HProgressHUD showHud:@""];
            CA_H_WeakSelf(self);
            [CA_HNetManager downloadUrlStr:model.storage_path path:filePath callBack:^(CA_HNetModel *netModel) {
                CA_H_StrongSelf(self);
                [CA_HProgressHUD hideHud];
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (!netModel.error) {
                        [CA_H_MANAGER browseDocument:[NSURL fileURLWithPath:filePath] viewController:self.getControllerBlock() noShare:NO];
                        return ;
                    }
                }
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                }

            } progress:nil];
        }
    }
    
}

- (void)shareFilePath:(NSString *)filePath {
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[[NSURL fileURLWithPath:filePath]] applicationActivities:nil];
    
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList];
    //给activityVC的属性completionHandler写一个block。
    //用以UIActivityViewController执行结束后，被调用，做一些后续处理。
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray * returnedItems, NSError * activityError)
    {
        NSLog(@"activityType :%@", activityType);
        if (completed)
        {
            NSLog(@"completed");
//            activityType    __NSCFString *    @"com.apple.UIKit.activity.RemoteOpenInApplication-ByCopy"    0x00000001cc097660
            
            
        }
        else
        {
            NSLog(@"cancel");
        }
    };
    
    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    activityVC.completionWithItemsHandler = myBlock;
    
    [self.getControllerBlock() presentViewController:activityVC animated:YES completion:nil];
}

- (void)createDirectory {
    
    if (_getControllerBlock) {
        CA_H_WeakSelf(self);
        [CA_HNewFolderManager newFolder:_model.file_id parentPath:_model.file_path callBack:^(CA_HNetModel *netModel) {
            CA_H_StrongSelf(self);
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    
                    if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                        
                        if (self.tableView.data.count==0) {
                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        
                        [self.tableView.data insertObject:[CA_HBrowseFoldersModel modelWithDictionary:netModel.data] atIndex:0];
                        if (self.tableView.data.count>1
                            &&
                            self.tableView.mj_footer.state != MJRefreshStateNoMoreData) {
                            [self.tableView.data removeLastObject];
                            NSIndexPath *indexPathDelete = [NSIndexPath indexPathForRow:self.tableView.data.count-1 inSection:1];
                            [self.tableView deleteRowAtIndexPath:indexPathDelete withRowAnimation:UITableViewRowAnimationNone];
                        }
                        NSIndexPath *indexPathZero = [NSIndexPath indexPathForRow:0 inSection:1];
                        [self.tableView insertRowAtIndexPath:indexPathZero withRowAnimation:UITableViewRowAnimationLeft];
                        [self.tableView scrollToRowAtIndexPath:indexPathZero atScrollPosition:UITableViewScrollPositionNone animated:YES];
                        return ;
                    }
                }
                
            }
            if (netModel.error.code != -999) {
                [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
            }
            
        } controller:_getControllerBlock()];
    }
}

- (void)menu:(NSArray *)data item:(NSInteger)item cell:(CA_HBaseTableCell *)cell{
    
    if (!_getControllerBlock) {
        return ;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CA_HBrowseFoldersModel *model = self.tableView.data[indexPath.row];
    
    if ([model.file_type isEqualToString:@"directory"]) {//文件夹
        
        if (item) { // 删除
            CA_H_WeakSelf(self);
            [CA_HNewFolderManager deleteFolder:model.parent_id fileId:model.file_id filePath:model.file_path callBack:^(CA_HNetModel *netModel) {
                CA_H_StrongSelf(self);
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.integerValue == 0) {
                        
                        [self.tableView.data removeObjectAtIndex:indexPath.row];
                        
                        [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
                        
                        return ;
                    }
                }
                
                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                }
                
            } controller:_getControllerBlock()];
        }else { // 重命名
            CA_H_WeakSelf(self);
            [CA_HNewFolderManager renameFolder:model.parent_id parentPath:model.parent_path fileId:model.file_id folderName:model.file_name callBack:^(CA_HNetModel *netModel) {
                CA_H_StrongSelf(self);
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.integerValue == 0) {
                        
                        if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                            [self.tableView.data replaceObjectAtIndex:indexPath.row withObject:[CA_HBrowseFoldersModel modelWithDictionary:netModel.data]];
                            
                            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                            
                            return ;
                        }
                    }
                }
                
                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                }
                
            } controller:_getControllerBlock()];
        }
    } else if ([model.file_type isEqualToString:@"file"]) {//文件
        
        NSString *dataStr = data[item];
        if ([dataStr isEqualToString:CA_H_LAN(@"标签")]) {
            [self menuTags:cell];
        } else if ([dataStr isEqualToString:CA_H_LAN(@"发送给朋友")]) {
            [self browseDocument:model isShare:YES];
        } else if ([dataStr isEqualToString:CA_H_LAN(@"下载")]) {
            model.isDownLoad = 3;
            cell.model = cell.model;
            model.downloadBlock();
        } else if ([dataStr isEqualToString:CA_H_LAN(@"移动")]) {
            
            if (_pushBlock) {
                CA_H_WeakSelf(self);
                _pushBlock(@"CA_HChooseFolderViewController", @{@"chooseBlock":^UIViewController *(CA_HBrowseFoldersModel *parentModel){
                    CA_H_StrongSelf(self);
                    
                    CA_H_WeakSelf(self);
                    [CA_HNewFileManager moveFile:model.parent_id parentPath:parentModel.file_path fileId:model.file_id callBack:^(CA_HNetModel *netModel) {
                        CA_H_StrongSelf(self);
                        if (netModel.type == CA_H_NetTypeSuccess) {
                            if (netModel.errcode.integerValue == 0) {
                                
                                [CA_HProgressHUD showHudStr:@"移动成功!"];
                                
                                if (![parentModel.file_path isEqualToArray:self.model.file_path]) {
                                    [self.tableView.data removeObjectAtIndex:indexPath.row];
                                    
                                    [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
                                }
                                
                                
                                return ;
                            }
                        }
                        
                        if (netModel.error.code != -999) {
                            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                        }
                        
                    }];
                    
                    return self.getControllerBlock();
                }});
            }
            
        } else if ([dataStr isEqualToString:CA_H_LAN(@"重命名")]) {
            CA_H_WeakSelf(self);
            [CA_HNewFileManager renamefile:model.parent_id parentPath:model.parent_path fileId:model.file_id fileName:model.file_name callBack:^(CA_HNetModel *netModel) {
                CA_H_StrongSelf(self);
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.integerValue == 0) {
                        
                        if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                            [self.tableView.data replaceObjectAtIndex:indexPath.row withObject:[CA_HBrowseFoldersModel modelWithDictionary:netModel.data]];
                            
                            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                            
                            return ;
                        }
                    }
                }
                
                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                }
                
            } controller:_getControllerBlock()];
            
        } else if ([dataStr isEqualToString:CA_H_LAN(@"删除")]) {
            CA_H_WeakSelf(self);
            [CA_HNewFileManager deleteFile:model.parent_id fileId:model.file_id callBack:^(CA_HNetModel *netModel) {
                CA_H_StrongSelf(self);
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.integerValue == 0) {
                        
                        [self.tableView.data removeObjectAtIndex:indexPath.row];
                        
                        [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
                        
                        return ;
                    }
                }
                
                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                }
            } controller:_getControllerBlock()];
        }
    }
}


// 标签
- (void)menuTags:(CA_HBaseTableCell *)cell {
    if (_getControllerBlock) {
        CA_HChooseTagMenuController *tagMenuVC = [CA_HChooseTagMenuController new];
        CA_H_WeakSelf(self);
        tagMenuVC.viewModel.dataCorrectionBlock = ^(NSArray *tags) {
            CA_H_StrongSelf(self);
            NSArray *oldTags = [cell.model valueForKey:@"tags"];
            if ([oldTags isEqualToArray:tags]) {
                return;
            }
            
            NSNumber *fileId = [cell.model valueForKey:@"file_id"];
            if (!(fileId&&tags)) {
                [CA_HProgressHUD showHudStr:@"系统错误!"];
                return;
            }
            
            NSMutableArray *tagsId = [NSMutableArray new];
            for (CA_HFileTagModel *tag in tags) {
                [tagsId addObject:tag.tag_id];
            }
            
            NSDictionary *parameters = @{@"file_id":fileId,
                                         @"tags_id":tagsId};
            
            [CA_HNetManager postUrlStr:CA_H_Api_UpdateFileTags parameters:parameters callBack:^(CA_HNetModel *netModel) {
                CA_H_StrongSelf(self);
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.integerValue == 0) {
                        if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                            
                            [cell.model modelSetWithDictionary:netModel.data];
                            
                            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                            
                            return;
                        }
                    }
                }

                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                }
            } progress:nil];
            
        };
        tagMenuVC.viewModel.oldTagsBlock([cell.model valueForKey:@"tags"]);
        CA_H_DISPATCH_MAIN_THREAD(^{
            [_getControllerBlock() presentViewController:tagMenuVC animated:NO completion:^{
                
            }];
        });
    }
}

@end
