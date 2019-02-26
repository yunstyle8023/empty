
//
//  CA_MProjectContentScrollView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectContentScrollView.h"
#import "CA_MProjectTraceTableView.h"
#import "CA_HNoteListTebleView.h"
#import "CA_HTodoListTableView.h"
#import "CA_MProjectProgressView.h"
#import "CA_MProjectModel.h"
#import "CA_HTodoDetailModel.h"
#import "CA_HBrowseFoldersModel.h"
#import "CA_HBrowseFoldersViewModel.h"
#import "CA_HNullView.h"

@interface CA_MProjectContentScrollView ()

@property (nonatomic,strong) NSNumber *pId;

@property (nonatomic,strong) CA_MProjectTraceTableView *traceView;//项目追踪

/// 待办view
@property(nonatomic,strong)UIView* toDoView;
@property (nonatomic, strong) CA_HTodoListTableView *todoTableView;
/// 笔记view
@property(nonatomic,strong)UIView* noteView;
@property (nonatomic, strong) CA_HNoteListTebleView *noteTableView;
/// 文件view
@property(nonatomic,strong)UIView* fileView;

@property(nonatomic,strong) CA_HBrowseFoldersModel *foldersModel;

@property (nonatomic,strong) CA_MProjectProgressView *progressView;//进展
@end

@implementation CA_MProjectContentScrollView

-(instancetype)initWithFrame:(CGRect)frame pId:(NSNumber *)pid{
    if (self = [super initWithFrame:frame]) {
        
        self.pId = pid;
        
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(CA_H_SCREEN_WIDTH*5, 0);
        
        [self upView];
        
    }
    return self;
}

-(void)upView{

    [self addSubview:self.traceView];
    self.traceView.sd_layout
    .leftSpaceToView(self, 0)
    .topEqualToView(self)
    .widthIs(CA_H_SCREEN_WIDTH)
    .bottomEqualToView(self);
    
    [self addSubview:self.toDoView];
    self.toDoView.sd_layout
    .leftSpaceToView(self, CA_H_SCREEN_WIDTH*1)
    .topEqualToView(self)
    .widthIs(CA_H_SCREEN_WIDTH)
    .bottomEqualToView(self);
    
    [self addSubview:self.noteView];
    self.noteView.sd_layout
    .leftSpaceToView(self, CA_H_SCREEN_WIDTH*2)
    .topEqualToView(self)
    .widthIs(CA_H_SCREEN_WIDTH)
    .bottomEqualToView(self);
    
    [self addSubview:self.fileView];
    self.fileView.sd_layout
    .leftSpaceToView(self, CA_H_SCREEN_WIDTH*3)
    .topEqualToView(self)
    .widthIs(CA_H_SCREEN_WIDTH)
    .bottomEqualToView(self);
    
    [self addSubview:self.progressView];
    self.progressView.sd_layout
    .leftSpaceToView(self, CA_H_SCREEN_WIDTH*4)
    .topEqualToView(self)
    .widthIs(CA_H_SCREEN_WIDTH)
    .bottomEqualToView(self);
}

-(void)setModel:(CA_MProjectModel *)model{
    _model = model;
    
    
    if (!model) {
        return;
    }
    
    self.traceView.loadDataBlock(model.member_type_id,model.is_relation,model.project_id);
    
    self.progressView.project_id = model.project_id;
    self.progressView.member_type_id = model.member_type_id;
    
    UIView *todoButtonView = [self.toDoView viewWithTag:330];
    UIView *noteButtonView = [self.noteView viewWithTag:330];
    UIView *fileButtonView = [self.fileView viewWithTag:330];
    if (model.member_type_id.integerValue == 0) {
        todoButtonView.hidden = YES;
        noteButtonView.hidden = YES;
        fileButtonView.hidden = YES;
    } else {
        todoButtonView.hidden = NO;
        noteButtonView.hidden = NO;
        fileButtonView.hidden = NO;
    }
    
    self.foldersModel = [CA_HBrowseFoldersModel new];
    self.foldersModel.file_id = model.file_id;
    self.foldersModel.file_path = model.file_path;
    
    self.viewModel.model = self.foldersModel;
    [CA_HProgressHUD loading:self.viewModel.tableView];
    self.viewModel.listFileModel.loadDataBlock(self.foldersModel.file_path, nil);
    
}

