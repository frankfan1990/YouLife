//
//  VillageDynamicTableViewCell.h
//  youmi
//
//  Created by frankfan on 14-9-22.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VillageDynamicTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *moreDetail;/*显示最后一条row的文本*/

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
