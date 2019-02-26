
//
//  CA_MAddRelatedMemberVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MAddRelatedMemberVC.h"
#import "CA_MInputCell.h"
#import "CA_MSelectCell.h"
#import "CA_MProjectToDoHeaderView.h"
#import "CA_MAddRelatedMemberCell.h"
#import "CA_MTypeModel.h"
#import "CA_MAddTagVC.h"
#import "CA_MProjectTagModel.h"
#import "CA_HDatePicker.h"
#import "CA_MRelatedMemberVC.h"
#import "CA_MPersonModel.h"

typedef enum : NSUInteger {
    NameTag,
    TelTag,
    OtherTag
} InputCellTag;

static NSString* const inputKey = @"CA_MInputCell";
static NSString* const selectKey = @"CA_MSelectCell";
static NSString* const relationKey = @"CA_MAddRelatedMemberCell";

@interface CA_MAddRelatedMemberVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MProjectToDoHeaderViewDelegate,
CA_MAddRelatedMemberCellDelegate,
CA_MInputCellDelegate>{
    BOOL _flag;
    NSMutableArray* _tags;
    CA_MPersonModel* _existModel;
}

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* dataSource;
@property(nonatomic,strong)CA_MProjectToDoHeaderView* headerView;
@property (nonatomic,strong) UIBarButtonItem *rightBarBtnItem;
@end

@implementation CA_MAddRelatedMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _flag = YES;
    _tags = @[].mutableCopy;
    [self upNavigationButtonItem];
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

-(void)upNavigationButtonItem{
    self.navigationItem.title = @"添加相关人员";
    self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
}

