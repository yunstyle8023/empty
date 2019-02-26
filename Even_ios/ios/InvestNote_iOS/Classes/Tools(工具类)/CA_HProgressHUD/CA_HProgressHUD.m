//
//  CA_HProgressHUD.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HProgressHUD.h"

@implementation CA_HProgressHUD


+ (MBProgressHUD *)loading:(UIView*)rootView {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:rootView];
    hud.backgroundView.backgroundColor = [UIColor whiteColor];
    
    [rootView addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    
    UIView *customView = [UIView new];
    
    UIView *view = [UIView new];
    view.backgroundColor = CA_H_FBCOLOR;
    view.frame = CGRectMake(12*CA_H_RATIO_WIDTH, 12*CA_H_RATIO_WIDTH, 70*CA_H_RATIO_WIDTH, 70*CA_H_RATIO_WIDTH);
    [customView addSubview:view];
    view.layer.cornerRadius = 4*CA_H_RATIO_WIDTH;
    view.layer.masksToBounds = YES;
    
    UIColor *shadowColor = UIColorHex(0xDEDEDE);
    
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = view.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius = 4*CA_H_RATIO_WIDTH;
    subLayer.backgroundColor=[UIColor whiteColor].CGColor;//[shadowColor colorWithAlphaComponent:1].CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.5;//阴影透明度，默认0
    subLayer.shadowRadius = 6*CA_H_RATIO_WIDTH;//阴影半径，默认3
    
    [customView.layer insertSublayer:subLayer below:view.layer];
    
    
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:[YYImage imageNamed:@"ani"]];
    
    [view addSubview:imageView];
    imageView.sd_layout
    .widthIs(30*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .centerXEqualToView(view)
    .centerYEqualToView(view);

    [hud.backgroundView addSubview:customView];
    customView.sd_layout
    .widthIs(94*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .centerXEqualToView(hud.backgroundView)
    .topSpaceToView(hud.backgroundView, 114*CA_H_RATIO_HEIGHT);
    
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    
    [hud.backgroundView bringSubviewToFront:customView];
    
    hud.bezelView.hidden = YES;
    
    return hud;
}


+ (MBProgressHUD *)showHud:(UIView*)rootView text:(NSString*)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:rootView animated:YES];
    hud.label.text = text;
//    HUD.detailsLabelText = text;//详情
//    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    [rootView addSubview:hud];
    return hud;
}
+ (void)hideHud:(UIView*)rootView {
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self hideHud:rootView animated:YES];
    });
}
+ (void)hideHud:(UIView*)rootView animated:(BOOL)animated {
    [MBProgressHUD hideHUDForView:rootView animated:animated];
}


+ (void)showHudStr:(NSString *)str rootView:(UIView *)rootView image:(UIImage *)image {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:rootView];
//    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    [rootView addSubview:hud];
    
    UIImageView * customView = [[UIImageView alloc] initWithImage:image];
    hud.customView = customView;
    hud.mode = MBProgressHUDModeCustomView;
    
    if (image) {
        hud.detailsLabel.text = [NSString stringWithFormat:@"\n%@",str];
    }else{
        if (str.length>12) {
            hud.detailsLabel.text = str;
        } else {
            hud.label.text = str;
        }
    }
    
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2.0];
}
+ (void)showHudSuccess:(NSString *)success rootView:(UIView *)rootView {
    [self showHudStr:success rootView:rootView image:[UIImage imageNamed:@"okey"]];
}
+ (void)showHudFailed:(NSString *)failed rootView:(UIView *)rootView {
    [self showHudStr:failed rootView:rootView image:[UIImage imageNamed:@"warn"]];
}


+ (MBProgressHUD *)showHud:(NSString*)text {
    return [self showHud:CA_H_MANAGER.mainWindow text:text];
}
+ (void)hideHud {
    [self hideHud:CA_H_MANAGER.mainWindow];
}

+ (void)showHudStr:(NSString *)str image:(UIImage *)image {
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self showHudStr:str rootView:CA_H_MANAGER.mainWindow image:image];
    });
}
+ (void)showHudStr:(NSString*)str {
    [self showHudStr:str image:nil];
}
+ (void)showHudSuccess:(NSString *)success {
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self showHudSuccess:success rootView:CA_H_MANAGER.mainWindow];
    });
}
+ (void)showHudFailed:(NSString *)failed {
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self showHudFailed:failed rootView:CA_H_MANAGER.mainWindow];
    });
}


@end
