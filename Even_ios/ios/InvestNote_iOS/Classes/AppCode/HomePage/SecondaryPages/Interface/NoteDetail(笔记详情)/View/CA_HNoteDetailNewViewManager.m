//
//  CA_HNoteDetailNewViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteDetailNewViewManager.h"

#import "CA_HBaseTableCell.h"
#import "CA_HNoteDetailAttachCell.h"

@interface CA_HNoteDetailNewViewManager () <YYTextViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *cellsDic;

@end

@implementation CA_HNoteDetailNewViewManager

#pragma mark --- Action

#pragma mark --- Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, CA_H_RATIO_WIDTH, 60*CA_H_RATIO_WIDTH);
        tableView.tableFooterView = view;
        tableView.backgroundColor = [UIColor whiteColor];
        
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[CA_HReplyCell class] forCellReuseIdentifier:@"ReplyCell"];
    }
    return _tableView;
}

- (UITableViewHeaderFooterView *)commentHeader {
    if (!_commentHeader) {
        UITableViewHeaderFooterView *view = [UITableViewHeaderFooterView new];
        _commentHeader = view;
        
        UIView *line = [UIView new];
        line.backgroundColor = CA_H_BACKCOLOR;
        line.frame = CGRectMake(20*CA_H_RATIO_WIDTH, 21*CA_H_RATIO_WIDTH, 335*CA_H_RATIO_WIDTH, CA_H_LINE_Thickness);
        [view addSubview:line];
        
        UILabel *label = [UILabel new];
        label.numberOfLines = 1;
        label.font = CA_H_FONT_PFSC_Medium(18);
        label.textColor = CA_H_4BLACKCOLOR;
        label.text = @"评论";
        label.frame = CGRectMake(20*CA_H_RATIO_WIDTH, 36*CA_H_RATIO_WIDTH, 50*CA_H_RATIO_WIDTH, 25*CA_H_RATIO_WIDTH);
        [view addSubview:label];
    }
    return _commentHeader;
}

- (NSMutableDictionary *)cellsDic {
    if (!_cellsDic) {
        _cellsDic = [NSMutableDictionary new];
    }
    return _cellsDic;
}

- (NSMutableArray<YYPhotoGroupItem *> *)photoGroupItems {
    if (!_photoGroupItems) {
        _photoGroupItems = [NSMutableArray new];
    }
    return _photoGroupItems;
}

- (CATextLayer *)holderLayer {
    if (!_holderLayer) {
        CATextLayer *textLayer = [CATextLayer new];
        _holderLayer = textLayer;
        
        textLayer.frame = CGRectMake(10*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 150*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
        textLayer.string = CA_H_LAN(@"写下你的见解...");
        textLayer.font = (__bridge CFTypeRef _Nullable)(@"PingFangSC-Regular");
        textLayer.fontSize = 14*CA_H_RATIO_WIDTH;
        textLayer.wrapped = NO;//默认为No.  当Yes时，字符串自动适应layer的bounds大小
        textLayer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.foregroundColor = CA_H_9GRAYCOLOR.CGColor;
    }
    return _holderLayer;
}

- (CALayer *)backLayer {
    if (!_backLayer) {
        CALayer *layer = [CALayer new];
        _backLayer = layer;
        
        layer.frame = CGRectMake(10*CA_H_RATIO_WIDTH, 8*CA_H_RATIO_WIDTH, 355*CA_H_RATIO_WIDTH, 40*CA_H_RATIO_WIDTH);
        layer.cornerRadius = 6*CA_H_RATIO_WIDTH;
        layer.backgroundColor = CA_H_F4COLOR.CGColor;
        layer.masksToBounds = YES;
        
        [layer addSublayer:self.holderLayer];
    }
    return _backLayer;
}

- (UIView *)replyView {
    if (!_replyView) {
        UIView *view = [UIView new];
        _replyView = view;
        
        view.backgroundColor = CA_H_FCCOLOR;
        view.opaque = NO;
        
        view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 196*CA_H_RATIO_WIDTH);
        
        [view addSubview:self.textView];
        [view.layer insertSublayer:self.backLayer below:self.textView.layer];
        
        
        view.layer.masksToBounds = NO;
        view.layer.shadowColor = CA_H_SHADOWCOLOR.CGColor;//shadowColor阴影颜色
        view.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        view.layer.shadowRadius = 6*CA_H_RATIO_WIDTH;//阴影半径，默认3
    }
    return _replyView;
}

