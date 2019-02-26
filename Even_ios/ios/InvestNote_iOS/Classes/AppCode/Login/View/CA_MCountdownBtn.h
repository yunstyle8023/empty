//
//  CA_M_CountdownBtn.h
//  ceshi
//  Created by yezhuge on 2017/11/18.
//  God bless me without no bugs.
//

#import <UIKit/UIKit.h>
@protocol CA_MCountdownBtnDelegate <NSObject>
@optional
-(void)getVerifyCode;
-(void)startCount;
-(void)didEndCount;
@end
/**
 倒计时button
 */
@interface CA_MCountdownBtn : UIButton
/// 是否开启验证码
@property (nonatomic, assign) BOOL isVerificationCode;
@property(nonatomic,weak)id<CA_MCountdownBtnDelegate> delegate;
/// 验证码倒计时时长
@property (nonatomic, assign) NSInteger durationOfCountDown;

- (void)startCountDown;

- (void)startCountDownWithVerificationCode;

- (void)countOver;

@end
