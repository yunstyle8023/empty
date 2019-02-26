//
//  CA_MProjectTraceMutilTagsVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectTraceMutilTagsVC.h"
#import "CA_MProjectTraceMutilTagsViewModel.h"
#import "CA_MProjectTraceMutilTModel.h"
#import "CA_MProjectTraceMutilTagsView.h"

@interface CA_MProjectTraceMutilTagsVC ()

@property (nonatomic,strong) CA_MProjectTraceMutilTagsViewModel *viewModel;

@property (nonatomic,assign,getter=isFirstRequest) BOOL firstRequest;

@property (nonatomic,strong) NSMutableArray *requests;

@end

@implementation CA_MProjectTraceMutilTagsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstRequest = YES;
    self.viewModel.loadDataBlock();
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HFoundFactoryPattern hideShadowWithView:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)ca_layoutContentView {
    [super ca_layoutContentView];
    [self customScrollView];
}

-(CGRect)buttonViewFrame{
    if ([self.viewModel.tagNames count] <= 1) {
        CGRect rect = [super buttonViewFrame];
        rect.size.height = 0;
        return rect;
    }
    return [super buttonViewFrame];
}

- (NSArray *)scrollViewTitles {
    return self.viewModel.tagNames;
}

- (UIView *)scrollViewContentViewWithItem:(NSInteger)item {
    return self.viewModel.tagViews[item];
}

-(void)didSelectIndex:(NSInteger)currentIndex{
    if (![self.requests containsObject:@(self.currentIndex)]) {
        
        [self.requests addObject:@(self.currentIndex)];
        
        CA_MProjectTraceMutilTagsView *tagView = self.viewModel.tagViews[self.currentIndex];
        [tagView configView:self.project_id
                    tagName:self.viewModel.tagNames[self.currentIndex]
              traceCellType:TraceType_Normal];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.currentIndex = scrollView.contentOffset.x / CA_H_SCREEN_WIDTH;
    
    if (![self.requests containsObject:@(self.currentIndex)]) {
        
        [self.requests addObject:@(self.currentIndex)];
        
        CA_MProjectTraceMutilTagsView *tagView = self.viewModel.tagViews[self.currentIndex];
        [tagView configView:self.project_id
                    tagName:self.viewModel.tagNames[self.currentIndex]
              traceCellType:TraceType_Normal];
    }
}


#pragma mark - getter and setter

-(NSMutableArray *)requests{
    if (!_requests) {
        _requests = @[].mutableCopy;
    }
    return _requests;
}

-(CA_MProjectTraceMutilTagsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CA_MProjectTraceMutilTagsViewModel new];
        _viewModel.loadingView = CA_H_MANAGER.mainWindow;
        _viewModel.project_id = self.project_id;
        _viewModel.homePage = YES;
        CA_H_WeakSelf(self)
        _viewModel.finishedBlock = ^(BOOL isHasData){
            CA_H_StrongSelf(self)
            
            if (self.isFirstRequest) {
                self.firstRequest = NO;
                
                [self.requests addObject:@(0)];
                
                [self cleanScrollView];
                [self customScrollView];
                
            }
            
        };
    }
    return _viewModel;
}

@end