#pragma mark - getter and setter

-(CA_MProjectTraceTableView *)traceView{
    if (!_traceView) {
        _traceView = [CA_MProjectTraceTableView newTableViewGrouped];
    }
    return _traceView;
}

-(UIView *)fileView{
    if (!_fileView) {
        UIView *view = [UIView new];
        _fileView = view;
        
        UIEdgeInsets edge = self.viewModel.tableView.contentInset;
        edge.bottom = 66*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight;
        self.viewModel.tableView.contentInset = edge;
        
        [view addSubview:self.viewModel.tableView];
        
        self.viewModel.tableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
        
        UIView *buttonView = [self customView:CA_H_LAN(@"添加文件") tag:102];
        buttonView.tag = 330;
        
        [view addSubview:buttonView];
        buttonView.sd_layout
        .widthIs(buttonView.width)
        .heightIs(buttonView.height)
        .rightSpaceToView(view, 13*CA_H_RATIO_WIDTH)
        .bottomSpaceToView(view, 13*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    }
    return _fileView;
}

- (CA_HBrowseFoldersViewModel *)viewModel{
    if (!_viewModel) {
        CA_HBrowseFoldersViewModel * viewModel = [CA_HBrowseFoldersViewModel new];
        _viewModel = viewModel;
        
        CA_H_WeakSelf(self);
        viewModel.getControllerBlock = ^CA_HBaseViewController *{
            CA_H_StrongSelf(self);
            if (self.pushBlock) {
                return self.pushBlock(nil, nil);
            }
            return nil;
        };
        
        viewModel.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            if (self.pushBlock) {
                self.pushBlock(classStr, kvcDic);
            }
        };
        
        //        CA_HBrowseFoldersModel *model = [CA_HBrowseFoldersModel new];
        //        model.file_id = self.fileId;
        //        model.file_path = self.filePath;
        //
        //        viewModel.model = model;
        
        [viewModel.tableView nullTitle:@"暂无文件" buttonTitle:nil top:125*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_file"];
        viewModel.tableView.searchType = CA_HFileSearchTypeNone;
        viewModel.tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self); self.viewModel.listFileModel.loadDataBlock(self.viewModel.model.file_path, nil);
        }];
        
        //        [CA_HProgressHUD loading:viewModel.tableView];
        //        viewModel.listFileModel.loadDataBlock(model.file_path, nil);
    }
    return _viewModel;
}

-(UIView *)toDoView{
    if (!_toDoView) {
        UIView * view = [UIView new];
        _toDoView = view;
        
        [view addSubview:self.todoTableView];
        [view addSubview:self.todoTableView.header];
        
        self.todoTableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(self.todoTableView.header.mj_h, 0, 0, 0));
        
        UIView *buttonView = [self customView:CA_H_LAN(@"添加待办") tag:100];
        buttonView.tag = 330;
        
        [view addSubview:buttonView];
        buttonView.sd_layout
        .widthIs(buttonView.width)
        .heightIs(buttonView.height)
        .rightSpaceToView(view, 13*CA_H_RATIO_WIDTH)
        .bottomSpaceToView(view, 13*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    }
    return _toDoView;
}

- (CA_HTodoListTableView *)todoTableView{
    if (!_todoTableView) {
        CA_HTodoListTableView *tableView = [CA_HTodoListTableView newWithProjectId:self.pId];
        _todoTableView = tableView;
        
        tableView.backgroundView = [CA_HNullView newTitle:@"有事就去办"
                                              buttonTitle:nil
                                                      top:70*CA_H_RATIO_WIDTH
                                                 onButton:nil
                                                imageName:@"empty_todo"];
        CA_H_WeakSelf(self);
        tableView.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            if (self.pushBlock) {
                self.pushBlock(classStr, kvcDic);
            }
        }; //跳转
    }
    return _todoTableView;
}

