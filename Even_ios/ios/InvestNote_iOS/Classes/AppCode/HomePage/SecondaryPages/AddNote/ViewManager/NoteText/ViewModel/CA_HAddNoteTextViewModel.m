//
//  CA_HAddNoteTextViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAddNoteTextViewModel.h"

#import "CA_HAddNoteManager.h"
#import "CA_HSelectMenuView.h"
#import "YYPhotoBrowseView.h"

@interface CA_HAddNoteTextViewModel ()

@property (nonatomic, strong) UILabel *myTagLabel;

@property (nonatomic, strong) YYTextView *textView;

@end

@implementation CA_HAddNoteTextViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (CA_HNoteUploadManager *)uploadManager {
    if (!_uploadManager) {
        CA_HNoteUploadManager *uploadManager = [CA_HNoteUploadManager new];
        _uploadManager = uploadManager;
    }
    return _uploadManager;
}

- (YYTextView *(^)(id))titleTextView{
    if (!_titleTextView) {
        _titleTextView = ^YYTextView *(id delegate) {
            YYTextView *textView = [YYTextView new];
            textView.tag = 110;
            textView.delegate = delegate;
            textView.textContainerInset = UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 0, 20*CA_H_RATIO_WIDTH);
            
            textView.placeholderTextColor = CA_H_9GRAYCOLOR;
            textView.placeholderFont = CA_H_FONT_PFSC_Medium(18);
            textView.placeholderText = CA_H_LAN(@"笔记标题");
            
            textView.font = CA_H_FONT_PFSC_Medium(18);
            textView.textColor = CA_H_4BLACKCOLOR;
            
            UIView *line = [UIView new];
            line.backgroundColor = CA_H_BACKCOLOR;
            [textView addSubview:line];
            line.sd_layout
            .heightIs(CA_H_LINE_Thickness)
            .bottomSpaceToView(textView, 15*CA_H_RATIO_WIDTH)
            .leftSpaceToView(textView, 20*CA_H_RATIO_WIDTH)
            .rightSpaceToView(textView, 20*CA_H_RATIO_WIDTH);
            
            textView.returnKeyType = UIReturnKeyDone;
            textView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 60*CA_H_RATIO_WIDTH);
            
            return textView;
        };
    }
    return _titleTextView;
}

