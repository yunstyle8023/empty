//
//  CA_HScheduleListVC.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleListVC.h"

#import "CA_HScheduleListMM.h"
#import "CA_HScheduleListVM.h"

@interface CA_HScheduleListVC ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) CA_HScheduleListMM *modelM;
@property (nonatomic, strong) CA_HScheduleListVM *viewM;

@end

@implementation CA_HScheduleListVC

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HScheduleListMM *)modelM {
    if (!_modelM) {
        CA_HScheduleListMM *object = [CA_HScheduleListMM new];
        _modelM = object;
    }
    return _modelM;
}

- (CA_HScheduleListVM *)viewM {
    if (!_viewM) {
        CA_HScheduleListVM *object = [CA_HScheduleListVM new];
        _viewM = object;
    }
    return _viewM;
}

#pragma mark --- LifeCircle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.viewM.tableNode.delegate = nil;
    self.viewM.tableNode.dataSource = nil;
}

- (instancetype)init {
    self = [super initWithNode:self.viewM.tableNode];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schedule_screeningChange:)  name:@"schedule_screeningChange" object:nil];
        //在此设置任何实例变量或属性
        self.viewM.tableNode.delegate = self;
        self.viewM.tableNode.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //绝不应该在此方法中放置布局代码
    self.viewM.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.viewM.tableNode.view.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, CA_H_RATIO_WIDTH)];
    self.viewM.tableNode.view.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, CA_H_RATIO_WIDTH)];
    self.viewM.tableNode.view.sectionHeaderHeight = 0;
    self.viewM.tableNode.view.sectionFooterHeight = 0;
    self.viewM.tableNode.leadingScreensForBatching = 1.0;
    
    [CA_HProgressHUD loading:self.view];
    self.modelM.page_num = 0;
    self.modelM.page_size = 30;
    
    CA_H_WeakSelf(self);
    [self.modelM reloadFilter:^{
        CA_H_StrongSelf(self);
        [self.modelM reloadMore:^{
            CA_H_StrongSelf(self);
            if(![self hasMoreData]){// 无数据显示
                self.viewM.tableNode.view.mj_footer.state = MJRefreshStateNoMoreData;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewM.tableNode reloadData];
            });
            [CA_HProgressHUD performSelector:@selector(hideHud:) withObject:self.view afterDelay:0.5];
        }];
    }];
    
    [self addMJ];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //为了保持一致性，最佳做法是将所有布局代码放在此方法中
//    self.view.frame = self.changeFrame;
}

#pragma mark --- Custom

-(void) addMJ{
    
    CA_H_WeakSelf(self)
    
    self.viewM.tableNode.view.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
        CA_H_StrongSelf(self);
        
        [self.viewM.tableNode.view.mj_header endRefreshing];
        self.modelM.page_num = 0;
        
        [self.modelM reloadMore:^{
            CA_H_StrongSelf(self);
            if(![self hasMoreData]){// 无数据显示
                self.viewM.tableNode.view.mj_footer.state = MJRefreshStateNoMoreData;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewM.tableNode reloadData];
            });
        }];
    }];
    
    self.viewM.tableNode.view.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        CA_H_StrongSelf(self);
        if(![self hasMoreData]){// 无数据显示
            self.viewM.tableNode.view.mj_footer.state = MJRefreshStateNoMoreData;
        }else{
            [self.viewM.tableNode.view.mj_footer endRefreshing];
        }
    }];

}

#pragma mark --- Delegate

//table
- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 3;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    if (self.modelM.data.count > 0 || (self.modelM.start_time&&self.modelM.end_time) || self.modelM.user_ids.count > 0) {
        if (section == 2) {
            return self.modelM.data.count;
        }
        return section;
    }
    return (section == 0);
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.modelM.data.count > 0 || (self.modelM.start_time&&self.modelM.end_time) || self.modelM.user_ids.count > 0) {
        if (indexPath.section == 1) {
            return ^{
                return [[CA_HScheduleListHeaderNode alloc]  initWithStart:self.modelM.start_time end:self.modelM.end_time userIds:self.modelM.user_ids userName:self.modelM.user_name];
            };
        } else if (indexPath.section == 2) {
            return ^{
                return [[CA_HScheduleListCellNode alloc]initWithModel:self.modelM.data[indexPath.row]];;
            };
        }
        return nil;
    }
    return ^{
        return [CA_HScheduleListNullNode new];;
    };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && self.pushBlock) {
        CA_HScheduleListModel *model = self.modelM.data[indexPath.row];
        
        if (model.id&&!([model.privacy_typ isEqualToNumber:@(1)]&&[model.is_participate isEqualToNumber:@(0)])) {
            self.pushBlock(@"CA_HRNScheduleDetailVC", @{@"scheduleId":model.id,@"model":model});
        } else {
            [CA_HProgressHUD showHudStr:@"隐私日程不可查看"];
        }
    }
}

- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    return [self hasMoreData];
}
//2
- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [context beginBatchFetching];
    [self loadPageWithContext:context];
}

- (BOOL)hasMoreData{
    return self.modelM.data.count < self.modelM.total_count.integerValue ;
}

- (void)loadPageWithContext:(ASBatchContext *)context
{
    if([self hasMoreData]){
        CA_H_WeakSelf(self);
        [self.modelM reloadMore:^{
            CA_H_StrongSelf(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewM.tableNode reloadData];
            });
            [context completeBatchFetching:YES];
        }];
    }
}

#pragma mark --- Notification
- (void)schedule_screeningChange:(NSNotification*)notification{
    NSString *nameString = [notification name];
    NSString *objectString = [notification object];
    NSDictionary *dictionary = [notification userInfo];//为nil要有这行代码哦
    // 当你拿到这些数据的时候你可以去做一些操作
    
    if ([objectString isEqualToString:@"reset"]) {
        self.modelM.start_time = nil;
        self.modelM.end_time = nil;
        self.modelM.page_num = 0;
        
        [CA_HProgressHUD loading:self.view];
        CA_H_WeakSelf(self);
        [self.modelM reloadMore:^{
            CA_H_StrongSelf(self);
            if(![self hasMoreData]){// 无数据显示
                self.viewM.tableNode.view.mj_footer.state = MJRefreshStateNoMoreData;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewM.tableNode reloadData];
                [CA_HProgressHUD hideHud:self.view];
            });
        }];
    } else if ([objectString isEqualToString:@"sure"]) {
        NSDate *start = dictionary[@"start"];
        NSDate *end = dictionary[@"end"];
        if (start&&end) {
            NSString *format = @"yyyy.MM.dd";
            self.modelM.start_time = @([NSDate dateWithString:[start stringWithFormat:format] format:format].timeIntervalSince1970);
            self.modelM.end_time = @([NSDate dateWithString:[end stringWithFormat:format] format:format].timeIntervalSince1970);
            
//            int rander = 24*3600;
//            self.modelM.start_time = @(floor(start.timeIntervalSince1970/rander)*rander);
//            self.modelM.end_time = @(floor(end.timeIntervalSince1970/rander)*rander);
            self.modelM.page_num = 0;
            
            [CA_HProgressHUD loading:self.view];
            CA_H_WeakSelf(self);
            [self.modelM reloadMore:^{
                CA_H_StrongSelf(self);
                if(![self hasMoreData]){// 无数据显示
                    self.viewM.tableNode.view.mj_footer.state = MJRefreshStateNoMoreData;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.viewM.tableNode reloadData];
                    [CA_HProgressHUD hideHud:self.view];
                });
            }];
        }
    } else if ([objectString isEqualToString:@"refresh"]) {
        self.modelM.page_num = 0;
        
        [CA_HProgressHUD loading:self.view];
        CA_H_WeakSelf(self);
        [self.modelM reloadMore:^{
            CA_H_StrongSelf(self);
            if(![self hasMoreData]){// 无数据显示
                self.viewM.tableNode.view.mj_footer.state = MJRefreshStateNoMoreData;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewM.tableNode reloadData];
                [CA_HProgressHUD hideHud:self.view];
            });
        }];
    } else if ([objectString isEqualToString:@"user_sure"]) {
        NSArray *array = dictionary[@"user_ids"];
        if ([array isKindOfClass:[NSArray class]]) {
            if (array.count > 0) {
                NSMutableArray *user_ids = [NSMutableArray new];
                for (CA_HParticipantsModel *model in array) {
                    [user_ids addObject:model.user_id];
                }
                self.modelM.user_ids = user_ids;
                self.modelM.user_name = [array.firstObject chinese_name]?:@"";
            } else {
                self.modelM.user_ids = @[];
                self.modelM.user_name = @"";
            }
            
            self.modelM.page_num = 0;
            
            [CA_HProgressHUD loading:self.view];
            CA_H_WeakSelf(self);
            [self.modelM reloadMore:^{
                CA_H_StrongSelf(self);
                if(![self hasMoreData]){// 无数据显示
                    self.viewM.tableNode.view.mj_footer.state = MJRefreshStateNoMoreData;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.viewM.tableNode reloadData];
                    [CA_HProgressHUD hideHud:self.view];
                });
            }];
        }
    }
}



@end
