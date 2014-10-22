//
//  LuggageBagsTableViewCell.h
//  youmi
//
//  Created by frankfan on 14-9-2.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LuggageBagsTableViewCell : UITableViewCell


@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *TheShopName;
@property (nonatomic,strong)UILabel *aboutUpay;
@property (nonatomic,strong)UILabel *TheShopAddress;
@property (nonatomic,strong)UILabel *distanceFromShop;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
