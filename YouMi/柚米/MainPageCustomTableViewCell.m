//
//  MainPageCustomTableViewCell.m
//  youmi
//
//  Created by frankfan on 14-8-28.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//cell的高度为100
//首页的cell


#import "MainPageCustomTableViewCell.h"

@interface MainPageCustomTableViewCell ()



@end


@implementation MainPageCustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 93)];
        backView.backgroundColor =[UIColor whiteColor];
        backView.layer.cornerRadius = 3.0f;
        [self.contentView addSubview:backView];
        
        //
        self.headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(5+5, 28-15, 60+20-5+10, 60+15)];
        self.headerImageView.layer.borderWidth = 1;
        self.headerImageView.layer.borderColor =[UIColor colorWithWhite:0.95 alpha:0.5].CGColor;
        self.headerImageView.layer.masksToBounds = YES;
        self.headerImageView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.headerImageView];
        
        //
        self.TheShopName =[[UILabel alloc]initWithFrame:CGRectMake(100, 28-15, 144, 22)];
        self.TheShopName.font = ShopNameFont;
        self.TheShopName.textColor = baseTextColor;
        [self.contentView addSubview:self.TheShopName];
#warning fake data 此数据需要从接口处去得
        self.TheShopName.text = @"店铺名";
        
        //
        self.aboutUpay =[[UILabel alloc]initWithFrame:CGRectMake(100, 47-8, 144, 22)];
        self.aboutUpay.font = ShopNameFont;
        self.aboutUpay.textColor = [UIColor colorWithWhite:0.7 alpha:0.9];
        [self.contentView addSubview:self.aboutUpay];
#warning fake data 此数据需要从接口处去得
        self.aboutUpay.text = @"满一百送50U币";
        
        //
        self.TheShopAddress =[[UILabel alloc]initWithFrame:CGRectMake(100, 69, 144, 22)];
        self.TheShopAddress.font = ShopNameFont;
        self.TheShopAddress.textColor = baseTextColor;
        [self.contentView addSubview:self.TheShopAddress];
#warning fake data 此数据需要从接口处去得
        self.TheShopAddress.text = @"浪漫西餐 | 南门口";
        
        //
#pragma mark 静态数据
        _label =[[UILabel alloc]initWithFrame:CGRectMake(240+5, 36-7, 30, 20)];
        _label.text = @"人均:";
        _label.font =[UIFont systemFontOfSize:12];
        _label.textColor = baseTextColor;
        [self.contentView addSubview:_label];
        
        //
        self.averageMoney =[[UILabel alloc]initWithFrame:CGRectMake(275+5, 36-7, 30, 20)];
        self.averageMoney.textColor = baseTextColor;
        self.averageMoney.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.averageMoney];
        self.averageMoney.text = @"20";
        
        /*位置小标志*/
        _locationView =[[UIImageView alloc]initWithFrame:CGRectMake(240+5, 58, 16, 17)];
        _locationView.image =[UIImage imageNamed:@"地标.png"];
        [self.contentView addSubview:_locationView];
        
        self.distanceFromShop =[[UILabel alloc]initWithFrame:CGRectMake(260+5, 56, 50, 20)];
        self.distanceFromShop.font =[UIFont systemFontOfSize:12];
        self.distanceFromShop.textColor = baseTextColor;
        [self.contentView addSubview:self.distanceFromShop];
#warning fake data 此数据需要从接口处去得
        self.distanceFromShop.text = @"500m";
    
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString *cellName = @"cell";
    MainPageCustomTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[MainPageCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
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
