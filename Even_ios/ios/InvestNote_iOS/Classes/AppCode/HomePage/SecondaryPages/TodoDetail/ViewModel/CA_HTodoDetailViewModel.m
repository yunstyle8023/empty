//
//  CA_HTodoDetailViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HTodoDetailViewModel.h"

#import "CA_HAddTodoCell.h"
#import "CA_HPeopleCell.h"
#import "CA_HRemarkCell.h"
#import "CA_HFileCell.h"

#import "CA_HTodoNetModel.h"

#import "CA_HBorwseFileManager.h"

@interface CA_HTodoDetailViewModel () <UITableViewDelegate, UITableViewDataSource, YYTextViewDelegate>

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *middleView;

@property (nonatomic, strong) UILabel *replyLabel;

@end

@implementation CA_HTodoDetailViewModel

#pragma mark --- Action

- (void (^)(NSNumber *, NSString *, NSString *, UIViewController *))borwseFileBlock {
    if (!_borwseFileBlock) {
        _borwseFileBlock = ^ (NSNumber *fileId, NSString *fileName, NSString *fileUrl, UIViewController *vc) {
            [CA_HBorwseFileManager browseCachesFile:fileId fileName:fileName fileUrl:fileUrl controller:vc];
        };
    }
    return _borwseFileBlock;
}

- (void)setPeople:(NSArray *)people {
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    for (CA_HParticipantsModel *model in people) {
        
        if (![model isKindOfClass:[CA_HParticipantsModel class]]) {
            continue;
        }
        
        NSMutableAttributedString *tagText = [NSMutableAttributedString new];
        
        [tagText appendString:@"@"];
        [tagText appendString:model.chinese_name];
        tagText.font = CA_H_FONT_PFSC_Regular(14);
        tagText.color = CA_H_TINTCOLOR;//CA_H_4BLACKCOLOR;
        
        NSMutableAttributedString *idText = [NSMutableAttributedString new];
        [idText appendString:@"0/0"];
        [idText appendString:model.user_id.stringValue];
        [idText appendString:@"0/0"];
        idText.font = CA_H_FONT_PFSC_Regular(0);
        idText.color = [UIColor clearColor];
        
        NSMutableAttributedString *spaceText = [[NSMutableAttributedString alloc] initWithString:@" "];
        spaceText.font = CA_H_FONT_PFSC_Regular(14);
        spaceText.color = CA_H_4BLACKCOLOR;
        
        [tagText appendAttributedString:idText];
        [tagText appendAttributedString:spaceText];
        
        [tagText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.rangeOfAll];
        
        [text appendAttributedString:tagText];
    }
    
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    
    NSRange selectedRange = self.textView.selectedRange;
    [contentText replaceCharactersInRange:selectedRange withAttributedString:text];
    
    selectedRange.location += text.length;
    selectedRange.length = 0;

    self.textView.delegate = nil;
    self.textView.attributedText = contentText;
    [self textViewDidChange:self.textView];
    self.textView.selectedRange = selectedRange;
    self.textView.delegate = self;
}

- (void)onButton:(UIButton *)sender {
    
    CA_H_WeakSelf(self);
    [CA_HTodoNetModel updateTodoStatus:self.model.todo_id objectId:self.model.object_id status:self.model.status callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    CA_H_StrongSelf(self);
                    [CA_H_NotificationCenter postNotificationName:CA_H_RefreshTodoListNotification object:@"ready"];
                    [CA_H_NotificationCenter postNotificationName:CA_H_RefreshTodoListNotification object:@"finish"];
                    
                    self.DetailDic = netModel.data;
                }
            }
        }
    }];
    
}

