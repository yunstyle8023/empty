
//
//  CA_MSelectDataVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSelectDataVC.h"
#import "CA_MCityModel.h"
#import "CA_MCategoryModel.h"
#import "CA_MProjectDetailModel.h"
#import "CA_MProjectProgressModel.h"
#import "CA_MSettingModel.h"

@interface CA_MSelectDataVC ()
<UIPickerViewDataSource,
UIPickerViewDelegate>

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *confirmBtn;
@end

@implementation CA_MSelectDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setConstraint];
    if (!self.isProgress) {
       [self requestData];
    }else{
        [self.pickerView reloadAllComponents];
    }
}

-(void)setupUI{
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.cancelBtn];
    [self.bgView addSubview:self.confirmBtn];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.pickerView];
}

-(void)setConstraint{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(272*CA_H_RATIO_WIDTH);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView).offset(20);
        make.top.mas_equalTo(self.bgView).offset(8);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView).offset(-20);
        make.top.mas_equalTo(self.bgView).offset(8);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView).offset(52);
        make.height.mas_equalTo(1);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.lineView.mas_bottom);
    }];
}

-(void)requestData{
    if (![self.requestUrl isEqualToString:CA_M_Api_ListCompanyUser]) {
        [CA_HNetManager getUrlStr:self.requestUrl parameters:nil callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    if ([netModel.data isKindOfClass:[NSArray class]] &&
                        [NSObject isValueableObject:netModel.data]) {
                        for (NSDictionary* dic in netModel.data) {
                            [self.dataSource addObject:[NSClassFromString(self.className) modelWithDictionary:dic]];
                        }
                        [self.pickerView reloadAllComponents];
                    }
                }else{
                    [CA_HProgressHUD showHudStr:netModel.errmsg];
                }
            }
//            else{
//                [CA_HProgressHUD showHudStr:netModel.errmsg];
//            }
        } progress:nil];
    }else{
        [CA_HNetManager postUrlStr:self.requestUrl parameters:@{} callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    if ([netModel.data isKindOfClass:[NSArray class]] &&
                        [NSObject isValueableObject:netModel.data]) {
                        for (NSDictionary* dic in netModel.data) {
                            [self.dataSource addObject:[NSClassFromString(self.className) modelWithDictionary:dic]];
                        }
                        [self.pickerView reloadAllComponents];
                    }
                }else{
                    [CA_HProgressHUD showHudStr:netModel.errmsg];
                }
            }
//            else{
//                [CA_HProgressHUD showHudStr:netModel.errmsg];
//            }
        } progress:nil];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([self.dataSource count]) {
        return self.dataSource.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if ([self.dataSource count]) {
        CA_HBaseModel* model = self.dataSource[row];
//        if (![self.requestUrl isEqualToString:CA_M_Api_ListCompanyUser]) {
           return [model valueForKey:self.key];
//        }
//        return [NSString stringWithFormat:@"%@-%@",[model valueForKey:self.key],[model valueForKey:self.role]];
    }
    return @"";
}


-(void)confirmAction{
    
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    if ([NSObject isValueableObject:self.dataSource]) {
        CA_HBaseModel* model = self.dataSource[row];
        model.projectKey = self.key;
        if (self.callback) {
            self.callback(model);
        }
    }
    [self cancelAction];
}

-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter
-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    return _dataSource;
}
-(UIPickerView *)pickerView{
    if (_pickerView) {
        return _pickerView;
    }
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = kColor(@"#FFFFFF");
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    return _pickerView;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UIButton *)confirmBtn{
    if (_confirmBtn) {
        return _confirmBtn;
    }
    _confirmBtn = [[UIButton alloc] init];
    [_confirmBtn configTitle:@"完成" titleColor:CA_H_TINTCOLOR font:16];
    [_confirmBtn addTarget:self
                    action:@selector(confirmAction)
          forControlEvents:UIControlEventTouchUpInside];
    return _confirmBtn;
}
-(UIButton *)cancelBtn{
    if (_cancelBtn) {
        return _cancelBtn;
    }
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn configTitle:@"取消" titleColor:CA_H_9GRAYCOLOR font:16];
    [_cancelBtn addTarget:self
                   action:@selector(cancelAction)
         forControlEvents:UIControlEventTouchUpInside];
    return _cancelBtn;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    return _bgView;
}
@end
