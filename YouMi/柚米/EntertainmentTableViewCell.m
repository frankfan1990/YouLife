//
//  EntertainmentTableViewCell.m
//  youmi
//
//  Created by frankfan on 14-9-10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//休闲娱乐cell

#import "EntertainmentTableViewCell.h"

@implementation EntertainmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //
        self.headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(25, 28, 60, 60)];
        self.headerImageView.layer.borderWidth = 3;
        self.headerImageView.layer.borderColor =[UIColor colorWithWhite:0.9 alpha:0.8].CGColor;
        self.headerImageView.layer.masksToBounds = YES;
        self.headerImageView.layer.cornerRadius = 30;
        [self.contentView addSubview:self.headerImageView];

        //
        self.TheShopName =[[UILabel alloc]initWithFrame:CGRectMake(100, 26, 144, 22)];
        self.TheShopName.font = ShopNameFont;
        self.TheShopName.textColor = baseTextColor;
        [self.contentView addSubview:self.TheShopName];
#warning fake data 此数据需要从接口处去得
        self.TheShopName.text = @"店铺名";
        
        
        //
        self.aboutUpay =[[UILabel alloc]initWithFrame:CGRectMake(100, 47, 144, 22)];
        self.aboutUpay.font = ShopNameFont;
        self.aboutUpay.textColor = [UIColor colorWithWhite:0.7 alpha:0.9];
        [self.contentView addSubview:self.aboutUpay];
#warning fake data 此数据需要从接口处去得
        self.aboutUpay.text = @"满一百送50U币";

        
        //
        self.TheShopAddress =[[UILabel alloc]initWithFrame:CGRectMake(225, 43, 90, 22)];
        self.TheShopAddress.textAlignment = NSTextAlignmentCenter;
        self.TheShopAddress.font = ShopNameFont;
        self.TheShopAddress.textColor = baseTextColor;
        [self.contentView addSubview:self.TheShopAddress];
#warning fake data 此数据需要从接口处去得
        self.TheShopAddress.text = @"南门口";


    
    
    }
    return self;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString *cellName = @"cell";
    EntertainmentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[EntertainmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
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
