//
//  CA_M_CountdownBtn.m
//  ceshi
//  Created by yezhuge on 2017/11/18.
//  God bless me without no bugs.
//

#import "CA_MCountdownBtn.h"

@interface CA_MCountdownBtn()
/// 保存倒计时按钮的非倒计时状态的title
@property (nonatomic, copy) NSString *originalTitle;

/// 保存倒计时的时长
@property (nonatomic, assign) NSInteger tempDurationOfCountDown;

/// 定时器对象
@property (nonatomic, strong) NSTimer *countDownTimer;

@end

@implementation CA_MCountdownBtn

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 设置默认的倒计时时长为60秒
        self.durationOfCountDown = 60;
        // 设置button的默认标题为“获取验证码”
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        self.isVerificationCode = YES;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    // 倒计时过程中title的改变不更新originalTitle
    if (self.tempDurationOfCountDown == self.durationOfCountDown) {
        self.originalTitle = title;
    }
}

- (void)setDurationOfCountDown:(NSInteger)durationOfCountDown {
    _durationOfCountDown = durationOfCountDown;
    self.tempDurationOfCountDown = _durationOfCountDown;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // 若正在倒计时，不响应点击事件
    if (self.tempDurationOfCountDown != self.durationOfCountDown) {
        return NO;
    }
    if (self.isVerificationCode) {
        // 若未开始倒计时，响应并传递点击事件，开始倒计时
        [self startCountDown];
    }else{
        [self startCountDownWithVerificationCode];
    }
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)startCountDown {
    self.countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateIDCountDownButtonTitle) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(startCount)]) {
        [self.delegate startCount];
    }
}

- (void)startCountDownWithVerificationCode{
    if ([self.delegate respondsToSelector:@selector(getVerifyCode)]) {
        [self.delegate getVerifyCode];
    }
}

- (void)countOver{
    [self.countDownTimer invalidate];
    self.tempDurationOfCountDown = 0;
    [self updateIDCountDownButtonTitle];
}

- (void)updateIDCountDownButtonTitle {
    if (self.tempDurationOfCountDown == 0) {
        // 设置CountDownButton的title为开始倒计时前的title
        [self setTitle:@"重新获取" forState:UIControlStateNormal];
        [self setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        // 恢复CountDownButton开始倒计时的能力
        self.tempDurationOfCountDown = self.durationOfCountDown;
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(didEndCount)]) {
            [self.delegate didEndCount];
        }
    } else {
        // 设置CountDownButton的title为当前倒计时剩余的时间
        [self setTitle:[NSString stringWithFormat:@"%zd秒后重新获取", self.tempDurationOfCountDown--] forState:UIControlStateNormal];
        [self setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
}

@end
