//
//  CA_HLongViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/18.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HLongViewModel.h"

#import "CA_HAddNoteManager.h"
#import "CA_HNoteFileView.h"

#import <WXApi.h>

@interface CA_HLongViewModel ()

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@property (nonatomic, strong) NSMutableDictionary *cellsDic;

@end

@implementation CA_HLongViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (NSString *)title {
    return CA_H_LAN(@"图片预览");
}

- (void)cancelImageRequest {
    [_imageView cancelCurrentImageRequest];
//    [_task cancel];
//    _task = nil;
}

- (void)loadImage:(NSNumber *)noteId success:(void(^)(UIImageView *imageView))success failed:(void(^)(void))failed {
    
    if (!noteId.integerValue) {
        if (failed) failed();
        return;
    }
    
    /*
    CA_H_WeakSelf(self);
    _task =
    [CA_HNetManager downloadUrlStr:CA_H_Api_NoteImage(noteId) path:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.jpg", noteId]] callBack:^(CA_HNetModel *netModel) {
        
        NSData *data = [NSData dataWithContentsOfURL:netModel.filePath];
        UIImage *image = [UIImage imageWithData:data];
        
        if (!netModel.error&&image) {
            CA_H_StrongSelf(self);
            self.image = image;
            self.imageView.image = image;
            self.imageView.width = CA_H_SCREEN_WIDTH;
            self.imageView.height = self.imageView.width*image.size.height/(1.0*image.size.width);
            
            CA_H_WeakSelf(self);
            CA_H_DISPATCH_MAIN_THREAD(^{
                CA_H_StrongSelf(self);
                if (success) success(self.imageView);
            });
        } else {
            if (netModel.error.code != -999) {
                if (failed) failed();
            }
        }
        
    } progress:nil];
    */


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, CA_H_Api_NoteImage(noteId)]];

    YYWebImageManager *manager = [YYWebImageManager sharedManager];

    manager.timeout = 120;

    NSString* token = CA_H_MANAGER.getToken;
    if (token.length) {
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:manager.headers];
        [headers setObject:token forKey:@"token"];
        manager.headers = headers;
    } else {
        if (failed) failed();
        return;
    }
    
    CA_H_WeakSelf(self);
    [self.imageView setImageWithURL:url placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {

        if (!error && image) {
            CA_H_StrongSelf(self);
            self.image = image;
            self.imageView.width = CA_H_SCREEN_WIDTH;
            self.imageView.height = self.imageView.width*image.size.height/(1.0*image.size.width);
            
            CA_H_WeakSelf(self);
            CA_H_DISPATCH_MAIN_THREAD(^{
                CA_H_StrongSelf(self);
                if (success) success(self.imageView);
            });
        } else {
            if (error.code != -999) {
                if (failed) failed();
            }
        }
        
    }];
}

- (UIImageView *)imageViewWithImage:(UIImage *)image type:(CA_HLongType)type {
    _image = image;
    self.imageView.image = image;
    switch (type) {
        case CA_HLongTypeFound:
            self.imageView.width = CA_H_SCREEN_WIDTH-20*CA_H_RATIO_WIDTH;
            self.imageView.height = self.imageView.width*image.size.height/(1.0*image.size.width);
            self.imageView.left = 10*CA_H_RATIO_WIDTH;
            self.imageView.top = 10*CA_H_RATIO_WIDTH;
            self.contentSize = CGSizeMake(self.imageView.width+20*CA_H_RATIO_WIDTH, self.imageView.height+20*CA_H_RATIO_WIDTH);
            break;
        default:
            self.imageView.width = CA_H_SCREEN_WIDTH;
            self.imageView.height = self.imageView.width*image.size.height/(1.0*image.size.width);
            self.contentSize = self.imageView.size;
            break;
    }
    
    return self.imageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [UIImageView new];
        _imageView = imageView;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.frame = CGRectZero;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIScrollView *(^)(BOOL))scrollViewBlock {
    if (!_scrollViewBlock) {
        CA_H_WeakSelf(self);
        _scrollViewBlock = ^UIScrollView *(BOOL isImage) {
            CA_H_StrongSelf(self);
            UIScrollView * scrollView = [UIScrollView new];
            scrollView.backgroundColor = CA_H_BACKCOLOR;
            scrollView.bounces = NO;
            [scrollView addSubview:self.imageView];
            return scrollView;
        };
    }
    return _scrollViewBlock;
}

