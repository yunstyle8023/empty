//
//  CA_HFolderFileCell.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/22.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"

#import "CA_HFolderFileCellViewModel.h"

@interface CA_HFolderFileCell : CA_HBaseTableCell

@property (nonatomic, strong) CA_HFolderFileCellViewModel *viewModel;

@property (nonatomic, copy) void (^editBlock)(UITableViewCell * editCell);

//- (void)download;

@end
