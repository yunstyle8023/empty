//
//  CA_HAddNoteManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAddNoteManager.h"

#import "lame.h"
#import "CA_HProgressView.h"

@interface CA_HAddNoteManager ()

@property (nonatomic, copy) CA_HAddNoteManager *(^show)(void);
@property (nonatomic, copy) CA_HAddNoteManager *(^start)(void);

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL myShowDelete;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) NSMutableArray *myContentArray;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) CA_HProgressView *progressHud;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) dispatch_source_t timer;


@property (nonatomic, strong) UIView *reuploadView;
@property (nonatomic, strong) UIButton *reuploadButton;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation CA_HAddNoteManager

#pragma mark --- Action

- (void)onDeleteButton:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    NSString * str = CA_H_EDITNOTE;
    NSUInteger index = [self.myContentArray indexOfObject:self];
    NSArray * allArray = [self.textView.text componentsSeparatedByString:str];
    
    NSRange range = NSMakeRange(0, str.length);
    for (NSInteger i = 0; i <= index; i++) {
        range.location += [allArray[i] length];
    }
    range.location += index*range.length;
    
    NSRange selectRange = self.textView.selectedRange;
    
    if (selectRange.location > range.location) {
        selectRange.location = MAX(range.location, selectRange.location-range.length);
    }
    selectRange.location += selectRange.length;
    selectRange.length = 0;
    
    self.textView.selectedRange = range;
    [self.textView replaceRange:self.textView.selectedTextRange withText:@""];
    self.textView.selectedRange = selectRange;
}

#pragma mark --- Lazy


- (CA_HAddNoteManager *(^)(YYTextView *))begin {
    if (!_begin) {
        CA_H_WeakSelf(self);
        _begin = ^CA_HAddNoteManager *(YYTextView *textView) {
            CA_H_StrongSelf(self);
            self.textView = textView;
            return self;
        };
    }
    return _begin;
}

- (CA_HAddNoteManager *(^)(CA_HNoteContentModel *))model {
    if (!_model) {
        CA_H_WeakSelf(self);
        _model = ^CA_HAddNoteManager *(CA_HNoteContentModel *model) {
            CA_H_StrongSelf(self);
            self.contentModel = model;
            return self;
        };
    }
    return _model;
}

- (CA_HAddNoteManager *(^)(NSMutableArray *))contentArray {
    if (!_contentArray) {
        CA_H_WeakSelf(self);
        _contentArray = ^CA_HAddNoteManager *(NSMutableArray * contentArray) {
            CA_H_StrongSelf(self);
            self.myContentArray = contentArray;
            return self;
        };
    }
    return _contentArray;
}

- (CA_HAddNoteManager *(^)(BOOL))showDelete {
    if (!_showDelete) {
        CA_H_WeakSelf(self);
        _showDelete = ^CA_HAddNoteManager *(BOOL showDelete) {
            CA_H_StrongSelf(self);
            self.myShowDelete = showDelete;
            return self;
        };
    }
    return _showDelete;
}

- (CA_HAddNoteManager *(^)(BOOL))end {
    if (!_end) {
        CA_H_WeakSelf(self);
        _end = ^CA_HAddNoteManager *(BOOL isEdit) {
            CA_H_StrongSelf(self);
            self.isEdit = isEdit;
            [self contentView];
            if (!isEdit) {
                self->_addFileModel = [CA_HAddFileModel new];
                switch (self.contentModel.enumType) {
                    case CA_HAddNoteTypeFile:
                        self.addFileModel.type = CA_H_AddFileTypeData;
                        self.stateLabel.text = @"（上传成功）";
                        break;
                    case CA_HAddNoteTypeImage:
                        self.addFileModel.type = CA_H_AddFileTypeImage;
                        break;
                    case CA_HAddNoteTypeRecord:
                        self.addFileModel.type = CA_H_AddFileTypeRecord;
                        self.stateLabel.text = @"（上传成功）";
                        break;
                    default:
                        break;
                }
                self.addFileModel.isFinish = YES;
                self.addFileModel.fileName = self.contentModel.file_name;
                self.addFileModel.file_id = self.contentModel.file_id;
                self.addFileModel.file_url = self.contentModel.file_url;
                self.addFileModel.size = self.contentModel.file_size;
            }
            return self;
        };
    }
    return _end;
}



