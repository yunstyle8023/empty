//
//  CA_MFiltrateItemUITableView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MFiltrateItemUITableView.h"
#import "CA_MFiltrateItemCell.h"

@interface CA_MFiltrateItemUITableView ()
<
UITableViewDataSource,
UITableViewDelegate
>

@end

@implementation CA_MFiltrateItemUITableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[CA_MFiltrateItemCell class] forCellReuseIdentifier:@"FiltrateItemCell"];
    }
    return self;
}

#pragma mark - UITableViewDataSource

-(void)setData:(NSMutableArray *)data{
    _data = data;
    
    [self reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MFiltrateItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"FiltrateItemCell"];
    itemCell.keyName = self.keyName;
    itemCell.backgroundColor = self.cellColor;
    itemCell.model = self.data[indexPath.row];
    return itemCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *titleStr = [self.data[indexPath.row] valueForKey:self.keyName];
    
    return [titleStr heightForFont:CA_H_FONT_PFSC_Regular(16) width:self.mj_w-10*2*CA_H_RATIO_WIDTH*2]+10*2*CA_H_RATIO_WIDTH;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 26*2*CA_H_RATIO_WIDTH+10*2*CA_H_RATIO_WIDTH;
}

@end
