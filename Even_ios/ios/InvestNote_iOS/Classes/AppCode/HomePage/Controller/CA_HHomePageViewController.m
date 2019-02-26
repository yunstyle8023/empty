//
//  CA_HHomePageViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/21.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HHomePageViewController.h"

#import "CA_HHomePageViewModel.h"
#import "CA_HAddButton.h"

#import "CA_HScheduleScreeningVC.h"//日程筛选

@interface CA_HHomePageViewController ()

@property (nonatomic, strong) CA_HHomePageViewModel * viewModel;
@property (nonatomic, strong) CA_HAddButton *addButton;

@end

@implementation CA_HHomePageViewController

#pragma mark --- lazy

- (CA_HHomePageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_HHomePageViewModel new];
        
        CA_H_WeakSelf(self);
        _viewModel.getControllerBlock = ^CA_HHomePageViewController *{
            CA_H_StrongSelf(self);
            return self;
        };
        
        
        
        _viewModel.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            UIViewController * vc = [NSClassFromString(classStr) new];
            [vc setValuesForKeysWithDictionary:kvcDic];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _viewModel;
}


- (CA_HAddButton *)addButton {
    if (!_addButton) {
        CA_HAddButton *button = [CA_HAddButton newAdd];
        _addButton = button;
        
        button.noItemAnimate = YES;
        button.items =
        @[@{@"title":@"日程",@"image":[UIImage imageNamed:@"icons_add_schedule"]},
          @{@"title":@"待办",@"image":[UIImage imageNamed:@"missionicon"]},
          @{@"title":@"文件",@"image":[UIImage imageNamed:@"fileicon"]},
          @{@"title":@"笔记",@"image":[UIImage imageNamed:@"noteicon"]}];
        CA_H_WeakSelf(self);
        button.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(self);
            [self.addButton showShadowLayer];
        };
        button.onItemBlock = ^(NSInteger index, NSDictionary *itemDic, UIButton *item) {
            CA_H_StrongSelf(self);
            
            NSString *classStr = nil;
            switch (index) {
                case 0:
                    classStr = @"CA_HRNAddScheduleVC";
                    break;
                case 3:
                    classStr = @"CA_HAddNoteViewController";
                    break;
                case 1:
                    classStr = @"CA_HAddTodoViewController";
                    break;
                case 2:
                   classStr = @"CA_HAddFileViewController";
                    break;
                default:
                    break;
            }
            if (classStr) {
                UIViewController *vc = [NSClassFromString(classStr) new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    return _addButton;
}


#pragma mark --- lifeCircle

+ (void)reloadData {
    UITabBarController *tabBarC = (id)CA_H_MANAGER.mainWindow.rootViewController;
    tabBarC.selectedIndex = 0;
    UINavigationController *navC = tabBarC.childViewControllers.firstObject;
    CA_HHomePageViewController *homePageVC = navC.viewControllers.firstObject;
    
    [homePageVC.viewModel reloadData];
}

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)schedule_screening:(NSNotification*)notification{
    NSString *nameString = [notification name];
    NSString *objectString = [notification object];
    NSDictionary *dictionary = [notification userInfo];//为nil要有这行代码哦
    // 当你拿到这些数据的时候你可以去做一些操作
    
    
    CA_HScheduleScreeningVC *vc = [[CA_HScheduleScreeningVC alloc] initWithObjectString:objectString userIds:dictionary[@"user_ids"]];
    [vc setStart:dictionary[@"start"] end:dictionary[@"end"]];
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}

- (void)schedule_pushToAdd:(NSNotification*)notification{
    NSString *nameString = [notification name];
    NSString *objectString = [notification object];
    NSDictionary *dictionary = [notification userInfo];//为nil要有这行代码哦
    // 当你拿到这些数据的时候你可以去做一些操作
    
    UIViewController *vc = [NSClassFromString(@"CA_HRNAddScheduleVC") new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.viewModel hideMenu:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schedule_pushToAdd:)  name:@"schedule_pushToAdd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schedule_screening:)  name:@"schedule_screening" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"schedule_pushToAdd" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"schedule_screening" object:nil];
//    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
//                            offset:CGSizeMake(0, 3)
//                            radius:3
//                             color:CA_H_SHADOWCOLOR
//                           opacity:0.3];
}

- (void)upView{
    self.navigationItem.titleView = self.viewModel.titleView;
//    self.navigationItem.rightBarButtonItem = self.viewModel.rightNavBarButton;
    
    [self customScrollView];
    
    [self.view addSubview:self.addButton];
    self.addButton.sd_layout
    .widthIs(96*CA_H_RATIO_WIDTH)
    .heightIs(40*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.view, 25*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(self.view, 25*CA_H_RATIO_WIDTH);
    
    
//    CGFloat width = 96*CA_H_RATIO_WIDTH;
//    CGFloat height = 40*CA_H_RATIO_WIDTH;
//    CGRect frame = CGRectMake(CA_H_SCREEN_WIDTH-width-25*CA_H_RATIO_WIDTH, -height-25*CA_H_RATIO_WIDTH, width, height);
//    frame = [self.tabBarController.tabBar convertRect:frame toView:CA_H_MANAGER.mainWindow];
//    frame.origin.y -= 64+CA_H_MANAGER.xheight;
}


//- (void)ca_layoutContentView{
//    [super ca_layoutContentView];
//
//    [self customScrollView];
//}

// 滚动分页
//- (CGRect)buttonViewFrame {
//    return CGRectMake(99./2*CA_H_RATIO_WIDTH, 0, 92*3*CA_H_RATIO_WIDTH, 36*CA_H_RATIO_WIDTH);
//}
//- (CGRect)scrollViewFrame {
//    CGRect frame = self.view.bounds;
//    frame.origin.y = 36*CA_H_RATIO_WIDTH;
//    frame.size.height -= 36*CA_H_RATIO_WIDTH;
//    return frame;
//}

- (NSArray *)scrollViewTitles{
    return self.viewModel.titles;
}
- (UIView *)scrollViewContentViewWithItem:(NSInteger)item{
    switch (item) {
        case 0:
            return self.viewModel.scheduleList.view;
        case 3:
            return self.viewModel.noteTableView;
        case 1:
            return self.viewModel.todoView;
        case 2:
            return self.viewModel.fileTableView;
        default:
            return [UIView new];
    }
}


@end
