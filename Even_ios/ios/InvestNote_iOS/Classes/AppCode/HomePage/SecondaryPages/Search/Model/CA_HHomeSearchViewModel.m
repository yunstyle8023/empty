//
//  CA_HHomeSearchViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/28.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HHomeSearchViewModel.h"

#import "CA_HAddMenuView.h"

#import "CA_HHomeSearchProjectCell.h"
#import "CA_HHomeSearchNoteCell.h"
#import "CA_HHomeSearchFileCell.h"
#import "CA_HHomeSearchFriendCell.h"

#import "CA_HListNoteModel.h" //笔记模型
#import "CA_HMoveListModel.h" //项目模型
#import "CA_HBrowseFoldersModel.h" //文件模型
#import "CA_HListHumanModel.h" //人脉模型

#import "CA_HBorwseFileManager.h" // 浏览文件

#import "CA_HNullView.h"

@interface CA_HHomeSearchViewModel () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *historyData;

@property (nonatomic, strong) CA_HListNoteModel *noteModel;
@property (nonatomic, strong) CA_HMoveListModel *projectModel;
@property (nonatomic, strong) CA_HListFileModel *fileModel;
@property (nonatomic, strong) CA_HListHumanModel *humanModel;

@property (nonatomic, strong) YYTextView *historyBackView;
@property (nonatomic, strong) UIView *noteBackView;
@property (nonatomic, strong) UIView *projectBackView;
@property (nonatomic, strong) UIView *fileBackView;
@property (nonatomic, strong) UIView *humanBackView;


@end

@implementation CA_HHomeSearchViewModel

#pragma mark --- Action

- (void)onCancal:(UIButton *)sender{
    if (_backBlock) {
        _backBlock();
    }
}

- (void)onMune:(UIButton *)sender{
    
    if (!sender.selected) {
        
        CA_HAddMenuView * menuView = [CA_HAddMenuView new];
        
        NSArray * data = @[/*@"全部",*/
                           @"笔记",
                           @"项目",
                           @"文件",
                           @"人脉"];
        
        CGRect rectOfNavigationbar = CGRectMake(0., 20., 0., 44.);
        
        if (_getControllerBlock) {
            rectOfNavigationbar = _getControllerBlock().navigationController.navigationBar.frame;
        }
        

        menuView.cellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
            
            cell.textLabel.text = CA_H_LAN(data[indexPath.row]);
            
            if ([cell.textLabel.text isEqualToString:sender.titleLabel.text]) {
                [cell.textLabel setTextColor:CA_H_TINTCOLOR];
            }else{
                [cell.textLabel setTextColor:CA_H_6GRAYCOLOR];
            }
            [cell.textLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.sd_resetLayout.spaceToSuperView(UIEdgeInsetsZero);
        };
        
        CGFloat y = rectOfNavigationbar.origin.y + rectOfNavigationbar.size.height - 6;
        menuView.tableLayoutBlock = ^(UITableView *tableView) {
            tableView.sd_resetLayout
            .widthIs(78*CA_H_RATIO_WIDTH)
            .heightIs(41*data.count-1)
            .topSpaceToView(tableView.superview, y)
            .leftSpaceToView(tableView.superview, 10*CA_H_RATIO_WIDTH);
        };
        
        CA_H_WeakSelf(self);
        CA_H_WeakSelf(menuView);
        menuView.clickBlock = ^(NSInteger item) {
            CA_H_StrongSelf(self);
            CA_H_StrongSelf(menuView);
            if (item >= 0) {
                self.ButtonTitle = CA_H_LAN(data[item]);
            }
            [self onMune:sender];
            [menuView hideMenu:YES];
        };
        
        menuView.frame = CA_H_MANAGER.mainWindow.bounds;
        
        menuView.ca_anchorPoint = CGPointMake(49*CA_H_RATIO_WIDTH/menuView.mj_w, y/menuView.mj_h);
        menuView.ca_transform = CATransform3DMakeTranslation(-(menuView.mj_w/2 - 49*CA_H_RATIO_WIDTH), -(menuView.mj_h/2 - y), 0);
        
        menuView.data = data;
        
        [CA_H_MANAGER.mainWindow addSubview:menuView];
        [menuView showMenu:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            sender.imageView.transform = CGAffineTransformIdentity;
        }];
    }
    
    sender.selected = !sender.selected;
}