-(void)setupUI{
    [self.contentView addSubview:self.tableView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

-(void)clickRightBarBtnAction{
    
    NSString* url = _flag ? CA_M_Api_CreateHumanResource : CA_M_Api_CreateObjectHuman;
    
    NSArray* array = _flag ? [self.dataSource firstObject] : [self.dataSource lastObject];

    NSDictionary* parameters = @{};
    
    if (_flag) {
//        "chinese_name": "cctv",  # 必填
//        "phone": "12345678909",   #必填
//        "job_position": "cto",      # 必填， 工作岗位/关联关系
//        "object_id": 1,            # 必填
//        "object_type": "project",  # 必填，同上
//        "gender": "",       # 非必填 性别 男/女
//        "ts_born": 33333,       # 非必填 出生年月,时间戳
//        "tag_id_list" : [1],     # 非必填人脉圈标签/类型  ,从 listhumantag 接口得到的 human_tag_id 字段
        NSString* chinese_name = ((CA_MTypeModel*)[array objectAtIndex:0]).value;
        NSString* phone = ((CA_MTypeModel*)[array objectAtIndex:4]).value;
        NSString* job_position = ((CA_MTypeModel*)[array objectAtIndex:5]).value;
        
        if (![NSString isValueableString:chinese_name]) {
            [CA_HProgressHUD showHudStr:@"请填写姓名"];
            return;
        }
        if (![self isMobileNumber:phone]) {
            [CA_HProgressHUD showHudStr:@"请填写正确的手机号码"];
            return;
        }
        if (![NSString isValueableString:job_position]) {
            [CA_HProgressHUD showHudStr:@"请填写关联关系"];
            return;
        }
        NSString* gender = ((CA_MTypeModel*)[array objectAtIndex:1]).value;
        parameters = @{@"chinese_name":chinese_name,
                       @"phone":phone,
                       @"job_position":job_position,
                       @"object_id":self.model.project_id,
                       @"object_type":@"project",
                       @"gender":[gender isEqualToString:@"选择"]?@"":gender,
                       @"ts_born":@([self timeWithTimeIntervalString:((CA_MTypeModel*)[array objectAtIndex:2]).value]),
                       @"tag_id_list":_tags
                       };
    }else{
        CA_MTypeModel* model = [array lastObject];
        
        if (_existModel == nil) {
            [CA_HProgressHUD showHudStr:@"请选择相关人员"];
            return;
        }
        if (![NSString isValueableString:model.value]) {
            [CA_HProgressHUD showHudStr:@"请填写关联关系"];
            return;
        }
        
//        ""object_id: 1,       # 必填 object_type 是 project时 ，此处为 project_id
//        "object_type": "", # 必填 枚举型，可以是 project, 后期可能会有 fund
//        "human_id": 2,   # 必填
//        "job_position": "cfo,cco"      # 必填  工作岗位/关联关系
        
        parameters = @{@"object_id":self.model.project_id,
                       @"object_type":@"project",
                       @"human_id":_existModel.human_id,
                       @"job_position":model.value
                       };
        
    }
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:url parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if (self.block) {
                    self.block();
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

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* array = _flag ? [self.dataSource firstObject] : [self.dataSource lastObject];
    return array.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* array = _flag ? [self.dataSource firstObject] : [self.dataSource lastObject];
    CA_MTypeModel* model = array[indexPath.row];
    if (model.type == Input) {
        CA_MInputCell* inputCell = [tableView dequeueReusableCellWithIdentifier:inputKey];
        inputCell.delegate = self;
        [inputCell configCell:model.title text:@"" placeholder:model.value];
        if ([model.title isEqualToString:@"姓名"]) {
            inputCell.tag = NameTag;
        }else if([model.title isEqualToString:@"电话"]){
            inputCell.tag = TelTag;
        }else{
            inputCell.tag = OtherTag;
        }
        return inputCell;
    }else if (model.type == Select){
        CA_MSelectCell* selectCell = [tableView dequeueReusableCellWithIdentifier:selectKey];
        [selectCell configCell:model.title :model.value];
        return selectCell;
    }
    CA_MAddRelatedMemberCell* relatedMemberCell = [tableView dequeueReusableCellWithIdentifier:relationKey];
    relatedMemberCell.delegate = self;
    [relatedMemberCell configCell:model.value placeHolder:model.placeHolder];
    return relatedMemberCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_flag) {
        if (indexPath.row == 1) {//性别
            NSArray* array = [self.dataSource firstObject];
            UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CA_MTypeModel* model = [array objectAtIndex:1];
                model.value = @"男";
                [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }];
            UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CA_MTypeModel* model = [array objectAtIndex:1];
                model.value = @"女";
                [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [actionSheetController addAction:maleAction];
                [actionSheetController addAction:femaleAction];
                [actionSheetController addAction:cancelAction];
                [self presentViewController:actionSheetController animated:YES completion:nil];
            });
        }else if (indexPath.row == 2) {//出生年月
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
                NSArray* array = [self.dataSource firstObject];
                CA_MTypeModel* model = [array objectAtIndex:2];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
                model.value = strDate;
                [self.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }];
            
        }else if (indexPath.row == 3) {//人物标签
            CA_H_WeakSelf(self);
            CGRect rect = CGRectMake(0, CA_H_SCREEN_HEIGHT - 283*CA_H_RATIO_WIDTH , CA_H_SCREEN_WIDTH, 283*CA_H_RATIO_WIDTH);
            CA_MAddTagVC* adminVC = [[CA_MAddTagVC alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(NSArray* tags) {
                CA_H_StrongSelf(self);
                if ([tags count]) {
                    NSMutableString* tmpStr = [NSMutableString string];
                    for (CA_MProjectTagModel* tagModel in tags) {
                        [tmpStr appendString:[NSString stringWithFormat:@"%@ ",tagModel.tag_name]];
                        [_tags appendObject:tagModel.human_tag_id];
                    }
                    NSArray* array = [self.dataSource firstObject];
                    CA_MTypeModel* model = [array objectAtIndex:3];
                    model.value = tmpStr;
                    [self.tableView reloadRow:3 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            adminVC.selectedTags = _tags;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:adminVC animated:YES completion:nil];
            });
        }
    }else{
        if (indexPath.row == 0) {//相关人员
            CA_H_WeakSelf(self);
            CA_MRelatedMemberVC* relatedMemberVC = [[CA_MRelatedMemberVC alloc] init];
            relatedMemberVC.callBack = ^(CA_MPersonModel* obj) {
                CA_H_StrongSelf(self);
                _existModel = obj;
                NSArray* array = [self.dataSource lastObject];
                CA_MTypeModel* model = [array objectAtIndex:0];
                model.value = obj.chinese_name;
                [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:relatedMemberVC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* array = _flag ? [self.dataSource firstObject] : [self.dataSource lastObject];
    if (indexPath.row == array.count - 1) {
        return 120*CA_H_RATIO_WIDTH;
    }
    return 52*CA_H_RATIO_WIDTH;
}

#pragma mark - CA_MProjectToDoHeaderViewDelegate

-(void)didSelect:(BOOL)isFinished{
    _flag = !_flag;
    [self.tableView reloadData];
}

#pragma mark - CA_MAddRelatedMemberCellDelegate

-(void)textDidChange:(NSString*)content{
    NSArray* array = _flag ? [self.dataSource firstObject] : [self.dataSource lastObject];
    CA_MTypeModel* model = [array lastObject];
    
    if (![NSString isValueableString:content]) {
        return;
    }
    if ([model.value isEqualToString:content]) {
        return;
    }
    model.value = content;
}

#pragma mark - CA_MInputCellDelegate
-(void)textDidChange:(CA_MInputCell *)cell content:(NSString *)content{
    NSArray* array = [self.dataSource firstObject];
    if (cell.tag == NameTag) {
        CA_MTypeModel* model = [array firstObject];
        model.value = content;
    }else if(cell.tag == TelTag){
        CA_MTypeModel* model = [array objectAtIndex:4];
        model.value = content;
    }
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

#pragma mark - getter and setter
-(CA_MProjectToDoHeaderView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[CA_MProjectToDoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55*CA_H_RATIO_WIDTH)];
    _headerView.delegate = self;
    return _headerView;
}
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewPlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = self.headerView;
    [_tableView registerClass:[CA_MInputCell class] forCellReuseIdentifier:inputKey];
    [_tableView registerClass:[CA_MSelectCell class] forCellReuseIdentifier:selectKey];
    [_tableView registerClass:[CA_MAddRelatedMemberCell class] forCellReuseIdentifier:relationKey];
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    
    CA_MTypeModel* nameModel = [CA_MTypeModel new];
    nameModel.title = @"姓名";
    nameModel.value = @"请输入姓名";
    nameModel.type = Input;
    
    CA_MTypeModel* sexModel = [CA_MTypeModel new];
    sexModel.title = @"性别";
    sexModel.value = @"选择";
    sexModel.type = Select;
    
    CA_MTypeModel* bornModel = [CA_MTypeModel new];
    bornModel.title = @"出生年月";
    bornModel.value = @"选择";
    bornModel.type = Select;
    
    CA_MTypeModel* tagModel = [CA_MTypeModel new];
    tagModel.title = @"人物标签";
    tagModel.value = @"选择";
    tagModel.type = Select;
    
    CA_MTypeModel* telModel = [CA_MTypeModel new];
    telModel.title = @"电话";
    telModel.value = @"请输入手机号码";
    telModel.type = Input;
    
    CA_MTypeModel* personModel = [CA_MTypeModel new];
    personModel.title = @"相关人员";
    personModel.value = @"选择";
    personModel.type = Select;
    
    CA_MTypeModel* relaModel1 = [CA_MTypeModel new];
    relaModel1.title = @"";
    relaModel1.value = @"";
    relaModel1.placeHolder = @"请输入关联关系";
    relaModel1.type = Other;
    
    CA_MTypeModel* relaModel2 = [CA_MTypeModel new];
    relaModel2.title = @"";
    relaModel2.value = @"";
    relaModel2.placeHolder = @"请输入关联关系";
    relaModel2.type = Other;
    
    [_dataSource addObject:@[nameModel,sexModel,bornModel,tagModel,telModel,relaModel1]];
    [_dataSource addObject:@[personModel,relaModel2]];
    return _dataSource;
}
-(UIBarButtonItem *)rightBarBtnItem{
    if (_rightBarBtnItem) {
        return _rightBarBtnItem;
    }
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton configTitle:@"保存" titleColor:CA_H_TINTCOLOR font:16];
    [rightButton sizeToFit];
    [rightButton addTarget: self action: @selector(clickRightBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    _rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    return _rightBarBtnItem;
}
@end

