//
//  CA_HAddTodoCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAddTodoCell.h"

#import "CA_HParticipantsModel.h"

#import "CA_HTodoModel.h"

@interface CA_HAddTodoCell ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *moreLabel;

@end

@implementation CA_HAddTodoCell

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [UIView new];
        _headerView = view;
        
        [self.contentView addSubview:view];
        view.sd_layout
        .heightIs(30*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.contentView, 54*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 40*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.contentView);
    }
    return _headerView;
}

- (UIImageView *)customImageView:(NSInteger)tag {
    UIImageView *imageView = [self.headerView viewWithTag:200+tag];
    
    if (!imageView) {
        
        UIView *lastView = [self.headerView viewWithTag:199+tag];
        if (!lastView) {
            lastView = self.headerView;
        }
        
        imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = 200+tag;
        [self.headerView addSubview:imageView];
        
        imageView.sd_layout
        .leftSpaceToView(lastView, 5*CA_H_RATIO_WIDTH)
        .topEqualToView(self.headerView)
        .bottomEqualToView(self.headerView)
        .widthEqualToHeight();
        
        imageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    }
    
    return imageView;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        UILabel *label = [UILabel new];
        _moreLabel = label;
        
        label.font = CA_H_FONT_PFSC_Semibold(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = CA_H_TINTCOLOR;
    }
    return _moreLabel;
}

- (void)upView{
    [super upView];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.imageView sd_clearAutoLayoutSettings];
    self.imageView.sd_resetLayout
    .widthIs(24*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.imageView.superview);
    
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.sd_resetLayout
    .spaceToSuperView(UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 54*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator?5:20)*CA_H_RATIO_WIDTH));
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightSpaceToView(self, 20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
}

- (void)setType:(CA_H_AddTodoType)type{
    _type = type;
    switch (type) {
        case CA_H_AddTodoTypeProject:
            self.imageView.image = [UIImage imageNamed:@"project3"];
            self.textLabel.text = CA_H_LAN(@"关联项目");
            break;
        case CA_H_AddTodoTypePeople:
            self.imageView.image = [UIImage imageNamed:@"project_icon3"];
            self.textLabel.text = CA_H_LAN(@"参与人");
            break;
        case CA_H_AddTodoTypeDate:
            self.imageView.image = [UIImage imageNamed:@"setting_time_icon"];
            self.textLabel.text = CA_H_LAN(@"设置截止时间");
            break;
        case CA_H_AddTodoTypeRemind:
            self.imageView.image = [UIImage imageNamed:@"icons_remind"];
            self.textLabel.text = CA_H_LAN(@"设置提醒");
            break;
        case CA_H_AddTodoTypeFirst:
            self.imageView.image = [UIImage imageNamed:@"icons_first"];
            self.textLabel.text = CA_H_LAN(@"优先级：普通");
            break;
        case CA_H_AddTodoTypeRemark:
            self.imageView.image = [UIImage imageNamed:@"remark_icon"];
            self.textLabel.text = CA_H_LAN(@"添加备注");
            break;
        case CA_H_AddTodoTypeFile:
            self.imageView.image = [UIImage imageNamed:@"attachment_icon2"];
            self.textLabel.text = CA_H_LAN(@"添加附件");
            break;
        default:
            break;
    }
    self.textLabel.textColor = CA_H_9GRAYCOLOR;
}

- (void)setModel:(CA_HTodoModel *)model{
    [super setModel:model];
    
    switch (self.type) {
        case CA_H_AddTodoTypeProject:
            if (model.object_id.integerValue) {
                self.textLabel.text = model.objectName;
                self.textLabel.textColor = CA_H_4BLACKCOLOR;
            } else {
                self.textLabel.text = CA_H_LAN(@"关联项目");
                self.textLabel.textColor = CA_H_9GRAYCOLOR;
            }
            break;
        case CA_H_AddTodoTypePeople:{
            if (model.peoples.count > 0) {
                self.textLabel.text = nil;
                self.headerView.hidden = NO;
                
                NSInteger imageCount = model.peoples.count;
                
                UIImageView *imageView;
                for (NSInteger i=0; i<8; i++) {
                    if (i<imageCount) {
                        CA_HParticipantsModel *pmodel = model.peoples[i];
                        imageView = [self customImageView:i];
                        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, pmodel.avatar]] placeholder:[UIImage imageNamed:@"head20"]] ;
                        imageView.hidden = NO;
                        
                        if (i == 7) {
                            if (imageCount > 8) {
                                if (imageCount > 106) {
                                    self.moreLabel.text = @"99+";
                                } else {
                                    self.moreLabel.text = [NSString stringWithFormat:@"+%ld", imageCount-7];
                                }
                                if (!self.moreLabel.superview) {
                                    [imageView addSubview:self.moreLabel];
                                    self.moreLabel.sd_layout
                                    .spaceToSuperView(UIEdgeInsetsZero);
                                }
                            } else {
                                [self.moreLabel removeFromSuperviewAndClearAutoLayoutSettings];
                            }
                        }
                    } else {
                        imageView = [self.headerView viewWithTag:200+i];
                        if (!imageView) break;
                        imageView.hidden = YES;
                    }
                }
                
            } else {
                self.headerView.hidden = YES;
                self.textLabel.text = CA_H_LAN(@"参与人");
                self.textLabel.textColor = CA_H_9GRAYCOLOR;
            }
        }break;
        case CA_H_AddTodoTypeDate:
            if (model.ts_finish.integerValue > 0) {
                NSDate *date = model.finishDate;
                NSDate *nowDate = [NSDate new];
                if (date.year == nowDate.year) {
                    self.textLabel.text = [date stringWithFormat:@"MM月d日（EE）HH:mm"];
                } else {
                    self.textLabel.text = [date stringWithFormat:@"yyyy年MM月dd日（EE）HH:mm"];
                }
//                self.textLabel.text = [model.finishDate stringWithFormat:@"MMMd日（EE）HH:mm"];
                self.textLabel.textColor = CA_H_4BLACKCOLOR;
            } else {
                self.textLabel.text = CA_H_LAN(@"设置截止时间");
                self.textLabel.textColor = CA_H_9GRAYCOLOR;
            }
            break;
        case CA_H_AddTodoTypeRemind:
            if (model.remind_time.integerValue>0) {
                self.textLabel.text = [NSString stringWithFormat:@"提醒：提前%@", (model.remind_time_desc?:@"")];
                self.textLabel.textColor = CA_H_4BLACKCOLOR;
            }else {
                self.textLabel.text = CA_H_LAN(@"设置提醒");
                self.textLabel.textColor = CA_H_9GRAYCOLOR;
            }
            break;
        case CA_H_AddTodoTypeFirst:
            self.textLabel.text = [NSString stringWithFormat:@"优先级：%@", (model.tag_level_desc?:@"普通")];
            if (model.tag_level.integerValue>1) {
                self.textLabel.textColor = CA_H_4BLACKCOLOR;
            }else {
                self.textLabel.textColor = CA_H_9GRAYCOLOR;
            }
            break;
        case CA_H_AddTodoTypeRemark:
            if (model.todo_content.length) {
                self.textLabel.text = model.todo_content;
                self.textLabel.textColor = CA_H_4BLACKCOLOR;
            }else {
                self.textLabel.text = CA_H_LAN(@"添加备注");
                self.textLabel.textColor = CA_H_9GRAYCOLOR;
            }
            break;
        default:
            break;
    }
    
}

@end