- (void)onKeyboardView:(UIButton *)sender {
    if (sender.tag == 100) {
        if (self.onKeyboardBlock) {
            self.onKeyboardBlock(NO);
        }
    } else {
        [self.textView resignFirstResponder];
        
        if (self.textView.text.length <= 0) {
            [CA_HProgressHUD showHudStr:@"系统错误!"];
            return;
        }
        NSMutableArray *noticeUserIdList = [NSMutableArray new];
        NSMutableString *conmmentContent = [NSMutableString new];
        
        NSArray<NSString *> *array = [self.textView.text componentsSeparatedByString:@"0/0"];
        
        for (NSInteger i=0; i<array.count; i++) {
            if (i%2) {
                [noticeUserIdList addObject:array[i].numberValue];
            } else {
                [conmmentContent appendString:array[i]];
            }
        }

        CA_H_WeakSelf(self);
        [CA_HTodoNetModel addTodoComment:self.model.todo_id objectId:self.model.object_id conmmentContent:conmmentContent noticeUserIdList:noticeUserIdList callBack:^(CA_HNetModel *netModel) {
            CA_H_StrongSelf(self);
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                        if (!self.model.comment_list) {
                            self.model.comment_list = [NSMutableArray new];
                        }
                        [self.model.comment_list addObject:[CA_HTodoDetailCommentModel modelWithDictionary:netModel.data]];
                        self.textView.text = nil;
                        CA_H_DISPATCH_MAIN_THREAD(^{
                            [self.tableView insertRow:self.model.comment_list.count-1 inSection:1 withRowAnimation:UITableViewRowAnimationLeft];
//                            [self.tableView scrollToBottom];
                        });
                    }
                    return ;
                }
            }
            if (netModel.error.code != -999) {
        [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
    }
        }];
    }
}

#pragma mark --- Lazy

- (UILabel *)replyLabel {
    if (!_replyLabel) {
        UILabel *label = [UILabel new];
        _replyLabel = label;
        
        label.text = CA_H_LAN(@"评论");
        label.textColor = CA_H_4BLACKCOLOR;
        label.font = CA_H_FONT_PFSC_Regular(18);
        label.numberOfLines = 1;
        label.hidden = YES;
    }
    return _replyLabel;
}

- (void (^)(NSNumber *, NSNumber *, UIView *))loadDetailBlock {
    if (!_loadDetailBlock) {
        CA_H_WeakSelf(self);
        _loadDetailBlock = ^ (NSNumber *todoId, NSNumber *objectId, UIView *view) {
            CA_H_StrongSelf(self);
            [self queryTodo:todoId objectId:objectId view:view];
        };
    }
    return _loadDetailBlock;
}

- (YYTextView *)textView {
    if (!_textView) {
        YYTextView *textView = [YYTextView new];
        _textView = textView;
        
        textView.bounces = NO;
        textView.font = CA_H_FONT_PFSC_Regular(14);
        textView.textColor = CA_H_4BLACKCOLOR;
        textView.placeholderFont = CA_H_FONT_PFSC_Regular(14);
        textView.placeholderTextColor = CA_H_9GRAYCOLOR;
        textView.placeholderText = CA_H_LAN(@"写下你的见解...");
        
        textView.inputAccessoryView = self.keyboardView;
        
        textView.delegate = self;
    }
    return _textView;
}

