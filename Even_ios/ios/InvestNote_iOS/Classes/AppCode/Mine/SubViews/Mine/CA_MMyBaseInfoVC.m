
//
//  CA_MMyBaseInfoVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MMyBaseInfoVC.h"
#import "CA_MIconCell.h"
#import "CA_MInputCell.h"
#import "CA_MSelectCell.h"
#import "CA_MPersonIntroduceCell.h"
#import "CA_MTypeModel.h"
#import "CA_HSelectMenuView.h"

static NSString* const inputKey = @"CA_MInputCell";
static NSString* const selectKey = @"CA_MSelectCell";
static NSString* const iconKey = @"CA_MIconCell";
static NSString* const introduceKey = @"CA_MPersonIntroduceCell";

@interface CA_MMyBaseInfoVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MInputCellDelegate,
CA_MPersonIntroduceCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIBarButtonItem *rightBarBtnItem;
@property (nonatomic,strong) UIImage *iconImage;

@property (nonatomic,strong) NSMutableArray *oldDataSource;
@end

@implementation CA_MMyBaseInfoVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基本信息";
    self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
    [self.view addSubview:self.tableView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

-(void)ca_backAction{
    
    CA_MTypeModel* newNameModel = [self.dataSource objectAtIndex:1];
    CA_MTypeModel* newSexModel =  [self.dataSource objectAtIndex:2];
    CA_MTypeModel* newIntroModel =  [self.dataSource objectAtIndex:3];
    
    CA_MTypeModel* oldNameModel = [self.oldDataSource objectAtIndex:0];
    CA_MTypeModel* oldSexModel =  [self.oldDataSource objectAtIndex:1];
    CA_MTypeModel* oldIntroModel =  [self.oldDataSource objectAtIndex:2];
    
    if ([newNameModel.value isEqualToString:oldNameModel.value] &&
        [newSexModel.value isEqualToString:oldSexModel.value] &&
        [newIntroModel.value isEqualToString:oldIntroModel.value]) {
        [super ca_backAction];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"内容已更改,是否保存?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self clickRightBarBtnAction];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [super ca_backAction];
                                                             }];
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

-(void)setUserInfo:(CA_HMineUserInfoModel *)userInfo{
    _userInfo = userInfo;
    CA_MTypeModel* iconModel = [CA_MTypeModel new];
    iconModel.title = @"头像";
    iconModel.value = @"选择";
    iconModel.type = ChooseIcon;
    //
    if ([NSString isValueableString:userInfo.avatar]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString* imgUrl = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,userInfo.avatar];
            NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.iconImage = [UIImage imageWithData:imgData];
                [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }
    
    CA_MTypeModel* nameModel = [CA_MTypeModel new];
    nameModel.title = @"姓名";
    nameModel.value = userInfo.chinese_name;
    nameModel.placeHolder = @"请输入姓名";
    nameModel.type = Input;

    CA_MTypeModel* sexModel = [CA_MTypeModel new];
    sexModel.title = @"性别";
    sexModel.value = [NSString isValueableString:userInfo.gender]?userInfo.gender:@"选择";
    sexModel.type = Select;

    CA_MTypeModel* introModel = [CA_MTypeModel new];
    introModel.title = @"个人介绍";
    introModel.value = userInfo.extra;
    introModel.placeHolder = @"请输入个人介绍";
    introModel.type = Introduce;

    [self.dataSource addObjectsFromArray:
     @[iconModel,nameModel,sexModel,introModel]];
    
    
    CA_MTypeModel* oldNameModel = [CA_MTypeModel new];
    oldNameModel.title = @"姓名";
    oldNameModel.value = userInfo.chinese_name;
    oldNameModel.placeHolder = @"请输入姓名";
    oldNameModel.type = Input;
    
    CA_MTypeModel* oldSexModel = [CA_MTypeModel new];
    oldSexModel.title = @"性别";
    oldSexModel.value = [NSString isValueableString:userInfo.gender]?userInfo.gender:@"选择";
    oldSexModel.type = Select;
    
    CA_MTypeModel* oldIntroModel = [CA_MTypeModel new];
    oldIntroModel.title = @"个人介绍";
    oldIntroModel.value = userInfo.extra;
    oldIntroModel.placeHolder = @"请输入个人介绍";
    oldIntroModel.type = Introduce;
    [self.oldDataSource addObjectsFromArray:
     @[oldNameModel,oldSexModel,oldIntroModel]];
    
    [self.tableView reloadData];
}

-(void)clickRightBarBtnAction{
    CA_MTypeModel* newNameModel = [self.dataSource objectAtIndex:1];
    CA_MTypeModel* newSexModel =  [self.dataSource objectAtIndex:2];
    CA_MTypeModel* newIntroModel =  [self.dataSource objectAtIndex:3];
    
    CA_MTypeModel* oldNameModel = [self.oldDataSource objectAtIndex:0];
    CA_MTypeModel* oldSexModel =  [self.oldDataSource objectAtIndex:1];
    CA_MTypeModel* oldIntroModel =  [self.oldDataSource objectAtIndex:2];
    
    if ([newNameModel.value isEqualToString:oldNameModel.value] &&
        [newSexModel.value isEqualToString:oldSexModel.value] &&
        [newIntroModel.value isEqualToString:oldIntroModel.value]) {
        [super ca_backAction];
        return;
    }
    
    NSString* gender = ((CA_MTypeModel*)[self.dataSource objectAtIndex:2]).value;
    
    if ([gender isEqualToString:@"选择"]) {
        [CA_HProgressHUD showHudStr:@"请选择性别"];
        return;
    }
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:[gender isEqualToString:@"选择"]?@"":gender,@"gender",((CA_MTypeModel*)[self.dataSource objectAtIndex:1]).value,@"chinese_name",((CA_MTypeModel*)[self.dataSource objectAtIndex:3]).value,@"extra", nil];
    
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_H_Api_UpdateUserInfo parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}