- (CA_HAddNoteManager *(^)(void))deleteMe {
    if (!_deleteMe) {
        CA_H_WeakSelf(self);
        _deleteMe = ^CA_HAddNoteManager * {
            CA_H_StrongSelf(self);
            [self.myContentArray removeObject:self];
            [self.addFileModel.dataTask cancel];
//            [self.updateFileManager.contents removeObject:self.addFileModel];
            return self;
        };
    }
    return _deleteMe;
}

-(CA_HAddNoteManager *(^)(void))show {
    if (!_show) {
        CA_H_WeakSelf(self);
        _show = ^CA_HAddNoteManager * {
            CA_H_StrongSelf(self);
            
            switch (self.contentModel.enumType) {
                case CA_HAddNoteTypeRecord:{
                    
                    NSInteger currentTime = self.contentModel.record_duration.integerValue;
                    NSString * newStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",currentTime/3600, currentTime%3600/60, currentTime%60];
                    
                    self.imageView.image = [UIImage imageNamed:@"micro_icon"];
                    self.rightLabel.hidden = YES;
                    self.contentLabel.font = CA_H_FONT_PFSC_Light(16);
                    self.contentLabel.textColor = CA_H_4BLACKCOLOR;
                    self.contentLabel.text = newStr;
                    
                }break;
                case CA_HAddNoteTypeFile:{
                    
                    self.progressView.hidden = YES;
                    self.contentLabel.text = self.contentModel.file_name;
                    
                }break;
                default:
                    break;
            }
            
            self.deleteButton.hidden = !self.myShowDelete;
            
            return self;
        };
    }
    return _show;
}

- (CA_HAddNoteManager *(^)(void))stop {
    if (!_stop) {
        CA_H_WeakSelf(self);
        _stop = ^CA_HAddNoteManager * {
            CA_H_StrongSelf(self);
            
            switch (self.contentModel.enumType) {
                case CA_HAddNoteTypeRecord:{
                    // 取消定时器
                    dispatch_cancel(self.timer);
                    self.timer = nil;
                    
                    NSInteger currentTime = CA_H_MANAGER.recorder.currentTime;
                    self.contentModel.record_duration = @(currentTime);
                    NSString * newStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",currentTime/3600, currentTime%3600/60, currentTime%60];
                    [CA_H_MANAGER stopRecord];
                    
                    NSString *homeDocumentPath = NSTemporaryDirectory();
                    NSString *path = [homeDocumentPath stringByAppendingString:@"record/"];
                    
                    CA_H_WeakSelf(self);
                    CA_H_DISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                        CA_H_StrongSelf(self);
                        [self formatToMp3:path fileName:CA_H_MANAGER.recordFileName];
                    });
                    
                    self.imageView.image = [UIImage imageNamed:@"micro_icon"];
                    self.rightLabel.hidden = YES;
                    self.contentLabel.font = CA_H_FONT_PFSC_Light(16);
                    self.contentLabel.textColor = CA_H_4BLACKCOLOR;
                    self.contentLabel.text = newStr;
                    self.deleteButton.hidden = NO;
                    self.stateLabel.textColor = CA_H_4BLACKCOLOR;
                    self.stateLabel.text = @"（上传中0%）";
                    
                }break;
                case CA_HAddNoteTypeFile:{
                    CA_H_WeakSelf(self);
                    CA_H_DISPATCH_MAIN_THREAD(^{
                        CA_H_StrongSelf(self);
                        self.progressView.hidden = YES;
                        self.contentLabel.text = self.contentModel.file_name;
                        self.stateLabel.textColor = UIColorHex(0x4CD964);
                        self.stateLabel.text = @"（上传成功）";
                        self.deleteButton.hidden = NO;
                    });
                }break;
                default:{
                    self.deleteButton.hidden = NO;
                }break;
            }
            
            return self;
        };
    }
    return _stop;
}