#pragma mark --- Lazy

- (CA_HListHumanModel *)humanModel {
    if (!_humanModel) {
        CA_HListHumanModel *model = [CA_HListHumanModel new];
        _humanModel = model;
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(CA_H_RefreshType type) {
            if (type == CA_H_RefreshTypeFail) return;
            CA_H_StrongSelf(self);
            self.data = self.humanModel.data;
            self.FinishRequestType = type;
        };
    }
    return _humanModel;
}

- (CA_HListFileModel *)fileModel {
    if (!_fileModel) {
        CA_HListFileModel *model = [CA_HListFileModel new];
        _fileModel = model;
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(BOOL success, BOOL noMore) {
            if (!success) return;
            CA_H_StrongSelf(self);
            NSMutableArray *mut = [NSMutableArray new];
            if (self.fileModel.page_num.integerValue != 1) {
                [mut addObjectsFromArray:self.data];
            }
            [mut addObjectsFromArray:self.fileModel.data_list];
            self.data = mut;
            
            if (success) {
                if (noMore) {
                    self.FinishRequestType = CA_H_RefreshTypeNomore;
                } else {
                    self.FinishRequestType = CA_H_RefreshTypeDefine;
                }
            } else {
                self.FinishRequestType = CA_H_RefreshTypeFail;
            }
            
        };
    }
    return _fileModel;
}

- (CA_HMoveListModel *)projectModel {
    if (!_projectModel) {
        CA_HMoveListModel *model = [CA_HMoveListModel new];
        _projectModel = model;
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(CA_H_RefreshType type) {
            if (type == CA_H_RefreshTypeFail) return;
            CA_H_StrongSelf(self);
            self.data = self.projectModel.data;
            self.FinishRequestType = type;
        };
    }
    return _projectModel;
}

- (CA_HListNoteModel *)noteModel {
    if (!_noteModel) {
        CA_HListNoteModel *model = [CA_HListNoteModel new];
        _noteModel = model;
        
        model.noShow = YES;
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(CA_H_RefreshType type) {
            if (type == CA_H_RefreshTypeFail) return;
            CA_H_StrongSelf(self);
            self.data = self.noteModel.allData;
            self.FinishRequestType = type;
        };
    }
    return _noteModel;
}

