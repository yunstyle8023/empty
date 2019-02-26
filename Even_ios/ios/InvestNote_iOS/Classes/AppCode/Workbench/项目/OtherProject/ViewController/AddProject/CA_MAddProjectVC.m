//
//  CA_MProjectProgressVC.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/21.
//  God bless me without no bugs.
//

#import "CA_MAddProjectVC.h"
#import "CA_MInputCell.h"
#import "CA_MSelectCell.h"
#import "CA_MLimitedCell.h"
#import "FSTextView.h"
#import "CA_MTypeModel.h"
#import "CA_MFiltrateItemVC.h"
#import "CA_MSelectDataVC.h"
#import "CA_MCategoryModel.h"
#import "CA_MProjectDetailModel.h"
#import "CA_MInvest_stageModel.h"
#import "CA_MCurrencyModel.h"
#import "CA_MSettingModel.h"
#import "CA_MProjectProgressModel.h"
#import "CA_MValutionModel.h"

typedef enum : NSUInteger {
    NameTag,
    AppraisementTag,
    OtherTag
} InputCellTag;

static NSString* const inputKey = @"CA_MInputCell";
static NSString* const selectKey = @"CA_MSelectCell";
static NSString* const remarkKey = @"CA_MLimitedCell";

@interface CA_MAddProjectVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MInputCellDelegate,
CA_MLimitedCellDelegate>{
    CA_MCategoryModel* _categoryModel;//
    CA_MCategory* _categoryChildrenModel;//
    CA_MSource* _sourceModel;//
    CA_MInvest_stageModel* _stageModel;//
    CA_MCurrencyModel* _coinModel;//
    CA_MValuation_method* _methodModel;//
    CA_MSettingAvaterModel* _manageModel;//
    CA_Mprocedure_viewModel* _processModel;//
}

/// 右边按钮
@property(nonatomic,strong)UIBarButtonItem* rightBarBtnItem;
/// tableview
@property(nonatomic,strong)UITableView* tableView;
/// datasource
@property(nonatomic,strong)NSMutableArray* dataSource;
@end

@implementation CA_MAddProjectVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加项目";
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

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)upNavigationButtonItem{
    self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
}

- (void)setupUI{
    [self.contentView addSubview:self.tableView];
}

-(void)setDetailModel:(CA_MSelectModelDetail *)detailModel{
    _detailModel = detailModel;
    //项目名称
    CA_MTypeModel* nameModel = ((CA_MTypeModel*)[self.dataSource objectAtIndex:0]);
    nameModel.value = detailModel.project_name;
    //行业领域
    if ([NSObject isValueableObject:detailModel.project_category]) {
        ((CA_MTypeModel*)[self.dataSource objectAtIndex:1]).value = [NSString stringWithFormat:@"%@-%@",[detailModel.project_category firstObject],[detailModel.project_category lastObject]];
    }else{
        ((CA_MTypeModel*)[self.dataSource objectAtIndex:1]).value = @"选择";
    }
    //所在区域
//    if ([NSString isValueableString:detailModel.project_area]) {
//        ((CA_MTypeModel*)[self.dataSource objectAtIndex:2]).value = [NSString stringWithFormat:@"%@",detailModel.project_area];
//    }else{
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:2]).value = @"选择";
//    }
    //项目来源
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:3]).value = [NSString isValueableString:detailModel.project_source]?detailModel.project_source:@"选择";
    //来源备注
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:4]).value = detailModel.source_note;
    //融资阶段
    _stageModel = [CA_MInvest_stageModel new];
    _stageModel.invest_stage_id = detailModel.invest_stage_id?detailModel.invest_stage_id:@0;
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:5]).value = [NSString isValueableString:detailModel.project_invest_stage]?detailModel.project_invest_stage:@"选择";
    //目前估值
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:6]).value = detailModel.valuation;
    //币种
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:7]).value = [NSString isValueableString:detailModel.currency]?detailModel.currency:@"选择";
    //估值方式
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:8]).value = [NSString isValueableString:detailModel.valuation_mode]?detailModel.valuation_mode:@"选择";
    //隐私设置
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:9]).value = [NSString isValueableString:detailModel.privacy_setting]?detailModel.privacy_setting:@"公开-机构所有人可见";
    //项目管理员
