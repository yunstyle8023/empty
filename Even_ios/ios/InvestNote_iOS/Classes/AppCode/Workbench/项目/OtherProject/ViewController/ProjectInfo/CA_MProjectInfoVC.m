//
//  CA_MProjectInfoVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectInfoVC.h"
#import "CA_MProjectInfoCell.h"
#import "CA_MProjectTagCell.h"
#import "CA_MTypeModel.h"

static NSString* const infoKey = @"CA_MProjectInfoCell";
static NSString* const tagKey = @"CA_MProjectTagCell";

@interface CA_MProjectInfoVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MProjectInfoCellDelegate,
CA_MProjectTagCellDelegate>{
    CGFloat _cellHeight;
}

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* dataSource;
/// 右barButtonItem
@property(nonatomic,strong)UIBarButtonItem* rightBarBtnItem;

@property(nonatomic,strong)NSMutableArray* tagList;
@end

@implementation CA_MProjectInfoVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"项目信息";
    self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
    [self.view addSubview:self.tableView];
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
        make.edges.mas_equalTo(self.view);
    }];
}

-(void)setModel:(CA_MProjectDetailModel *)model{
    _model = model;
    
    NSMutableArray* tags = @[].mutableCopy;
    for (CA_MTag_list* tag in model.project_info.tag_list) {
        [tags addObject:tag.tag_name];
        [self.tagList addObject:tag.tag_id];
    }
    
    CA_MTypeModel* briefModel = [CA_MTypeModel new];
    briefModel.title = @"一句话简介";
    briefModel.value = model.project_info.slogan;
    briefModel.placeHolder = @"请填写简介";
    briefModel.type = Input;
    
    CA_MTypeModel* tagModel = [CA_MTypeModel new];
    tagModel.title = @"项目标签";
    tagModel.values = tags;
    tagModel.type = Other;
    
    CA_MTypeModel* introModel = [CA_MTypeModel new];
    introModel.title = @"项目介绍";
    introModel.value = model.project_info.brief_intro;
    introModel.placeHolder = @"请填写项目介绍";
    introModel.type = Input;
    
    CA_MTypeModel* hilightModel = [CA_MTypeModel new];
    hilightModel.title = @"投资亮点";
    hilightModel.value = model.project_info.invest_highlight;
    hilightModel.placeHolder = @"请填写投资亮点";
    hilightModel.type = Input;
    
    CA_MTypeModel* riskModel = [CA_MTypeModel new];
    riskModel.title = @"投资风险";
    riskModel.value = model.project_info.invest_risk;
    riskModel.placeHolder = @"请填写投资风险";
    riskModel.type = Input;
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:
     @[briefModel,tagModel,introModel,hilightModel,riskModel]
     ];
    [self.tableView reloadData];
}

-(void)clickRightBarBtnAction{
    
    NSDictionary* parameters = @{
                                 @"project_id": self.model.project_id,
                                 @"brief_intro": ((CA_MTypeModel*)self.dataSource[0]).value,
                                 @"introduction": ((CA_MTypeModel*)self.dataSource[2]).value,
                                 @"invest_highlight": ((CA_MTypeModel*)self.dataSource[3]).value,
                                 @"invest_risk": ((CA_MTypeModel*)self.dataSource[4]).value
                                 };
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_UpdateProjectIntro parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                
                //刷新项目列表
                [[NSNotificationCenter defaultCenter] postNotificationName:CA_M_RefreshProjectListNotification object:nil];
                //
                if (self.block) {
                    self.block();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}

#pragma mark - CA_MProjectInfoCellDelegate

-(void)textDidChange:(NSString*)placeHolder content:(NSString*)content{
    
    [self.dataSource enumerateObjectsUsingBlock:^(CA_MTypeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([placeHolder isEqualToString:model.placeHolder]) {
            
            if ([content isEqualToString:model.value]) {
                return;
            }
            
            CA_MTypeModel* newModel = [CA_MTypeModel new];
            newModel.title = model.title;
            newModel.value = content;
            newModel.placeHolder = model.placeHolder;
            newModel.type = model.type;
            
            [self.dataSource replaceObjectAtIndex:idx withObject:newModel];
            *stop = YES;
        }
    }];

}

-(void)textLengthDidMax{
    NSLog(@"已达到最大限制字数");
}

#pragma mark - CA_MProjectTagCellDelegate

-(void)addTag{
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:@"新标签" preferredStyle:UIAlertControllerStyleAlert];
    [actionSheetController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"新标签名称";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* tagName = [actionSheetController.textFields firstObject].text;
        if (![NSString isValueableString:tagName]) {
            return ;
        }
        
        NSDictionary* parameters = @{@"project_id":self.model.project_id,
                                     @"tag_name": tagName};
        [CA_HProgressHUD loading:self.view];
        [CA_HNetManager postUrlStr:CA_M_Api_CreateProjectTag parameters:parameters callBack:^(CA_HNetModel *netModel) {
            [CA_HProgressHUD hideHud:self.view];
            
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.intValue == 0) {
                    [self.dataSource enumerateObjectsUsingBlock:^(CA_MTypeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if (model.type == Other) {
                            [model.values appendObject:netModel.data[@"tag_name"]];
                            [self.tagList addObject:netModel.data[@"project_tag_id"]];
                            [self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
                            
                            //
                            if (self.block) {
                                self.block();
                            }
                            
                            *stop = YES;
                        }
                    }];
                }else{
                    [CA_HProgressHUD showHudStr:netModel.errmsg];
                }
            }
//            else{
//                [CA_HProgressHUD showHudStr:netModel.errmsg];
//            }
        } progress:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [actionSheetController addAction:determineAction];
    [actionSheetController addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:actionSheetController animated:YES completion:nil];
    });
}

-(void)delTag:(NSInteger)index{
    
    NSDictionary* parameters = @{@"project_id":self.model.project_id,
                                 @"project_tag_id":self.tagList[index]};
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_DeleteProjectTag parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                [self.dataSource enumerateObjectsUsingBlock:^(CA_MTypeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (model.type == Other) {
                        [model.values removeObjectAtIndex:index];
                        [self.tagList removeObjectAtIndex:index];
                        [self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
                        //
                        if (self.block) {
                            self.block();
                        }
                        
                        *stop = YES;
                    }
                }];
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Input) {
        CA_MProjectInfoCell* infoCell = [tableView dequeueReusableCellWithIdentifier:infoKey];
        infoCell.delegate = self;
        [infoCell configCell:model.title
                 placeHolder:model.placeHolder
                        text:model.value];
        return infoCell;
    }
    CA_MProjectTagCell* tagCell = [tableView dequeueReusableCellWithIdentifier:tagKey];
    tagCell.delegate = self;
    _cellHeight = [tagCell configCell:model.title tags:model.values];
    return tagCell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Input) {
        return 190*CA_H_RATIO_WIDTH;
    }
    return _cellHeight;
}

#pragma mark - getter and setter
-(NSMutableArray *)tagList{
    if (_tagList) {
        return _tagList;
    }
    _tagList = @[].mutableCopy;
    return _tagList;
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
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[CA_MProjectInfoCell class] forCellReuseIdentifier:infoKey];
    [_tableView registerClass:[CA_MProjectTagCell class] forCellReuseIdentifier:tagKey];
    return _tableView;
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