- (void (^)(BOOL))onReplyBlock {
    if (!_onReplyBlock) {
        CA_H_WeakSelf(self);
        _onReplyBlock = ^ (BOOL isAuto) {
            CA_H_StrongSelf(self);
            
            if (isAuto || self.backView.bottom > self.backView.superview.height) {
                
                if (self.textView.isFirstResponder) {
                    return;
                }
                
                [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
                
                if (!self.textView.text.length) {
                    self.backView.height = 56*CA_H_RATIO_WIDTH;
                }
                self.backView.bottom = self.middleView.height;
                self.tableView.height = self.backView.top;
                self.shadowView.bottom = self.backView.top;
                [self.textView layoutSubviews];
                
                CGFloat offsetY = self.tableView.contentOffset.y;
                [self.textView becomeFirstResponder];
                CGRect rect = [self.tableView rectForHeaderInSection:1];
                if (rect.origin.y-10*CA_H_RATIO_WIDTH > offsetY) {
                    [self.tableView setContentOffset:CGPointMake(0, MIN((rect.origin.y-10*CA_H_RATIO_WIDTH), MAX((self.tableView.contentSize.height-self.tableView.height), 0))) animated:YES];
                }
                
                
//                CGRect rect = [self.tableView rectForHeaderInSection:1];
//                if (rect.origin.y-10*CA_H_RATIO_WIDTH > self.tableView.contentOffset.y) {
//                    self.isPlay = YES;
//                    [UIView animateWithDuration:0.25 animations:^{
//                        self.tableView.contentOffset = CGPointMake(0, MIN((rect.origin.y-10*CA_H_RATIO_WIDTH), MAX((self.tableView.contentSize.height-self.tableView.height), 0)));
//                    } completion:^(BOOL finished) {
//                        self.isPlay = NO;
//                    }];
//                }
                
            } else {
                self.people = nil;
                self.textView.text = nil;
                self.backView.height = 56*CA_H_RATIO_WIDTH;
                self.backView.top = self.middleView.height;
                self.tableView.height = self.backView.top;
                self.shadowView.bottom = self.backView.top;
            }
        };
    }
    return _onReplyBlock;
}

// titleView
- (UIButton *)titleButton {
    if (!_titleButton) {
        UIButton *button = [UIButton new];
        _titleButton = button;
        
        [button setBackgroundImage:[UIImage imageNamed:@"unfinished"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"finished"] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        _titleLabel = label;
        
        label.textColor = CA_H_4BLACKCOLOR;
        label.font = CA_H_FONT_PFSC_Medium(18);
        label.numberOfLines = 1;
        
//        UIView *line = [UIView new];
//        line.backgroundColor = CA_H_9GRAYCOLOR;
//        line.hidden = YES;
//
//        [label addSubview:line];
//        line.sd_layout
//        .heightIs(1)
//        .leftEqualToView(label)
//        .rightEqualToView(label)
//        .centerYEqualToView(label);

    }
    return _titleLabel;
}

- (UIView *(^)(void))titleViewBlock {
    if (!_titleViewBlock) {
        CA_H_WeakSelf(self);
        _titleViewBlock = ^ {
            CA_H_StrongSelf(self);
            
            UIView *view = [UIView new];
            
            view.backgroundColor = [UIColor whiteColor];
            CA_H_WeakSelf(view);
            view.didFinishAutoLayoutBlock = ^(CGRect frame) {
                CA_H_StrongSelf(view);
                [CA_HShadow dropShadowWithView:view
                                        offset:CGSizeMake(0, 3)
                                        radius:3
                                         color:CA_H_SHADOWCOLOR
                                       opacity:0.3];
            };
            
            
            [view addSubview:self.titleButton];
            self.titleButton.sd_layout
            .widthIs(26*CA_H_RATIO_WIDTH)
            .heightEqualToWidth()
            .topSpaceToView(view, 5*CA_H_RATIO_WIDTH)
            .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH);
            
            [view addSubview:self.titleLabel];
            self.titleLabel.sd_layout
            .leftSpaceToView(view, 54*CA_H_RATIO_WIDTH)
            .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH)
            .topEqualToView(self.titleButton)
            .autoHeightRatio(0);
//            .heightIs(25*CA_H_RATIO_WIDTH)
//            .leftSpaceToView(view, 54*CA_H_RATIO_WIDTH)
//            .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH)
//            .centerYEqualToView(self.titleButton);
            
            [view setupAutoHeightWithBottomView:self.titleLabel bottomMargin:15*CA_H_RATIO_WIDTH];
            
            return view;
        };
    }
    return _titleViewBlock;
}

- (void (^)(NSString *, BOOL))setTitleBlock {
    if (!_setTitleBlock) {
        CA_H_WeakSelf(self);
        _setTitleBlock = ^ (NSString *title, BOOL isDone) {
            CA_H_StrongSelf(self);
            
            self.titleLabel.text = title;
            self.titleButton.selected = isDone;
            
            if (isDone) {
                
                CGFloat height = [title heightForFont:self.titleLabel.font width:CA_H_SCREEN_WIDTH-74*CA_H_RATIO_WIDTH];
                
                NSInteger numberOfLines = (NSUInteger)(height / self.titleLabel.font.lineHeight);
                
                for (NSInteger i=0; i<numberOfLines; i++) {
                    UIView *line = [UIView new];
                    line.backgroundColor = CA_H_9GRAYCOLOR;
                    
                    [self.titleLabel addSubview:line];
                    line.sd_layout
                    .heightIs(1)
                    .leftEqualToView(self.titleLabel)
                    .rightEqualToView(self.titleLabel)
                    .topSpaceToView(self.titleLabel, (0.5+i)*self.titleLabel.font.lineHeight);
                }
            } else {
                [self.titleLabel removeAllSubviews];
            }
//            UIView *line = self.titleLabel.subviews.firstObject;
//            line.hidden = !isDone;
            self.titleLabel.textColor = isDone?CA_H_9GRAYCOLOR:CA_H_4BLACKCOLOR;
            [self.tableView reloadData];
        };
    }
    return _setTitleBlock;
}


