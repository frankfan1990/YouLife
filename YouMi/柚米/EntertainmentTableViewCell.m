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
        self.headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(5+5, 28-15+5, 60+20-5+10, 60+15-10)];
        self.headerImageView.layer.masksToBounds = YES;
        self.headerImageView.layer.cornerRadius = 2;
        [self.contentView addSubview:self.headerImageView];

        //
        self.TheShopName =[[UILabel alloc]initWithFrame:CGRectMake(100+4, 28-15+3, 144, 22)];
        self.TheShopName.font = ShopNameFont;
        self.TheShopName.textColor = baseTextColor;
        [self.contentView addSubview:self.TheShopName];

        self.TheShopName.text = @"店铺名";
        
        
        //
        self.aboutUpay =[[UILabel alloc]initWithFrame:CGRectMake(100+4, 69-3, 144, 22)];
        self.aboutUpay.font = ShopNameFont;
        self.aboutUpay.textColor = [UIColor colorWithWhite:0.7 alpha:0.9];
        [self.contentView addSubview:self.aboutUpay];

        self.aboutUpay.text = @"满一百送50U币";

        
        //
        self.TheShopAddress =[[UILabel alloc]initWithFrame:CGRectMake(225+10, 43, self.bounds.size.width-225-10-5, 22)];
        self.TheShopAddress.textAlignment = NSTextAlignmentLeft;
        self.TheShopAddress.font =[UIFont systemFontOfSize:12];
        self.TheShopAddress.adjustsFontSizeToFitWidth = YES;
        self.TheShopAddress.font = ShopNameFont;
        self.TheShopAddress.textColor = baseTextColor;
        [self.contentView addSubview:self.TheShopAddress];

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
