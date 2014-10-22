//
//  Village2DynamicTableViewCell.m
//  youmi
//
//  Created by frankfan on 14-9-22.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "Village2DynamicTableViewCell.h"

@implementation Village2DynamicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        /*头部image*/
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 115, 70)];
        self.headerImageView.layer.cornerRadius = 3;
        self.headerImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImageView];
        
        /*店铺名字*/
        self.labelName = [[UILabel alloc]initWithFrame:CGRectMake(140, 7, 123, 30)];
        self.labelName.font =[UIFont systemFontOfSize:14];
        self.labelName.textColor = baseTextColor;
        [self.contentView addSubview:self.labelName];
        
        /*店铺detail*/
        self.labeDetail =[[UILabel alloc]initWithFrame:CGRectMake(140, 65, 100, 30)];
        self.labeDetail.font = [UIFont systemFontOfSize:14];
        self.labeDetail.textColor = [UIColor colorWithWhite:0.8 alpha:0.9];
        [self.contentView addSubview:self.labeDetail];
        
        /*创建线*/
        UIView *sep_line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width-20, 1)];
        sep_line.backgroundColor = customGrayColor;
        [self.contentView addSubview:sep_line];

        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString *cellName =@"cell2";
    Village2DynamicTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[Village2DynamicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
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
