//
//  CA_HAddNoteTextView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAddNoteTextView.h"

#import "CA_HSelectMenuView.h"

#import "CA_HPrivacyCheck.h"

@interface CA_HAddNoteTextView () <YYTextViewDelegate>

@property (nonatomic, strong) NSArray *typeData;

@end

@implementation CA_HAddNoteTextView

#pragma mark --- Action

- (void)showMenu {
    [self.contentTextView resignFirstResponder];
    if (_typeData) {
        CA_HSelectMenuView * selectMenuView = [CA_HSelectMenuView new];
        selectMenuView.frame = CA_H_MANAGER.mainWindow.bounds;
        
        NSMutableArray *data = [NSMutableArray new];
        [data addObject:CA_H_LAN(@"选择笔记类型")];
        for (CA_HNoteTypeModel *typeModel in self.typeData) {
            [data addObject:typeModel.note_type_name];
        }
        
        CA_H_WeakSelf(selectMenuView);
        CA_H_WeakSelf(self);
        selectMenuView.clickBlock = ^(NSInteger item) {
            CA_H_StrongSelf(selectMenuView);
            CA_H_StrongSelf(self);
            
            if (item > 0) {
                self.viewModel.typeModel = self.typeData[item-1];
                self.tagText = self.viewModel.typeModel.note_type_name;
                [self.contentTextView becomeFirstResponder];
            }
            
            [selectMenuView hideMenu:YES];
        };
        selectMenuView.data = data;
        [CA_H_MANAGER.mainWindow addSubview:selectMenuView];
        [selectMenuView showMenu:YES];
    } else {
        [CA_HProgressHUD showHud:nil];
        CA_H_WeakSelf(self);
        [CA_HNetManager postUrlStr:CA_H_Api_ListNoteType parameters:@{} callBack:^(CA_HNetModel *netModel) {
            [CA_HProgressHUD hideHud];
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    if ([netModel.data isKindOfClass:[NSArray class]]) {
                        CA_H_StrongSelf(self);
                        NSMutableArray *data = [NSMutableArray new];
                        for (NSDictionary *dic in netModel.data) {
                            [data addObject:[CA_HNoteTypeModel modelWithDictionary:dic]];
                        }
                        self.typeData = data;
                        [self showMenu];
                        return;
                    }
                }
            }
            if (netModel.error.code != -999) {
        [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
    }
        } progress:nil];
    }
}

- (void)onKeyboardButton:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{
            if (self.viewModel.isProject) {
                [self showMenu];
            } else {
                if (_pushBlock) {
                    CA_H_WeakSelf(self);
                    _pushBlock(@"CA_HMoveListViewController", @{@"type":@(1),@"noteTypeBlock":^(CA_MProjectModel *model, CA_HNoteTypeModel *typeModel){
                        CA_H_StrongSelf(self);
                        self.viewModel.projectModel = model;
                        self.viewModel.typeModel = typeModel;
                        self.tagText = [NSString stringWithFormat:@"%@·%@", model.project_name, typeModel.note_type_name];
                    }});
                }
            }
        }break;
        case 101:{
            [self.contentTextView resignFirstResponder];
            
            CA_H_WeakSelf(self);
            self.viewModel.selectMenuBlock = ^(NSInteger item) {
                CA_H_StrongSelf(self);
                if (item > 0) {
                    [self selectImage:item];
                }else{
                    [self.contentTextView becomeFirstResponder];
                }
            };
        }break;
        case 102:{
            if (_browseDocument) {
                ReturnBlock block = _browseDocument(NO);
                CA_H_WeakSelf(self);
                CA_H_MANAGER.fileBlock = ^(NSString *filePath, NSData *data) {
                    CA_H_StrongSelf(self);
                    [self.contentTextView becomeFirstResponder];
                    CA_HAddFileModel *model = [CA_HAddFileModel new];
                    model.type = CA_H_AddFileTypeDocument;
                    model.filePath = filePath;
                    model.file = data;
                    
                    CA_H_WeakSelf(self);
                    [self.viewModel.uploadManager.updateFileManager saveToTmp:model success:^{
                        CA_H_StrongSelf(self);
                        
                        [self.viewModel.uploadManager addFile:model];
                        CA_HAddNoteManager * manager = self.viewModel.addFile([filePath componentsSeparatedByString:@"/"].lastObject);
                        manager.updateFileManager = self.viewModel.uploadManager.updateFileManager;
                        manager.addFileModel = model;
                        manager.clickBlock = ^(CA_HAddNoteManager *clickModel) {
                            if (block) {
                                block(clickModel.addFileModel.file_id, clickModel.addFileModel.fileName, clickModel.addFileModel.file_url);
                            }
                        };
                    } failed:^{
                        
                    }];
                    
                };
            }
        }break;
        default:{
            
            CA_H_WeakSelf(self);
            [CA_HPrivacyCheck checkCameraAuthorizationGrand:^{
                CA_H_StrongSelf(self);
                CA_H_WeakSelf(self);
                
                UIButton * button = [sender.superview viewWithTag:(207 - sender.tag)];
                sender.hidden = YES;
                button.hidden = NO;
                
                
                if (sender.tag == 103) {
                    
                    CA_H_MANAGER.recorderStopBlock = ^{
                        CA_H_StrongSelf(self);
                        [self onKeyboardButton:button];
                    };
                    
                    self.viewModel.addRecord(YES);
                    self.viewModel.recordManager.recordStopBlock = ^{
                        CA_H_StrongSelf(self);
                        [CA_HProgressHUD showHudStr:CA_H_LAN(@"录音时间过长已自动停止")];
                        [self onKeyboardButton:button];
                    };
                    self.viewModel.recordManager.clickBlock = ^(CA_HAddNoteManager *clickModel) {
                        CA_H_StrongSelf(self);
                        if (!clickModel.addFileModel.isFinish) {
                            if (clickModel.addFileModel) {
                                [CA_HProgressHUD showHudStr:CA_H_LAN(@"录音文件上传中...")];
                            }
                            return ;
                        }
                        if (self.playRecord) {
                            self.playRecord(clickModel.addFileModel.file_id, clickModel.addFileModel.fileName, clickModel.addFileModel.file_url);
                        }
                        
                    };
                    
                } else {
                    self.viewModel.recordManager.recordStopBlock = nil;
                    self.viewModel.addRecord(NO);
                }
                
            } withNoPermission:^{
                [CA_HProgressHUD showHudStr:@"您的设备未授权录音权限!"];
            } controller:self.viewController];
            
        }break;
    }
}


