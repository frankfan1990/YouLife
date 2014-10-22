//
//  ShopAddressTableViewCell.h
//  youmi
//
//  Created by frankfan on 14-9-16.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopAddressTableViewCell : UITableViewCell

//@property (nonatomic,strong)NSString *shopAddress;
@property (nonatomic,strong)UILabel *shopADDress;

+ (instancetype)celWithTableView:(UITableView *)tableView;
@end