- (UIBarButtonItem *)rightBarButtonItem{
    if (!_rightBarButtonItem) {
        
        UIButton * rightBtn = [UIButton new];
        rightBtn.frame = CGRectMake(0, 0, 32, 44);
        
        [rightBtn setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
        [rightBtn setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
        [rightBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        [rightBtn addTarget:self action:@selector(onCancal:) forControlEvents:UIControlEventTouchUpInside];
        
        rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        rightBtn.titleLabel.sd_resetLayout
        .centerYEqualToView(rightBtn)
        .rightEqualToView(rightBtn)
        .autoHeightRatio(0);
        
        _rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    }
    return _rightBarButtonItem;
}

- (UITextField *)titleView{
    if (!_titleView) {
        _titleView = [UITextField new];
        _titleView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 20);
        
        _titleView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleView.textColor = CA_H_4BLACKCOLOR;
        _titleView.placeholder = CA_H_LAN(@"搜索");
        _titleView.returnKeyType = UIReturnKeySearch;
        _titleView.clearButtonMode = UITextFieldViewModeAlways;
        
        UIButton * leftBtn = [UIButton new];
        leftBtn.frame = CGRectMake(0, 0, 70, 44);
        
        [leftBtn setImage:[UIImage imageNamed:@"shape3"] forState:UIControlStateNormal];
        [leftBtn setTitle:CA_H_LAN(@"笔记") forState:UIControlStateNormal];
        [leftBtn setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
        [leftBtn addTarget:self action:@selector(onMune:) forControlEvents:UIControlEventTouchUpInside];
        
//        CGSize imageSize = leftBtn.imageView.image.size;
//        CGSize titleSize = [leftBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: leftBtn.titleLabel.font}];
//        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0., -(imageSize.width+titleSize.width/2), 0., 0.);
//        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0., (imageSize.width*2+titleSize.width), 0., 0);
        
        leftBtn.titleLabel.sd_resetLayout
        .centerYEqualToView(leftBtn)
        .leftSpaceToView(leftBtn, 15)
        .heightRatioToView(leftBtn, 1)
        .widthIs(30);
        
        leftBtn.imageView.sd_resetLayout
        .widthIs(12)
        .heightEqualToWidth()
        .leftSpaceToView(leftBtn.titleLabel, 5)
        .centerYEqualToView(leftBtn);
        
        
        _titleView.leftView = leftBtn;
        _titleView.leftViewMode = UITextFieldViewModeAlways;
        
        [_titleView addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        _titleView.delegate = self;
        
    }
    return _titleView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = self.historyBackView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 0, CA_H_MANAGER.xheight, 0);
        
        [_tableView registerClass:[CA_HHomeSearchProjectCell class] forCellReuseIdentifier:CA_H_LAN(@"项目")];
        [_tableView registerClass:[CA_HHomeSearchNoteCell class] forCellReuseIdentifier:CA_H_LAN(@"笔记")];
        [_tableView registerClass:[CA_HHomeSearchFileCell class] forCellReuseIdentifier:CA_H_LAN(@"文件")];
        [_tableView registerClass:[CA_HHomeSearchFriendCell class] forCellReuseIdentifier:CA_H_LAN(@"人脉")];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        self.historyData = [CA_H_UserDefaults objectForKey:CA_H_HistorySearch];
        
        CA_H_WeakSelf(self);
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            UIButton *leftBtn = (id)self.titleView.leftView;
            NSString *type = leftBtn.titleLabel.text;
            if ([type isEqualToString:CA_H_LAN(@"笔记")]) {
                self.noteModel.loadMoreBlock(self.titleView.text);
            } else if ([type isEqualToString:CA_H_LAN(@"项目")]) {
                self.projectModel.loadMoreBlock(self.titleView.text, NO);
            } else if ([type isEqualToString:CA_H_LAN(@"文件")]) {
                [self.fileModel loadMore];
            }
        }];
    }
    return _tableView;
}

- (void)setHistoryData:(NSArray *)historyData{
    _historyData = historyData;
    
    if (historyData) {
        YYTextView * textView = self.historyBackView;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:@"最近搜索\n"];
        text.font = CA_H_FONT_PFSC_Regular(14);
        text.color = CA_H_9GRAYCOLOR;
        
        for (NSString * tag in historyData) {
            
            NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
            [tagText insertString:@"  " atIndex:0];
            [tagText appendString:@"  "];
            tagText.font = CA_H_FONT_PFSC_Regular(14);
            tagText.color = CA_H_6GRAYCOLOR;
            
            [tagText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.rangeOfAll];
            
            YYTextBorder *border = [YYTextBorder new];
            border.fillColor = CA_H_F8COLOR;
            border.cornerRadius = 4*CA_H_RATIO_WIDTH; // a huge value
            border.lineJoin = kCGLineJoinBevel;
            
            border.insets = UIEdgeInsetsMake(-4*CA_H_RATIO_WIDTH, -10*CA_H_RATIO_WIDTH, -4*CA_H_RATIO_WIDTH, -10*CA_H_RATIO_WIDTH);
            [tagText setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
            
            YYTextHighlight *highlight = [YYTextHighlight new];
            CA_H_WeakSelf(self);
            highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                CA_H_StrongSelf(self);
                NSLog(@"%@", tag);
                self.titleView.text = tag;
                // 搜索
                [self textFieldShouldReturn:self.titleView];
            };
            [tagText setTextHighlight:highlight range:tagText.rangeOfAll];
            
            
            [text appendAttributedString:tagText];
            
            CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            if (rect.size.width > CA_H_SCREEN_WIDTH - 60*CA_H_RATIO_WIDTH) {
                [text insertString:@"\n" atIndex:text.length - tagText.length];
                [text appendString:@"  "];
            }else{
                [text appendString:@"  "];
                CGRect newRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                if (newRect.size.width > CA_H_SCREEN_WIDTH - 60*CA_H_RATIO_WIDTH) {
                    [text removeAttributesInRange:NSMakeRange(text.length-2, 2)];
                }
            }
           
        }
        
        text.lineSpacing = 18*CA_H_RATIO_WIDTH;
        text.lineBreakMode = NSLineBreakByWordWrapping;
        
        textView.attributedText = text;
        
    }
}

