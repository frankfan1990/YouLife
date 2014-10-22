//
//  ShopAddressTableViewCell.m
//  youmi
//
//  Created by frankfan on 14-9-16.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ShopAddressTableViewCell.h"

@implementation ShopAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
        headerImageView.image =[UIImage imageNamed:@"地标"];
        [self.contentView addSubview:headerImageView];

    
        _shopADDress =[[UILabel alloc]initWithFrame:CGRectMake(35, 14, 260, 30)];
//        _shopADDress.text = self.shopAddress;
        _shopADDress.textColor = baseTextColor;
        _shopADDress.font =[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_shopADDress];
        
        /*fake data*/
//        self.shopAddress = @"雨花区井圭路138号";
    
    
    
    }
    return self;
}

+ (instancetype)celWithTableView:(UITableView *)tableView{

//    static NSString *cellName = @"cell";
    ShopAddressTableViewCell *cell = nil;
    if(!cell){
    
        cell =[[ShopAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