#pragma mark - CA_MInputCellDelegate
-(void)textDidChange:(CA_MInputCell*)cell content:(NSString*)content{
    CA_MTypeModel* nameModel = (CA_MTypeModel*)[self.dataSource objectAtIndex:1];
    nameModel.value = content;
}

#pragma mark - CA_MPersonIntroduceCellDelegate

-(void)textDidChange:(NSString*)content{
    CA_MTypeModel* introModel = (CA_MTypeModel*)[self.dataSource objectAtIndex:3];
    introModel.value = content;
}

-(void)textLengthDidMax{
    [CA_HProgressHUD showHudStr:@"已达到最大字数限制"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Input) {//姓名
        CA_MInputCell* inputCell = [tableView dequeueReusableCellWithIdentifier:inputKey];
        inputCell.delegate = self;
        [inputCell configCell:model.title text:model.value placeholder:model.placeHolder];
        return inputCell;
    }else if (model.type == Select){//性别
        CA_MSelectCell* selectCell = [tableView dequeueReusableCellWithIdentifier:selectKey];
        [selectCell configCell:model.title :model.value];
        return selectCell;
    }else if (model.type == ChooseIcon){//头像
        CA_MIconCell* iconCell = [tableView dequeueReusableCellWithIdentifier:iconKey];
        [iconCell configCell:model.title image:self.iconImage];
        return iconCell;
    }
    //个人介绍
    CA_MPersonIntroduceCell* introduceCell = [tableView dequeueReusableCellWithIdentifier:introduceKey];
    introduceCell.delegate = self;
    [introduceCell configCell:model.title text:model.value placeHolder:model.placeHolder];
    return introduceCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        CA_HSelectMenuView * selectMenuView = [CA_HSelectMenuView new];
        selectMenuView.frame = CA_H_MANAGER.mainWindow.bounds;
        NSArray * data = @[@"添加图片",
                           @"拍摄照片",
                           @"选择照片"];
        CA_H_WeakSelf(selectMenuView);
        CA_H_WeakSelf(self);
        selectMenuView.clickBlock = ^(NSInteger item) {
            CA_H_StrongSelf(selectMenuView);
            CA_H_StrongSelf(self);
            [selectMenuView hideMenu:YES];
            [self selectImage:item];
        };
        selectMenuView.data = data;
        [CA_H_MANAGER.mainWindow addSubview:selectMenuView];
        [selectMenuView showMenu:YES];
    }else if (indexPath.row == 2) {
        UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CA_MTypeModel* model = [self.dataSource objectAtIndex:2];
            model.value = @"男";
            [self.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CA_MTypeModel* model = [self.dataSource objectAtIndex:2];
            model.value = @"女";
            [self.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [actionSheetController addAction:maleAction];
            [actionSheetController addAction:femaleAction];
            [actionSheetController addAction:cancelAction];
            [self presentViewController:actionSheetController animated:YES completion:nil];
        });
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataSource.count-1) {
        return 187*CA_H_RATIO_WIDTH;
    }
    return 52*CA_H_RATIO_WIDTH;
}

/**
 设置头像
 
 @param item <#item description#>
 */