//    ((CA_MTypeModel*)[self.dataSource objectAtIndex:10]).value = [NSString isValueableString:detailModel.project_manager]?detailModel.project_manager:@"选择";
    
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:10]).value = [CA_H_MANAGER userName];
    _manageModel = [CA_MSettingAvaterModel new];
    _manageModel.user_id = [CA_H_MANAGER userId];
    
    //项目流程
    ((CA_MTypeModel*)[self.dataSource objectAtIndex:11]).value = [NSString isValueableString:detailModel.project_flow]?detailModel.project_flow:@"选择";
    
    [self.tableView reloadData];
}

- (void)clickRightBarBtnAction{
    NSLog(@"clickRightBarBtnAction");
//    "project_name": "项目名称",
//    "parent_category_id": 1,
//    "child_category_id": 2,
//    "area": ["北京", "朝阳"],
//    "source": 1,                        # 需要去转换接口查询id
//    "source_comment": "来源备注, 不超过50字",
//    "source_contact": "介绍人",         # web端字段,选填
//    "invest_stage_id": 5,               # 融资阶段
//    "valuation": {
//        "num": 1000,
//        "unit_id": 1,                   # 币种ID
//    },
//    "procedure_id": 1,                  # 流程进展id
//    "privacy": "public",
//    "project_manager_id": 1,            # 项目管理员的 user_id
//    "valuation_method": 1,              # 估值方式
//    "data_id": 1,                       # 一键导入使用,选填
    //项目名称
    CA_MTypeModel* nameModel = [self.dataSource objectAtIndex:0];
    NSString* project_name = nameModel.value;
    if (![NSString isValueableString:project_name]) {
        [CA_HProgressHUD showHudStr:@"请填写项目名称"];
        return;
    }
    if ([project_name length]>20) {
        [CA_HProgressHUD showHudStr:@"标题最多只能输入20个汉字"];
        return;
    }
    //行业领域
    CA_MTypeModel* categoryModel = [self.dataSource objectAtIndex:1];
    NSString* category = categoryModel.value;
    if ([NSString isValueableString:category]) {
        if ([category isEqualToString:@"选择"]) {
            [CA_HProgressHUD showHudStr:@"请选择行业领域"];
            return;
        }
    }else{
        [CA_HProgressHUD showHudStr:@"请选择行业领域"];
        return;
    }
    //所在区域
    CA_MTypeModel* areaModel = [self.dataSource objectAtIndex:2];
    NSString* area = areaModel.value;
    if ([NSString isValueableString:area]) {
        if ([area isEqualToString:@"选择"]) {
            [CA_HProgressHUD showHudStr:@"请选择所在区域"];
            return;
        }
    }else{
        [CA_HProgressHUD showHudStr:@"请选择所在区域"];
        return;
    }
    //项目来源
    CA_MTypeModel* sourceModel = [self.dataSource objectAtIndex:3];
    NSString* source = sourceModel.value;
    if ([NSString isValueableString:source]) {
        if ([source isEqualToString:@"选择"]) {
            [CA_HProgressHUD showHudStr:@"请选择项目来源"];
            return;
        }
    }else{
        [CA_HProgressHUD showHudStr:@"请选择项目来源"];
        return;
    }
    //融资阶段
    CA_MTypeModel* stageModel = [self.dataSource objectAtIndex:5];
    NSString* stage = stageModel.value;
    if ([NSString isValueableString:stage]) {
        if ([stage isEqualToString:@"选择"]) {
            [CA_HProgressHUD showHudStr:@"请选择融资阶段"];
            return;
        }
    }
    //目前估值
    CA_MTypeModel* valuationModel = [self.dataSource objectAtIndex:6];
    NSString* valuation = valuationModel.value;

//    if ([NSString isValueableString:valuation]) {//如果有估值 必须选择币种
//
////        if (![self isPureInt:valuation]) {
////            [CA_HProgressHUD showHudStr:@"请填写合法数字"];
////            return;
////        }
//
//        CA_MTypeModel* coinModel = [self.dataSource objectAtIndex:7];
//        if (![NSString isValueableString:coinModel.value] ||
//            [coinModel.value isEqualToString:@"选择"]) {
//            [CA_HProgressHUD showHudStr:@"请选择币种"];
//            return;
//        }
//    }
//
    if ([valuation length]>9){//13) {
        [CA_HProgressHUD showHudStr:@"目前估值最大为万亿级别"];
        return;
    }
//
//    if (!_stageModel) {
//        [CA_HProgressHUD showHudStr:@"请选择融资阶段"];
//        return;
//    }
    
    //币种
    CA_MTypeModel* coinModel = [self.dataSource objectAtIndex:7];
    if ([coinModel.value isEqualToString:@"选择"]) {
        [CA_HProgressHUD showHudStr:@"请选择估值币种"];
        return;
    }
    
    
    //估值方式
//    if (!_methodModel) {
//        [CA_HProgressHUD showHudStr:@"请选择估值方式"];
//        return;
//    }
    //项目管理员
    if (!_manageModel) {
        [CA_HProgressHUD showHudStr:@"请选择项目管理员"];
        return;
    }
    //项目流程
    if (!_processModel) {
        [CA_HProgressHUD showHudStr:@"请选择项目流程"];
        return;
    }

//    NSDictionary* parameters = @{ @"project_name": project_name,
//                                  @"parent_category_id": _categoryModel.category_id,
//                                  @"child_category_id": _categoryChildrenModel.category_id,
//                                  @"area": [((CA_MTypeModel*)[self.dataSource objectAtIndex:2]).value componentsSeparatedByString:@"-"],
//                                  @"source": _sourceModel.source_id,                        //# 需要去转换接口查询id
//                                  @"source_comment": ((CA_MTypeModel*)[self.dataSource objectAtIndex:4]).value,
//                                  @"source_contact": @"",         //# web端字段,选填
//                                  @"invest_stage_id": _stageModel.invest_stage_id,               //# 融资阶段
//                                  @"valuation": @{
//                                          @"num": @0 , // [NSString isValueableString:((CA_MTypeModel*)[self.dataSource objectAtIndex:6]).value]?@(((CA_MTypeModel*)[self.dataSource objectAtIndex:6]).value.intValue):@0,
//                                          @"unit_id": @0,// _coinModel?_coinModel.unit_id:@0,                   //# 币种ID
//                                  },
//                                  @"procedure_id": _processModel.procedure_id,                  //# 流程进展id
//                                  @"privacy":
//                                      [((CA_MTypeModel*)[self.dataSource objectAtIndex:6]).value isEqualToString:@"隐私"]?@"secret":@"public",
//                                  @"project_manager_id": _manageModel.user_id,            //# 项目管理员的 user_id
//                                  @"valuation_method": _methodModel?_methodModel.valuation_method_id:@0,              //# 估值方式
//                                  @"data_id": self.detailModel.data_id?self.detailModel.data_id:@0,                       //# 一键导入使用,选填
//                                  };
    
    
    
    
    
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:project_name,@"project_name",
                                _categoryModel.category_id,@"parent_category_id",
                                _categoryChildrenModel.category_id,@"child_category_id",
                                [((CA_MTypeModel*)[self.dataSource objectAtIndex:2]).value componentsSeparatedByString:@"-"],@"area",
                                _sourceModel.source_id,@"source",
                                ((CA_MTypeModel*)[self.dataSource objectAtIndex:4]).value,@"source_comment",
                                @"",@"source_contact",
                                _stageModel.invest_stage_id,@"invest_stage_id",
                                @{
                                  @"num": [NSString isValueableString:((CA_MTypeModel*)[self.dataSource objectAtIndex:6]).value]?@(((CA_MTypeModel*)[self.dataSource objectAtIndex:6]).value.doubleValue*10000):@0,
                                  @"unit_id": _coinModel?_coinModel.unit_id:@0,                   //# 币种ID
                                  },@"valuation",
                                _processModel.procedure_id,@"procedure_id",
                                [((CA_MTypeModel*)[self.dataSource objectAtIndex:9]).value isEqualToString:@"隐私"]?@"secret":@"public",@"privacy",
                                _manageModel.user_id,@"project_manager_id",
//                                _methodModel?_methodModel.valuation_method_id:@0,@"valuation_method",
                                [((CA_MTypeModel*)[self.dataSource objectAtIndex:8]).value isEqualToString:@"选择"]?@"":((CA_MTypeModel*)[self.dataSource objectAtIndex:8]).value,@"valuation_method",
                                self.detailModel.data_id?self.detailModel.data_id:@0,@"data_id",nil];
    

    

    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_CreateProject parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                
                //通知项目列表刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:CA_M_RefreshProjectListNotification object:@{@"refesh":@"0"}];
                
                if (self.isFind) {
                    [CA_HProgressHUD showHudStr:@"收录成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}

//- (BOOL)isPureInt:(NSString*)string{
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    int val;
//    return[scan scanInt:&val] && [scan isAtEnd];
//}

#pragma mark - CA_MInputCellDelegate

-(void)textDidChange:(CA_MInputCell *)cell content:(NSString *)content{
    if (cell.tag == NameTag) {
        CA_MTypeModel* model = [self.dataSource objectAtIndex:0];
        model.value = content;
//        [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }
    else if(cell.tag == AppraisementTag){
        CA_MTypeModel* model = [self.dataSource objectAtIndex:6];
        model.value = content;
//        [self.tableView reloadRow:6 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - CA_MLimitedCellDelegate

-(void)textDidChange:(NSString*)content{
    CA_MTypeModel* model = [self.dataSource objectAtIndex:4];
    model.value = content;
//    [self.tableView reloadRow:4 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

-(void)textLengthDidMax{
    [CA_HProgressHUD showHudStr:@"最多只能输入50个汉字"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Input) {
        CA_MInputCell* inputCell = [tableView dequeueReusableCellWithIdentifier:inputKey];
        inputCell.delegate = self;
        [inputCell configCell:model.title text:model.value placeholder:model.placeHolder];
        if ([model.title isEqualToString:@"项目名称"]) {
            inputCell.tag = NameTag;
        }else if([model.title isEqualToString:@"目前估值（万元）"]){
            inputCell.tag = AppraisementTag;
        }
        if ([model.title isEqualToString:@"目前估值（万元）"]) {
            inputCell.keyBoardType = UIKeyboardTypeNumberPad;
        }else{
            inputCell.keyBoardType = UIKeyboardTypeDefault;
        }
        return inputCell;
    }else if (model.type == Select){
        CA_MSelectCell* selectCell = [tableView dequeueReusableCellWithIdentifier:selectKey];
        [selectCell configCell:model.title :model.value];
        return selectCell;
    }
    CA_MLimitedCell* remarkCell = [tableView dequeueReusableCellWithIdentifier:remarkKey];
    remarkCell.model = model;
    remarkCell.delegate = self;
    remarkCell.maxLength = 50;
    return remarkCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_H_WeakSelf(self);
    __weak NSIndexPath* weakIndexPath = indexPath;
    CGRect rect = CGRectMake(0, (kDevice_Is_iPhoneX?60:40)*2*CA_H_RATIO_WIDTH, CA_H_SCREEN_WIDTH, CA_H_SCREEN_HEIGHT-(kDevice_Is_iPhoneX?60:40)*2*CA_H_RATIO_WIDTH);
    if (indexPath.row == 1 ||
        indexPath.row == 2 ||
        indexPath.row == 8 ){
        CA_MFiltrateItemVC* filtrateItemVC = [[CA_MFiltrateItemVC alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(id obj) {
            CA_H_StrongSelf(self);
            if ([obj isKindOfClass:[NSString class]]) {//所在区域
                CA_MTypeModel* model =  [self.dataSource objectAtIndex:weakIndexPath.row];
                model.value = [NSString isValueableString:obj] ? obj : @"选择";
            }else if ([obj isKindOfClass:[NSArray class]]) {//行业领域
                _categoryModel = [obj firstObject];
                _categoryChildrenModel = [obj lastObject];
                CA_MTypeModel* model =  [self.dataSource objectAtIndex:weakIndexPath.row];
                model.value = [NSString isValueableString:_categoryModel.category_name] ? [NSString stringWithFormat:@"%@-%@",_categoryModel.category_name,_categoryChildrenModel.category_name] : @"选择";
            }else if ([obj isKindOfClass:[CA_MValutionModel class]]) {//估值方式
                CA_MTypeModel* model =  [self.dataSource objectAtIndex:weakIndexPath.row];
                model.value = ((CA_MValutionModel *)obj).label;
            }
            [self.tableView reloadRow:weakIndexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        if (weakIndexPath.row == 1) {//行业领域
            filtrateItemVC.titleStr = @"选择行业领域";
            filtrateItemVC.urlStr = CA_M_Api_ListCategory;
            filtrateItemVC.className = @"CA_MCategoryModel";
            filtrateItemVC.keyName = @"category_name";
        }else if (weakIndexPath.row == 2) {//所在区域
            filtrateItemVC.titleStr = @"选择所在区域";
            filtrateItemVC.urlStr = CA_M_Api_ListArea;
            filtrateItemVC.className = @"CA_MCityModel";
            filtrateItemVC.keyName = @"area_name";
        }else if (weakIndexPath.row == 8) {//估值方式
            filtrateItemVC.titleStr = @"选择估值方式";
            filtrateItemVC.urlStr = CA_M_Api_ListProjectValutionmethod;
            filtrateItemVC.className = @"CA_MValutionModel";
            filtrateItemVC.keyName = @"label";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:filtrateItemVC animated:YES completion:nil];
        });
    }
    
    if (indexPath.row == 3 ||
        indexPath.row == 5 ||
        indexPath.row == 7 ||
//        indexPath.row == 8 ||
        indexPath.row == 10 ||
        indexPath.row == 11) {
        CA_MSelectDataVC* dataVC = [[CA_MSelectDataVC alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(CA_HBaseModel* selectModel) {
            CA_H_StrongSelf(self);
            
            if ([selectModel isKindOfClass:[CA_MSource class]]) {//项目来源
                _sourceModel = (CA_MSource*)selectModel;
            }else if ([selectModel isKindOfClass:[CA_MInvest_stageModel class]]) {//融资阶段
                _stageModel = (CA_MInvest_stageModel*)selectModel;
            }else if ([selectModel isKindOfClass:[CA_MCurrencyModel class]]){//币种
                _coinModel = (CA_MCurrencyModel*)selectModel;
            }
//            else if ([selectModel isKindOfClass:[CA_MValuation_method class]]){//估值方式
//                _methodModel = (CA_MValuation_method*)selectModel;
//            }
            else if ([selectModel isKindOfClass:[CA_MSettingAvaterModel class]]){//项目管理员
                _manageModel = (CA_MSettingAvaterModel*)selectModel;
            }else if ([selectModel isKindOfClass:[CA_Mprocedure_viewModel class]]){//项目流程
                _processModel = (CA_Mprocedure_viewModel*)selectModel;
            }

            CA_MTypeModel* model = self.dataSource[weakIndexPath.row];
            NSString* selectStr = [selectModel valueForKey:selectModel.projectKey];
            model.value = [NSString isValueableString:selectStr] ? selectStr : @"选择";
            [self.tableView reloadRow:weakIndexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        dataVC.progress = NO;
        if (indexPath.row == 3){//项目来源
            dataVC.requestUrl = CA_M_Api_QuerySourceDict;
            dataVC.className = @"CA_MSource";
            dataVC.key = @"source_name";
        }else if (indexPath.row == 5){//融资阶段
            dataVC.requestUrl = CA_M_Api_QueryInvestStageDict;
            dataVC.className = @"CA_MInvest_stageModel";
            dataVC.key = @"invest_stage_name";
        }
        else if (indexPath.row == 7){//币种
            dataVC.requestUrl = CA_M_Api_ListCurrency;
            dataVC.className = @"CA_MCurrencyModel";
            dataVC.key = @"unit_cn";
        }
//        else if (indexPath.row == 8){//估值方式
//            dataVC.requestUrl = CA_M_Api_QueryValuationDict;
//            dataVC.className = @"CA_MValuation_method";
//            dataVC.key = @"valuation_method_name";
//        }
        else if (indexPath.row == 10){//项目管理员
            dataVC.requestUrl = CA_M_Api_ListCompanyUser;
            dataVC.className = @"CA_MSettingAvaterModel";
            dataVC.key = @"chinese_name";
//            dataVC.role = @"role";
        }else if (indexPath.row == 11){//项目流程
            dataVC.requestUrl = CA_M_Api_ListCompanyProcedure;
            dataVC.className = @"CA_Mprocedure_viewModel";
            dataVC.key = @"procedure_name";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:dataVC animated:YES completion:nil];
        });
    }

    if (indexPath.row == 9) {//隐私设置
        UIAlertAction *publicAction = [UIAlertAction actionWithTitle:@"公开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CA_MTypeModel* model = self.dataSource[weakIndexPath.row];
             model.value = @"公开";
            [self.tableView reloadRow:weakIndexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        UIAlertAction *privateAction = [UIAlertAction actionWithTitle:@"隐私" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CA_MTypeModel* model = self.dataSource[weakIndexPath.row];
            model.value = @"隐私";
            [self.tableView reloadRow:weakIndexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            CA_MTypeModel* model = self.dataSource[weakIndexPath.row];
            model.value = @"公开-机构所有人可见";
            [self.tableView reloadRow:weakIndexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheetController addAction:publicAction];
        [actionSheetController addAction:privateAction];
        [actionSheetController addAction:cancelAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:actionSheetController animated:YES completion:nil];
        });
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Introduce) {
        return 87 * CA_H_RATIO_WIDTH;
    }
    return 52 * CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({//没有意义 纯属占位
        UIView* view = [UIView new];
        view.backgroundColor = kColor(@"#FFFFFF");
        view;
    });
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return ({//没有意义 纯属占位
        UIView* view = [UIView new];
        view.backgroundColor = kColor(@"#FFFFFF");
        view;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30*2*CA_H_RATIO_WIDTH;
}

#pragma mark - Getter and Setter
-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    CA_MTypeModel* nameModel = [CA_MTypeModel new];
    nameModel.title = @"项目名称";
    nameModel.value = @"";
    nameModel.placeHolder = @"请输入项目名称";
    nameModel.type = Input;
    CA_MTypeModel* industryModel = [CA_MTypeModel new];
    industryModel.title = @"行业领域";
    industryModel.value = @"选择";
    industryModel.type = Select;
    CA_MTypeModel* areaModel = [CA_MTypeModel new];
    areaModel.title = @"所在区域";
    areaModel.value = @"选择";
    areaModel.type = Select;
    CA_MTypeModel* sourceModel = [CA_MTypeModel new];
    sourceModel.title = @"项目来源";
    sourceModel.value = @"选择";
    sourceModel.type = Select;
    CA_MTypeModel* stageModel = [CA_MTypeModel new];
    stageModel.title = @"融资阶段";
    stageModel.value = @"选择";
    stageModel.type = Select;
    CA_MTypeModel* valuationModel = [CA_MTypeModel new];
    valuationModel.title = @"目前估值（万元）";
    valuationModel.value = @"";
    valuationModel.placeHolder = @"请输入估值";
    valuationModel.type = Input;
    CA_MTypeModel* remarkModel = [CA_MTypeModel new];
    remarkModel.title = @"";
    remarkModel.value = @"";
    remarkModel.placeHolder = @"来源备注";
    remarkModel.type = Introduce;
    CA_MTypeModel* coinModel = [CA_MTypeModel new];
    coinModel.title = @"估值币种";
    coinModel.value = @"选择";
    coinModel.type = Select;
    CA_MTypeModel* patternModel = [CA_MTypeModel new];
    patternModel.title = @"估值方式";
    patternModel.value = @"选择";
    patternModel.type = Select;
    CA_MTypeModel* settingModel = [CA_MTypeModel new];
    settingModel.title = @"隐私设置";
    settingModel.value = @"公开-机构所有人可见";
    settingModel.type = Select;
    CA_MTypeModel* manageModel = [CA_MTypeModel new];
    manageModel.title = @"项目管理员";
    manageModel.value = [CA_H_MANAGER userName];
    manageModel.type = Select;
    _manageModel = [CA_MSettingAvaterModel new];
    _manageModel.user_id = [CA_H_MANAGER userId];
    
    CA_MTypeModel* processModel = [CA_MTypeModel new];
    processModel.title = @"项目流程";
    processModel.value = @"选择";
    processModel.type = Select;
    
    _dataSource = @[].mutableCopy;
    [_dataSource addObjectsFromArray:
  @[nameModel,industryModel,areaModel,
    sourceModel,remarkModel,stageModel,
    valuationModel,coinModel,patternModel,
    settingModel,manageModel,processModel]];
    return _dataSource;
}
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kColor(@"#FFFFFF");
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[CA_MInputCell class] forCellReuseIdentifier:inputKey];
    [_tableView registerClass:[CA_MSelectCell class] forCellReuseIdentifier:selectKey];
    [_tableView registerClass:[CA_MLimitedCell class] forCellReuseIdentifier:remarkKey];
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



