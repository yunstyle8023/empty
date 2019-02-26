
//
//  CA_MMyApproveVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MMyApproveVC.h"
#import "CA_MMyApproveView.h"
#import "CA_MMyApproveCell.h"
#import "CA_MApproveDetailVC.h"
#import "CA_MMyApproveModel.h"
#import "CA_HNullView.h"

typedef enum : NSUInteger {
    ReceivedApproval,//我审批的
    LaunchedApproval//我发起的
} MyApproveTag;

static NSString * const approveKey = @"CA_MMyApproveCell";

@interface CA_MMyApproveVC ()
<UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
CA_MMyApproveViewDelegaet>
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) CA_MMyApproveView *myApproveView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *myApproveTableView;
@property (nonatomic,strong) UITableView *myStartTableView;
@property (nonatomic,strong) NSMutableArray *myApproveDataSource;
@property (nonatomic,strong) NSMutableArray *myStartDataSource;
@property (nonatomic,assign) MyApproveTag approveTag;
@end

@implementation CA_MMyApproveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.approveTag = ReceivedApproval;
    [self setupUI];
    [self requestReceivedpprovalData];//我审批的
    [self requestLaunchedApprovalData];//我发起的
}

- (void)viewWillAppear:(BOOL)animated{
    if (CA_H_SystemVersion >= 11.0) {
        self.myApproveView.hidden = NO;
    }
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (CA_H_SystemVersion >= 11.0) {
       self.myApproveView.hidden = YES;
    }
    
    [super viewWillDisappear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

-(void)setupUI{

    if (CA_H_SystemVersion >= 11.0) {
        [self.navigationController.navigationBar addSubview:self.myApproveView];
        [self.myApproveView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.navigationController.navigationBar);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
    }else{
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(200, 20, 200, 40)];
        view.backgroundColor=[UIColor whiteColor];
        [view addSubview:self.myApproveView];
        self.navigationItem.titleView = view;
    }
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.myApproveTableView];
    [self.scrollView addSubview:self.myStartTableView];
}

-(void)requestReceivedpprovalData{
    [CA_HProgressHUD loading:self.myApproveTableView];
    [CA_HNetManager postUrlStr:CA_M_Api_ListUserReceivedApproval parameters:@{} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.myApproveTableView];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    for (NSDictionary* dic in netModel.data) {
                        CA_MMyApproveModel* model = [CA_MMyApproveModel modelWithDictionary:dic];
                        [self.myApproveDataSource addObject:model];
                    }
                    [self.myApproveTableView reloadData];
                }
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
        [self.myApproveTableView.mj_header endRefreshing];
        
        self.myApproveTableView.backgroundView.hidden = [NSObject isValueableObject:self.myApproveDataSource];
    } progress:nil];
}
-(void)requestLaunchedApprovalData{
    [CA_HProgressHUD loading:self.myStartTableView];
    [CA_HNetManager postUrlStr:CA_M_Api_ListUserLaunchedApproval parameters:@{} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.myStartTableView];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    for (NSDictionary* dic in netModel.data) {
                        CA_MMyApproveModel* model = [CA_MMyApproveModel modelWithDictionary:dic];
                        [self.myStartDataSource addObject:model];
                    }
                    [self.myStartTableView reloadData];
                }
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
        [self.myStartTableView.mj_header endRefreshing];
        self.myStartTableView.backgroundView.hidden = [NSObject isValueableObject:self.myStartDataSource];
    } progress:nil];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.approveTag == ReceivedApproval) {
//        tableView.backgroundView.hidden = self.myApproveDataSource.count;
//    }else{
//        tableView.backgroundView.hidden = self.myStartDataSource.count;
//    }
    NSInteger count = self.approveTag == ReceivedApproval?self.myApproveDataSource.count:self.myStartDataSource.count;
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MMyApproveCell* cell = [tableView dequeueReusableCellWithIdentifier:approveKey];
    CA_MMyApproveModel* model = nil;
    if (tableView == self.myApproveTableView) {
        
        if ([NSObject isValueableObject:self.myApproveDataSource]) {
            if (indexPath.row <= self.myApproveDataSource.count-1) {
                model = self.myApproveDataSource[indexPath.row];
                cell.model = model;
            }
        }
    }else{
        if ([NSObject isValueableObject:self.myStartDataSource]) {
            if (indexPath.row <= self.myStartDataSource.count-1) {
                model = self.myStartDataSource[indexPath.row];
                cell.model = model;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CA_MMyApproveModel* model = nil;
    if (tableView == self.myApproveTableView) {
        
        if ([NSObject isValueableObject:self.myApproveDataSource]) {
            if (indexPath.row <= self.myApproveDataSource.count-1) {
                model = self.myApproveDataSource[indexPath.row];
            }
        }
    }else{
        if ([NSObject isValueableObject:self.myStartDataSource]) {
            if (indexPath.row <= self.myStartDataSource.count-1) {
                model = self.myStartDataSource[indexPath.row];
            }
        }
    }
    
    if (!model) {
        return;
    }
    
    if (![model.approval_english_status isEqualToString:@"revoke"]) {
        CA_MApproveDetailVC* approveDetailVC = [CA_MApproveDetailVC new];
        approveDetailVC.approveID = model.approval_id;
        CA_H_WeakSelf(self)
        approveDetailVC.block = ^{
            CA_H_StrongSelf(self)
            //我审批的
            [self.myApproveDataSource removeAllObjects];
            [self.myApproveTableView reloadData];
            [self requestReceivedpprovalData];
            //我发起的
            [self.myStartDataSource removeAllObjects];
            [self.myStartTableView reloadData];
            [self requestLaunchedApprovalData];
        };
        [self.navigationController pushViewController:approveDetailVC animated:YES];
    }else {
        [CA_HProgressHUD showHudStr:@"审批已撤销"];
    }
}

#pragma mark - CA_MMyApproveViewDelegaet

-(void)didSelect:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(CA_H_SCREEN_WIDTH*index, 0) animated:YES];
    //
    self.approveTag = index;
    if (self.approveTag == ReceivedApproval) {
        [self.myApproveTableView reloadData];
    }else{
        [self.myStartTableView reloadData];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        ((UITableView *)scrollView).backgroundView.subviews.firstObject.mj_y = -scrollView.contentOffset.y;
    }
    
    if (scrollView == self.scrollView) {
        [self.myApproveView scroll:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x/CA_H_SCREEN_WIDTH;
        [self.myApproveView scrollDidEnd:index];
        //
        self.approveTag = index;
        if (self.approveTag == ReceivedApproval) {
            [self.myApproveTableView reloadData];
        }else{
            [self.myStartTableView reloadData];
        }
    }
}

#pragma mark - getter and setter
-(UITableView *)myStartTableView{
    if (_myStartTableView) {
        return _myStartTableView;
    }
    CGRect rect = CGRectMake(CA_H_SCREEN_WIDTH, 0, CA_H_SCREEN_WIDTH, self.view.frame.size.height-(Navigation_Height));
    _myStartTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _myStartTableView.dataSource = self;
    _myStartTableView.delegate = self;
    _myStartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myStartTableView registerClass:[CA_MMyApproveCell class] forCellReuseIdentifier:approveKey];
    _myStartTableView.backgroundColor = kColor(@"#FFFFFF");
    _myStartTableView.rowHeight = 220*CA_H_RATIO_WIDTH;
    CA_H_WeakSelf(self);
    __weak UITableView* weakTableView = _myStartTableView;
    _myStartTableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
        CA_H_StrongSelf(self);
        [self.myStartDataSource removeAllObjects];
        [self requestLaunchedApprovalData];
    }];
    _myStartTableView.backgroundView = [CA_HNullView newTitle:@"当前没有任何审批"
               buttonTitle:nil
                       top:79*CA_H_RATIO_WIDTH
                  onButton:nil
                 imageName:@"empty_approval"];
    _myStartTableView.backgroundView.hidden = YES;
    return _myStartTableView;
}

