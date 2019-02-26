//
//  CA_MProjectSearchView.h
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/6.
//  God bless me without no bugs.
//

#import <UIKit/UIKit.h>

@protocol CA_MProjectSearchViewDelegate <NSObject>
@optional
- (void)jump2SearchPage;
@end

@interface CA_MProjectSearchView : UIView
@property(nonatomic,weak)id<CA_MProjectSearchViewDelegate> delegate;
@end