-(void)selectImage:(NSInteger)item{
    if (item == 1) {//摄像头
        [CA_H_MANAGER selectImageFromCamera:self];
    }else if (item == 2){//相册
        [CA_H_MANAGER selectImageFromAlbum:self];
    }
    
    CA_H_WeakSelf(self);
    CA_H_MANAGER.imageBlock = ^(BOOL success, UIImage *image, NSDictionary *info) {
        CA_H_StrongSelf(self);
        if (success) {
            
            NSURL *url = info[@"PHImageFileURLKey"];
            if (!url) {
                url = info[@"UIImagePickerControllerImageURL"];
            }
            
            NSData *imageData = info[@"ca_imageData"]?:image.imageDataRepresentation;
            NSString *filePath;
            NSString *fileName;
            if (url) {
                filePath = url.absoluteString;
                if ([filePath hasSuffix:@".HEIC"]) {
                    filePath = [filePath stringByReplacingCharactersInRange:NSMakeRange(filePath.length-4, 4) withString:@"jpeg"];
                }
                fileName = [filePath componentsSeparatedByString:@"/"].lastObject;
            } else {
                imageData = UIImageJPEGRepresentation(image, 1);
                fileName = [[[info[UIImagePickerControllerMediaMetadata][@"{TIFF}"][@"DateTime"] stringByReplacingOccurrencesOfString:@" " withString:@"T"]stringByReplacingOccurrencesOfString:@":" withString:@"-"] stringByAppendingString:@".jpeg"];
            }
            
            NSString* fileType = [self contentTypeForImageData:imageData];
            
            if (![NSString isValueableString:fileName]) {
                NSDate *date = [NSDate new];
                NSString* fileDate = [date stringWithFormat:@"yyyy-MM-dd-HH-mm-ss"];
                fileName = [NSString stringWithFormat:@"%@.%@",fileDate,fileType];
            }
            
            filePath = [self saveToTmp:imageData fileName:fileName];
            
            if (filePath) {
                
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                
                NSString* token = CA_H_MANAGER.getToken;
                if (token.length) {
                    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
                }
                [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
                
                //压缩图片
                NSData* compressImgData = [self zipNSDataWithImage:image];
                
                CA_H_WeakSelf(self);
                NSString * url = [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, CA_H_Api_UpLoadAvatar];
                [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    [formData appendPartWithFileData:compressImgData name:@"user_avatar_new" fileName:fileName mimeType:[[fileName componentsSeparatedByString:@"."] lastObject]];
                } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    CA_H_StrongSelf(self);
                    [CA_HProgressHUD showHudStr:@"上传头像成功"];
                    self.iconImage = image;
                    [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [CA_HProgressHUD showHudStr:@"上传头像失败"];
                }];
                
            } else {
                [CA_HProgressHUD showHudStr:@"系统错误!"];
            }
            
        }
    };
}

- (NSString *)saveToTmp:(NSData *)imageData fileName:(NSString *)fileName {
    NSString *tmp = NSTemporaryDirectory();
    NSString *path;
    NSInteger i = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    do {
        NSString *parentPath = [[[NSDate date] stringWithFormat:@"yyyy-MM-dd'T'HH-mm-ss'T'"] stringByAppendingString:[NSString stringWithFormat:@"/%ld/",i++]];
        path = [tmp stringByAppendingString:parentPath];
    } while ([fileManager fileExistsAtPath:path]);
    
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [path stringByAppendingString:fileName];
    
    if ([imageData writeToFile:filePath atomically:YES]) {
        return filePath;
    } else {
        return nil;
    }
}

-(NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280||height>1280) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
        //2.宽大于1280高小于1280
    }else if(width>1280||height<1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
        //3.宽小于1280高大于1280
    }else if(width<1280||height>1280){
        CGFloat scale = width/height;
        height = 1280;
        width = height*scale;
        //4.宽高都小于1280
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return data;
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return @"";
    }
    return @"";
}

#pragma mark - getter and setter
-(NSMutableArray *)oldDataSource{
    if (_oldDataSource) {
        return _oldDataSource;
    }
    _oldDataSource = @[].mutableCopy;
    return _oldDataSource;
}

-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    return _dataSource;
}

-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewPlain];
    _tableView.sectionHeaderHeight = 10;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[CA_MInputCell class] forCellReuseIdentifier:inputKey];
    [_tableView registerClass:[CA_MSelectCell class] forCellReuseIdentifier:selectKey];
    [_tableView registerClass:[CA_MIconCell class] forCellReuseIdentifier:iconKey];
    [_tableView registerClass:[CA_MPersonIntroduceCell class] forCellReuseIdentifier:introduceKey];
    return _tableView;
}
-(UIBarButtonItem *)rightBarBtnItem{
    if (_rightBarBtnItem) {
        return _rightBarBtnItem;
    }
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton configTitle:@"完成" titleColor:CA_H_TINTCOLOR font:16];
    [rightButton sizeToFit];
    [rightButton addTarget: self action: @selector(clickRightBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    _rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    return _rightBarBtnItem;
}
@end
