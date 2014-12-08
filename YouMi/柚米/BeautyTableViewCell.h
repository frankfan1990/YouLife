//
//  BeautyTableViewCell.h
//  youmi
//
//  Created by frankfan on 14/12/8.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeautyTableViewCell : UITableViewCell


@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *TheShopName;
@property (nonatomic,strong)UILabel *aboutUpay;
@property (nonatomic,strong)UILabel *TheShopAddress;
@property (nonatomic,strong)UILabel *averageMoney;
@property (nonatomic,strong)UILabel *distanceFromShop;

@property (nonatomic,strong,readonly)UILabel *label;/*"人均"*/
@property (nonatomic,strong,readonly)UIImageView *locationView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
