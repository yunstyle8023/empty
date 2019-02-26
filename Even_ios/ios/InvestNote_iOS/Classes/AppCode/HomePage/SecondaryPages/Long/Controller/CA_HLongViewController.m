//
//  CA_HLongViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/18.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HLongViewController.h"

#import "CA_MShareTool.h"
#import "CA_HNoteNetManager.h"

@interface CA_HLongViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HLongViewModel *viewModel;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bottomView;

@end


@implementation CA_HLongViewController


#pragma mark --- Action

- (void)onBottomButton:(UIButton *)sender {
    
    if (!self.image) {
        [self.viewModel.tableView layoutIfNeeded];
        if (self.viewModel.tableView.contentSize.height > 10000) {
            [CA_HProgressHUD showHudStr:@"生成长图失败，当前笔记内容过长"];
            return;
        }
    }
    
    if (sender.tag == 101) {
        UIImageWriteToSavedPhotosAlbum(self.viewModel.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }else if (sender.tag == 100) {
        [CA_MShareTool shareImageToFriend:nil
                                         :self.viewModel.image
                                         :self
                                         :nil];
    }
}

#pragma mark --- Lazy

- (CA_HLongViewModel *)viewModel{
    if (!_viewModel) {
        CA_HLongViewModel * viewModel = [CA_HLongViewModel new];
        
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = self.viewModel.scrollViewBlock((self.image != nil));
    }
    return _scrollView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = self.viewModel.bottomViewBlock(self, @selector(onBottomButton:));
    }
    return _bottomView;
}


#pragma mark --- LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated {
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.viewModel cancelImageRequest];
}

#pragma mark --- Custom

- (void)upView{
    
    self.title = self.viewModel.title;
    
    
    if (self.image) {
        [self.contentView addSubview:self.scrollView];
        self.scrollView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 110*CA_H_RATIO_WIDTH, 0));
        
        UIImageView *imageView = [self.viewModel imageViewWithImage:self.image type:self.type];
        self.scrollView.contentSize = self.viewModel.contentSize;
    } else {
        self.viewModel.tableView.frame = self.view.bounds;
        self.viewModel.tableView.delegate = self;
        self.viewModel.tableView.dataSource = self;
        [self.contentView addSubview:self.viewModel.tableView];
        
        [CA_HProgressHUD loading:self.view];
        if (self.model) {
            self.viewModel.model = self.model;
            [self.viewModel reloadCellsData:self.model];
            [self.viewModel.tableView reloadData];
            [self performSelector:@selector(hideHud) withObject:nil afterDelay:1];
        } else {
            CA_H_WeakSelf(self);
            [CA_HNoteNetManager queryNote:self.noteId callBack:^(CA_HNetModel *netModel) {
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.integerValue == 0) {
                        if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                            CA_H_StrongSelf(self);
                            self.viewModel.detailDic = netModel.data;
                        }
                        [self performSelector:@selector(hideHud) withObject:nil afterDelay:1];
                        return ;
                    }
                }
                [CA_HProgressHUD hideHud:self.view];
                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
                }
            } view:self.view];
        }
    }
    
    [self.contentView addSubview:self.bottomView];
    
    self.bottomView.sd_layout
    .heightIs(110*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
}

- (void)hideHud {
    [CA_HProgressHUD hideHud:self.view];
}

#pragma mark --- Delegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [CA_HProgressHUD showHudStr:CA_H_LAN(@"保存失败")];
    } else {
        [CA_HProgressHUD showHudStr:CA_H_LAN(@"保存成功")];
    }
}

#pragma mark --- Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewModel.model) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.viewModel.model.content.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel heightForRowAtIndexPath:indexPath model:self.viewModel.model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel heightForRowAtIndexPath:indexPath model:self.viewModel.model];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.viewModel cellForRowAtIndexPath:indexPath model:self.viewModel.model];
    return cell;
}



@end