// bottom
- (UIView *(^)(void))bottomViewBlock {
    if (!_bottomViewBlock) {
        CA_H_WeakSelf(self);
        _bottomViewBlock = ^UIView * {
            CA_H_StrongSelf(self);
            
            UIView *view = [UIView new];
            self.bottomView = view;
            
            view.backgroundColor = CA_H_FCCOLOR;
            
            UIView *buttonView = [UIView new];
            [view addSubview:buttonView];
            buttonView.sd_layout
            .topEqualToView(view)
            .leftSpaceToView(view, 28*CA_H_RATIO_WIDTH)
            .rightSpaceToView(view, 28*CA_H_RATIO_WIDTH);
            
            if (self.model.privilege.count == 0) return view;
            
            if (self.buttonViewBlock) {
                self.buttonViewBlock(buttonView);
            }
            
            return view;
        };
    }
    return _bottomViewBlock;
}


// middle
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, CA_H_RATIO_WIDTH, 5.5*CA_H_RATIO_WIDTH);
        tableView.tableHeaderView = view;
        
        [tableView registerClass:[CA_HAddTodoCell class] forCellReuseIdentifier:@"TodoCell"];
        [tableView registerClass:[CA_HPeopleCell class] forCellReuseIdentifier:@"PeopleCell"];
        [tableView registerClass:[CA_HRemarkCell class] forCellReuseIdentifier:@"RemarkCell"];
        [tableView registerClass:[CA_HFileCell class] forCellReuseIdentifier:@"FileCell"];
        [tableView registerClass:[CA_HReplyCell class] forCellReuseIdentifier:@"ReplyCell"];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)backView {
    if (!_backView) {
        UIView *view = [UIView new];
        _backView = view;
        
        view.backgroundColor = CA_H_FCCOLOR;
        
        UIView *backView = [UIView new];
        backView.backgroundColor = CA_H_F4COLOR;
        [view addSubview:backView];
        backView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(8*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 8*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH));
        backView.sd_cornerRadius = @(6*CA_H_RATIO_WIDTH);
        
        [view addSubview:self.textView];
        self.textView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(13*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 8*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
        
    }
    return _backView;
}

- (UIView *(^)(void))middleViewBlock {
    if (!_middleViewBlock) {
        CA_H_WeakSelf(self);
        _middleViewBlock = ^UIView * {
            CA_H_StrongSelf(self);
            return self.middleView;
        };
    }
    return _middleViewBlock;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)queryTodo:(NSNumber *)todoId objectId:(NSNumber *)objectId view:(UIView *)view {
    CA_H_WeakSelf(self);
    [CA_HTodoNetModel queryTodo:todoId objectId:objectId callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    self.DetailDic = netModel.data;
                    return;
                }
            }
        }
        [CA_HProgressHUD showHudStr:netModel.errmsg?:@"加载失败！"];
    } view:view];
}

- (void)setDetailDic:(NSDictionary *)detailDic {
    if (!self.model) {
        self.model = [CA_HTodoDetailModel modelWithDictionary:detailDic];
        self.setTitleBlock(self.model.todo_name, [self.model.status isEqualToString:@"finish"]);
        if (self.getDetailBlock) {
            self.getDetailBlock();
        }
    } else {
        self.model = [CA_HTodoDetailModel modelWithDictionary:detailDic];
        self.setTitleBlock(self.model.todo_name, [self.model.status isEqualToString:@"finish"]);
        if (self.buttonViewBlock) {
            self.buttonViewBlock(self.bottomView.subviews.firstObject);
        }
        CA_H_WeakSelf(self);
        CA_H_DISPATCH_MAIN_THREAD(^{
            CA_H_StrongSelf(self);
            [self.tableView reloadData];
        });
    }
}

