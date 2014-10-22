//
//  ShopDetai_Row1TableViewCell.m
//  youmi
//
//  Created by frankfan on 14-9-16.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ShopDetai_Row1TableViewCell.h"
#import "EDStarRating.h"

@interface ShopDetai_Row1TableViewCell ()<EDStarRatingProtocol>
{
    
    EDStarRating *starRatingCon;


}



@end


@implementation ShopDetai_Row1TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    
        
#pragma mark 创建评分控件
        
        starRatingCon =[[EDStarRating alloc]initWithFrame:CGRectMake(185,6, 123, 30)];
        starRatingCon.delegate = self;
        starRatingCon.maxRating = 5;
        starRatingCon.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        starRatingCon.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        starRatingCon.horizontalMargin = 15.0;
        starRatingCon.displayMode=EDStarRatingDisplayHalf;
        starRatingCon.editable = NO;
        starRatingCon.tintColor = baseRedColor;
#warning 模拟评分
        self.rating = 3;/*fake data*/
        starRatingCon.rating = self.rating;
        [starRatingCon setNeedsDisplay];

        
        self.shopName =[[UILabel alloc]initWithFrame:CGRectMake(15, -20, 150, 80)];
        self.shopName.textColor = baseTextColor;
        self.shopName.font =[UIFont systemFontOfSize:19];
        [self.contentView addSubview:self.shopName];
        self.selectionStyle = NO;
        
        
        self.kindofFood =[[UILabel alloc]initWithFrame:CGRectMake(15, 35, 150, 30)];
        self.kindofFood.font =[UIFont systemFontOfSize:14];
        self.kindofFood.textColor = [UIColor colorWithWhite:0.7 alpha:0.9];
        [self.contentView addSubview:self.kindofFood];
        /*fake data*/
        self.kindOfFoodName =@"湘菜，田园菜";
        self.kindofFood.text = self.kindOfFoodName;
        
        self.aboutUpay =[[UILabel alloc]initWithFrame:CGRectMake(200, 35, 123, 30)];
        self.aboutUpay.font =[UIFont systemFontOfSize:14];
        self.aboutUpay.textColor =[UIColor colorWithWhite:0.7 alpha:0.9];
        [self.contentView addSubview:self.aboutUpay];
        /*fake data*/
        self.AboutPayText = @"满100送10U币";
        self.aboutUpay.text = self.AboutPayText;
        
        
        /*fake data*/
        self.ShopNameText = @"店铺名";
        self.shopName.text = self.ShopNameText;
        
        //评分控件
        [self.contentView addSubview:starRatingCon];

        
        
    
    
    }
    return self;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{

//    static NSString *cellName = @"cell";
    
    ShopDetai_Row1TableViewCell *cell = nil;
//    ShopDetai_Row1TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[ShopDetai_Row1TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
