//
//  CA_MProjectBaseInfoVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectBaseInfoVC.h"
#import "CA_MInputCell.h"
#import "CA_MSelectCell.h"
#import "CA_MTypeModel.h"
#import "CA_MFiltrateItemVC.h"
#import "CA_MCategoryModel.h"
#import "CA_MSelectDataVC.h"
#import "CA_MInvest_stageModel.h"
#import "CA_MProjectDetailModel.h"
#import "CA_MCurrencyModel.h"
#import "CA_MValutionModel.h"

typedef enum : NSUInteger {
    RemarkTag,
    ValuationTag,
    OtherTag
} BaseInfoTag;

static NSString* const inputKey = @"CA_MInputCell";
static NSString* const selectKey = @"CA_MSelectCell";

@interface CA_MProjectBaseInfoVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MInputCellDelegate>{
    CA_MCategoryModel* _categoryModel;//
    CA_MCategory* _categoryChildrenModel;//
    CA_MSource* _sourceModel;//
    CA_MInvest_stageModel* _stageModel;//
    CA_MCurrencyModel* _coinModel;//
    CA_MValuation_method* _methodModel;//
//    CA_MSettingAvaterModel* _manageModel;//
//    CA_Mprocedure_viewModel* _processModel;//
}

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* dataSource;
/// 右barButtonItem
@property(nonatomic,strong)UIBarButtonItem* rightBarBtnItem;
@end

@implementation CA_MProjectBaseInfoVC

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
    self.navigationItem.title = @"基本资料";
    self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
    [self.contentView addSubview:self.tableView];
}

-(void)setModel:(CA_MProjectDetailModel *)model{
    _model = model;
    
    _categoryModel = [CA_MCategoryModel new];
    _categoryModel.category_name = model.header_info.parent_category_name;
    _categoryModel.category_id = model.header_info.parent_category_id;

    _categoryChildrenModel = [CA_MCategory new];
    _categoryChildrenModel.category_id = model.header_info.child_category_id;
    _categoryChildrenModel.category_name = model.header_info.child_category_name;
    
    _sourceModel = [CA_MSource new];
    _sourceModel = model.basic_info.source;
    
    _stageModel = [CA_MInvest_stageModel new];
    _stageModel.invest_stage_name = model.header_info.invest_stage_name;
    _stageModel.invest_stage_id = model.header_info.invest_stage_id;
    
    _coinModel = [CA_MCurrencyModel new];
    _coinModel.unit_id = model.basic_info.valuation.currency_id;
    _coinModel.unit_en = model.basic_info.valuation.currency_en;
    _coinModel.unit_sym = model.basic_info.valuation.currency_sym;
    _coinModel.unit_cn = model.basic_info.valuation.currency_cn;

    _methodModel = model.basic_info.valuation_method;
    
    [self.tableView reloadData];
}