- (void)buttonView:(UIView *)buttonView target:(id)target action:(SEL)action {
    
    [buttonView clearAutoWidthFlowItemsSettings];
    [buttonView removeAllSubviews];
    
    NSArray *privilege = @[@"comment", @"edit", @"jump", @"delete"];
    NSArray *array = @[@"reply2",
                       @"edit_icon",
                       @"goto",
                       @"delete2"];
    
    for (NSInteger i=0; i<array.count; i++) {
        
        NSInteger index = [self.model.privilege indexOfObject:privilege[i]];
        if (index == NSNotFound) {
            continue;
        }
        
        UIButton *button = [UIButton new];
        button.tag = 100+i;
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        button.imageView.sd_resetLayout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerXEqualToView(button)
        .centerYEqualToView(button);
        
        button.frame = CGRectMake(0, 0, 0, 48*CA_H_RATIO_WIDTH);
        
        [buttonView addSubview:button];
    }
    
    [buttonView setupAutoWidthFlowItems:buttonView.subviews withPerRowItemsCount:buttonView.subviews.count verticalMargin:0 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
}


- (UIView *)middleView {
    if (!_middleView) {
        UIView *middleView = [UIView new];
        _middleView = middleView;
        
        CA_H_WeakSelf(self);
        middleView.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(self);
            self.middleView.didFinishAutoLayoutBlock = nil;
            self.backView.height = 56*CA_H_RATIO_WIDTH;
            self.backView.top = self.middleView.height;
            self.tableView.height = self.backView.top;
            self.shadowView.bottom = self.backView.top;
        };
        
        
        [middleView addSubview:self.backView];
        
        self.backView.sd_layout
        .leftEqualToView(middleView)
        .rightEqualToView(middleView);
        
        
        [middleView addSubview:self.tableView];
        self.tableView.sd_layout
        .topEqualToView(middleView)
        .leftEqualToView(middleView)
        .rightEqualToView(middleView);
        
        UIView *shadowView = [UIView new];
        self.shadowView = shadowView;
        shadowView.userInteractionEnabled = NO;
        shadowView.backgroundColor = [UIColor clearColor];
        
        [middleView addSubview:shadowView];
        [middleView bringSubviewToFront:shadowView];
        shadowView.sd_layout
        .heightIs(30*CA_H_RATIO_WIDTH)
        .leftEqualToView(middleView)
        .rightEqualToView(middleView);
        
        
        UIColor *shadowColor = CA_H_SHADOWCOLOR;
        CALayer *subLayer=[CALayer layer];
        subLayer.frame= CGRectMake(0, 30*CA_H_RATIO_WIDTH, CA_H_SCREEN_WIDTH, 48*CA_H_RATIO_WIDTH);
        subLayer.cornerRadius = 0;
        subLayer.backgroundColor=[UIColor whiteColor].CGColor;//[shadowColor colorWithAlphaComponent:0.5].CGColor;
        subLayer.masksToBounds = NO;
        subLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.5;//阴影透明度，默认0
        subLayer.shadowRadius = 6*CA_H_RATIO_WIDTH;//阴影半径，默认3
        
        shadowView.layer.masksToBounds = YES;
        [shadowView.layer addSublayer:subLayer];
    }
    return _middleView;
}

- (UIView *)keyboardView {
    UIView *view = [UIView new];
    
    view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 40*CA_H_RATIO_WIDTH);
    view.backgroundColor = CA_H_FCCOLOR;
    
    
    if (![self.model.object_type isEqualToString:@"person"]) {
        UIButton *button = [UIButton new];
        button.tag = 100;
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(22);
        [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [button setTitle:@"@" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onKeyboardView:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        button.sd_layout
        .heightIs(30*CA_H_RATIO_WIDTH)
        .widthIs(49*CA_H_RATIO_WIDTH)
        .leftEqualToView(view)
        .topSpaceToView(view, 2*CA_H_RATIO_WIDTH);
    }
    
    UIButton *sendButton = [UIButton new];
    sendButton.enabled = NO;
    sendButton.tag = 101;
    sendButton.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:CA_H_LAN(@"发表") forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageWithColor:CA_H_TINTCOLOR] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageWithColor:CA_H_BACKCOLOR] forState:UIControlStateDisabled];
    [sendButton addTarget:self action:@selector(onKeyboardView:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:sendButton];
    sendButton.sd_layout
    .heightIs(28*CA_H_RATIO_WIDTH)
    .widthIs(52*CA_H_RATIO_WIDTH)
    .rightSpaceToView(view, 10*CA_H_RATIO_WIDTH)
    .topSpaceToView(view, 2*CA_H_RATIO_WIDTH);
    sendButton.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    
    return view;
}

