
//
//  CA_MRelatedMemberVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MRelatedMemberVC.h"
#import "CA_MProjectPersonCell.h"
#import "CA_MProjectProgressMaskView.h"

static NSString* persontKey = @"CA_MProjectPersonCell";

@interface CA_MRelatedMemberVC ()
<UITableViewDelegate,
UITableViewDataSource>{
    CA_MPersonModel* _currentModel;
}

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* dataSource;
@property(nonatomic,strong)UIBarButtonItem* rightBarBtnItem;
@end

@implementation CA_MRelatedMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择相关人员";
    self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
    [self setupUI];
    [self requestHumanList];
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

- (void)setupUI{
    [self.view addSubview:self.tableView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

-(void)clickRightBarBtnAction{
    if (self.callBack) {
        self.callBack(_currentModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestHumanList{
    
//    NSDictionary* parameters = @{@"tag_id_list": @[],
//                                 @"page_num": @1
//                                 };
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_ListHumanrResource parameters:@{@"tag_id_list":@[],@"keyword":@""} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    for (NSDictionary* dic in netModel.data) {
                        CA_MPersonModel* model = [CA_MPersonModel modelWithDictionary:dic];
                        model.select = YES;
                        [self.dataSource addObject:model];
                    }
                    [self.tableView reloadData];
                }
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
        [self.tableView.mj_header endRefreshing];
    } progress:nil];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    tableView.mj_footer.hidden = !tableView.backgroundView.hidden;
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_H_WeakSelf(self);
    CA_MProjectPersonCell* personCell = [tableView dequeueReusableCellWithIdentifier:persontKey];
    if([NSObject isValueableObject:self.dataSource]){
        CA_MPersonModel* model = self.dataSource[indexPath.row];
        personCell.model = model;
    }
    __weak NSIndexPath* weakIndexPath = indexPath;
    personCell.block = ^{
        CA_H_StrongSelf(self);
        [self tableView:self.tableView didSelectRowAtIndexPath:weakIndexPath];
    };
    return personCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MPersonModel* model = self.dataSource[indexPath.row];
    
    for (CA_MPersonModel* m in self.dataSource) {
        if (model == m) {
            model.select = NO;
            _currentModel = model;
        }else{
            m.select = YES;
        }
    }
    [tableView reloadData];
}

#pragma mark - getter and setter
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewPlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kColor(@"#FFFFFF");
    _tableView.rowHeight = 70 * CA_H_RATIO_WIDTH;
    [_tableView registerClass:[CA_MProjectPersonCell class] forCellReuseIdentifier:persontKey];

//    CA_H_WeakSelf(self);
//    __weak UITableView* weakTableView = _tableView;
//    _tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
//        CA_H_StrongSelf(self);
//        [weakTableView.mj_header endRefreshing];
//    }];
//
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        CA_H_StrongSelf(self);
//        [weakTableView.mj_footer endRefreshing];
//    }];

    return _tableView;
}
-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    return _dataSource;
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
