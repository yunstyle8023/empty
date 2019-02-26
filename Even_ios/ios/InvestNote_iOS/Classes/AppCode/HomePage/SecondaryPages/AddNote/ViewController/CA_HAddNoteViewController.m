//
//  CA_HAddNoteViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAddNoteViewController.h"

#import "CA_HAddNoteViewManager.h"
#import "CA_HBorwseFileManager.h"

#import "CA_HNoteDetailController.h" //详情

@interface CA_HAddNoteViewController () <YYTextKeyboardObserver>

@property (nonatomic, strong) CA_HAddNoteViewManager *viewManager;

@end

@implementation CA_HAddNoteViewController

#pragma mark --- Action

- (void)onRightBar:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [self.viewManager.noteView.titleTextView resignFirstResponder];
    [self.viewManager.noteView.contentTextView resignFirstResponder];
    
    if (self.viewManager.noteView.viewModel.recordManager.recordStopBlock) {
        [CA_HProgressHUD showHudStr:@"请先结束并保存录音"];
        sender.userInteractionEnabled = YES;
        return;
    }
    
    if (self.viewManager.noteView.titleTextView.text.length > 30) {
        [CA_HProgressHUD showHudStr:CA_H_LAN(@"标题最多只能输入30个汉字")];
        sender.userInteractionEnabled = YES;
        return;
    }
    

    NSString *contentStr = [self.viewManager.noteView.contentTextView.text stringByReplacingOccurrencesOfString:CA_H_EDITNOTE withString:@""];
    if (contentStr.length > 20000) {
        [CA_HProgressHUD showHudStr:CA_H_LAN(@"内容最多只能输入20000字，请精简内容")];
        sender.userInteractionEnabled = YES;
        return;
    }
    
    [CA_HProgressHUD showHud:nil];
    [self createNote];
    sender.userInteractionEnabled = YES;
}

#pragma mark --- Lazy

- (CA_HAddNoteViewModel *)viewModel {
    if (!_viewModel) {
        CA_HAddNoteViewModel *viewModel = [CA_HAddNoteViewModel new];
        _viewModel = viewModel;
        
        CA_H_WeakSelf(self);
        viewModel.pushToDetailBlock = ^(NSDictionary *dic) {
            CA_H_StrongSelf(self);
            CA_HNoteDetailController *vc = [CA_HNoteDetailController new];
            vc.dataDic = dic;
            [self.navigationController pushViewController:vc animated:YES];
            
            NSMutableArray *arr = self.navigationController.viewControllers.mutableCopy;
            if (self.viewManager.noteView.viewModel.model) {
                NSInteger index = [arr indexOfObject:self];
                [arr removeObjectAtIndex:index-1];
            }
            [arr removeObject:self];
            [self.navigationController setViewControllers:arr animated:YES];
        };
    }
    return _viewModel;
}