- (void)openKeyboard:(CGFloat)height {
    
    if (self.backView.bottom > self.backView.superview.height) {
        return;
    }
    
    self.keyboardHeight = height-self.bottomView.height;
    if (self.keyboardHeight > 0) {
        self.isPlay = YES;
        
        CGFloat bottom = self.tableView.contentOffset.y + self.tableView.height;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.backView.bottom = self.middleView.height - self.keyboardHeight;
            self.tableView.height = self.backView.top;
            self.shadowView.bottom = self.backView.top;
            
            CGPoint set = CGPointMake(0, ((self.tableView.contentSize.height > self.tableView.height)?(bottom - self.tableView.height):(0)));
            self.tableView.contentOffset = set;
            
        } completion:^(BOOL finished) {
            self.isPlay = NO;
        }];
        
    }
}

- (void)closeKeyboard {
    
    if (self.backView.bottom > self.backView.superview.height) {
        return;
    }
    
    self.isPlay = YES;
    CGFloat bottom = self.tableView.contentOffset.y + self.tableView.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.bottom = self.middleView.height;
        self.tableView.height = self.backView.top;
        self.shadowView.bottom = self.backView.top;
        
        CGPoint set = CGPointMake(0, MAX((bottom - self.tableView.height), 0));
        self.tableView.contentOffset = set;
        
    } completion:^(BOOL finished) {
        self.isPlay = NO;
    }];
    self.keyboardHeight = 0;
}