- (UIView *(^)(id, SEL))bottomViewBlock{
    if (!_bottomViewBlock) {
        CA_H_WeakSelf(self);
        _bottomViewBlock = ^UIView *(id delegate, SEL action) {
            CA_H_StrongSelf(self);
            UIView * view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            
            CA_H_WeakSelf(self);
            CA_H_WeakSelf(view);
            view.didFinishAutoLayoutBlock = ^(CGRect frame) {
                CA_H_StrongSelf(self);
                CA_H_StrongSelf(view);
                [CA_HShadow dropShadowWithView:view
                                        offset:CGSizeMake(0, -3)
                                        radius:3
                                         color:CA_H_SHADOWCOLOR
                                       opacity:0.3];
                self.tableView.height = frame.origin.y;
            };
            
            UIButton * leftBtn = [self buttonWithTitle:CA_H_LAN(@"发送给微信好友") imageName:@"WeChat_icon" tag:100];
            [leftBtn addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
            UIButton * rightBtn = [self buttonWithTitle:CA_H_LAN(@"保存到本地") imageName:@"save_icon" tag:101];
            [rightBtn addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:rightBtn];
            
            if ([WXApi isWXAppInstalled]) {
                [view addSubview:leftBtn];
                
                leftBtn.sd_layout
                .widthIs(105*CA_H_RATIO_WIDTH)
                .leftSpaceToView(view, 52*CA_H_RATIO_WIDTH)
                .topEqualToView(view)
                .bottomEqualToView(view);
                
                rightBtn.sd_layout
                .widthIs(105*CA_H_RATIO_WIDTH)
                .rightSpaceToView(view, 52*CA_H_RATIO_WIDTH)
                .topEqualToView(view)
                .bottomEqualToView(view);
                
            }else {
                rightBtn.sd_layout
                .widthIs(105*CA_H_RATIO_WIDTH)
                .centerXEqualToView(view)
                .topEqualToView(view)
                .bottomEqualToView(view);
            }
            
            return view;
        };
    }
    return _bottomViewBlock;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName tag:(NSInteger)tag{
    UIButton * button = [UIButton new];
    
    button.tag = tag;
    
    [button.imageView sd_clearAutoLayoutSettings];
    [button.titleLabel sd_clearAutoLayoutSettings];
    
    button.imageView.sd_resetLayout
    .widthIs(45*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .topSpaceToView(button, 20*CA_H_RATIO_WIDTH)
    .centerXEqualToView(button);
    
    button.titleLabel.sd_resetLayout
    .topSpaceToView(button.imageView, 10*CA_H_RATIO_WIDTH)
    .centerXEqualToView(button)
    .autoHeightRatio(0);
    [button.titleLabel setMaxNumberOfLinesToShow:1];
    [button.titleLabel setSingleLineAutoResizeWithMaxWidth:100*CA_H_RATIO_WIDTH];
    
    
    [button.titleLabel setFont:CA_H_FONT_PFSC_Regular(12)];
    [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    
    return button;
}

- (CIImage *)generateQRCodeFilter:(NSString *)content {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];              //通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];      //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    
    //设置背景颜色和填充颜色 默认白色背景黑色填充
    
    
    CIImage * outputImage = [filter.outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    CIColor *color0 = [CIColor colorWithCGColor:CA_H_TINTCOLOR.CGColor];
    CIColor *color1 = [CIColor colorWithCGColor:[UIColor clearColor].CGColor];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                outputImage, @"inputImage",
                                color0, @"inputColor0",
                                color1, @"inputColor1", nil];
    CIFilter *newFilter = [CIFilter filterWithName:@"CIFalseColor" withInputParameters:parameters];
    
    return newFilter.outputImage;                  //拿到二维码图片
}

#pragma mark --- 新的生成长图

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        
        UIView *footer = [UIView new];
        footer.backgroundColor = [UIColor whiteColor];
        footer.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 250*CA_H_RATIO_WIDTH);
        
        UIImageView *footerImageView = [UIImageView new];
        footerImageView.frame = CGRectMake(0, 190*CA_H_RATIO_WIDTH, CA_H_SCREEN_WIDTH, 60*CA_H_RATIO_WIDTH);
        footerImageView.image = [UIImage imageNamed:@"pic_footer"];
        
        
        UIImageView *codeImageView = [UIImageView new];
        codeImageView.frame = CGRectMake((CA_H_SCREEN_WIDTH-100*CA_H_RATIO_WIDTH)/2.0, 40*CA_H_RATIO_WIDTH, 100*CA_H_RATIO_WIDTH, 100*CA_H_RATIO_WIDTH);
        codeImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *image = [UIImage imageNamed:@"Page 1"];//[UIImage imageWithCIImage:[self generateQRCodeFilter:@"https://www.baidu.com"]];
        codeImageView.image = image;
        
        [footer addSubview:footerImageView];
        [footer addSubview:codeImageView];
        
        tableView.tableFooterView = footer;
        tableView.backgroundColor = CA_H_BACKCOLOR;
        tableView.bounces = NO;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableDictionary *)cellsDic {
    if (!_cellsDic) {
        _cellsDic = [NSMutableDictionary new];
    }
    return _cellsDic;
}

- (void)setDetailDic:(NSDictionary *)detailDic {
    if (self.model) {
        [self.model modelSetWithDictionary:detailDic];
    } else {
        self.model = [CA_HNoteDetailModel modelWithDictionary:detailDic];
    }
    
    [self reloadCellsData:self.model];
    
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self.tableView reloadData];
    });
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
    
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:model.ts_create.doubleValue];
    
    UILabel *timeLayer = [UILabel new];
    timeLayer.font = CA_H_FONT_PFSC_Regular(14);
    timeLayer.textColor = CA_H_9GRAYCOLOR;
    timeLayer.text = [createDate stringWithFormat:@"yyyy.MM.dd  HH:mm"];
    timeLayer.frame = CGRectMake(20*CA_H_RATIO_WIDTH, titleLabel.bottom+5*CA_H_RATIO_WIDTH, 335*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
    [cell.contentView addSubview:timeLayer];
    
    
    CALayer *line = [CALayer new];
    line.backgroundColor = CA_H_BACKCOLOR.CGColor;
    line.frame = CGRectMake(187*CA_H_RATIO_WIDTH, timeLayer.bottom+20*CA_H_RATIO_WIDTH, CA_H_RATIO_WIDTH, 120*CA_H_RATIO_WIDTH);
    [cell.contentView.layer addSublayer:line];
    
    UIImageView * imageView = [UIImageView new];
    imageView.frame = CGRectMake(68*CA_H_RATIO_WIDTH, timeLayer.bottom+42*CA_H_RATIO_WIDTH, 50*CA_H_RATIO_WIDTH, 50*CA_H_RATIO_WIDTH);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25*CA_H_RATIO_WIDTH;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlStr = model.creator.avatar;
    urlStr = ^{
        if ([urlStr hasPrefix:@"http://"]
            ||
            [urlStr hasPrefix:@"https://"]) {
            return urlStr;
        }
        return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
    }();
    CA_H_WeakSelf(self);
    [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:[UIImage imageNamed:@"head50"] options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        CA_H_StrongSelf(self);
        self->_image = nil;
    }];
    [cell.contentView addSubview:imageView];
    
    
    UILabel *nameLayer = [UILabel new];
    nameLayer.font = CA_H_FONT_PFSC_Regular(16);
    nameLayer.textAlignment = NSTextAlignmentCenter;//字体的对齐方式
    nameLayer.textColor = CA_H_4BLACKCOLOR;
    nameLayer.text = model.creator.chinese_name;
    nameLayer.frame = CGRectMake(20*CA_H_RATIO_WIDTH, imageView.bottom+5*CA_H_RATIO_WIDTH, 48*3*CA_H_RATIO_WIDTH, 22*CA_H_RATIO_WIDTH);
    [cell.contentView addSubview:nameLayer];
    
    
    CALayer *backLayer = [CALayer new];
    backLayer.backgroundColor = CA_H_F8COLOR.CGColor;
    backLayer.frame = CGRectMake(line.right+33*CA_H_RATIO_WIDTH, line.top+10*CA_H_RATIO_WIDTH, 120*CA_H_RATIO_WIDTH, 100*CA_H_RATIO_WIDTH);
    backLayer.cornerRadius = 10*CA_H_RATIO_WIDTH;
    backLayer.masksToBounds = YES;
    [cell.contentView.layer addSublayer:backLayer];
    
    
    UILabel *titleLayer = [UILabel new];
    titleLayer.font = CA_H_FONT_PFSC_Regular(12);
    titleLayer.textAlignment = NSTextAlignmentCenter;
    titleLayer.textColor = CA_H_9GRAYCOLOR;
    titleLayer.text = CA_H_LAN(@"读完需要");
    titleLayer.frame = CGRectMake(backLayer.left+30*CA_H_RATIO_WIDTH, backLayer.top+8*CA_H_RATIO_WIDTH, 60*CA_H_RATIO_WIDTH, 17*CA_H_RATIO_WIDTH);
    [cell.contentView addSubview:titleLayer];
    
    
    UILabel *showLayer = [UILabel new];
    showLayer.font = CA_H_FONT_PFSC_Regular(36);
    showLayer.textAlignment = NSTextAlignmentCenter;
    showLayer.textColor = CA_H_4BLACKCOLOR;
    showLayer.text = model.reading_time.stringValue;
    showLayer.frame = CGRectMake(backLayer.left+10*CA_H_RATIO_WIDTH, backLayer.top+25*CA_H_RATIO_WIDTH, 100*CA_H_RATIO_WIDTH, 50*CA_H_RATIO_WIDTH);
    [cell.contentView addSubview:showLayer];
    

    UILabel *unitLayer = [UILabel new];
    unitLayer.font = CA_H_FONT_PFSC_Regular(12);
    unitLayer.textAlignment = NSTextAlignmentCenter;
    unitLayer.textColor = CA_H_9GRAYCOLOR;
    unitLayer.text = CA_H_LAN(@"分钟");
    unitLayer.frame = CGRectMake(backLayer.left+45*CA_H_RATIO_WIDTH, backLayer.top+75*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH, 17*CA_H_RATIO_WIDTH);
    [cell.contentView addSubview:unitLayer];
    
    
    model.cellHeight = (rect.size.height+185*CA_H_RATIO_WIDTH);
    
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
    CA_H_WeakSelf(self);
    [imageView setImageWithURL:url placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        [label removeFromSuperviewAndClearAutoLayoutSettings];
        CA_H_StrongSelf(imageView);
        CA_H_StrongSelf(self);
        if (image) {
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = image;
        } else {
            imageView.contentMode = UIViewContentModeCenter;
            imageView.image = [UIImage imageNamed:@"loadfail_pic2"];
        }
        self->_image = nil;
    }];
    
    model.cellHeight = imageView.height+20*CA_H_RATIO_WIDTH;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    [self.cellsDic setValue:cell forKey:[NSString stringWithFormat:@"%@", indexPath]];
}

