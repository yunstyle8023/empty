
//
//  CA_MAddPersonVC.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/3/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MAddPersonVC.h"
#import "CA_MInputCell.h"
#import "CA_MSelectCell.h"
#import "CA_MIconCell.h"
#import "CA_MProjectTagCell.h"
#import "CA_MPersonIntroduceCell.h"
#import "CA_MSelectPersonVC.h"
#import "CA_MAddTagVC.h"
#import "CA_MTypeModel.h"
#import "CA_HDatePicker.h"
#import "CA_MProjectTagModel.h"
#import "CA_MFiltrateItemVC.h"
#import "CA_HSelectMenuView.h"
#import "CA_MPersonDetailModel.h"

typedef enum : NSUInteger {
    NameTag,
    TelTag,
    EmailTag,
    WXTag
} InputCellTag;

static NSString* const inputKey = @"CA_MInputCell";
static NSString* const selectKey = @"CA_MSelectCell";
static NSString* const iconKey = @"CA_MIconCell";
static NSString* const tagKey = @"CA_MProjectTagCell";
static NSString* const introduceKey = @"CA_MPersonIntroduceCell";

@interface CA_MAddPersonVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MProjectTagCellDelegate,
CA_MInputCellDelegate,
CA_MPersonIntroduceCellDelegate>{
    CGFloat _cellHeight;
    UIImage* _iconImage;
    NSString* _file_url;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIBarButtonItem *rightBarBtnItem;
@property (nonatomic,strong) NSMutableArray *tags;
@end

@implementation CA_MAddPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

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

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

-(void)setupUI{
    self.navigationItem.title = self.naviTitle;
    self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
    [self.contentView addSubview:self.tableView];
}

-(void)setModel:(CA_MHuman_detail *)model{
    
    _model = model;
    
    [self.dataSource removeAllObjects];
    
    CA_MTypeModel* iconModel = [CA_MTypeModel new];
    iconModel.title = @"头像";
    iconModel.type = ChooseIcon;
    if ([NSString isValueableString:model.avatar]) {
        _file_url = model.avatar;
        iconModel.value = @"";
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString* imgUrl = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,_file_url];
            NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _iconImage = [UIImage imageWithData:imgData];
                [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }else{
        _file_url = @"";
        iconModel.value = @"选择";
        _iconImage = nil;
    }
    
    CA_MTypeModel* nameModel = [CA_MTypeModel new];
    nameModel.title = @"姓名";
    nameModel.value = model.chinese_name;
    nameModel.placeHolder = @"请输入姓名";
    nameModel.type = Input;
    
    CA_MTypeModel* sexModel = [CA_MTypeModel new];
    sexModel.title = @"性别";
    if ([NSString isValueableString:model.gender] &&
        ![model.gender isEqualToString:@"暂无"]) {
        sexModel.value = model.gender;
    }else{
        sexModel.value = @"选择";
    }
    sexModel.type = Select;
    
    CA_MTypeModel* cityModel = [CA_MTypeModel new];
    cityModel.title = @"所在城市";
    model.area = [model.area stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([NSString isValueableString:model.area] &&
        ![model.area isEqualToString:@"|"] &&
        ![model.area isEqualToString:@"暂无"]) {
        cityModel.value = model.area;
    }else{
        cityModel.value = @"选择";
    }
    cityModel.type = Select;
    
    CA_MTypeModel* bornModel = [CA_MTypeModel new];
    bornModel.title = @"出生年月";
//    if (model.ts_born.longValue>=0) {
        NSDate *bornDate = [NSDate dateWithTimeIntervalSince1970:model.ts_born.longValue];
        NSString* bornDateStr = [bornDate stringWithFormat:@"yyyy-MM-dd"];
        bornModel.value = bornDateStr;
//    }else{
//        bornModel.value = @"选择";
//    }
    bornModel.type = Select;
    
    CA_MTypeModel* telModel = [CA_MTypeModel new];
    telModel.title = @"电话";
    if ([NSString isValueableString:model.phone] &&
        ![model.phone isEqualToString:@"暂无"]) {
        telModel.value = model.phone;
    }else{
        telModel.value = @"";
    }
    telModel.placeHolder = @"请输入手机号码";
    telModel.type = Input;
    
    CA_MTypeModel* emailModel = [CA_MTypeModel new];
    emailModel.title = @"邮箱";
    if ([NSString isValueableString:model.email] &&
        ![model.email isEqualToString:@"暂无"]) {
        emailModel.value = model.email;
    }else{
        emailModel.value = @"";
    }
    emailModel.placeHolder = @"请输入邮箱";
    emailModel.type = Input;
    
    CA_MTypeModel* wxModel = [CA_MTypeModel new];
    wxModel.title = @"微信号";
    if ([NSString isValueableString:model.wechat] &&
        ![model.wechat isEqualToString:@"暂无"]) {
        wxModel.value = model.wechat;
    }else{
        wxModel.value = @"";
    }
    wxModel.placeHolder = @"请输入微信号";
    wxModel.type = Input;
    
    CA_MTypeModel* tagModel = [CA_MTypeModel new];
    tagModel.title = @"人物标签";
    
    [self.tags removeAllObjects];
    if ([NSObject isValueableObject:model.tag_data]) {
        NSMutableArray* tagNames = @[].mutableCopy;
        for (CA_MPersonTagModel* tag in model.tag_data) {
            [tagNames addObject:tag.tag_name];
            [self.tags addObject:tag.human_tag_id];
        }
        tagModel.values = tagNames;
    }else{
        tagModel.values = @[].mutableCopy;
    }
    tagModel.type = Tag;
    
    CA_MTypeModel* introModel = [CA_MTypeModel new];
    introModel.title = @"人物简介";
    if ([NSString isValueableString:model.intro] &&
        ![model.intro isEqualToString:@"暂无"]) {
        introModel.value = model.intro;
    }else{
        introModel.value = @"";
    }
    introModel.placeHolder = @"请输入人物简介";
    introModel.type = Introduce;
    
    [self.dataSource addObjectsFromArray:
     @[iconModel,nameModel,sexModel,
       cityModel,bornModel,telModel,
       emailModel,wxModel,tagModel,introModel]];
    
    [self.tableView reloadData];
    
}

-(void)clickRightBarBtnAction{
    NSMutableDictionary* parameters = @{}.mutableCopy;
    NSString* url = @"";
    if (!self.model) {
        url = CA_M_Api_CreateHumanResource;
    }else{
        url = CA_M_Api_UpdateHumanResource;
    }
    NSString* chinese_name = ((CA_MTypeModel*)[self.dataSource objectAtIndex:1]).value;
    NSString* phone = ((CA_MTypeModel*)[self.dataSource objectAtIndex:5]).value;
    NSString* email = ((CA_MTypeModel*)[self.dataSource objectAtIndex:6]).value;
    
    if (![NSString isValueableString:chinese_name]) {
        [CA_HProgressHUD showHudStr:@"请填写姓名"];
        return;
    }
    if (![NSString isValueableString:phone]) {
        [CA_HProgressHUD showHudStr:@"请填写正确的手机号码"];
        return;
    }

    if (![self isMobileNumber:phone]) {
        [CA_HProgressHUD showHudStr:@"请填写正确的手机号码"];
        return;
    }
    if ([NSString isValueableString:email]) {
        if (![self isValidateEmail:email]) {
            [CA_HProgressHUD showHudStr:@"请填写正确的邮箱"];
            return;
        }
    }
    
    NSString* gender = ((CA_MTypeModel*)[self.dataSource objectAtIndex:2]).value;
    NSString* address = ((CA_MTypeModel*)[self.dataSource objectAtIndex:3]).value;
    NSString* ts_born = ((CA_MTypeModel*)[self.dataSource objectAtIndex:4]).value;
    NSString* wechat = ((CA_MTypeModel*)[self.dataSource objectAtIndex:7]).value;
    NSString* intro = ((CA_MTypeModel*)[self.dataSource lastObject]).value;
//    'avatar': '/static/pic/avatar.jpg',    # 非必填
//    'chinese_name': '章三',                # 必填
//    'gender': '男',                        # 非必填
//    'address': '北京|朝阳|花家地',         # 非必填
//    'ts_born': 2333333,                    # 非必填
//    'phone': '12345123451',                # 必填/唯一
//    'email': 'qw@qq.com',                  # 非必填
//    'wechat': 'fei',                       # 非必填，微信
//    'tag_id_list':[1]                      # 非必填， 人物标签id 列表
//    'intro': '简介' ,                      # 非必填
    
    [parameters setValue:[NSString isValueableString:_file_url]?_file_url:@"" forKey:@"avatar"];
    [parameters setValue:chinese_name forKey:@"chinese_name"];
    [parameters setValue:[gender isEqualToString:@"选择"]?@"":gender forKey:@"gender"];
    [parameters setValue:[address isEqualToString:@"选择"]?@"":address forKey:@"address"];
    [parameters setValue:@([self timeWithTimeIntervalString:ts_born]) forKey:@"ts_born"];
    [parameters setValue:phone forKey:@"phone"];
    [parameters setValue:![NSString isValueableString:email]?@"":email forKey:@"email"];
    [parameters setValue:![NSString isValueableString:wechat]?@"":wechat forKey:@"wechat"];
    [parameters setValue:self.tags forKey:@"tag_id_list"];
    [parameters setValue:intro forKey:@"intro"];
    
    if (self.model) {
        [parameters setValue:self.model.human_id forKey:@"human_id"];
    }
    
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:url parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                
                if (self.model) {
                    CA_MPersonDetailModel* detailModel = [CA_MPersonDetailModel modelWithDictionary:netModel.data];
                    if (self.block) {
                        self.block(detailModel);
                    }
                }else{
                    if (self.block) {
                        self.block(nil);
                    }
                }
                
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

- (BOOL)isMobileNumber:(NSString *)mobileNum {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170µ
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
//    NSString *MOBILE = @"^1\\d{10}$/";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    return [regextestmobile evaluateWithObject:mobileNum];
    
    if ([[mobileNum substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]
        &&
        [self isPureInt:mobileNum]) {
        return YES;
    }
    return NO;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(BOOL )isValidateEmail:(NSString *)email{
    NSString  *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    NSPredicate  *emailTest = [ NSPredicate predicateWithFormat : @"SELF MATCHES%@",emailRegex];
    return  [emailTest  evaluateWithObject :email];
}

- (NSTimeInterval)timeWithTimeIntervalString:(NSString *)timeString{
    if ([timeString isEqualToString:@"选择"]) {
        return -2208988800;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *birthdayDate = [dateFormatter dateFromString:timeString];
    return birthdayDate.timeIntervalSince1970;
}

#pragma mark - CA_MInputCellDelegate
-(void)textDidChange:(CA_MInputCell *)cell content:(NSString *)content{
    if (cell.tag == NameTag) {
        CA_MTypeModel* model = [self.dataSource objectAtIndex:1];
        model.value = content;
    }else if (cell.tag == TelTag){
        CA_MTypeModel* model = [self.dataSource objectAtIndex:5];
        model.value = content;
    }else if (cell.tag == EmailTag){
        CA_MTypeModel* model = [self.dataSource objectAtIndex:6];
        model.value = content;
    }else if (cell.tag == WXTag){
        CA_MTypeModel* model = [self.dataSource objectAtIndex:7];
        model.value = content;
    }
}

#pragma mark - CA_MPersonIntroduceCellDelegate

-(void)textDidChange:(NSString*)content{
    CA_MTypeModel* model = [self.dataSource lastObject];
    model.value = content;
}

-(void)textLengthDidMax{
    
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
                NSURL *url = [NSURL fileURLWithPath:filePath];
                NSURLSession *session = [NSURLSession sharedSession];
                [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    CA_HDataModel * dataModel = [CA_HDataModel new];
                    dataModel.fileData = [self zipNSDataWithImage:image];
                    dataModel.name = @"file";
                    dataModel.fileName = fileName;
                    dataModel.mimeType = response.MIMEType;
                    
                    [CA_HNetManager updateFile:@[dataModel] callBack:^(CA_HNetModel *netModel) {
                        if (netModel.type == CA_H_NetTypeSuccess) {
                            if (netModel.errcode.integerValue == 0) {
                                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                                    NSLog(@"netModel.data == %@",netModel.data);
                                    _file_url = netModel.data[@"file_url"];
                                    _iconImage = image;
                                    [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                                    [CA_HProgressHUD showHudStr:@"头像上传成功"];
                                }
                                return ;
                            }
                        }
                        if (netModel.error.code != -999) {
        [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
    }
                    } progress:nil];
                    
                }] resume];
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
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Input) {
        CA_MInputCell* inputCell = [tableView dequeueReusableCellWithIdentifier:inputKey];
        if (indexPath.row == 1) {
            inputCell.tag = NameTag;
        }else if (indexPath.row == 5){
            inputCell.tag = TelTag;
        }else if (indexPath.row == 6){
            inputCell.tag = EmailTag;
        }else if (indexPath.row == 7){
            inputCell.tag = WXTag;
        }else{
            inputCell.tag = Other;
        }
        inputCell.delegate = self;
        [inputCell configCell:model.title text:model.value placeholder:model.placeHolder];
        return inputCell;
    }else if (model.type == Select){
        CA_MSelectCell* selectCell = [tableView dequeueReusableCellWithIdentifier:selectKey];
        [selectCell configCell:model.title :model.value];
        return selectCell;
    }else if (model.type == ChooseIcon){
        CA_MIconCell* iconCell = [tableView dequeueReusableCellWithIdentifier:iconKey];
        [iconCell configCell:model.title image:_iconImage];
        return iconCell;
    }else if (model.type == Introduce){
        CA_MPersonIntroduceCell* introduceCell = [tableView dequeueReusableCellWithIdentifier:introduceKey];
        introduceCell.delegate = self;
        [introduceCell configCell:model.title text:model.value placeHolder:model.placeHolder];
        return introduceCell;
    }
    CA_MProjectTagCell* tagCell = [tableView dequeueReusableCellWithIdentifier:tagKey];
    tagCell.delegate = self;
    _cellHeight = [tagCell configCell:model.title tags:model.values];
    return tagCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {//头像
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
    }else if (indexPath.row == 2){//性别
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
        
    }else if (indexPath.row == 3){//城市
        CA_H_WeakSelf(self);
        CGRect rect = CGRectMake(0, (kDevice_Is_iPhoneX?60:40)*2*CA_H_RATIO_WIDTH, CA_H_SCREEN_WIDTH, CA_H_SCREEN_HEIGHT-(kDevice_Is_iPhoneX?60:40)*2*CA_H_RATIO_WIDTH);
        CA_MFiltrateItemVC* filtrateItemVC = [[CA_MFiltrateItemVC alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(NSString* area) {
            CA_H_StrongSelf(self);
            CA_MTypeModel* model =  [self.dataSource objectAtIndex:3];
            model.value = [NSString isValueableString:area] ? area : @"选择";
            [self.tableView reloadRow:3 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        filtrateItemVC.titleStr = @"选择所在城市";
        filtrateItemVC.urlStr = CA_M_Api_ListArea;
        filtrateItemVC.className = @"CA_MCityModel";
        filtrateItemVC.keyName = @"area_name";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:filtrateItemVC animated:YES completion:nil];
        });
    }else if (indexPath.row == 4){//出生年月
        CA_H_WeakSelf(self);
        CA_HDatePicker* datePicker = [CA_HDatePicker new];
        datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
        NSString *minStr = @"1900-01-01";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *minDate = [dateFormatter dateFromString:minStr];
        datePicker.datePicker.minimumDate = minDate;
        
        datePicker.datePicker.maximumDate = [NSDate new];
        [datePicker presentDatePicker:@"" dateBlock:^(UIDatePicker *datePicker) {
            CA_H_StrongSelf(self);
            CA_MTypeModel* model = [self.dataSource objectAtIndex:4];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
            model.value = strDate;
            [self.tableView reloadRow:4 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Tag) {
        return _cellHeight;
    }else if (model.type == Introduce){
        return 187*CA_H_RATIO_WIDTH;
    }else if (model.type == ChooseIcon){
        return 62*CA_H_RATIO_WIDTH;
    }
    return 52*CA_H_RATIO_WIDTH;
}

#pragma mark - CA_MProjectTagCellDelegate

-(void)delTag:(NSInteger)index{
    CA_MTypeModel* model = [self.dataSource objectAtIndex:8];
    NSMutableArray* tmpVlues = [[NSMutableArray alloc] initWithArray:model.values];
    [tmpVlues removeObjectAtIndex:index];
    model.values = tmpVlues;
    
    NSMutableArray* tmpTags = [[NSMutableArray alloc] initWithArray:self.tags];
    [tmpTags removeObjectAtIndex:index];
    self.tags = tmpTags;
    
    [self.tableView reloadRow:8 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

-(void)addTag{
    
    CA_H_WeakSelf(self);
    CGRect rect = CGRectMake(0, CA_H_SCREEN_HEIGHT - 283*CA_H_RATIO_WIDTH , CA_H_SCREEN_WIDTH, 283*CA_H_RATIO_WIDTH);
    CA_MAddTagVC* adminVC = [[CA_MAddTagVC alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(NSArray* tags) {
        CA_H_StrongSelf(self);
        if ([tags count]) {
            CA_MTypeModel* model = [self.dataSource objectAtIndex:8];
            for (CA_MProjectTagModel* tagModel in tags) {
                if (![model.values containsObject:tagModel.tag_name]) {
                    [model.values addObject:tagModel.tag_name];
                }
                if (![self.tags containsObject:tagModel.human_tag_id]) {
                    [self.tags appendObject:tagModel.human_tag_id];
                }
            }
            
            [self.tableView reloadRow:8 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    adminVC.selectedTags = self.tags;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:adminVC animated:YES completion:nil];
    });
    
}

#pragma mark - getter and setter
-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    CA_MTypeModel* iconModel = [CA_MTypeModel new];
    iconModel.title = @"头像";
    iconModel.value = @"选择";
    iconModel.type = ChooseIcon;
    
    CA_MTypeModel* nameModel = [CA_MTypeModel new];
    nameModel.title = @"姓名";
    nameModel.placeHolder = @"请输入姓名";
    nameModel.type = Input;
    
    CA_MTypeModel* sexModel = [CA_MTypeModel new];
    sexModel.title = @"性别";
    sexModel.value = @"选择";
    sexModel.type = Select;
    
    CA_MTypeModel* cityModel = [CA_MTypeModel new];
    cityModel.title = @"所在城市";
    cityModel.value = @"选择";
    cityModel.type = Select;
    
    CA_MTypeModel* bornModel = [CA_MTypeModel new];
    bornModel.title = @"出生年月";
    bornModel.value = @"选择";
    bornModel.type = Select;
    
    CA_MTypeModel* telModel = [CA_MTypeModel new];
    telModel.title = @"电话";
    telModel.placeHolder = @"请输入手机号码";
    telModel.type = Input;
    
    CA_MTypeModel* emailModel = [CA_MTypeModel new];
    emailModel.title = @"邮箱";
    emailModel.placeHolder = @"请输入邮箱";
    emailModel.type = Input;
    
    CA_MTypeModel* wxModel = [CA_MTypeModel new];
    wxModel.title = @"微信号";
    wxModel.placeHolder = @"请输入微信号";
    wxModel.type = Input;
    
    CA_MTypeModel* tagModel = [CA_MTypeModel new];
    tagModel.title = @"人物标签";
    tagModel.values = @[].mutableCopy;
    tagModel.type = Tag;
    
    CA_MTypeModel* introModel = [CA_MTypeModel new];
    introModel.title = @"人物简介";
    introModel.value = @"";
    introModel.placeHolder = @"请输入人物简介";
    introModel.type = Introduce;
    
    [_dataSource addObjectsFromArray:
     @[iconModel,nameModel,sexModel,
       cityModel,bornModel,telModel,
       emailModel,wxModel,tagModel,introModel]];
    return _dataSource;
}
-(NSMutableArray *)tags{
    if (_tags) {
        return _tags;
    }
    _tags = @[].mutableCopy;
    return _tags;
}
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewPlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[CA_MSelectCell class] forCellReuseIdentifier:selectKey];
    [_tableView registerClass:[CA_MInputCell class] forCellReuseIdentifier:inputKey];
    [_tableView registerClass:[CA_MIconCell class] forCellReuseIdentifier:iconKey];
    [_tableView registerClass:[CA_MPersonIntroduceCell class] forCellReuseIdentifier:introduceKey];
    [_tableView registerClass:[CA_MProjectTagCell class] forCellReuseIdentifier:tagKey];
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