- (YYTextView *(^)(id, SEL))contentTextView{
    if (!_contentTextView) {
        CA_H_WeakSelf(self);
        _contentTextView = ^YYTextView *(id delegate, SEL action) {
            CA_H_StrongSelf(self);
            YYTextView *textView = [YYTextView new];
            self.textView = textView;
            textView.tag = 111;
            textView.delegate = delegate;
            
            textView.placeholderFont = CA_H_FONT_PFSC_Regular(15);
            textView.placeholderTextColor = CA_H_9GRAYCOLOR;
            textView.placeholderText = CA_H_LAN(@"填写笔记内容...");
            
            textView.font = CA_H_FONT_PFSC_Regular(15);
            textView.textColor = CA_H_4BLACKCOLOR;
            
            textView.inputAccessoryView = [self textKeyboardView:delegate action:action];
            
            textView.textContainerInset = UIEdgeInsetsMake(60*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
            
            return textView;
        };
    }
    return _contentTextView;
}

- (CA_HAddNoteTextViewModel *(^)(NSString *, UIView *))tagLabel{
    if (!_tagLabel) {
        CA_H_WeakSelf(self);
        _tagLabel = ^CA_HAddNoteTextViewModel *(NSString *tagText, UIView *superView) {
            CA_H_StrongSelf(self);
            
            if (!self.myTagLabel) {
                UIView *view = [UIView new];
                view.backgroundColor = CA_H_F8COLOR;
                
                UILabel * label = [UILabel new];
                label.font = CA_H_FONT_PFSC_Regular(12);
                label.textColor = CA_H_9GRAYCOLOR;
                
                [view addSubview:label];
                label.sd_layout
                .leftSpaceToView(view, 8*CA_H_RATIO_WIDTH)
                .centerYEqualToView(view)
                .autoHeightRatio(0);
                [label setMaxNumberOfLinesToShow:1];
                [label setSingleLineAutoResizeWithMaxWidth:320*CA_H_RATIO_WIDTH];
                
                [superView addSubview:view];
                view.sd_layout
                .heightIs(25*CA_H_RATIO_WIDTH)
                .leftSpaceToView(superView, 20*CA_H_RATIO_WIDTH)
                .bottomSpaceToView(superView, 25*CA_H_RATIO_WIDTH);
                [view setupAutoWidthWithRightView:label rightMargin:8*CA_H_RATIO_WIDTH];
                view.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
                
                self.myTagLabel = label;
            }
            
            self.myTagLabel.text = tagText;
            [self.myTagLabel sizeToFit];
            
            return self;
        };
    }
    return _tagLabel;
}

- (NSUInteger (^)(NSString *, NSUInteger))indexText{
    if (!_indexText) {
        _indexText = ^NSUInteger (NSString *text, NSUInteger toIndex) {
            
            NSString * subStr = [text substringToIndex:toIndex];
            
            NSArray * countArray = [subStr componentsSeparatedByString:CA_H_EDITNOTE];
            
            return countArray.count - 1;
        };
    }
    return _indexText;
}

- (CA_HAddNoteTextViewModel *(^)(YYTextView *, NSString *, NSRange))deleteText{
    if (!_deleteText) {
        CA_H_WeakSelf(self);
        _deleteText = ^CA_HAddNoteTextViewModel *(YYTextView *textView, NSString *text, NSRange range) {
            CA_H_StrongSelf(self);
            
            NSString * editText = @"\U0000fffc";
            
            NSUInteger index = self.indexText(textView.text, range.location);
            
            NSMutableString * subStr = [NSMutableString stringWithString:text];
            NSRange subRange = [subStr rangeOfString:editText];
            
            while (subRange.length == [editText length]) {
                CA_HAddNoteManager *model = [self.contentArray objectAtIndex:index];
                model.deleteMe();
                [subStr replaceCharactersInRange:subRange withString:@""];
                subRange = [subStr rangeOfString:editText];
            }
            
            return self;
        };
    }
    return _deleteText;
}

- (NSMutableArray *)contentArray{
    if (!_contentArray) {
        _contentArray = [NSMutableArray new];
    }
    return _contentArray;
}

- (void)setModel:(CA_HNoteDetailModel *)model{
    if (!model) {
        return;
    }
    _model = model;
    
    if (_toModel) {
        _toModel(model);
    }
    
    for (CA_HNoteDetailContentModel *contentModel in model.content) {
        CA_HNoteContentModel *myModel = [CA_HNoteContentModel modelWithJSON:[contentModel modelToJSONString]];
        
        if (myModel.enumType == CA_HAddNoteTypeString) {
            [_textView insertText:contentModel.content];
        }else {
            [CA_HAddNoteManager new]
            .begin(self.textView)
            .model(myModel)
            .contentArray(self.contentArray)
            .showDelete(YES)
            .end(NO)
            .clickBlock = _clickBlock;
        }
    }
}

- (NSArray<CA_HNoteContentModel *> *)saveContent {
    
    NSMutableArray *mutArray = [NSMutableArray new];
    NSArray * array = [self.textView.text componentsSeparatedByString:CA_H_EDITNOTE];
    
    for (NSInteger i = 0; i < array.count; i++) {
        NSString * str = array[i];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        
        if (str.length) {
            CA_HNoteContentModel * contentModel = [CA_HNoteContentModel new];
            contentModel.type = @"string";
            contentModel.content = str;
            [mutArray addObject:contentModel];
        }
        
        if (i < self.contentArray.count) {
            [mutArray addObject:[self.contentArray[i] contentModel]];
        }
    }
    
    return mutArray;
}

- (CA_HAddNoteManager *(^)(BOOL))addRecord{
    if (!_addRecord) {
        CA_H_WeakSelf(self);
        _addRecord = ^CA_HAddNoteManager *(BOOL isPlay) {
            CA_H_StrongSelf(self);
            
            if (isPlay) {
                self.recordManager = [CA_HAddNoteManager new];
                self.recordManager.updateFileManager = self.uploadManager.updateFileManager;
                
                CA_HNoteContentModel *model = [CA_HNoteContentModel new];
                model.enumType = CA_HAddNoteTypeRecord;
                
                self.recordManager
                .begin(self.textView)
                .model(model)
                .contentArray(self.contentArray)
                .showDelete(YES)
                .end(YES);

            }else{
                CA_H_MANAGER.recorderStopBlock = nil;
                self.recordManager.stop();
                self.recordManager = nil;
            }
            
            return self.recordManager;
        };
    }
    return _addRecord;
}

- (CA_HAddNoteManager *(^)(NSString *))addFile{
    if (!_addFile) {
        CA_H_WeakSelf(self);
        _addFile = ^CA_HAddNoteManager *(NSString *fileName) {
            CA_H_StrongSelf(self);
            
            CA_HNoteContentModel *model = [CA_HNoteContentModel new];
            model.enumType = CA_HAddNoteTypeFile;
            model.file_name = fileName;
            
            return [CA_HAddNoteManager new]
            .begin(self.textView)
            .model(model)
            .contentArray(self.contentArray)
            .showDelete(YES)
            .end(YES);
        };
    }
    return _addFile;
}

- (CA_HAddNoteManager *(^)(UIImage *))addImage{
    if (!_addImage) {
        CA_H_WeakSelf(self);
        _addImage = ^CA_HAddNoteManager *(UIImage *image) {
            CA_H_StrongSelf(self);
            
            CA_HNoteContentModel *model = [CA_HNoteContentModel new];
            model.enumType = CA_HAddNoteTypeImage;
            model.file = image;
            model.img_width = @(image.size.width);
            model.img_height = @(image.size.height);
            
            return [CA_HAddNoteManager new]
            .begin(self.textView)
            .model(model)
            .contentArray(self.contentArray)
            .showDelete(YES)
            .end(YES);
        };
    }
    return _addImage;
}

- (NSArray *)items{
    NSMutableArray *items = [NSMutableArray new];
    for (CA_HAddNoteManager *manager in self.contentArray) {
        if (manager.contentModel.enumType == CA_HAddNoteTypeImage) {
            YYPhotoGroupItem * photo = [YYPhotoGroupItem new];
            photo.thumbView = manager.contentView.subviews.firstObject;
            [items addObject:photo];
        }
    }
    return items;
}

- (void)setSelectMenuBlock:(void (^)(NSInteger))selectMenuBlock{
    _selectMenuBlock = selectMenuBlock;
    if (!selectMenuBlock) {
        return;
    }
    CA_HSelectMenuView * selectMenuView = [CA_HSelectMenuView new];
    selectMenuView.frame = CA_H_MANAGER.mainWindow.bounds;
    NSArray * data = @[@"添加图片",
                       @"拍摄照片",
                       @"选择照片"];
    CA_H_WeakSelf(selectMenuView);
    CA_H_WeakSelf(self);
    selectMenuView.clickBlock = ^(NSInteger item) {
        CA_H_StrongSelf(selectMenuView);
        CA_H_StrongSelf(self);
        selectMenuBlock(item);
        [selectMenuView hideMenu:YES];
    };
    selectMenuView.data = data;
    [CA_H_MANAGER.mainWindow addSubview:selectMenuView];
    [selectMenuView showMenu:YES];
}

#pragma mark --- LifeCircle

- (void)dealloc{
    [self.contentArray removeAllObjects];
    self.contentArray = nil;
    NSLog(@"%@成功释放", self.class);
}

#pragma mark --- Custom

- (UIView *)textKeyboardView:(id)delegate action:(SEL)action{
    UIView * view = [UIView new];
    view.backgroundColor = CA_H_FCCOLOR;
    view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 40);
    
    [CA_HShadow dropShadowWithView:view
                            offset:CGSizeMake(0, -3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.3];
    
    NSArray * images = @[@"project_icon2",
                         @"pic_icon",
                         @"attachment_icon",
                         @"micro_icon"];
    
    UIView * lastView = view;
    for (NSInteger i = 0; i < images.count; i++) {
        
        if (i==0&&self.ishuman) {
            continue;
        }
        
        UIButton * button = [UIButton new];
        [button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.tag = 100 + i;
        [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        
        button.sd_layout
        .widthIs(24)
        .heightEqualToWidth()
        .centerYEqualToView(view);
        
        if (i == 3) {
            button.sd_layout.rightSpaceToView(view, 20*CA_H_RATIO_WIDTH);
        }else{
            button.sd_layout.leftSpaceToView(lastView, (lastView==view?20:30)*CA_H_RATIO_WIDTH);
            lastView = button;
        }
    }
    
    UIButton * button = [UIButton new];
    [button setTitle:CA_H_LAN(@"结束语音") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    button.backgroundColor = CA_H_TINTCOLOR;
    button.tag = 104;
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.hidden = YES;
    
    [view addSubview:button];
    
    button.sd_layout
    .widthIs(80)
    .heightIs(28)
    .centerYEqualToView(view)
    .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH);
    button.sd_cornerRadius = @(4);
    
    
    return view;
}

#pragma mark --- Delegate

@end