- (void)setAddFileModel:(CA_HAddFileModel *)addFileModel {
    _addFileModel = addFileModel;
    if (!addFileModel) {
        return;
    }
    CA_H_WeakSelf(self);
    switch (self.contentModel.enumType) {
        case CA_HAddNoteTypeFile:
        {
            NSMutableString *progressText = [NSMutableString stringWithFormat:@"%@（%@）", addFileModel.fileName, addFileModel.fileSize?:@"0K"];
            [progressText appendString:@" %2ld%%"];
            
            self.progressLabel.text = [NSString stringWithFormat:progressText, 0];
            addFileModel.progressBlock = ^(double progress) {
                CA_H_StrongSelf(self);
                if (progress == 2) {
                    
                    if (self.addFileModel.isFinish) {
                        self.contentModel.file_url = self.addFileModel.file_url;
                        self.contentModel.file_name = self.addFileModel.fileName;
                        self.contentModel.file_id = self.addFileModel.file_id;
                        self.contentModel.file_size = self.addFileModel.size;
                        NSArray *typeArr = [self.contentModel.file_name componentsSeparatedByString:@"."];
                        self.contentModel.file_type = typeArr.count>1?typeArr.lastObject:@"";
                        self.stop();
                    } else {
                        [self needToReupload];
                    }
                    
                } else {
                    if (progress >= 1) {
                        progress = 0.9999;
                    }
                    CA_H_DISPATCH_MAIN_THREAD((^{
                        self.progressHud.progress = progress;
                        self.progressLabel.text = [NSString stringWithFormat:progressText, (NSInteger)(self.progressHud.progress*100)];
                    }));
                }
            };
        }
            break;
        case CA_HAddNoteTypeImage:
        {
            self.reuploadView.hidden = NO;
            self.reuploadButton.hidden = YES;
            _stateLabel.textColor = CA_H_4BLACKCOLOR;
            _stateLabel.text = @"上传中0%";
            addFileModel.progressBlock = ^(double progress) {
                CA_H_StrongSelf(self);
                if (progress == 2) {
                    
                    if (self.addFileModel.isFinish) {
                        self.reuploadView.hidden = YES;
                        self.contentModel.file_url = self.addFileModel.file_url;
                        self.contentModel.file_name = self.addFileModel.fileName;
                        self.contentModel.file_id = self.addFileModel.file_id;
                        self.contentModel.file_size = self.addFileModel.size;
                        NSArray *typeArr = [self.contentModel.file_name componentsSeparatedByString:@"."];
                        self.contentModel.file_type = typeArr.count>1?typeArr.lastObject:@"";
                    } else {
                        [self needToReupload];
                    }
                } else {
                    if (progress >= 1) {
                        progress = 0.9999;
                    }
                    CA_H_DISPATCH_MAIN_THREAD((^{
                        self.stateLabel.text = [NSString stringWithFormat:@"上传中%2ld%%", (NSInteger)(progress*100)];
                    }));
                }
            };
        }
            break;
        case CA_HAddNoteTypeRecord:
        {
            addFileModel.progressBlock = ^(double progress) {
                CA_H_StrongSelf(self);
                if (progress == 2) {
                    if (self.addFileModel.isFinish) {
                        self.contentModel.file_url = self.addFileModel.file_url;
                        self.contentModel.file_name = self.addFileModel.fileName;
                        self.contentModel.file_id = self.addFileModel.file_id;
                        self.contentModel.file_size = self.addFileModel.size;
                        NSArray *typeArr = [self.contentModel.file_name componentsSeparatedByString:@"."];
                        self.contentModel.file_type = typeArr.count>1?typeArr.lastObject:@"";
                        CA_H_DISPATCH_MAIN_THREAD((^{
                            self.stateLabel.textColor = UIColorHex(0x4CD964);
                            self.stateLabel.text = @"（上传成功）";
                        }));
                    } else {
                        [self needToReupload];
                    }
                } else {
                    if (progress >= 1) {
                        progress = 0.9999;
                    }
                    CA_H_DISPATCH_MAIN_THREAD((^{
                        self.stateLabel.text = [NSString stringWithFormat:@"（上传中%2ld%%）", (NSInteger)(progress*100)];
                    }));
                }
            };
        }
            break;
        default:
            break;
    }
}

