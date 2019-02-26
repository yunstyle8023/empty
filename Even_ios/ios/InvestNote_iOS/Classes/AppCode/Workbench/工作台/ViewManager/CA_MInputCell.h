//
//  CA_MInputCell.h
//  InvestNote_iOS
//  Created by yezhuge on 2017/11/29.
//  God bless me without no bugs.
//

#import <UIKit/UIKit.h>
@class CA_MInputCell;

@protocol CA_MInputCellDelegate <NSObject>
-(void)textDidChange:(CA_MInputCell*)cell content:(NSString*)content;
@end

@interface CA_MInputCell : UITableViewCell
@property (nonatomic,weak) id<CA_MInputCellDelegate> delegate;
@property (nonatomic,assign) UIKeyboardType keyBoardType;
@property (nonatomic,assign) BOOL enabled;
- (void)configCell:(NSString*)title
              text:(NSString*)text
       placeholder:(NSString*)placeholder;
@end
