//
//  CA_MPersonDetailLogVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailLogVC.h"

#import "CA_HNoteListTebleView.h"
#import "CA_HNullView.h"

@interface CA_MPersonDetailLogVC ()

@property (nonatomic, strong) CA_HNoteListTebleView *noteTableView;
@property (nonatomic, strong) UIView *buttonView;

@end

@implementation CA_MPersonDetailLogVC

- (void)onButton:(UIButton *)sender {
    self.pushBlock(@"CA_HAddNoteViewController", @{@"humamId":self.humanID});
}

- (CA_HNoteListTebleView *)noteTableView{
    if (!_noteTableView) {
        CA_HNoteListTebleView *tableView = [CA_HNoteListTebleView newWithProjectId:self.humanID objectType:@"human"];
        _noteTableView = tableView;
        
        tableView.listNoteModel.noShow = YES;
        tableView.backgroundView = [CA_HNullView newTitle:@"记一下，好记性不如烂笔头"
                                              buttonTitle:nil
                                                      top:65*CA_H_RATIO_WIDTH
                                                 onButton:nil
                                                imageName:@"empty_note"];
        
        CA_H_WeakSelf(self);
        tableView.pushBlock = ^(NSString *classStr, NSDictionary *kvcDic) {
            CA_H_StrongSelf(self);
            if (self.pushBlock) {
                self.pushBlock(classStr, kvcDic);
            }
        };
        tableView.scrollBlock = ^(UIScrollView *scrollView) {
            CA_H_StrongSelf(self);
            [self scrollViewDidScroll:scrollView];
        };
    }
    return _noteTableView;
}

- (UITableView *)tableView {
    return self.noteTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *buttonView = [self customView:CA_H_LAN(@"添加记录") tag:101];
    _buttonView = buttonView;
    
    [self.view addSubview:buttonView];
    buttonView.sd_layout
    .widthIs(buttonView.width)
    .heightIs(buttonView.height)
    .rightSpaceToView(self.view, 13*CA_H_RATIO_WIDTH);
//    .bottomSpaceToView(self.view, 13*CA_H_RATIO_WIDTH);
//    buttonView.bottom = self.view.height - 168*CA_H_RATIO_WIDTH;
//    buttonView.bottom = CA_H_SCREEN_HEIGHT-64-CA_H_MANAGER.xheight-256*CA_H_RATIO_WIDTH-3;
    if (CA_H_MANAGER.xheight>0) {
        buttonView.bottom = CA_H_SCREEN_HEIGHT-64-CA_H_MANAGER.xheight-256*CA_H_RATIO_WIDTH-3-34.0;
    } else {
        buttonView.bottom = CA_H_SCREEN_HEIGHT-64-256*CA_H_RATIO_WIDTH-3;
    }
}

- (void)scroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 155*CA_H_RATIO_WIDTH) {
        self.buttonView.bottom = self.view.height - 13*CA_H_RATIO_WIDTH;
    } else {
        self.buttonView.bottom = self.view.height - 168*CA_H_RATIO_WIDTH + scrollView.contentOffset.y;
    }
}

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