- (void)reloadCellsData:(CA_HNoteDetailModel *)model {
    
    [self titleCellData:model];
    
    for (CA_HNoteDetailContentModel *detailModel in model.content) {
        if ([detailModel.type isEqualToString:@"string"]) {// 文本
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
        }
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath model:(CA_HNoteDetailModel *)model {
    if (indexPath.section == 0) {
        return model.cellHeight;
    } else if (indexPath.section == 1) {
        if (indexPath.row < model.content.count) {
            return model.content[indexPath.row].cellHeight;
        }
    }
    return 0;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(CA_HNoteDetailModel *)model {
    CA_HBaseTableCell *cell = [self.cellsDic valueForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (!cell) {
        if (indexPath.section == 1) {
            CA_HNoteDetailContentModel *detailModel = model.content[indexPath.row];
            NSString *identifier = [NSString stringWithFormat:@"%@",detailModel.type];
            cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CA_HNoteDetailAttachCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if (indexPath.row<model.content.count) {
                cell.model = model.content[indexPath.row];
            }
        } 
    }
    return cell;
}

- (UIImage *)image {
    if (!_image) {
        [self.tableView layoutIfNeeded];
        CGSize resultSize = self.tableView.contentSize;
        
        NSMutableArray *images = [NSMutableArray new];
        for (NSInteger i=0; i<[self.tableView numberOfSections]; i++) {
            for (NSInteger j=0; j<[self.tableView numberOfRowsInSection:i]; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                
                CA_HBaseTableCell *cell = [self.cellsDic valueForKey:[NSString stringWithFormat:@"%@", indexPath]];
                if (!cell) {
                    if (i == 1 && j<self.model.content.count) {
                        CA_HNoteDetailContentModel *detailModel = self.model.content[j];
                        cell = [[CA_HNoteDetailAttachCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailModel.type];
                        cell.model = detailModel;
                    } else {
                        cell = [CA_HNoteDetailAttachCell new];
                    }
                }
                cell.size = CGSizeMake(CA_H_SCREEN_WIDTH, [self heightForRowAtIndexPath:indexPath model:self.model]);
                
                UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
                [cell.layer renderInContext: UIGraphicsGetCurrentContext()];
                cell.layer.contents = nil;//释放
                UIImage *cellImage =UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [images addObject:cellImage];
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(self.tableView.tableFooterView.bounds.size, NO, 0);
        [self.tableView.tableFooterView.layer renderInContext: UIGraphicsGetCurrentContext()];
        self.tableView.tableFooterView.layer.contents = nil;//释放
        UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [images addObject:image];
        
        _image =
        [UIImage imageWithSize:resultSize drawBlock:^(CGContextRef  _Nonnull context) {
            UIGraphicsPushContext(context);
            CGRect rect = CGRectZero;
            for (UIImage *image in images) {
                rect.size = image.size;
                [image drawInRect:rect];
                rect.origin.y += image.size.height;
            }
            UIGraphicsPopContext();
        }];

        
    }
    return _image;
}

@end
