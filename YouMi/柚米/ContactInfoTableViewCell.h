//
//  ContactInfoTableViewCell.h
//  youmi
//
//  Created by frankfan on 14-9-16.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactInfoTableViewCell : UITableViewCell


//@property (nonatomic,strong)NSString *phoneNumber;
@property (nonatomic,strong)UILabel *phoneNUM;
@property (nonatomic,strong)UIButton *button;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