#pragma mark --- Lazy

- (CA_HAddNoteTextViewModel *)viewModel {
    if (!_viewModel) {
        CA_HAddNoteTextViewModel *viewModel = [CA_HAddNoteTextViewModel new];
        
        CA_H_WeakSelf(self);
        viewModel.toModel = ^YYTextView *(CA_HNoteDetailModel *model) {
            CA_H_StrongSelf(self);
            
            if (model) {
                
                if ([model.object_type isEqualToString:@"project"]) {
//                    self.viewModel.isProject = YES;
                    CA_MProjectModel *projectModel = [CA_MProjectModel new];
                    projectModel.project_id = model.object_id;
                    projectModel.project_name = model.object_name;
                    self.viewModel.projectModel = projectModel;
                    if (model.note_type_id.integerValue) {
                        CA_HNoteTypeModel *typeModel = [CA_HNoteTypeModel new];
                        typeModel.note_type_id = model.note_type_id;
                        typeModel.note_type_name = model.note_type_name;
                        self.viewModel.typeModel = typeModel;
                    }
                }
                
                self.titleTextView.text = model.note_title;
                NSMutableString *text = [NSMutableString new];
                [text appendString:model.object_name];
                if (text.length&&model.note_type_name.length) {
                    [text appendString:@"·"];
                }
                [text appendString:model.note_type_name];
                self.tagText = text;
            }
            
            if (self.textViewDidChange) {
                self.textViewDidChange(self.titleTextView.text, self.contentTextView.text);
            }
            
            return self.contentTextView;
        };
        
        viewModel.clickBlock = ^(CA_HAddNoteManager *clickManager) {
            CA_H_StrongSelf(self);
            switch (clickManager.contentModel.enumType) {
                case CA_HAddNoteTypeImage:{
                    [self.titleTextView resignFirstResponder];
                    [self.contentTextView resignFirstResponder];
                    
                    if (self.photoBrowse) {
                        self.photoBrowse(self.viewModel.items, clickManager.contentView.subviews.firstObject);
                    }
                }break;
                case CA_HAddNoteTypeFile:{
                    if (self.browseDocument) {
                        self.browseDocument(clickManager.addFileModel.isFinish)(clickManager.addFileModel.file_id, clickManager.addFileModel.fileName, clickManager.addFileModel.file_url);
                    }
                }break;
                case CA_HAddNoteTypeRecord:{
                    if (!clickManager.addFileModel.isFinish) {
                        if (clickManager.addFileModel) {
                            [CA_HProgressHUD showHudStr:CA_H_LAN(@"录音文件上传中...")];
                        }
                        return ;
                    }
                    if (self.playRecord) {
                        self.playRecord(clickManager.addFileModel.file_id, clickManager.addFileModel.fileName, clickManager.addFileModel.file_url);
                    }
                }break;
                    
                default:
                    break;
            }
        };
        
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (YYTextView *)titleTextView {
    if (!_titleTextView) {
        _titleTextView = self.viewModel.titleTextView(self);
    }
    return _titleTextView;
}

- (YYTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = self.viewModel.contentTextView(self, @selector(onKeyboardButton:));
    }
    return _contentTextView;
}

- (void)setTagText:(NSString *)tagText{
    if (!tagText.length) {
        return;
    }
    _tagText = tagText;
    self.viewModel.tagLabel(tagText, self.titleTextView);
    [self textViewDidChange:self.titleTextView];
}


#pragma mark --- LifeCircle

+ (instancetype)newWithHuman:(BOOL)ishuman {
    CA_HAddNoteTextView *view = [self new];
    view.viewModel.ishuman = ishuman;
    [view upView];
    return view;
}


#pragma mark --- Custom

- (void)upView {
    
    [self addSubview:self.contentTextView];
    self.contentTextView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self.contentTextView addSubview:self.titleTextView];
}

