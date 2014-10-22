//
//  BusinessInfoTableViewCell.m
//  youmi
//
//  Created by frankfan on 14-9-16.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "BusinessInfoTableViewCell.h"

@implementation BusinessInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIImageView *headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
        headerImageView.image =[UIImage imageNamed:@"营业"];
        [self.contentView addSubview:headerImageView];
        
        UILabel *businiInfo =[[UILabel alloc]initWithFrame:CGRectMake(35, 15, 123, 30)];
        businiInfo.text = @"营业信息";
        businiInfo.textColor = baseTextColor;
        businiInfo.font =[UIFont systemFontOfSize:14];
        [self.contentView addSubview:businiInfo];
        
        UILabel *detailInfo =[[UILabel alloc]initWithFrame:CGRectMake(225, 15, 123, 30)];
        detailInfo.text = @"查看详细";
        detailInfo.textColor = baseTextColor;
        detailInfo.font =[UIFont systemFontOfSize:14];
        [self.contentView addSubview:detailInfo];
        
        UIImageView *arrowImageView =[[UIImageView alloc]initWithFrame:CGRectMake(280, 20, 20, 20)];
        arrowImageView.image =[UIImage imageNamed:@"箭头icon"];
        [self.contentView addSubview:arrowImageView];
        
    
    }
    return self;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{

//    static NSString *cellName = @"cell";
    
    BusinessInfoTableViewCell *cell = nil;
    if(!cell){
        
        cell =[[BusinessInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
