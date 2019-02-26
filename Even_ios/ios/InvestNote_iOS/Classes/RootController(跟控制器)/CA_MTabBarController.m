//
//  CA_MTabBarController.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/11/20.
//  God bless me without no bugs.
//

#import "CA_MTabBarController.h"
#import "CA_MNavigationController.h"
#import "CA_MSettingType.h"
#import "CA_HAddFileViewController.h"
#import "CA_MChangeWorkSpace.h"
#import "CA_MSettingProjectVC.h"
#import "CA_MNavigationController.h"

#import "CA_HNoteDetailController.h"//笔记详情

#define CA_H_TABBAR_CLASSES @[  @"CA_HHomePageViewController",\
[CA_H_MANAGER isDefaulSetting]?([[CA_H_MANAGER defaultItemKey] isEqualToString:SettingType_Project] ? @"CA_MNewProjectVC" : @"CA_MNewPersonVC"):@"CA_MSettingProjectVC",\
                                @"CA_MDiscoverVC",\
                                @"CA_HMineViewController"]

#define CA_H_TABBAR_IMAGES @[   @"icon_home",\
                                @"icon_project",\
                                @"icon_discover",\
                                @"icon_me"]

#define CA_H_TABBAR_TITLES @[   @"首页",\
                                @"工作台",\
                                @"发现",\
                                @"我的"]


@interface CA_MTabBarController ()
<UITabBarControllerDelegate>

@property (nonatomic, strong) NSDictionary *shareDataDic;

@end

@implementation CA_MTabBarController

#pragma mark - LifeCycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//接收通知并相应的方法
- (void)shareDataNotification:(NSNotification *)notification {
    
    NSDictionary *params = notification.object;
    //    NSLog(@"通知过来的 - dic = %@",notification.object);
    
    NSString *open_type = params[@"open_type"];
    if ([open_type integerValue] == 1) {
        [self pushToNoteDetail:params];
    } else  if ([open_type integerValue] == 99) {
        if (params) {
            self.shareDataDic = params;
            if (GetToken.length) {
                [self pushToAddFile];
            }
        } else {
            [self pushToAddFile];
        }
    }
}

- (void)pushToNoteDetail:(NSDictionary *)params {
    
    if (GetToken.length&&params[@"note_id"]) {
        for (UINavigationController *nvc in self.childViewControllers) {
            if ([nvc.viewControllers.firstObject isKindOfClass:NSClassFromString(@"CA_HHomePageViewController")]) {

                [nvc popToRootViewControllerAnimated:NO];
                CA_HNoteDetailController *vc = [CA_HNoteDetailController new];
                vc.noteId = [params[@"note_id"] numberValue];
                [nvc pushViewController:vc animated:NO];
                
            } else {
                [nvc popToRootViewControllerAnimated:NO];
            }
        }
        self.selectedIndex = 0;
    }
}

- (void)pushToAddFile {
    if (self.shareDataDic) {
//        UITabBarController *tbc = (id)self.mainWindow.rootViewController;
        if (self.documentShare) {
            [self.documentShare dismissViewControllerAnimated:YES completion:nil];
            self.documentShare = nil;
        }
        
        for (UINavigationController *nvc in self.childViewControllers) {
            if ([nvc.viewControllers.firstObject isKindOfClass:NSClassFromString(@"CA_HHomePageViewController")]) {
                
                CA_HAddFileViewController *vc;
                if (nvc.viewControllers.count > 1
                    &&
                    [nvc.viewControllers[1] isKindOfClass:[CA_HAddFileViewController class]]) {
                    vc = nvc.viewControllers[1];
                    [nvc popToViewController:vc animated:NO];
                } else {
                    [nvc popToRootViewControllerAnimated:NO];
                    vc = [CA_HAddFileViewController new];
                    [nvc pushViewController:vc animated:NO];
                }
                vc.viewModel.addShareFileBlock(self.shareDataDic[@"fileName"], self.shareDataDic[@"data"]);
                
            } else {
                [nvc popToRootViewControllerAnimated:NO];
            }
        }
        self.selectedIndex = 0;
        self.shareDataDic = nil;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //创建通知
        [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(shareDataNotification:) name:CA_H_ShareDataNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self upTabBarConfig];
    [self addChileControllers];
    
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
#if CA_H_Online == 4
    if ([CA_H_UserDefaults boolForKey:@"CADebugging_switch"]) {
        CADebugging *debug = [CADebugging sharedManager];
        if (!debug.view.superview) {
            [debug show:CA_H_MANAGER.mainWindow];
        }
    }
#endif
    
}

#pragma mark - Private

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 1) {
        if ([((CA_MNavigationController*)viewController).topViewController isKindOfClass:[CA_MSettingProjectVC class]]) {
            //进行数据刷新
            [CA_MChangeWorkSpace changeWorkSpace:[CA_MSettingProjectVC new]];
        }
    }
}

/**
    更新自定义配置
 */
- (void)upTabBarConfig{
    
    [CA_HShadow dropShadowWithView:self.tabBar
                            offset:CGSizeMake(0, -3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    
}


/**
    添加子控制器
 */
- (void)addChileControllers{
    
    NSArray * classes = CA_H_TABBAR_CLASSES;
    NSArray * images = CA_H_TABBAR_IMAGES;
    NSArray * titles = CA_H_TABBAR_TITLES;
    
    
    for (NSUInteger i = 0; i < classes.count; i++) {
        [self addChildViewControllerStr:classes[i] title:titles[i] imageStr:images[i]];
    }
    
    UIView *point = CA_H_MANAGER.tabbarPoint;
    [self.tabBar addSubview:point];
    point.sd_layout
    .widthIs(6)
    .heightEqualToWidth()
    .topSpaceToView(self.tabBar, 5)
    .rightSpaceToView(self.tabBar, 35*CA_H_RATIO_WIDTH);
    point.sd_cornerRadiusFromWidthRatio = @(0.5);
}


/**
 批量添加控制器

 @param childStr 控制器类名
 @param title tabBar标题
 @param imageStr tabBar图标
 */
- (void)addChildViewControllerStr:(NSString *)childStr title:(NSString*)title imageStr:(NSString *)imageStr{
    
    CA_MNavigationController * nvc = [[CA_MNavigationController alloc] initWithRootViewController:[NSClassFromString(childStr) new]];
    nvc.tabBarItem.image = [[UIImage imageNamed:imageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nvc.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageStr]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nvc.tabBarItem.title = title;
    [nvc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:10], NSForegroundColorAttributeName:UIColorHex(0xB9BCCD)} forState:UIControlStateNormal];
    [nvc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:10], NSForegroundColorAttributeName:CA_H_TINTCOLOR} forState:UIControlStateSelected];
    
    [nvc.tabBarItem setImageInsets:UIEdgeInsetsMake(-2, 0, 2, 0)];
    [nvc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];

    [self addChildViewController:nvc];
}

@end
