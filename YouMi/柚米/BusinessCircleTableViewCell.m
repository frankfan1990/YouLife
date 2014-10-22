//
//  BusinessCircleTableViewCell.m
//  youmi
//
//  Created by frankfan on 14-9-12.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "BusinessCircleTableViewCell.h"

@implementation BusinessCircleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.BusiniessCircleName =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width, 44)];
        self.BusiniessCircleName.font = [UIFont systemFontOfSize:14];
        self.BusiniessCircleName.textColor = baseTextColor;
        [self.contentView addSubview:self.BusiniessCircleName];
    
    }
    return self;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString *cellName = @"cell1";
    BusinessCircleTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[BusinessCircleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    
    return cell;

}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
