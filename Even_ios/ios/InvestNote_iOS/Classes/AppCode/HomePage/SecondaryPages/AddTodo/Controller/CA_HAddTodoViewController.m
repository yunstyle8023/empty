//
//  CA_HAddTodoViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAddTodoViewController.h"

#import "CA_HAddTodoViewModel.h"
#import "CA_HAddTodoCell.h"

#import "CA_HMoveListViewController.h" //选择项目
#import "CA_HDatePicker.h" //截止时间
#import "CA_HRemarkViewController.h" //添加备注
#import "CA_HChooseParticipantsViewController.h" //添加成员

#import "CA_HTodoDetailViewController.h"

#import "CA_HBorwseFileManager.h"

@interface CA_HAddTodoViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) CA_HAddTodoViewModel *viewModel;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CA_HAddTodoViewController


#pragma mark --- Action

- (void)onButton:(UIButton *)sender{
    UITextField *textField = [self.titleView viewWithTag:102];
    if (textField.text.length == 0) {
        [self presentAlertTitle:nil message:CA_H_LAN(@"请填写待办标题后再保存") buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
        return;
    }
    if (textField.text.length > 30) {
        [self presentAlertTitle:nil message:CA_H_LAN(@"标题最多只能输入30个汉字") buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
        return;
    }
    
    if (self.viewModel.updateFileManager.contents.count > 0) {
        [self presentAlertTitle:nil message:CA_H_LAN(@"请等待文件上传完成后再保存") buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
        return;
    }
    
    self.viewModel.TodoName = textField.text;
}


#pragma mark --- Lazy

- (CA_HAddTodoViewModel *)viewModel {
    if (!_viewModel) {
        CA_HAddTodoViewModel * viewModel = [CA_HAddTodoViewModel new];
        _viewModel = viewModel;
        
        CA_H_WeakSelf(self);
        viewModel.pushDetailBlock = ^(NSDictionary *dic, BOOL isEdit) {
            CA_H_StrongSelf(self);
            CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
            vc.dic = dic;
            [self.navigationController pushViewController:vc animated:YES];
            
            NSMutableArray *arr = self.navigationController.viewControllers.mutableCopy;
            
            if (isEdit) {
                NSInteger index = [arr indexOfObject:self];
                if (index != NSNotFound && index >= 1) {
                    [arr removeObjectAtIndex:index-1];
                }
            }
            [arr removeObject:self];
            [self.navigationController setViewControllers:arr animated:YES];
        };
    }
    return _viewModel;
}

- (void)setDetailModel:(CA_HTodoDetailModel *)detailModel {
    self.viewModel.detailModel = detailModel;
    UITextField *textField = [self.titleView viewWithTag:102];
    textField.text = detailModel.todo_name;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = self.viewModel.titleViewBlock(self);
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = self.viewModel.tableViewBlock(self);
    }
    return _tableView;
}

#pragma mark --- LifeCircle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

- (void)viewWillDisappear:(BOOL)animated {
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)onSheet:(NSInteger)index{
    
    CA_H_WeakSelf(self);
    if (index == 1) {
        
        CA_H_MANAGER.fileBlock = ^(NSString *filePath, NSData *data) {
            CA_H_StrongSelf(self);
            CA_HAddFileModel *model = [CA_HAddFileModel new];
            model.type = CA_H_AddFileTypeDocument;
            model.filePath = filePath;
            model.file = data;
            
            self.viewModel.AddFile = model;
        };
        [CA_H_MANAGER presentDocumentPicker:self];
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
            
            self.viewModel.AddFile = model;
        }
        
    };
    [CA_H_MANAGER multiSelectImage:self maxSelected:9];
}

- (void)upView {
    
    self.navigationItem.rightBarButtonItem = self.viewModel.rightBarButtonItemBlock(self, @selector(onButton:));
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(44*CA_H_RATIO_WIDTH, 0, 0, 0));
    
    [self.view addSubview:self.titleView];
    
    self.titleView.sd_layout
    .heightIs(44*CA_H_RATIO_WIDTH)
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
    
    [CA_HProgressHUD loading:self.view];
    CA_H_WeakSelf(self);
    [self.viewModel loadParams:^(BOOL success) {
        CA_H_StrongSelf(self);
        [CA_HProgressHUD hideHud:self.view animated:success];
        UITextField *textField = [self.titleView viewWithTag:102];
        [textField becomeFirstResponder];
    }];
}