- (CA_HAddNoteManager *(^)(void))start {
    if (!_start) {
        CA_H_WeakSelf(self);
        _start = ^CA_HAddNoteManager * {
            CA_H_StrongSelf(self);
            
            switch (self.contentModel.enumType) {
                case CA_HAddNoteTypeRecord:{
                    
                    [CA_H_MANAGER startRecord];
                    self.contentModel.file_name = CA_H_MANAGER.recordFileName;
                    // 获得队列
                    dispatch_queue_t queue = dispatch_get_main_queue();
                    
                    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
                    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    
                    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
                    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
                    // 何时开始执行第一个任务
                    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
                    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
                    dispatch_source_set_timer(self.timer, start, interval, 0);
                    
                    // 设置回调
                    CA_H_WeakSelf(self);
                    dispatch_source_set_event_handler(self.timer, ^{
                        NSLog(@"------------%@", [NSThread currentThread]);
                        CA_H_StrongSelf(self);
                        NSInteger currentTime = CA_H_MANAGER.recorder.currentTime;
                        NSString * newStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",currentTime/3600, currentTime%3600/60, currentTime%60];
                        self.rightLabel.text = newStr;
                        
                        if (currentTime >= 2*3600) {
                            if (self.recordStopBlock) {
                                self.recordStopBlock();
                            }
                        }
                        
                    });
                    
                    // 启动定时器
                    dispatch_resume(self.timer);
                }break;
                case CA_HAddNoteTypeFile:{
                    
                    
                }break;
                default:
                    break;
            }
            
            return self;
        };
    }
    return _start;
}

- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [UIView new];
        
        CA_HProgressView * progressView = [CA_HProgressView new];
        
//        progressView.progressColor = CA_H_TINTCOLOR;
//        progressView.progressRemainingColor = CA_H_TINTCOLOR;
//        progressView.lineColor = CA_H_BACKCOLOR;
        
        _progressHud = progressView;
        
        [_progressView addSubview:progressView];
        progressView.sd_layout
        .widthIs(238*CA_H_RATIO_WIDTH)
        .heightIs(3*CA_H_RATIO_WIDTH)
        .centerYEqualToView(_progressView)
        .leftEqualToView(_progressView);
        
        UIButton * cencel = [UIButton new];
        [cencel setBackgroundImage:[UIImage imageNamed:@"x "] forState:UIControlStateNormal];
        [cencel addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView addSubview:cencel];
        cencel.sd_layout
        .widthIs(18*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(_progressView)
        .rightSpaceToView(_progressView, 15*CA_H_RATIO_WIDTH);
        
        _progressLabel = [UILabel new];
        _progressLabel.font = CA_H_FONT_PFSC_Regular(12);
        _progressLabel.textColor = CA_H_9GRAYCOLOR;
        [_progressView addSubview:_progressLabel];
        _progressLabel.sd_layout
        .topEqualToView(_progressView)
        .leftEqualToView(_progressView)
        .autoHeightRatio(0);
        [_progressLabel setMaxNumberOfLinesToShow:1];
        [_progressLabel setSingleLineAutoResizeWithMaxWidth:238*CA_H_RATIO_WIDTH];
    }
    return _progressView;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        UIButton * deleteButton = [UIButton new];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_icon 2"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:deleteButton];
        
        deleteButton.sd_layout
        .widthIs(28*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .rightSpaceToView(self.contentView, (self.contentModel.enumType != CA_HAddNoteTypeImage?15:10)*CA_H_RATIO_WIDTH)
        .bottomSpaceToView(self.contentView, (self.contentModel.enumType != CA_HAddNoteTypeImage?25:20)*CA_H_RATIO_WIDTH);
        
        _deleteButton = deleteButton;
    }
    return _deleteButton;
}


