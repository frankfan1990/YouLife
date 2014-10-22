//
//  ClassificationTableViewCell.h
//  youmi
//
//  Created by frankfan on 14-9-2.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UIView *customBackgroundView;/*背景圈*/

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
