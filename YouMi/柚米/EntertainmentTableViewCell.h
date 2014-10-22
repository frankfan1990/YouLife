//
//  EntertainmentTableViewCell.h
//  youmi
//
//  Created by frankfan on 14-9-10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntertainmentTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *TheShopName;
@property (nonatomic,strong)UILabel *aboutUpay;
@property (nonatomic,strong)UILabel *TheShopAddress;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