- (UIView *)contentView {
    if (!_contentView) {
        
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
        
        switch (_contentModel.enumType) {
            case CA_HAddNoteTypeImage:{
                UIImageView * imageView = [UIImageView new];
                imageView.backgroundColor = CA_H_F4COLOR;
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                
                if (_contentModel.file) {
                    imageView.image = _contentModel.file;
                } else {
                    CA_H_WeakSelf(self);
                    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, _contentModel.file_url]] placeholder:nil options:YYWebImageOptionShowNetworkActivity|YYWebImageOptionProgressive|YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                        CA_H_StrongSelf(self);
                        if (image) {
                            self.contentModel.file = image;
                        }
                    }];
                }
                
                
                if (_myShowDelete) {
                    _contentView.frame = CGRectMake(0, 0, 335*CA_H_RATIO_WIDTH, 110*CA_H_RATIO_WIDTH);
                }else{
                    CGSize size = imageView.image.size;
                    if (size.height&&size.width) {
                        _contentView.frame = CGRectMake(0, 0, 335*CA_H_RATIO_WIDTH, (335./size.width*size.height+20)*CA_H_RATIO_WIDTH);
                    }else{
                        _contentView.frame = CGRectMake(0, 0, 335*CA_H_RATIO_WIDTH, 110*CA_H_RATIO_WIDTH);
                    }
                    
                }
                
                [_contentView addSubview:imageView];
                imageView.sd_layout
                .spaceToSuperView(UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 0, 10*CA_H_RATIO_WIDTH, 0));
                
                self.deleteButton.hidden = NO;
            }break;
            default:{
                
                _contentView.frame = CGRectMake(0, 0, 335*CA_H_RATIO_WIDTH, 78*CA_H_RATIO_WIDTH);
                [CA_HShadow dropShadowWithView:_contentView
                                        bounds:CGRectMake(0, 10*CA_H_RATIO_WIDTH, 341*CA_H_RATIO_WIDTH, 64*CA_H_RATIO_WIDTH)
                                  cornerRadius:5*CA_H_RATIO_WIDTH
                                        offset:CGSizeMake(-3*CA_H_RATIO_WIDTH, -3*CA_H_RATIO_WIDTH) radius:5*CA_H_RATIO_WIDTH
                                         color:[CA_H_SHADOWCOLOR colorWithAlphaComponent:0.5]
                                       opacity:0.4];
                
                UIView * view = [UIView new];
                [_contentView addSubview:view];
                view.sd_layout
                .spaceToSuperView(UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 0, 10*CA_H_RATIO_WIDTH, 0));
                view.sd_cornerRadius = @(5*CA_H_RATIO_WIDTH);
                
                view.backgroundColor = [UIColor whiteColor];
                
                
                _imageView = [YYAnimatedImageView new];
                [view addSubview:_imageView];
                _imageView.sd_layout
                .widthIs(24*CA_H_RATIO_WIDTH)
                .heightEqualToWidth()
                .centerYEqualToView(view)
                .leftSpaceToView(view, 13*CA_H_RATIO_WIDTH);
                
                _contentLabel = [UILabel new];
                _contentLabel.font = CA_H_FONT_PFSC_Regular(16);
                _contentLabel.numberOfLines = 1;
                [view addSubview:_contentLabel];
                _contentLabel.sd_layout
                .leftSpaceToView(view, 50*CA_H_RATIO_WIDTH)
                .topSpaceToView(view, 18*CA_H_RATIO_WIDTH)
                .autoHeightRatio(0);
                [_contentLabel setSingleLineAutoResizeWithMaxWidth:116*CA_H_RATIO_WIDTH];
                [_contentLabel setMaxNumberOfLinesToShow:1];
                
                [view addSubview:self.stateLabel];
                self.stateLabel.sd_layout
                .centerYEqualToView(_contentLabel)
                .leftSpaceToView(_contentLabel, 5*CA_H_RATIO_WIDTH)
                .autoHeightRatio(0);
                [self.stateLabel setSingleLineAutoResizeWithMaxWidth:120*CA_H_RATIO_WIDTH];
                [self.stateLabel setMaxNumberOfLinesToShow:1];
                
                self.deleteButton.hidden = YES;
                
                
                if (_contentModel.enumType == CA_HAddNoteTypeRecord) {
                    
                    YYImage *image = [YYImage imageNamed:@"28"];
                    _imageView.image = image;
                    
                    _contentLabel.textColor = CA_H_9GRAYCOLOR;
                    _contentLabel.text = CA_H_LAN(@"正在录音…");
                    
                    _rightLabel = [UILabel new];
                    _rightLabel.textAlignment = NSTextAlignmentRight;
                    _rightLabel.font = CA_H_FONT_PFSC_Light(16);
                    _rightLabel.textColor = CA_H_TINTCOLOR;
                    _rightLabel.text = @"00:00:00";
                    
                    [view addSubview:_rightLabel];
                    _rightLabel.sd_layout
                    .centerYEqualToView(view)
                    .rightSpaceToView(view, 15*CA_H_RATIO_WIDTH)
                    .autoHeightRatio(0);
                }else {
                    
                    _imageView.image = [UIImage imageNamed:@"attachment_icon"];
                    
                    _contentLabel.textColor = CA_H_4BLACKCOLOR;
                    _contentLabel.hidden = NO;
                    
                    [view addSubview:self.progressView];
                    self.progressView.sd_layout
                    .heightIs(40*CA_H_RATIO_WIDTH)
                    .leftSpaceToView(view, 50*CA_H_RATIO_WIDTH)
                    .bottomEqualToView(view)
                    .rightEqualToView(view);
                }
                
            }break;
        }
        
        CA_H_WeakSelf(self);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            CA_H_StrongSelf(self);
            if (self.clickBlock) {
                self.clickBlock(self);
            }
        }];
        [_contentView addGestureRecognizer:tap];
        
        
        [self addContentViewToTextView];
        
        if (_isEdit) {
            self.start();
        }else{
            self.show();
        }
        
    }
    
    return _contentView;
}