- (CA_HAddNoteViewManager *)viewManager {
    if (!_viewManager) {
        CA_HAddNoteViewManager *viewManager = [CA_HAddNoteViewManager new];
        _viewManager = viewManager;
        
        self.viewManager.noteView = [CA_HAddNoteTextView newWithHuman:self.viewModel.isHuman];
        
        if (self.projectModel) {
            self.viewManager.noteView.viewModel.isProject = YES;
            self.viewManager.noteView.viewModel.projectModel = self.projectModel;
        }
        
        
        CA_H_WeakSelf(self);
        
        viewManager.noteView.playRecord = ^(NSNumber *fileId, NSString *fileName, NSString *fileUrl) {
            CA_H_StrongSelf(self);
            [CA_HBorwseFileManager browseCachesRecord:fileId recordName:fileName fileUrl:fileUrl controller:self];
        };
        
        viewManager.noteView.browseDocument = ^ReturnBlock (BOOL isFinish) {
            CA_H_StrongSelf(self);
            if (!isFinish) {
                [CA_H_MANAGER presentDocumentPicker:self];
            }
            return ^(NSNumber *fileId, NSString *fileName, NSString *fileUrl){
                CA_H_StrongSelf(self);
                [CA_HBorwseFileManager browseCachesFile:fileId fileName:fileName fileUrl:fileUrl controller:self];
            };
        };
        
        viewManager.noteView.photoBrowse = ^(NSArray *items, UIImageView *imageView) {
            CA_H_StrongSelf(self);
            
            YYPhotoBrowseView * photoView = [[YYPhotoBrowseView alloc]initWithGroupItems:items];
            photoView.blurEffectBackground = NO;
            
            CA_H_WeakSelf(self);
            photoView.getControllerBlock = ^UIViewController *(BOOL statusBarHidden) {
                CA_H_StrongSelf(self);
                self.viewModel.statusBarHidden = statusBarHidden;
                return self;
            };
            
            [photoView presentFromImageView:imageView toContainer:CA_H_MANAGER.mainWindow animated:YES completion:^{
                photoView.pager.hidden = YES;
            }];
        };
        
        viewManager.noteView.selectImage = ^(NSInteger item) {
            CA_H_StrongSelf(self);
            switch (item) {
                case 1:
                    [CA_H_MANAGER selectImageFromCamera:self];
                    break;
                case 2:
                    [CA_H_MANAGER multiSelectImage:self maxSelected:9];
                    break;
                default:
                    break;
            }
        };
        
        viewManager.noteView.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            UIViewController * vc = [NSClassFromString(classStr) new];
            [vc setValuesForKeysWithDictionary:kvcDic];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        viewManager.noteView.textViewDidChange = ^(NSString *title, NSString *content) {
            CA_H_StrongSelf(self);
            NSString *myTitle = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *myContent = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            self.viewManager.rightButton.enabled = (myTitle.length&&myContent.length);
        };
        
        if (self.viewModel.model) {
            viewManager.noteView.viewModel.model = self.viewModel.model;
        }
        
        

    }
    return _viewManager;
}

- (void)setHumamId:(NSNumber *)humamId {
    _humamId = humamId;
    self.viewModel.isHuman = (humamId.integerValue > 0);
}

#pragma mark --- LifeCircle

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)createNote {
//    NSArray *array = self.viewManager.noteView.viewModel.uploadManager.updateFileManager.contents;
//    if (array&&array.count > 0) {
//
//        [CA_HProgressHUD hideHud:CA_H_MANAGER.mainWindow animated:NO];
//        [CA_HProgressHUD showHudStr:@"当前有文件未上传若保存笔记，未上传的文件将被删除。"];
//        return;
//    }
    
    NSMutableArray<CA_HAddNoteManager *> *mutArray = [NSMutableArray new];
    
    for (CA_HAddNoteManager *noteManager in self.viewManager.noteView.viewModel.contentArray) {
        if (!noteManager.addFileModel.isFinish) {
            [mutArray addObject:noteManager];
        }
    }
    if (mutArray.count > 0) {
        [CA_HProgressHUD hideHud:CA_H_MANAGER.mainWindow animated:NO];
        CA_H_WeakSelf(self);
        [self presentAlertTitle:nil message:@"当前有文件未上传若保存笔记，未上传的文件将被删除。" buttons:@[@"仍要保存",@[@"取消"]] clickBlock:^(UIAlertController *alert, NSInteger index) {
            CA_H_StrongSelf(self);
            if (index == 0) {
                [CA_HProgressHUD showHud:nil];
                for (CA_HAddNoteManager *noteManager in mutArray) {
                    [noteManager onDeleteButton:nil];
                }
                if (self.viewManager.noteView.contentTextView.text.length > 0) {
                    [self createNote];
                } else {
                    [CA_HProgressHUD hideHud:CA_H_MANAGER.mainWindow animated:NO];
                    [CA_HProgressHUD showHudStr:@"请填写笔记内容再保存"];
                }
            } else {
                [self.viewManager.noteView.viewModel.uploadManager.updateFileManager update:nil];
            }
        }];
        return;
    }
    
    
    if (self.viewModel.isHuman) {
        [self.viewModel.parameters setObject:self.humamId forKey:@"object_id"];
        [self.viewModel.parameters setObject:@"human" forKey:@"object_type"];
        [self.viewModel.parameters setObject:@(0) forKey:@"note_type_id"];
    } else {
        [self.viewModel.parameters setObject:self.viewManager.noteView.viewModel.projectModel.project_id?:@(0) forKey:@"object_id"];
        [self.viewModel.parameters setObject:self.viewManager.noteView.viewModel.projectModel.project_id?@"project":@"person" forKey:@"object_type"];
        [self.viewModel.parameters setObject:self.viewManager.noteView.viewModel.typeModel.note_type_id?:@(0) forKey:@"note_type_id"];
    }
    [self.viewModel.parameters setObject:self.viewManager.noteView.titleTextView.text forKey:@"note_title"];
    
    self.viewModel.Content = self.viewManager.noteView.viewModel.saveContent;
    
    if (self.viewManager.noteView.viewModel.model.note_id) {
        self.viewModel.urlStr = CA_H_Api_UpdateNote;
        [self.viewModel.parameters setObject:self.viewManager.noteView.viewModel.model.note_id forKey:@"note_id"];
        [self.viewModel createNote];
    } else {
        self.viewModel.urlStr = CA_H_Api_CreateNote;
        [self.viewModel saveNote];
    }
    
}

