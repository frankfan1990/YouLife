//
//  ContactInfoTableViewCell.m
//  youmi
//
//  Created by frankfan on 14-9-16.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ContactInfoTableViewCell.h"

@implementation ContactInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIImageView *headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
        headerImageView.image =[UIImage imageNamed:@"电话"];
        [self.contentView addSubview:headerImageView];

    
        _phoneNUM =[[UILabel alloc]initWithFrame:CGRectMake(35, 14, 260, 30)];
//        phoneNUM.text = self.phoneNumber;
        _phoneNUM.textColor = baseTextColor;
        _phoneNUM.font =[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_phoneNUM];

        
        self.button =[UIButton buttonWithType:UIButtonTypeCustom];
        self.button.layer.cornerRadius = 2;
        self.button.frame = CGRectMake(225, 15, 80, 30);
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setBackgroundColor:baseRedColor];
        [self.button setTitle:@"预约" forState:UIControlStateNormal];
        [self.contentView addSubview:self.button];
        
    
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{

//    static NSString *cellName = @"cell";
    ContactInfoTableViewCell *cell = nil;
    if(!cell){
    
        cell =[[ContactInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
