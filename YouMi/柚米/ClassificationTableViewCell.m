//
//  ClassificationTableViewCell.m
//  youmi
//
//  Created by frankfan on 14-9-2.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//分类模块的cell【主一级菜单】

#import "ClassificationTableViewCell.h"

@implementation ClassificationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        /*添加背景*/
        self.customBackgroundView =[[UIView alloc]initWithFrame:CGRectMake(10, 5, 46, 46)];
        self.customBackgroundView.backgroundColor =[UIColor colorWithWhite:0.9 alpha:0.8];
        self.customBackgroundView.layer.cornerRadius = 23;
        self.customBackgroundView.layer.borderWidth = 4;
        self.customBackgroundView.layer.borderColor =[UIColor colorWithWhite:0.9 alpha:0.9].CGColor;
        [self.contentView addSubview:self.customBackgroundView];
        
        
        /*添加headerImage*/
        self.headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 46, 46)];
        self.headerImageView.layer.cornerRadius = 23;
        [self.contentView addSubview:self.headerImageView];
    
        /*添加title*/
        self.title =[[UILabel alloc]initWithFrame:CGRectMake(75, 15, 120, 30)];
//        self.title.font =[UIFont systemFontOfSize:16];
        self.title.textColor = baseTextColor;
        [self.contentView addSubview:self.title];
        
        self.selectionStyle = NO;
        
    }
    return self;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{


    static NSString *cellName =@"cell";
    ClassificationTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[ClassificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
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
