//
//  CA_MChooseOrganizationVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MChooseOrganizationVC.h"
#import "CA_MChooseOrganizationCell.h"

static NSString* const chooseOrganKey = @"CA_MChooseOrganizationCell";

@interface CA_MChooseOrganizationVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property(nonatomic,strong)UIImageView* logoImgView;
@property(nonatomic,strong)UILabel* welcomeLb;
@property(nonatomic,strong)UITableView* tableView;
@end

@implementation CA_MChooseOrganizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraint];
}

- (void)setupUI{
    [self.view addSubview:self.logoImgView];
    [self.view addSubview:self.welcomeLb];
    [self.view addSubview:self.tableView];
}

- (void)setupConstraint{
    
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.welcomeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.logoImgView.mas_bottom).offset(40*CA_H_RATIO_WIDTH);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.welcomeLb.mas_bottom).offset(50);
        make.bottom.mas_equalTo(self.view).offset(-40);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
    }];
    
    CAGradientLayer *_gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0.1 alpha:0] CGColor],
                       (id)[[UIColor colorWithWhite:0.2 alpha:0.5] CGColor],
                       (id)[[UIColor colorWithWhite:0.3 alpha:1] CGColor],
                       nil];
    [_gradLayer setColors:colors];
    //渐变起止点，point表示向量
    [_gradLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
    [_gradLayer setEndPoint:CGPointMake(0.0f, 0.0f)];
    [_gradLayer setFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 300)];
    
    [self.tableView.layer setMask:_gradLayer];

    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MChooseOrganizationCell* chooseOrganCell = [tableView dequeueReusableCellWithIdentifier:chooseOrganKey];
    
    return chooseOrganCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewPlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = (72+20)*CA_H_RATIO_WIDTH;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[CA_MChooseOrganizationCell class] forCellReuseIdentifier:chooseOrganKey];
    }
    return _tableView;
}
-(UILabel *)welcomeLb{
    if (!_welcomeLb) {
        _welcomeLb = [[UILabel alloc] init];
        [_welcomeLb configText:@"欢迎回来，选择登录" textColor:CA_H_4BLACKCOLOR font:22];
        [_welcomeLb changeLineSpaceWithSpace:26];
    }
    return _welcomeLb;
}
-(UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] init];
        _logoImgView.image = kImage(@"logo200");
    }
    return _logoImgView;
}

@end