- (void)pushToProject:(CA_HAddTodoCell *)todoCell {
    
    if (self.viewModel.detailModel.object_id.integerValue) {
        [CA_HProgressHUD showHudStr:@"已绑定关联项目不可更改"];
        return;
    }
    
    CA_HMoveListViewController *vc = [CA_HMoveListViewController new];
    vc.type = @(2);
    CA_H_WeakSelf(self);
    vc.backBlock = ^(CA_MProjectModel *model) {
        CA_H_StrongSelf(self);
        self.viewModel.model.object_id = model.project_id;
        self.viewModel.model.objectName = model.project_name;
        todoCell.model = self.viewModel.model;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToPeople:(CA_HAddTodoCell *)todoCell {
    
    if (!self.viewModel.model.object_id.integerValue) {
        [CA_HProgressHUD showHudStr:@"请先选择关联项目"];
        return;
    }
    
//    请先选择参与人
    CA_HChooseParticipantsViewController *vc = [CA_HChooseParticipantsViewController new];
    vc.title = CA_H_LAN(@"选择参与人");
    vc.viewModel.selectId = self.viewModel.model.member_id_list;
    vc.viewModel.projectId = self.viewModel.model.object_id;
    vc.viewModel.isAll = NO;
    CA_H_WeakSelf(self);
    vc.viewModel.backBlock = ^(NSArray *peoples) {
        CA_H_StrongSelf(self);
        NSMutableArray *mut = [NSMutableArray new];
        for (CA_HParticipantsModel *mod in peoples) {
            if ([mod isKindOfClass:[CA_HParticipantsModel class]]) {
                [mut addObject:mod.user_id];
            }
        }
        self.viewModel.model.member_id_list = mut;
        self.viewModel.model.peoples = peoples;
        todoCell.model = self.viewModel.model;
    };
    
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:^{
        
    }];
}
- (void)pushToDate:(CA_HAddTodoCell *)todoCell {
    CA_H_WeakSelf(self);
    [[CA_HDatePicker new] presentDatePicker:CA_H_LAN(@"截止时间") dateBlock:^(UIDatePicker *datePicker) {
        CA_H_StrongSelf(self);
        self.viewModel.model.ts_finish = @(datePicker.date.timeIntervalSince1970);
        self.viewModel.model.finishDate = datePicker.date;
        todoCell.model = self.viewModel.model;
    }];
}

- (void)pushToRemind:(CA_HAddTodoCell *)todoCell {
    
    if (!self.viewModel.model.ts_finish.integerValue) {
        [CA_HProgressHUD showHudStr:@"请先设置截止时间"];
        return;
    }
    
    
    if (!self.viewModel.remindData) {
        [CA_HProgressHUD showHud:nil];
        CA_H_WeakSelf(self);
        [self.viewModel loadParams:^(BOOL success) {
            CA_H_StrongSelf(self);
            [CA_HProgressHUD hideHud];
            if (self.viewModel.remindData) {
                [self pushToRemind:todoCell];
            }
        }];
        return;
    }
    
    CA_HDatePicker *picker = [CA_HDatePicker new];
    picker.modeToStrBlock = ^NSString *(NSDictionary *model) {
        NSString *text = model[@"remind_time_value"];
        if (text.length) {
            return [NSString stringWithFormat:@"%@前", text];
        } else {
            return @"";
        }
    };
    picker.data = @[self.viewModel.remindData];
    CA_H_WeakSelf(self);
    [picker presentPickerView:@"设置提醒" pickerBlock:^(UIPickerView *pickerView) {
        CA_H_StrongSelf(self);
        NSInteger item = [pickerView selectedRowInComponent:0];
        self.viewModel.model.remind_time = self.viewModel.remindData[item][@"remind_time"];
        self.viewModel.model.remind_time_desc = self.viewModel.remindData[item][@"remind_time_value"];
        todoCell.model = self.viewModel.model;
    }];
}

- (void)pushToFirst:(CA_HAddTodoCell *)todoCell {
    
    if (!self.viewModel.tagData) {
        [CA_HProgressHUD showHud:nil];
        CA_H_WeakSelf(self);
        [self.viewModel loadParams:^(BOOL success) {
            CA_H_StrongSelf(self);
            [CA_HProgressHUD hideHud];
            if (self.viewModel.tagData) {
                [self pushToFirst:todoCell];
            }
        }];
        return;
    }
    
    CA_HDatePicker *picker = [CA_HDatePicker new];
    picker.modeToStrBlock = ^NSString *(NSDictionary *model) {
        return model[@"tag_level_value"]?:@"";
    };
    picker.data = @[self.viewModel.tagData];
    CA_H_WeakSelf(self);
    [picker presentPickerView:@"设置优先级" pickerBlock:^(UIPickerView *pickerView) {
        CA_H_StrongSelf(self);
        NSInteger item = [pickerView selectedRowInComponent:0];
        self.viewModel.model.tag_level = self.viewModel.tagData[item][@"tag_level"];
        self.viewModel.model.tag_level_desc = self.viewModel.tagData[item][@"tag_level_value"];
        todoCell.model = self.viewModel.model;
    }];
}

- (void)pushToRemark:(CA_HAddTodoCell *)todoCell {
    NSString * remark = @"";
    if ([todoCell.textLabel.textColor isEqual:CA_H_4BLACKCOLOR]) {
        remark = todoCell.textLabel.text;
    }
    CA_HRemarkViewController *vc = [CA_HRemarkViewController new];
    
    vc.title = CA_H_LAN(@"备注");
    vc.placeholderText = CA_H_LAN(@"填写备注内容...");
    vc.text = remark?:@"";
    CA_H_WeakSelf(self);
    vc.backBlock = ^(NSString *text) {
        CA_H_StrongSelf(self);
        self.viewModel.model.todo_content = text;
        todoCell.model = self.viewModel.model;
    };
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:^{
        
    }];
}
- (void)pushToFile:(CA_HAddTodoCell *)todoCell {
    CA_H_WeakSelf(self);
    [self presentActionSheetTitle:CA_H_LAN(@"添加文件")
                          message:nil
                          buttons:@[CA_H_LAN(@"选择图片"),CA_H_LAN(@"选择文件")]
                       clickBlock:^(UIAlertController *alert, NSInteger index) {
                           
                           [self onSheet:index];
                       }];
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
    
    UITextField *textField = [self.titleView viewWithTag:102];
    CA_HTodoModel *model = self.viewModel.model;
    
    if (textField.text.length>0
        ||
        model.object_id.integerValue>0
        ||
        model.ts_finish.integerValue>0
        ||
        model.todo_content.length>0
        ||
        model.file_id_list.count>0
        ||
        self.viewModel.updateFileManager.contents.count>0) {
        
        [self.view endEditing:YES];
        CA_H_WeakSelf(self);
        [self presentAlertTitle:nil message:CA_H_LAN(@"是否保存当前待办后离开?") buttons:@[CA_H_LAN(@"不保存"), CA_H_LAN(@"保存")] clickBlock:^(UIAlertController *alert, NSInteger index) {
            CA_H_StrongSelf(self);
            if (index == 1) {
                [self onButton:nil];
            } else {
                [super ca_backAction];
            }
        }];
        
        return NO;
    }
    return YES;
}

