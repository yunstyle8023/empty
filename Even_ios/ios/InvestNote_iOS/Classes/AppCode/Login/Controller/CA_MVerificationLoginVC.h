//
//  CA_M_ VerificationVC.h
//  ceshi
//  Created by yezhuge on 2017/11/18.
//  God bless me without no bugs.
//

#import "CA_HBaseViewController.h"

typedef enum : NSUInteger {
    Type_PhoneLogin,
    Type_BindPhone,
    Type_ForgetPwd,
    Type_Register
} BindType;

@interface CA_MVerificationLoginVC : CA_HBaseViewController
/// 显示的标题
@property(nonatomic,copy)NSString* titleStr;
/// 手机号
@property(nonatomic,copy)NSString* phoneNumStr;

@property(nonatomic,copy)NSString* organizationName;
@property(nonatomic,strong)NSNumber* organizationId;
/// 登录按钮显示的文字
@property(nonatomic,copy)NSString* loginStr;

@property (nonatomic,assign) BindType bindType;

@property (nonatomic,strong) NSMutableDictionary *registerParms;

@end