#pragma mark --- LifeCircle

- (void)dealloc{
    NSLog(@"%@ 成功释放", self.class);
}

#pragma mark --- Custom

- (void)addContentViewToTextView{
    YYTextView * textView = _textView;
    
    NSMutableAttributedString * attachText = [NSMutableAttributedString attachmentStringWithContent:_contentView contentMode:UIViewContentModeCenter attachmentSize:_contentView.size alignToFont:CA_H_FONT_PFSC_Regular(15) alignment:YYTextVerticalAlignmentCenter];
    
    
    [attachText insertString:@"\n" atIndex:0];
    [attachText appendString:@"\n"];
    
    [attachText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:YES] range:attachText.rangeOfAll];
    
    
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    
    if (textView.selectedRange.location >= 2) {
        NSString * str = CA_H_EDITNOTE;
        NSRange contentRange = NSMakeRange(textView.selectedRange.location - 2, str.length);
        if (contentRange.location + contentRange.length <= textView.text.length) {
            NSString * subStr = [textView.text substringWithRange:contentRange];
            if ([subStr isEqualToString:str]) {
                textView.selectedRange = NSMakeRange(contentRange.location + contentRange.length, 0);
            }
        }
    }
    
    NSRange selectedRange = textView.selectedRange;
    
    NSString * subStr = [text.string substringToIndex:selectedRange.location];
    NSArray * countArray = [subStr componentsSeparatedByString:CA_H_EDITNOTE];
    
    [_myContentArray insertObject:self atIndex:countArray.count - 1];
    
    [text replaceCharactersInRange:selectedRange withAttributedString:attachText];
    
    text.font = CA_H_FONT_PFSC_Regular(15);
    text.lineSpacing = 6*CA_H_RATIO_WIDTH;
    text.color = CA_H_4BLACKCOLOR;
    
    selectedRange.location += attachText.length;
    selectedRange.length = 0;
    
    textView.attributedText = text;
    textView.selectedRange = selectedRange;
}


#pragma mark --- 转换格式

- (void)formatToMp3:(NSString *)path fileName:(NSString *)fileName {
    
    
    NSString *cafFilePath = [path stringByAppendingString:fileName];
    
    NSString *mp3FileName = [fileName stringByReplacingOccurrencesOfString:@".wav" withString:@".mp3"];
    
    NSString *mp3FilePath = [path stringByAppendingPathComponent:mp3FileName];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [self performSelectorOnMainThread:@selector(convertMp3Finish:)
                               withObject:mp3FilePath
                            waitUntilDone:YES];
    }
}

- (void)convertMp3Finish:(NSString *)filePath {
    
    CA_HAddFileModel *model = [CA_HAddFileModel new];
    model.type = CA_H_AddFileTypeRecord;
    model.filePath = filePath;
    
    CA_H_WeakSelf(self);
    [self.updateFileManager saveToTmp:model success:^{
        CA_H_StrongSelf(self);
        
        [self.updateFileManager update:model];
        self.addFileModel = model;
    } failed:^{
        CA_H_StrongSelf(self);
        [self needToReupload];
    }];
    
//    [self.updateFileManager.contents addObject:model];
//    self.updateFileManager.updateBlock();
//    self.addFileModel = model;
}