#pragma mark --- Table

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isPlay&&scrollView == self.tableView) {
        [self.textView resignFirstResponder];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        self.replyLabel.hidden = (self.model.comment_list.count==0);
        return self.model.comment_list.count;
    }
    return 6+self.model.file_list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 25*CA_H_RATIO_WIDTH;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 77*CA_H_RATIO_WIDTH;
    }
    return 20*CA_H_RATIO_WIDTH;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            case 2:
            case 3:
            case 4:
                return 54*CA_H_RATIO_WIDTH;
            case 1:
            case 5:
                break;
            default:
                return 80*CA_H_RATIO_WIDTH;
        }
    }
    
    if (indexPath.section) {
        return [tableView cellHeightForIndexPath:indexPath model:self.model.comment_list[indexPath.row] keyPath:@"model" cellClass:[CA_HReplyCell class] contentViewWidth:tableView.width];
    }
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:tableView.mj_w tableView:tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"header"];
            
            [headerView.contentView addSubview:self.replyLabel];
            self.replyLabel.sd_resetNewLayout
            .spaceToSuperView(UIEdgeInsetsMake(0, 20*CA_H_RATIO_WIDTH, 0, 20*CA_H_RATIO_WIDTH));
        }
        
        return headerView;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
        if (!footerView) {
            footerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"footer"];
            
            UILabel *label = [UILabel new];
            label.tag = 202;
            
            label.textColor = CA_H_9GRAYCOLOR;
            label.font = CA_H_FONT_PFSC_Regular(12);
            label.textAlignment = NSTextAlignmentRight;
            label.numberOfLines = 1;
            
            [footerView.contentView addSubview:label];
            label.sd_layout
            .topSpaceToView(footerView.contentView, 20*CA_H_RATIO_WIDTH)
            .rightSpaceToView(footerView.contentView, 20*CA_H_RATIO_WIDTH)
            .autoHeightRatio(0);
            [label setMaxNumberOfLinesToShow:1];
            [label setSingleLineAutoResizeWithMaxWidth:300*CA_H_RATIO_WIDTH];
        }
        
        UILabel *label = [footerView.contentView viewWithTag:202];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.ts_create.longValue];
        
        NSString *dateText = [date stringWithFormat:@"'创建于'yyyy.MM.dd HH:mm"];//@"创建于2017.12.12  18:00";
        label.text = [NSString stringWithFormat:@"%@ %@", self.model.creator.chinese_name, dateText];
        
        return footerView;
    }
    
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        UITableViewCell *cell;
        switch (indexPath.row) {
            case 4:
            case 3:
            case 2:
            case 0:{
                CA_HAddTodoCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"TodoCell"];
                myCell.accessoryType = UITableViewCellAccessoryNone;
                myCell.type = indexPath.row;
                myCell.model = nil;
                
                if (indexPath.row == 0) {
                    myCell.textLabel.text = self.model.object_name.length?self.model.object_name:CA_H_LAN(@"未关联项目");
                } else if (indexPath.row == 2) {
                    if (self.model.ts_finish.doubleValue > 0) {
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.ts_finish.doubleValue];
                        NSDate *nowDate = [NSDate new];
                        if (date.year == nowDate.year) {
                            myCell.textLabel.text = [date stringWithFormat:@"MM月dd日（EE）HH:mm"];//@"12月12日（周三）18:00";
                        } else {
                            myCell.textLabel.text = [date stringWithFormat:@"yyyy年MM月dd日（EE）HH:mm"];//@"12月12日（周三）18:00";
                        }
                        
                    } else {
                        myCell.textLabel.text = CA_H_LAN(@"未设置截止时间");
                    }
                } else if (indexPath.row == 3) {
                    if (self.model.remind_time.integerValue) {
                        myCell.textLabel.text = [NSString stringWithFormat:@"提醒：提前%@", self.model.remind_time_desc?:@""];
                    } else {
                        myCell.textLabel.text = CA_H_LAN(@"未设置提醒");
                    }
                } else if (indexPath.row == 4) {
                    myCell.textLabel.text = [NSString stringWithFormat:@"优先级：%@", self.model.tag_level_desc?:@"普通"];
                }
                
                cell = myCell;
            }break;
            case 1:{
                //people
                CA_HPeopleCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell"];
                myCell.model = self.model.member_list;
                cell = myCell;
            }break;
            case 5:{
                //remark
                CA_HRemarkCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"RemarkCell"];
                myCell.model = self.model.todo_content;
                cell = myCell;
            }break;
            default:{
                //file
                CA_HFileCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"FileCell"];
                myCell.model = self.model.file_list[indexPath.row-6];
                cell = myCell;
            }break;
        }
        
        if (self.titleButton.selected) {
            cell.textLabel.textColor = CA_H_9GRAYCOLOR;
        } else {
            cell.textLabel.textColor = CA_H_4BLACKCOLOR;
        }
        
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
        return cell;
    }
    
    CA_HReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyCell"];
    
    CA_H_WeakSelf(self);
    cell.onClickBlock = ^(CA_HReplyCell *clickCell, BOOL isMine) {
        CA_H_StrongSelf(self);
        if (isMine) {
            if (self.deleteCommentBlock) {
                self.deleteCommentBlock(clickCell);
            }
        } else {
            CA_HTodoDetailCommentModel *clickModel = (id)clickCell.model;
            self.People = (id)@[clickModel.creator];
            self.onReplyBlock(YES);
        }
    };
    cell.model = self.model.comment_list[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row > 5) {
        CA_HTodoDetailFileModel *model = self.model.file_list[indexPath.row-6];
        if (self.borwseFileControllerBlock) {
            self.borwseFileControllerBlock(model.file_id, model.file_name, model.file_url);
        }
    }
}

#pragma mark --- TextView

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (range.length == 0&&text.length > 0) {
        NSMutableString *str = [NSMutableString stringWithString:textView.text];
        [str insertString:text atIndex:range.location];
        CGSize size = [str sizeForFont:textView.font size:CGSizeMake(textView.width, MAXFLOAT) mode:NSLineBreakByWordWrapping];
        if (size.height > 40*textView.font.lineHeight+0.1) {
            [CA_HProgressHUD showHudStr:@"当前评论字数超过限制"];
            return NO;
        }
    }

    return [CA_HAppManager textView:textView shouldChangeTextInRange:range replacementText:text];
//    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView {
    if (textView.text.length == 0) {
        textView.font = CA_H_FONT_PFSC_Regular(14);
        textView.textColor = CA_H_4BLACKCOLOR;
    }
    
    UIButton *button = [textView.inputAccessoryView viewWithTag:101];
    button.enabled = (textView.text.length > 0);
    self.isPlay = YES;
    self.backView.height = MIN(196*CA_H_RATIO_WIDTH, MAX(56*CA_H_RATIO_WIDTH, textView.contentSize.height+21*CA_H_RATIO_WIDTH));
    self.backView.bottom = self.middleView.height-self.keyboardHeight;
    self.tableView.height = self.backView.top;
    self.shadowView.bottom = self.backView.top;
    self.isPlay = NO;
}

@end