-(void)clickRightBarBtnAction{
    
    NSString* industry = ((CA_MTypeModel*)[self.dataSource objectAtIndex:0]).value;
    if ([industry isEqualToString:@"选择"]) {
        [CA_HProgressHUD showHudStr:@"请选择行业领域"];
        return;
    }
    
    NSString* area = ((CA_MTypeModel*)[self.dataSource objectAtIndex:1]).value;
    if ([area isEqualToString:@"选择"]) {
        [CA_HProgressHUD showHudStr:@"请选择所在地区"];
        return;
    }
    
    NSString* stage = ((CA_MTypeModel*)[self.dataSource objectAtIndex:2]).value;
    if ([stage isEqualToString:@"选择"]) {
        [CA_HProgressHUD showHudStr:@"请选择融资轮次"];
        return;
    }
    
    NSString* source = ((CA_MTypeModel*)[self.dataSource objectAtIndex:3]).value;
    if ([source isEqualToString:@"选择"]) {
        [CA_HProgressHUD showHudStr:@"请选择项目来源"];
        return;
    }
    
//    NSString* valuation = ((CA_MTypeModel*)[self.dataSource objectAtIndex:5]).value;
//
//    if ([NSString isValueableString:valuation] &&
//        [valuation intValue]>0) {
//        if (valuation.length > 12) {
//            [CA_HProgressHUD showHudStr:@"目前估值最大为千亿级别"];
//            return;
//        }
//
//        NSString* coin = ((CA_MTypeModel*)[self.dataSource objectAtIndex:6]).value;
//        if ([coin isEqualToString:@"选择"]) {
//            [CA_HProgressHUD showHudStr:@"请选择币种"];
//            return;
//        }
//
//    }
    
//    NSString* method = ((CA_MTypeModel*)[self.dataSource objectAtIndex:7]).value;
//    if ([method isEqualToString:@"选择"]) {
//        [CA_HProgressHUD showHudStr:@"请选择估值方式"];
//        return;
//    }
    
//    NSString* method = ((CA_MTypeModel*)[self.dataSource objectAtIndex:6]).value;
//    if ([method isEqualToString:@"选择"]) {
//        [CA_HProgressHUD showHudStr:@"请选择估值币种"];
//        return;
//    }
    
    NSDictionary* parameters = @{@"project_id": self.model.project_id,
                                 @"category_id": _categoryChildrenModel.category_id,                    //# 投资领域
                                 @"area": [area componentsSeparatedByString:@"-"],
                                 @"source": _sourceModel.source_id,                               //# 项目来源
                                 @"source_contact": @"",                //# 介绍人
                                 @"invest_stage_id": _stageModel.invest_stage_id,                     // # 融资轮次
                                 @"source_comment": ((CA_MTypeModel*)[self.dataSource objectAtIndex:4]).value,              //# 来源备注
//                                 @"valuation_method":[((CA_MTypeModel*)[self.dataSource objectAtIndex:7]).value isEqualToString:@"选择"]?@"":((CA_MTypeModel*)[self.dataSource objectAtIndex:7]).value,                      //# 估值方式
                                 @"valuation_method":@"",  
//                                 @"valuation":@{@"num": @([((CA_MTypeModel*)[self.dataSource objectAtIndex:5]).value intValue]),
                                 @"valuation":@{@"num": @0,
                                                @"unit_id": _coinModel.unit_id?_coinModel.unit_id:@0
                                                }     //# 项目估值
                                 };
    
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_UpdateProject parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if (self.block) {
                    self.block();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:CA_M_RefreshProjectListNotification object:nil];
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

-(void)textDidChange:(CA_MInputCell *)cell content:(NSString *)content{
    if (cell.tag == RemarkTag) {//来源备注
        CA_MTypeModel* model = [self.dataSource objectAtIndex:4];
        model.value = content;
    }else if (cell.tag == ValuationTag){//目前估值
        CA_MTypeModel* model = [self.dataSource objectAtIndex:5];
        model.value = content;
    }
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
        if ([model.title isEqualToString:@"目前估值（万元）"]) {
            inputCell.keyBoardType = UIKeyboardTypeNumberPad;
        }else{
            inputCell.keyBoardType = UIKeyboardTypeDefault;
        }
        
        if ([model.title isEqualToString:@"来源备注"]) {
            inputCell.tag = RemarkTag;
        }else if ([model.title isEqualToString:@"目前估值（万元）"]) {
            inputCell.tag = ValuationTag;
        }else{
            inputCell.tag = OtherTag;
        }
        return inputCell;
    }
    CA_MSelectCell* selectCell = [tableView dequeueReusableCellWithIdentifier:selectKey];
    [selectCell configCell:model.title :model.value];
    return selectCell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_H_WeakSelf(self);
    __weak NSIndexPath* weakIndexPath = indexPath;
    CGRect rect = CGRectMake(0, (kDevice_Is_iPhoneX?60:40)*2*CA_H_RATIO_WIDTH, CA_H_SCREEN_WIDTH, CA_H_SCREEN_HEIGHT-(kDevice_Is_iPhoneX?60:40)*2*CA_H_RATIO_WIDTH);
    if (indexPath.row == 0 ||
        indexPath.row == 1 ||
        indexPath.row == 7){
        CA_MFiltrateItemVC* filtrateItemVC = [[CA_MFiltrateItemVC alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(id obj) {
            CA_H_StrongSelf(self);
            if (!obj) {
                return ;
            }
            if ([obj isKindOfClass:[NSString class]]) {//所在区域
                CA_MTypeModel* model =  [self.dataSource objectAtIndex:weakIndexPath.row];
                model.value = [NSString isValueableString:obj] ? obj : @"选择";
            }else if ([obj isKindOfClass:[NSArray class]]) {//行业领域
                _categoryModel = [obj firstObject];
                _categoryChildrenModel = [obj lastObject];
                CA_MTypeModel* model =  [self.dataSource objectAtIndex:weakIndexPath.row];
                model.value = [NSString isValueableString:_categoryModel.category_name] ? _categoryModel.category_name : @"选择";
            }else if ([obj isKindOfClass:[CA_MValutionModel class]]) {//估值方式
                CA_MTypeModel* model =  [self.dataSource objectAtIndex:weakIndexPath.row];
                model.value = ((CA_MValutionModel *)obj).label;
            }
            [self.tableView reloadRow:weakIndexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        if (indexPath.row == 0) {//行业领域
            filtrateItemVC.titleStr = @"选择行业领域";
            filtrateItemVC.urlStr = CA_M_Api_ListCategory;
            filtrateItemVC.className = @"CA_MCategoryModel";
            filtrateItemVC.keyName = @"category_name";
        }else if (indexPath.row == 1) {//所在区域
            filtrateItemVC.titleStr = @"选择所在区域";
            filtrateItemVC.urlStr = CA_M_Api_ListArea;
            filtrateItemVC.className = @"CA_MCityModel";
            filtrateItemVC.keyName = @"area_name";
        }else if (indexPath.row == 7) {//估值方式
            filtrateItemVC.titleStr = @"选择估值方式";
            filtrateItemVC.urlStr = CA_M_Api_ListProjectValutionmethod;
            filtrateItemVC.className = @"CA_MValutionModel";
            filtrateItemVC.keyName = @"label";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:filtrateItemVC animated:YES completion:nil];
        });
    }
    
    if (indexPath.row == 2 ||
        indexPath.row == 3 ||
        indexPath.row == 6 ){
        CA_MSelectDataVC* dataVC = [[CA_MSelectDataVC alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(CA_HBaseModel* selectModel) {
            CA_H_StrongSelf(self);
            
            if (!selectModel) {
                return ;
            }
            
            if ([selectModel isKindOfClass:[CA_MSource class]]) {//项目来源
                _sourceModel = (CA_MSource*)selectModel;
            }else if ([selectModel isKindOfClass:[CA_MInvest_stageModel class]]) {//融资阶段
                _stageModel = (CA_MInvest_stageModel*)selectModel;
            }else if ([selectModel isKindOfClass:[CA_MCurrencyModel class]]){//币种
                _coinModel = (CA_MCurrencyModel*)selectModel;
            }else if ([selectModel isKindOfClass:[CA_MValuation_method class]]){//估值方式
                _methodModel = (CA_MValuation_method*)selectModel;
            }
            
            CA_MTypeModel* model = self.dataSource[weakIndexPath.row];
            NSString* selectStr = [selectModel valueForKey:selectModel.projectKey];
            model.value = [NSString isValueableString:selectStr] ? selectStr : @"选择";
            [self.tableView reloadRow:weakIndexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        dataVC.progress = NO;
        if (indexPath.row == 2){//融资阶段
            dataVC.requestUrl = CA_M_Api_QueryInvestStageDict;
            dataVC.className = @"CA_MInvest_stageModel";
            dataVC.key = @"invest_stage_name";
        }else if (indexPath.row == 3){//项目来源
            dataVC.requestUrl = CA_M_Api_QuerySourceDict;
            dataVC.className = @"CA_MSource";
            dataVC.key = @"source_name";
        }else if (indexPath.row == 6){//币种
            dataVC.requestUrl = CA_M_Api_ListCurrency;
            dataVC.className = @"CA_MCurrencyModel";
            dataVC.key = @"unit_cn";
        }
//        else if (indexPath.row == 7){//估值方式
//            dataVC.requestUrl = CA_M_Api_QueryValuationDict;
//            dataVC.className = @"CA_MValuation_method";
//            dataVC.key = @"valuation_method_name";
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:dataVC animated:YES completion:nil];
        });
    }
}

#pragma mark - getter and setter
-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    
    CA_MTypeModel* industryModel = [CA_MTypeModel new];
    industryModel.title = @"行业领域";
    industryModel.value = [NSString isValueableString:self.model.header_info.parent_category_name]?self.model.header_info.parent_category_name:@"选择";
    industryModel.type = Select;
    
    CA_MTypeModel* areaModel = [CA_MTypeModel new];
    areaModel.title = @"所在区域";
    if ([NSObject isValueableObject:self.model.header_info.area]) {
        areaModel.value = [NSString stringWithFormat:@"%@-%@",[self.model.header_info.area firstObject],[self.model.header_info.area lastObject]];
    }else {
        areaModel.value = @"选择";
    }
    areaModel.type = Select;
    
    CA_MTypeModel* stageModel = [CA_MTypeModel new];
    stageModel.title = @"融资轮次";
    stageModel.value = [NSString isValueableString:self.model.header_info.invest_stage_name]?self.model.header_info.invest_stage_name:@"选择";
    stageModel.type = Select;
    
    CA_MTypeModel* sourceModel = [CA_MTypeModel new];
    sourceModel.title = @"项目来源";
    sourceModel.value = [NSString isValueableString:self.model.basic_info.source.source_name]?self.model.basic_info.source.source_name:@"选择";
    sourceModel.type = Select;
    
    CA_MTypeModel* remarkModel = [CA_MTypeModel new];
    remarkModel.title = @"来源备注";
    remarkModel.value = self.model.basic_info.source_comment;
    remarkModel.placeHolder = @"请输入";
    remarkModel.type = Input;
    
    CA_MTypeModel* assessmentModel = [CA_MTypeModel new];
    assessmentModel.title = @"目前估值（万元）";
    assessmentModel.value = self.model.basic_info.valuation.amount;
    assessmentModel.placeHolder = @"请输入目前估值";
    assessmentModel.type = Input;

    CA_MTypeModel* coinModel = [CA_MTypeModel new];
    coinModel.title = @"估值币种";
    coinModel.value = [NSString isValueableString:self.model.basic_info.valuation.currency_cn]?self.model.basic_info.valuation.currency_cn:@"选择";
    coinModel.type = Select;

    CA_MTypeModel* wayModel = [CA_MTypeModel new];
    wayModel.title = @"估值方式";
    wayModel.value = [NSString isValueableString:self.model.basic_info.valuation_method.valuation_method_name]?self.model.basic_info.valuation_method.valuation_method_name:@"选择";
    wayModel.type = Select;
    
//    [_dataSource addObjectsFromArray:
//     @[industryModel,areaModel,stageModel,
//       sourceModel,remarkModel,assessmentModel,
//       coinModel,wayModel]];
    
    [_dataSource addObjectsFromArray:
     @[industryModel,areaModel,stageModel,
       sourceModel,remarkModel]];
    return _dataSource;
}
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewPlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 52 * CA_H_RATIO_WIDTH;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[CA_MInputCell class] forCellReuseIdentifier:inputKey];
    [_tableView registerClass:[CA_MSelectCell class] forCellReuseIdentifier:selectKey];
    return _tableView;
}-(UIBarButtonItem *)rightBarBtnItem{
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