-(UIView *)noteView{
    if (!_noteView) {
        UIView * view = [UIView new];
        _noteView = view;
        
        [view addSubview:self.noteTableView];
        self.noteTableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
        
        UIView *buttonView = [self customView:CA_H_LAN(@"添加笔记") tag:101];
        buttonView.tag = 330;
        
        [view addSubview:buttonView];
        buttonView.sd_layout
        .widthIs(buttonView.width)
        .heightIs(buttonView.height)
        .rightSpaceToView(view, 13*CA_H_RATIO_WIDTH)
        .bottomSpaceToView(view, 13*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    }
    return _noteView;
}


- (CA_HNoteListTebleView *)noteTableView{
    if (!_noteTableView) {
        CA_HNoteListTebleView *tableView = [CA_HNoteListTebleView newWithProjectId:self.pId objectType:@"project"];
        _noteTableView = tableView;
        
        tableView.listNoteModel.noShow = YES;
        tableView.backgroundView = [CA_HNullView newTitle:@"记一下，好记性不如烂笔头"
                                              buttonTitle:nil
                                                      top:125*CA_H_RATIO_WIDTH
                                                 onButton:nil
                                                imageName:@"empty_note"];
        
        CA_H_WeakSelf(self);
        tableView.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            if (self.pushBlock) {
                self.pushBlock(classStr, kvcDic);
            }
        };
    }
    return _noteTableView;
}

-(CA_MProjectProgressView *)progressView{
    if (!_progressView) {
        _progressView = [CA_MProjectProgressView newTableViewGrouped];
    }
    return _progressView;
}

#pragma mark --- Action

- (void)onButton:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{
            CA_HTodoDetailModel *model = [CA_HTodoDetailModel new];
            model.object_id = self.model.project_id;
            model.object_name = self.model.project_name;
            self.pushBlock(@"CA_HAddTodoViewController", @{@"detailModel":model});
        }
            break;
        case 101:
            self.pushBlock(@"CA_HAddNoteViewController", @{@"projectModel":self.model});
            break;
        case 102:
            [self.viewModel addBarButton:nil];
            break;
        default:
            break;
    }
}

#pragma mark --- Custom

- (UIView *)customView:(NSString *)text tag:(NSInteger)tag {
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, 151*CA_H_RATIO_WIDTH, 66*CA_H_RATIO_WIDTH);
    
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor whiteColor];
    button.tag = tag;
    button.frame = CGRectMake(12*CA_H_RATIO_WIDTH, 12*CA_H_RATIO_WIDTH, 127*CA_H_RATIO_WIDTH, 42*CA_H_RATIO_WIDTH);
    button.layer.cornerRadius = 21*CA_H_RATIO_WIDTH;
    button.layer.masksToBounds = YES;
    [view addSubview:button];
    
    button.imageView.sd_resetLayout
    .widthIs(15*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(button.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(button.imageView.superview);
    
    button.titleLabel.sd_resetLayout
    .leftSpaceToView(button.imageView, 8*CA_H_RATIO_WIDTH)
    .centerYEqualToView(button.imageView.superview)
    .autoHeightRatio(0);
    button.titleLabel.numberOfLines = 1;
    [button.titleLabel setMaxNumberOfLinesToShow:1];
    [button.titleLabel setSingleLineAutoResizeWithMaxWidth:84*CA_H_RATIO_WIDTH];
    
    [button setImage:[UIImage imageNamed:@"add2"] forState:UIControlStateNormal];
    button.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
    [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *shadowColor = CA_H_SHADOWCOLOR;
    
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = button.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius = 21*CA_H_RATIO_WIDTH;
    subLayer.backgroundColor=[UIColor whiteColor].CGColor;//[shadowColor colorWithAlphaComponent:0.5].CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.5;//阴影透明度，默认0
    subLayer.shadowRadius = 6*CA_H_RATIO_WIDTH;//阴影半径，默认3
    
    [view.layer insertSublayer:subLayer below:button.layer];
    
    return view;
}

@end



