- (void)upView {
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    
    self.navigationItem.rightBarButtonItem = [self.viewManager barButtonItem:self action:@selector(onRightBar:)];
    self.viewManager.rightButton.enabled = NO;
    
    [self.view addSubview:self.viewManager.noteView];
    self.viewManager.noteView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self.viewManager.noteView.titleTextView becomeFirstResponder];
}

#pragma mark --- Status

- (BOOL)prefersStatusBarHidden {
    return self.viewModel.statusBarHidden;//隐藏为YES，显示为NO
}

#pragma mark --- Keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    self.viewManager.noteView.sd_closeAutoLayout = YES;
    if (transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            self.viewManager.noteView.frame = textFrame;
            [self.viewManager.noteView layoutSubviews];
            clipped = YES;
        }
    }
    
    if (!clipped) {
        self.viewManager.noteView.frame = self.view.bounds;
        [self.viewManager.noteView layoutSubviews];
    }
}

#pragma mark --- Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self shouldBack];
}

- (void)ca_backAction {
    if ([self shouldBack]) {
        [super ca_backAction];
    }
}

- (BOOL)shouldBack {
    
    CA_HAddNoteTextView *noteView = self.viewManager.noteView;
    if (noteView.titleTextView.text.length
        ||
        noteView.contentTextView.text.length
        ||
        noteView.tagText.length) {
        
        [self.viewManager.noteView.titleTextView resignFirstResponder];
        [self.viewManager.noteView.contentTextView resignFirstResponder];
        
        CA_H_WeakSelf(self);
        [self presentAlertTitle:nil message:CA_H_LAN(@"是否保存当前笔记后离开?") buttons:@[CA_H_LAN(@"不保存"), CA_H_LAN(@"保存")] clickBlock:^(UIAlertController *alert, NSInteger index) {
            CA_H_StrongSelf(self);
            if (index == 1) {
                if (self.viewManager.rightButton.enabled) {
                    [self onRightBar:self.navigationItem.rightBarButtonItem.customView];
                } else if (self.viewManager.noteView.titleTextView.text.length
                           &&
                           self.viewManager.noteView.contentTextView.text.length) {
                    [super ca_backAction];
                }
            } else {
                [super ca_backAction];
            }
        }];
        
        return NO;
    }
    return YES;
}

@end
