//
//  CA_MSelectCell.h
//  InvestNote_iOS
//  Created by yezhuge on 2017/11/29.
//  God bless me without no bugs.
//

#import <UIKit/UIKit.h>

@interface CA_MSelectCell : UITableViewCell
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UILabel* selectLb;
@property(nonatomic,strong)UIImageView* arrowImgView;
@property(nonatomic,strong)UIView* lineView;
- (void)configCell:(NSString*)title :(NSString*)selectStr;
@end
