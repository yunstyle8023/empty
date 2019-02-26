//
//  CA_MProjectProgressVC.h
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/21.
//  God bless me without no bugs.
//

#import "CA_HBaseViewController.h"
#import "CA_MSelectModelDetail.h"

@interface CA_MAddProjectVC : CA_HBaseViewController
@property (nonatomic,strong) CA_MSelectModelDetail *detailModel;
@property (nonatomic,assign,getter=isFind) BOOL find;
@end