-(UITableView *)myApproveTableView{
    if (_myApproveTableView) {
        return _myApproveTableView;
    }
    CGRect rect = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, self.view.frame.size.height-(Navigation_Height));
    _myApproveTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _myApproveTableView.dataSource = self;
    _myApproveTableView.delegate = self;
    _myApproveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myApproveTableView registerClass:[CA_MMyApproveCell class] forCellReuseIdentifier:approveKey];
    _myApproveTableView.backgroundColor = kColor(@"#FFFFFF");
    _myApproveTableView.rowHeight = 220*CA_H_RATIO_WIDTH;
    CA_H_WeakSelf(self);
    __weak UITableView* weakTableView = _myApproveTableView;
    _myApproveTableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
        CA_H_StrongSelf(self);
        [self.myApproveDataSource removeAllObjects];
        [self requestReceivedpprovalData];
    }];
    _myApproveTableView.backgroundView = [CA_HNullView newTitle:@"当前没有任何审批"
                                                  buttonTitle:nil
                                                          top:79*CA_H_RATIO_WIDTH
                                                     onButton:nil
                                                    imageName:@"empty_approval"];
    _myApproveTableView.backgroundView.hidden = YES;
    return _myApproveTableView;
}
-(UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(CA_H_SCREEN_WIDTH*2, 0);
    _scrollView.backgroundColor = kColor(@"#FFFFFF");
    _scrollView.delegate = self;
    //
    UIGestureRecognizer * screenEdgePanGestureRecognizer = self.navigationController.interactivePopGestureRecognizer;
    if(screenEdgePanGestureRecognizer)
        [_scrollView.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
    return _scrollView;
}
-(CA_MMyApproveView *)myApproveView{
    if (_myApproveView) {
        return _myApproveView;
    }
    _myApproveView = [CA_MMyApproveView new];
    _myApproveView.frame = CGRectMake(0, 0, 200, 40);
    _myApproveView.delegate = self;
    return _myApproveView;
}
-(NSMutableArray *)myStartDataSource{
    if (_myStartDataSource) {
        return _myStartDataSource;
    }
    _myStartDataSource = @[].mutableCopy;
    return _myStartDataSource;
}
-(NSMutableArray *)myApproveDataSource{
    if (_myApproveDataSource) {
        return _myApproveDataSource;
    }
    _myApproveDataSource = @[].mutableCopy;
    return _myApproveDataSource;
}

@end
