//
//  Village2DynamicTableViewCell.h
//  youmi
//
//  Created by frankfan on 14-9-22.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Village2DynamicTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *labelName;/*餐厅名字*/
@property (nonatomic,strong)UILabel *labeDetail ;/*备注信息*/

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