- (void)selectImage:(NSInteger)item {
    if (_photoBrowse&&_selectImage) {
        
        CA_H_WeakSelf(self);
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
                
                
                [self.viewModel.uploadManager.updateFileManager saveToTmp:model success:^{
                    CA_H_StrongSelf(self);
                    
                    [self.viewModel.uploadManager addFile:model];
                    CA_HAddNoteManager *manager = self.viewModel.addImage(image);
                    manager.updateFileManager = self.viewModel.uploadManager.updateFileManager;
                    manager.addFileModel = model;
                    
                    CA_H_WeakSelf(manager);
                    manager.clickBlock = ^(CA_HAddNoteManager *clickModel) {
                        CA_H_StrongSelf(self);
                        CA_H_StrongSelf(manager);
                        [self.titleTextView resignFirstResponder];
                        [self.contentTextView resignFirstResponder];
                        
                        if (self.photoBrowse) {
                            self.photoBrowse(self.viewModel.items, manager.contentView.subviews.firstObject);
                        }
                    };
                    
                } failed:^{
                    
                }];
                
            }
            
            [self.contentTextView becomeFirstResponder];
        };
        
        _selectImage(item);
    }
}


#pragma mark --- YYTextView

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.tag == 110){
        
        if ([text isEqualToString:@"\n"]) {
            [self.contentTextView becomeFirstResponder];
            return NO;
        }
        
        if (text.length == 0) {
            return [CA_HAppManager textView:textView shouldChangeTextInRange:range replacementText:text];
//            return YES;
        }
    }
    
    if (textView.tag == 111) {
        if (text.length > 0) {
            if (range.location >= 2) {
                NSString * str = CA_H_EDITNOTE;
                NSRange contentRange = NSMakeRange(range.location - 2, str.length);
                if (contentRange.location + contentRange.length <= textView.text.length) {
                    NSString * subStr = [textView.text substringWithRange:contentRange];
                    if ([subStr isEqualToString:str]) {
                        textView.selectedRange = NSMakeRange(contentRange.location + contentRange.length, 0);
                    }
                }
            }
        }else{
            if (range.length >= [CA_H_EDITNOTE length]) {
                
                NSString * subStr = [textView.text substringWithRange:range];
                self.viewModel.deleteText(textView, subStr, range);
                if (self.viewModel.recordManager) {
                    
                    NSInteger index = [self.viewModel.contentArray indexOfObject:self.viewModel.recordManager];
                    
                    if (index == NSNotFound) {
                        [CA_H_MANAGER stopRecord];
                        self.viewModel.recordManager = nil;
                        UIButton *playButton = [self.contentTextView.inputAccessoryView viewWithTag:103];
                        playButton.hidden = NO;
                        UIButton *doneButton = [self.contentTextView.inputAccessoryView viewWithTag:104];
                        doneButton.hidden = YES;
                    }
                }
            }
        }
    }
    
    return [CA_HAppManager textView:textView shouldChangeTextInRange:range replacementText:text];
//    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView{
    if (textView.tag == 110) {
        
        NSString *text = textView.text;
        if (text.length > 30) {
            [CA_HProgressHUD showHudStr:CA_H_LAN(@"标题最多只能输入30个汉字")];
            [textView resignFirstResponder];
            [self.contentTextView resignFirstResponder];
            textView.text = [text substringToIndex:30];
        }
        
        textView.contentOffset = CGPointZero;
        textView.size = CGSizeMake(textView.contentSize.width, MAX(textView.contentSize.height, 36*CA_H_RATIO_WIDTH) + (self.tagText.length?60:25)*CA_H_RATIO_WIDTH);
        
        self.contentTextView.textContainerInset = UIEdgeInsetsMake(textView.height, 20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
        [self.contentTextView scrollRangeToVisible:NSMakeRange(0, 0)];
        
        self.contentTextView.placeholderText = CA_H_LAN(@"填写笔记内容...");
    }
    
    if (self.textViewDidChange) {
        self.textViewDidChange(self.titleTextView.text, self.contentTextView.text);
    }
}

@end