#pragma mark --- Custom

- (void)setFinishRequestType:(CA_H_RefreshType)type {
    switch (type) {
        case CA_H_RefreshTypeNomore:
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            break;
        case CA_H_RefreshTypeFirst:
            [self.tableView.mj_footer resetNoMoreData];
        default:
            [self.tableView.mj_footer endRefreshing];
            break;
    }
    [self.tableView.mj_header endRefreshing];
    
    CA_H_WeakSelf(self);
    CA_H_DISPATCH_MAIN_THREAD(^{
        CA_H_StrongSelf(self);
        [self.tableView reloadData];
    });
}

- (void)setButtonTitle:(NSString *)text {
    UIButton *leftBtn = (id)self.titleView.leftView;
    [leftBtn setTitle:text forState:UIControlStateNormal];
    [self.noteModel.dataTask cancel];
    [self.projectModel.dataTask cancel];
    [self.humanModel.dataTask cancel];
    [self.data removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
}

- (void)loadData {
    if (!self.titleView.text.length) {
        [self.data removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    UIButton *leftBtn = (id)self.titleView.leftView;
    NSString *type = leftBtn.titleLabel.text;
    if ([type isEqualToString:CA_H_LAN(@"笔记")]) {
        self.noteModel.page_num = @(0);
        self.noteModel.loadMoreBlock(self.titleView.text);
    } else if ([type isEqualToString:CA_H_LAN(@"项目")]) {
        self.projectModel.page_num = @(0);
        self.projectModel.loadMoreBlock(self.titleView.text, NO);
    } else if ([type isEqualToString:CA_H_LAN(@"文件")]) {
        self.fileModel.loadDataBlock(@[], self.titleView.text);
    } else if ([type isEqualToString:CA_H_LAN(@"人脉")]) {
        self.humanModel.loadMoreBlock(self.titleView.text);
    }
}

- (UIView *)tableBackView{
    
    if (!self.titleView.text.length) {
        return self.historyBackView;
    }
    UIButton *leftBtn = (id)self.titleView.leftView;
    NSString *type = leftBtn.titleLabel.text;
    if ([type isEqualToString:CA_H_LAN(@"笔记")]) {
        return self.noteBackView;
    } else if ([type isEqualToString:CA_H_LAN(@"项目")]) {
        return self.projectBackView;
    } else if ([type isEqualToString:CA_H_LAN(@"文件")]) {
        return self.fileBackView;
    } else if ([type isEqualToString:CA_H_LAN(@"人脉")]) {
        return self.humanBackView;
    }
    return nil;
}

- (YYTextView *)historyBackView {
    if (!_historyBackView) {
        YYTextView *textView = [YYTextView new];
        _historyBackView = textView;
        
        textView.editable = NO;
        textView.selectable = NO;
        
        textView.textContainerInset = UIEdgeInsetsMake(20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:@"最近搜索"];
        text.font = CA_H_FONT_PFSC_Regular(14);
        text.color = CA_H_9GRAYCOLOR;
        textView.attributedText = text;
    }
    return _historyBackView;
}

- (UIView *)noteBackView {
    if (!_noteBackView) {
        _noteBackView = [CA_HNullView newTitle:@"没有搜索到相关笔记" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:nil/*@"empty_search"*/];
    }
    return _noteBackView;
}

- (UIView *)projectBackView {
    if (!_projectBackView) {
        _projectBackView = [CA_HNullView newTitle:@"没有搜索到相关项目" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:nil/*@"empty_search"*/];
    }
    return _projectBackView;
}

- (UIView *)fileBackView {
    if (!_fileBackView) {
        _fileBackView = [CA_HNullView newTitle:@"没有搜索到相关文件" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:nil/*@"empty_search"*/];
    }
    return _fileBackView;
}

- (UIView *)humanBackView {
    if (!_humanBackView) {
        _humanBackView = [CA_HNullView newTitle:@"没有搜索到相关人脉" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:nil/*@"empty_search"*/];
    }
    return _humanBackView;
}


#pragma mark --- Table

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    tableView.backgroundView.hidden = (_data.count>0);
//    return self.data.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.data.count>0) {
        tableView.backgroundView.hidden = YES;
        tableView.mj_footer.hidden = NO;
    } else {
        tableView.backgroundView = [self tableBackView];
        tableView.backgroundView.hidden = NO;
        tableView.mj_footer.hidden = YES;
    }
    
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIButton *leftBtn = (id)self.titleView.leftView;
    NSString *type = leftBtn.titleLabel.text;
    if ([type isEqualToString:@"笔记"]) {
        return 90*CA_H_RATIO_WIDTH;
    }else{
        return 70*CA_H_RATIO_WIDTH;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (self.data.count > 1) {
//        return 50*CA_H_RATIO_WIDTH;
//    }else{
//        return 0;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    UIButton * leftBtn = (id)self.titleView.leftView;
    if ([leftBtn.titleLabel.text isEqualToString:CA_H_LAN(@"全部")]) {
        return 50*CA_H_RATIO_WIDTH;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString * identifier = @"header";
    
    UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identifier];
        header.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel * label = [UILabel new];
        label.tag = 123;
        label.font = CA_H_FONT_PFSC_Regular(14);
        label.textColor = CA_H_9GRAYCOLOR;
        
        [header.contentView addSubview:label];
        
        label.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
    }
    
    UILabel * label = [header.contentView viewWithTag:123];
    
    label.text = CA_H_LAN([self.data[section] allKeys].firstObject);
    
        
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSString * identifier = @"footer";
    
    UITableViewHeaderFooterView * footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footer) {
        footer = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identifier];
        
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        
        CA_H_WeakSelf(self);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            CA_H_StrongSelf(self)
            if (self.pushBlock) {
                self.pushBlock(@"CA_HHomeSearchNextViewController", @{@"dataDic":self.data[[sender view].superview.tag - 100]});
            }
        }];
        [view addGestureRecognizer:tap];
        
        [footer.contentView addSubview:view];
        
        view.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 10*CA_H_RATIO_WIDTH, 0));
        
        UIImageView * imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"search_icon"];

        UILabel * label = [UILabel new];
        label.font = CA_H_FONT_PFSC_Regular(14);
        label.textColor = CA_H_9GRAYCOLOR;
        label.text = CA_H_LAN(@"查看更多项目");
        
        UIImageView * shape = [UIImageView new];
        shape.image = [UIImage imageNamed:@"shape5"];
        
        [view addSubview:imageView];
        [view addSubview:label];
        [view addSubview:shape];
        
        imageView.sd_layout
        .widthIs(15*CA_H_RATIO_WIDTH)
        .heightIs(14*CA_H_RATIO_WIDTH)
        .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH)
        .centerYEqualToView(view);
        
        label.sd_layout
        .leftSpaceToView(imageView, 6*CA_H_RATIO_WIDTH)
        .centerYEqualToView(view)
        .autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:300*CA_H_RATIO_WIDTH];
        [label setMaxNumberOfLinesToShow:1];
        
        shape.sd_layout
        .widthIs(14*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(view)
        .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH);
        
    }
    
    footer.contentView.tag = 100 + section;
    
    
    return footer;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIButton *leftBtn = (id)self.titleView.leftView;
    NSString *type = leftBtn.titleLabel.text;
    
    CA_HBaseTableCell * cell = [tableView dequeueReusableCellWithIdentifier:type];
    cell.model = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIButton *leftBtn = (id)self.titleView.leftView;
    NSString *type = leftBtn.titleLabel.text;
    if ([type isEqualToString:CA_H_LAN(@"笔记")]) {
        CA_HListNoteContentModel *model = self.data[indexPath.row];
        if (model.note_id&&_pushBlock) {
            _pushBlock(@"CA_HNoteDetailController", @{@"noteId":model.note_id});
        }
    } else if ([type isEqualToString:CA_H_LAN(@"项目")]) {
        CA_MProjectModel *model = self.data[indexPath.row];
        if (model&&_pushBlock) {
            CA_MProjectModel *newModel = model.modelCopy;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[newModel.project_name dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            newModel.project_name = attrStr.string;
            CA_H_WeakSelf(self);
            _pushBlock(@"CA_MNewProjectContentVC", @{@"pId":newModel.project_id,@"refreshBlock":^(NSNumber*ids){
                CA_H_StrongSelf(self);
                for (CA_MProjectModel* model in self.projectModel.data) {
                    if (ids == model.project_id) {
                        [self.projectModel.data removeObject:model];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }});
        }
    } else if ([type isEqualToString:CA_H_LAN(@"文件")]) {
        CA_HBrowseFoldersModel *model = self.data[indexPath.row];
        if ([model.file_type isEqualToString:@"directory"]) {
            if (_pushBlock) {
                _pushBlock(@"CA_HBrowseFoldersViewController", @{@"model":model});
            }
        } else {
            if (_getControllerBlock) {
                NSString *fileName = model.file_path.lastObject;
                [CA_HBorwseFileManager browseCachesFile:model.file_id fileName:fileName fileUrl:model.storage_path controller:_getControllerBlock()];
            }
        }
    } else if ([type isEqualToString:CA_H_LAN(@"人脉")]) {
        CA_MPersonModel* model = self.data[indexPath.row];
        if (model&&_pushBlock) {
            CA_MPersonModel *newModel = model.modelCopy;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[newModel.chinese_name dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            newModel.chinese_name = attrStr.string;
            CA_H_WeakSelf(self);
            _pushBlock(@"CA_MPersonDetailVC", @{@"humanID":newModel.human_id,@"fileID":model.file_id,@"filePath":model.file_path});
        }
    }
}


#pragma mark --- TextField

- (void)textFieldEditingChanged:(UITextField *)textField {
    if (textField.markedTextRange == nil) {
        [self loadData];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = textField.text;
    if (text.length > 1) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:[CA_H_UserDefaults objectForKey:CA_H_HistorySearch]];
        
        NSUInteger index = [mutArray indexOfObject:text];
        if (index != NSNotFound) {
            [mutArray removeObjectAtIndex:index];
        }
        [mutArray insertObject:text atIndex:0];
        while (mutArray.count > 10) {
            [mutArray removeLastObject];
        }
        [CA_H_UserDefaults setObject:mutArray forKey:CA_H_HistorySearch];
        self.historyData = mutArray;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.tableView scrollToTop];
    [self loadData];
    [self textFieldDidEndEditing:textField];
    [textField resignFirstResponder];
    return NO;
}

@end