#pragma mark --- TextField

- (void)textFieldEditingChanged:(UITextField *)textField {
    if (textField.markedTextRange == nil) {
        if (textField.text.length > 30) {
            [self presentAlertTitle:nil message:CA_H_LAN(@"标题最多只能输入30个汉字") buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
            textField.text = [textField.text substringToIndex:30];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --- Table

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 5) {
        return self.viewModel.files.count+1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 54*CA_H_RATIO_WIDTH;
    }else{
        return 80*CA_H_RATIO_WIDTH;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.cellForRowBlock(tableView, indexPath);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[CA_HAddTodoCell class]]) {
        CA_HAddTodoCell * todoCell = (id)cell;
        CA_H_DISPATCH_MAIN_THREAD(^{
            switch (indexPath.section) {
                case CA_H_AddTodoTypeProject:
                    [self pushToProject:todoCell];
                    break;
                case CA_H_AddTodoTypePeople:
                    [self pushToPeople:todoCell];
                    break;
                case CA_H_AddTodoTypeDate:
                    [self pushToDate:todoCell];
                    break;
                case CA_H_AddTodoTypeRemind:
                    [self pushToRemind:todoCell];
                    break;
                case CA_H_AddTodoTypeFirst:
                    [self pushToFirst:todoCell];
                    break;
                case CA_H_AddTodoTypeRemark:
                    [self pushToRemark:todoCell];
                    break;
                case CA_H_AddTodoTypeFile:
                    [self pushToFile:todoCell];
                    break;
                default:
                    break;
            }
        });
    }else{
        CA_HAddFileModel *fileModel = self.viewModel.files[indexPath.row - 1];
        if (fileModel.isFinish) {
            [CA_HBorwseFileManager browseCachesFile:fileModel.file_id fileName:fileModel.fileName fileUrl:fileModel.file_url controller:self];
        }
    }
}

@end