- (YYTextView *)textView {
    if (!_textView) {
        YYTextView *textView = [YYTextView new];
        _textView = textView;
        
        textView.backgroundColor = [UIColor clearColor];
        textView.opaque = NO;
        
        textView.bounces = NO;
        textView.font = CA_H_FONT_PFSC_Regular(14);
        textView.textColor = CA_H_4BLACKCOLOR;
        
        UIView *view = [UIView new];
        
        view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 40*CA_H_RATIO_WIDTH);
        view.backgroundColor = CA_H_FCCOLOR;
        
        [view addSubview:self.remindButton];
        [view addSubview:self.sendButton];
        
        if (@available(iOS 11.0, *)) {
            textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        textView.extraAccessoryViewHeight = view.frame.size.height;
        textView.inputAccessoryView = view;
        
        textView.frame = CGRectMake(15*CA_H_RATIO_WIDTH, 13*CA_H_RATIO_WIDTH, 345*CA_H_RATIO_WIDTH, 170*CA_H_RATIO_WIDTH);
        
        textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        UIButton *button = [UIButton new];
        _sendButton = button;
        
        button.enabled = NO;
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:CA_H_LAN(@"发表") forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:CA_H_TINTCOLOR] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:CA_H_BACKCOLOR] forState:UIControlStateDisabled];
        
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4*CA_H_RATIO_WIDTH;
        
        button.frame = CGRectMake(CA_H_SCREEN_WIDTH-62*CA_H_RATIO_WIDTH, 2*CA_H_RATIO_WIDTH, 52*CA_H_RATIO_WIDTH, 28*CA_H_RATIO_WIDTH);
    }
    return _sendButton;
}