#pragma mark --- 重传逻辑

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        UILabel *label = [UILabel new];
        _stateLabel = label;
        
        label.font = CA_H_FONT_PFSC_Regular(14);
        label.textColor = UIColorHex(0x4CD964);
        label.numberOfLines = 1;
    }
    return _stateLabel;
}

- (UIView *)reuploadView {
    if (!_reuploadView) {
        switch (self.contentModel.enumType) {
            case CA_HAddNoteTypeImage:
            {
                UIView *view = [UIView new];
                _reuploadView = view;
                view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
                
                UILabel *label = [UILabel new];
                _stateLabel = label;
                label.font = CA_H_FONT_PFSC_Regular(14);
                label.numberOfLines = 1;
                [view addSubview:label];
                label.sd_layout
                .spaceToSuperView(UIEdgeInsetsMake(40*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 40*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
                
                UIButton *button = [UIButton new];
                self.reuploadButton = button;
                [button setBackgroundImage:[UIImage imageNamed:@"reupload"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(onReupload:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                button.sd_layout
                .widthIs(28*CA_H_RATIO_WIDTH)
                .heightEqualToWidth()
                .bottomSpaceToView(view, 20*CA_H_RATIO_WIDTH)
                .rightSpaceToView(view, 53*CA_H_RATIO_WIDTH);
                
                
                [self.contentView insertSubview:view belowSubview:self.deleteButton];
                view.sd_layout
                .spaceToSuperView(UIEdgeInsetsZero);
                
            }
                break;
                
            default:
            {
                UIButton *button = [UIButton new];
                _reuploadView = button;
                
                [button setBackgroundImage:[UIImage imageNamed:@"reupload"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(onReupload:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView addSubview:button];
                button.sd_layout
                .widthIs(28*CA_H_RATIO_WIDTH)
                .heightEqualToWidth()
                .rightSpaceToView(self.contentView, 58*CA_H_RATIO_WIDTH)
                .bottomSpaceToView(self.contentView, 25*CA_H_RATIO_WIDTH);
            }
                break;
        }
    }
    return _reuploadView;
}

- (void)needToReupload {
    CA_H_WeakSelf(self);
    CA_H_DISPATCH_MAIN_THREAD(^{
        CA_H_StrongSelf(self);
        self.reuploadView.hidden = NO;
        self.stateLabel.textColor = UIColorHex(0xDC5656);
        if (self.contentModel.enumType != CA_HAddNoteTypeImage) {
            if (self.contentModel.enumType == CA_HAddNoteTypeFile) {
                self.progressView.hidden = YES;
                self.contentLabel.text = self.addFileModel.fileName;
            } else {
                
            }
            self.deleteButton.hidden = NO;
            self.stateLabel.text = @"（上传失败）";
        } else {
            self.reuploadButton.hidden = NO;
            _stateLabel.text = @"图片上传失败，点击重试";
        }
    })
}

- (void)onReupload:(UIButton *)sender {
    
    if (self.contentModel.enumType != CA_HAddNoteTypeImage) {
        self.reuploadView.hidden = YES;
        if (self.contentModel.enumType == CA_HAddNoteTypeFile) {
            self.progressView.hidden = NO;
            self.progressHud.progress = 0;
            self.contentLabel.text = nil;
            self.deleteButton.hidden = YES;
            self.stateLabel.text = nil;
            NSMutableString *progressText = [NSMutableString stringWithFormat:@"%@（%@）", self.addFileModel.fileName, self.addFileModel.fileSize?:@"0K"];
            [progressText appendString:@" %2ld%%"];
            self.progressLabel.text = [NSString stringWithFormat:progressText, 0];
        } else {
            self.stateLabel.textColor = CA_H_4BLACKCOLOR;
            self.stateLabel.text = @"（上传中0%）";
        }
    } else {
        self.reuploadView.hidden = NO;
        self.reuploadButton.hidden = YES;
        _stateLabel.textColor = CA_H_4BLACKCOLOR;
        _stateLabel.text = @"上传中0%";
    }
    
    CA_H_WeakSelf(self);
    [self.updateFileManager saveToTmp:self.addFileModel success:^{
        CA_H_StrongSelf(self);
        [self.updateFileManager update:self.addFileModel];
    } failed:^{
        CA_H_StrongSelf(self);
        [self needToReupload];
    }];
}

@end
