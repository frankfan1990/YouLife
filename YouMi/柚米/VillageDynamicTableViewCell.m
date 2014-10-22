//
//  VillageDynamicTableViewCell.m
//  youmi
//
//  Created by frankfan on 14-9-22.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "VillageDynamicTableViewCell.h"

@implementation VillageDynamicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.moreDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, 44)];
        self.moreDetail.font =[UIFont systemFontOfSize:14];
        self.moreDetail.textColor =baseTextColor;
        [self.contentView addSubview:self.moreDetail];
        
        UIImageView *sep_line =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width-20, 1)];
        sep_line.image =[UIImage imageNamed:@"虚线"];
        [self.contentView addSubview:sep_line];

        
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString *cellName = @"cell1";
    VillageDynamicTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[VillageDynamicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
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
