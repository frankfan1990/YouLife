//
//  ShopDetai_Row1TableViewCell.h
//  youmi
//
//  Created by frankfan on 14-9-16.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetai_Row1TableViewCell : UITableViewCell

@property (nonatomic,assign)float rating;//评分
@property (nonatomic,strong)NSString *kindOfFoodName;
@property (nonatomic,strong)NSString *ShopNameText;
@property (nonatomic,strong)NSString *AboutPayText;


@property (nonatomic,strong)UILabel *shopName;
@property (nonatomic,strong)UILabel *kindofFood;
@property (nonatomic,strong)UILabel *aboutUpay;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