- (UIButton *)remindButton {
    if (!_remindButton) {
        UIButton *button = [UIButton new];
        _remindButton = button;
        
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(22);
        [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [button setTitle:@"@" forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0, 2*CA_H_RATIO_WIDTH, 49*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH);
    }
    return _remindButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *view = [UIView new];
        _bottomView = view;
        
        view.backgroundColor = CA_H_FCCOLOR;
    }
    
    return _bottomView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIBarButtonItem *)rightBarButton:(id)target action:(SEL)action {
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(0, 0, 70, 44);
    
    [button setImage:[UIImage imageNamed:@"icons_info"] forState:UIControlStateNormal];
    button.imageView.sd_resetLayout
    .widthIs(20)
    .heightEqualToWidth()
    .centerYEqualToView(button.imageView.superview)
    .rightEqualToView(button.imageView.superview);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)titleCellData:(CA_HNoteDetailModel *)model {
    CA_HBaseTableCell *cell = [CA_HBaseTableCell new];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    
    NSMutableAttributedString *noteTitle = [NSMutableAttributedString new];
    [noteTitle appendString:model.note_title];
    noteTitle.font = CA_H_FONT_PFSC_Medium(18);
    noteTitle.color = CA_H_4BLACKCOLOR;
    noteTitle.lineSpacing = 6*CA_H_RATIO_WIDTH;
    
    CGRect rect = [noteTitle boundingRectWithSize:CGSizeMake(335*CA_H_RATIO_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    rect.origin = CGPointMake(20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH);
    
    titleLabel.frame = rect;
    titleLabel.attributedText = noteTitle;
    [cell.contentView addSubview:titleLabel];
    
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 10*CA_H_RATIO_WIDTH;
    headImageView.frame = CGRectMake(20*CA_H_RATIO_WIDTH, titleLabel.bottom+10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
    [cell.contentView addSubview:headImageView];
    NSString *urlStr = model.creator.avatar;
    urlStr = ^{
        if ([urlStr hasPrefix:@"http://"]
            ||
            [urlStr hasPrefix:@"https://"]) {
            return urlStr;
        }
        return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
    }();
    [headImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:[UIImage imageNamed:@"head20"]];
    
    
    NSString *projectStr = nil;
    if ([model.object_type isEqualToString:@"project"]) {
        if (model.note_type_id.integerValue) {
            projectStr = [NSString stringWithFormat:@"%@·%@", model.object_name, model.note_type_name];
        } else {
            projectStr = model.object_name;
        }
    }
    NSMutableString *text = [NSMutableString new];
    [text appendString:model.creator.chinese_name];
    [text appendString:@" | "];
    if (projectStr.length) {
        [text appendString:projectStr];
        [text appendString:@" | "];
    }
    [text appendString:[[NSDate dateWithTimeIntervalSince1970:model.ts_create.doubleValue] stringWithFormat:@"yyyy.MM.dd HH:mm"]];
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(48*CA_H_RATIO_WIDTH, titleLabel.bottom+10*CA_H_RATIO_WIDTH, 307*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
    [cell.contentView addSubview:label];
    label.textColor = CA_H_9GRAYCOLOR;
    label.font = CA_H_FONT_PFSC_Regular(12);
    label.numberOfLines = 1;
    label.text = text;
    
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    line.frame = CGRectMake(20*CA_H_RATIO_WIDTH, titleLabel.bottom+46*CA_H_RATIO_WIDTH, 335*CA_H_RATIO_WIDTH, CA_H_LINE_Thickness);
    [cell.contentView addSubview:line];
    
    
    model.cellHeight = (rect.size.height+61*CA_H_RATIO_WIDTH);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.cellsDic setValue:cell forKey:[NSString stringWithFormat:@"%@", indexPath]];
}

- (void)imageCellData:(CA_HNoteDetailContentModel *)model index:(NSInteger)index {
    
    CA_HBaseTableCell *cell = [CA_HBaseTableCell new];
    
    NSString *urlStr = model.file_url;
    urlStr = ^{
        if ([urlStr hasPrefix:@"http://"]
            ||
            [urlStr hasPrefix:@"https://"]) {
            return urlStr;
        }
        return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
    }();
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    CGFloat width = CA_H_SCREEN_WIDTH-40*CA_H_RATIO_WIDTH;
    
    UIImageView *imageView = [UIImageView new];
    imageView.tag = 2333;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = CA_H_F4COLOR;
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, width, width*(model.img_height.doubleValue?:1)/(model.img_width.doubleValue?:1));
    [cell.contentView addSubview:imageView];
    
    
    UILabel *label = [UILabel new];
    label.text = @"加载中…";
    label.font = CA_H_FONT_PFSC_Regular(14);
    label.textColor = CA_H_9GRAYCOLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = imageView.bounds;
    [imageView addSubview:label];
    
    
    CA_H_WeakSelf(imageView);
    [imageView setImageWithURL:url placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        [label removeFromSuperviewAndClearAutoLayoutSettings];
        CA_H_StrongSelf(imageView);
        if (image) {
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = image;
        } else {
            imageView.contentMode = UIViewContentModeCenter;
            imageView.image = [UIImage imageNamed:@"loadfail_pic2"];
        }
    }];
    
    YYPhotoGroupItem * photo = [YYPhotoGroupItem new];
    photo.thumbView = imageView;
    photo.largeImageURL = url;
    [self.photoGroupItems addObject:photo];
    
    model.cellHeight = imageView.height+20*CA_H_RATIO_WIDTH;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    [self.cellsDic setValue:cell forKey:[NSString stringWithFormat:@"%@", indexPath]];
}

- (void)bottomButtons:(NSArray<NSString *> *)privilege target:(id)target action:(SEL)action {
    
    [self.bottomView removeAllSubviews];
    
    NSMutableArray *images = [NSMutableArray new];
    [images addObject:@"share_icon2"];
    
    if ([privilege indexOfObject:@"comment"] != NSNotFound) {
        [images insertObject:@"reply2" atIndex:0];
        if (privilege.count > 1) {
            [images addObject:@"more icon"];
        }
    } else {
        if (privilege.count > 0) {
            [images addObject:@"more icon"];
        }
    }
    
    CGFloat width = 285.0*CA_H_RATIO_WIDTH/images.count;
    for (NSInteger i=0; i<images.count; i++) {
        
        NSString *imageName = images[i];
        
        UIButton *button = [UIButton new];
        
        if ([imageName isEqualToString:@"reply2"]) {
            button.tag = 100;
        } else if ([imageName isEqualToString:@"share_icon2"]) {
            button.tag = 101;
        } else {
            button.tag = 102;
        }
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        button.imageView.sd_resetLayout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerXEqualToView(button)
        .centerYEqualToView(button);
        
        button.frame = CGRectMake(45*CA_H_RATIO_WIDTH+i*width, 0, width, 48*CA_H_RATIO_WIDTH);
        
        [self.bottomView addSubview:button];
    }
}

#pragma mark --- Table

- (void)reloadCellsData:(CA_HNoteDetailModel *)model {
    
    [self titleCellData:model];
    
    for (CA_HNoteDetailContentModel *detailModel in model.content) {
        if ([detailModel.type isEqualToString:@"string"]) {// 文本
            if (![self.tableView dequeueReusableCellWithIdentifier:detailModel.type]) {
                [self.tableView registerClass:[CA_HNoteDetailAttachCell class] forCellReuseIdentifier:detailModel.type];
            }
            NSMutableAttributedString *content = [NSMutableAttributedString new];
            [content appendString:detailModel.content];
            content.font = CA_H_FONT_PFSC_Regular(15);
            content.color = CA_H_4BLACKCOLOR;
            content.lineSpacing = 6.5*CA_H_RATIO_WIDTH;
            
            CGRect rect = [content boundingRectWithSize:CGSizeMake(335*CA_H_RATIO_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            
            detailModel.attributedContent = content;
            detailModel.cellHeight = (rect.size.height+20*CA_H_RATIO_WIDTH);
            
        } else if ([detailModel.type isEqualToString:@"image"]) {// 图片
            [self imageCellData:detailModel index:[model.content indexOfObject:detailModel]];
        } else {// 录音&文件
            detailModel.cellHeight = 78*CA_H_RATIO_WIDTH;
            if (![self.tableView dequeueReusableCellWithIdentifier:detailModel.type]) {
                [self.tableView registerClass:[CA_HNoteDetailAttachCell class] forCellReuseIdentifier:detailModel.type];
            }
        }
    }
    
    for (CA_HTodoDetailCommentModel *commentModel in model.comment_list) {
        [self commentCellHeight:commentModel];
    }
}

- (void)commentCellHeight:(CA_HTodoDetailCommentModel *)model {
    NSMutableAttributedString *comment = [NSMutableAttributedString new];
    [comment appendString:model.content];
    comment.font = CA_H_FONT_PFSC_Regular(15);
    comment.color = CA_H_4BLACKCOLOR;
    comment.lineSpacing = 4.5*CA_H_RATIO_WIDTH;
    
    CGRect rect = [comment boundingRectWithSize:CGSizeMake(295*CA_H_RATIO_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    model.attributedContent = comment;
    model.cellHeight = (rect.size.height+65*CA_H_RATIO_WIDTH);
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath model:(CA_HNoteDetailModel *)model {
    if (indexPath.section == 0) {
        return model.cellHeight;
    } else if (indexPath.section == 1) {
        if (indexPath.row < model.content.count) {
            return model.content[indexPath.row].cellHeight;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row < model.comment_list.count) {
            return model.comment_list[indexPath.row].cellHeight;
        }
    }
    return 0;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(CA_HNoteDetailModel *)model {
    CA_HBaseTableCell *cell = [self.cellsDic valueForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (!cell) {
        if (indexPath.section == 1) {
            if (indexPath.row<model.content.count) {
                CA_HNoteDetailContentModel *detailModel = model.content[indexPath.row];
                cell = [self.tableView dequeueReusableCellWithIdentifier:detailModel.type];
                cell.model = detailModel;
            }
        } else if (indexPath.section == 2) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"ReplyCell"];
            if (indexPath.row<model.comment_list.count) {
                cell.model = model.comment_list[indexPath.row];
            }
        }
    }
    return cell;
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
    self.holderLayer.hidden = (textView.text.length>0);
    if (textView.text.length == 0) {
        textView.font = CA_H_FONT_PFSC_Regular(14);
        textView.textColor = CA_H_4BLACKCOLOR;
    }
    self.sendButton.enabled = (textView.text.length > 0);
    
    [self textHeight:textView.contentSize.height];
}

- (void)textHeight:(CGFloat)height {
    CGFloat changeHeight = 56*CA_H_RATIO_WIDTH;
    if (height > 30*CA_H_RATIO_WIDTH) {
        changeHeight = MIN(height, self.textView.frame.size.height)+26*CA_H_RATIO_WIDTH;
    }
    
    if (self.replyHeight != changeHeight) {
        CGFloat fix = changeHeight-self.replyHeight;
        self.replyHeight = changeHeight;
        
        CA_H_WeakSelf(self);
        [UIView animateWithDuration:0.25 animations:^{
            CA_H_StrongSelf(self);
            {
                CGRect frame = self.replyView.frame;
                frame.origin.y -= fix;
                self.replyView.frame = frame;
            }
            {
                CGRect frame = self.backLayer.frame;
                frame.size.height = self.replyHeight-16*CA_H_RATIO_WIDTH;
                self.backLayer.frame = frame;
            }
            {
                CGPoint point = self.tableView.contentOffset;
                point.y += fix;
                if (point.y>self.tableView.contentSize.height-self.replyView.top) point.y=self.tableView.contentSize.height-self.replyView.top;
                if (point.y<0) point.y=0;
                
                UIEdgeInsets contentInset = UIEdgeInsetsZero;
                contentInset.bottom = self.tableView.bottom-self.replyView.top;
                
                self.tableView.contentInset = contentInset;
                self.tableView.contentOffset = point;
            }
        }];
    }
}

// @成员
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
        tagText.color = CA_H_TINTCOLOR;
        
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
    
    [self.textView becomeFirstResponder];
}

- (void)onReplyButton {
    if (self.replyHeight > 0) {
        self.replyHeight = 0;
        CA_H_WeakSelf(self);
        [UIView animateWithDuration:0.25 animations:^{
            CA_H_StrongSelf(self);
            self.replyView.top = self.bottomView.top;
            self.tableView.contentInset = UIEdgeInsetsZero;
        }];
    } else {
        self.textView.text = nil;
        self.replyHeight = 56*CA_H_RATIO_WIDTH;
        [self.textView becomeFirstResponder];
        if ([self.tableView numberOfRowsInSection:2]>0) {
            CGRect rect = [self.tableView rectForSection:2];
            if (self.tableView.contentOffset.y < rect.origin.y) {
                [self.tableView scrollToRow:0 inSection:2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        } else {
            if ([self.tableView numberOfRowsInSection:1]>0) {
                [self.tableView scrollToRow:[self.tableView numberOfRowsInSection:1]-1 inSection:1 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
}

- (void)keyboardFrame:(CGRect)frame isShow:(BOOL)isShow {
    self.textView.inputAccessoryView.hidden = !isShow;
    if (frame.origin.x == 0) {
        CGFloat top = MIN(frame.origin.y, self.bottomView.top)-self.replyHeight;
        UIEdgeInsets contentInset = UIEdgeInsetsZero;
        contentInset.bottom = self.tableView.bottom-top;
        CA_H_WeakSelf(self);
        [UIView animateWithDuration:0.25 animations:^{
            CA_H_StrongSelf(self);
            self.replyView.top = top;
            self.tableView.contentInset = contentInset;
        }];
    }
}

@end
