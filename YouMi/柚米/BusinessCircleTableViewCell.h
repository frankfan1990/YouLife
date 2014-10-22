//
//  BusinessCircleTableViewCell.h
//  youmi
//
//  Created by frankfan on 14-9-12.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCircleTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *BusiniessCircleName;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
