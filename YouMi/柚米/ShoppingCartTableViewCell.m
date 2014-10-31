//
//  ShoppingCartTableViewCell.m
//  youmi
//
//  Created by H.DX on 14-10-31.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"

@implementation ShoppingCartTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelOfGoodsName = [[UILabel alloc] init];
        _labelOfShoppName = [[UILabel alloc] init];
        _labelOfPrice = [[UILabel alloc] init];
        _labelOfNumber = [[UILabel alloc] init];
        _imageOfGoods = [[UIImageView alloc] init];
        
        _btnOfSelected = [[UIButton alloc] init];
        [_btnOfSelected setBackgroundImage:[UIImage imageNamed:@"未选中.png"] forState:UIControlStateNormal];
        [_btnOfSelected setBackgroundImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
        _btnOfSelected.selected =NO;
       
        
        _labelOfNumber.textAlignment = NSTextAlignmentRight;
        _labelOfShoppName.textAlignment = NSTextAlignmentLeft;
        _labelOfGoodsName.textAlignment = NSTextAlignmentLeft;
        _labelOfPrice.textAlignment = NSTextAlignmentLeft;
        
        _labelOfNumber.textColor = baseTextColor;
        _labelOfGoodsName.textColor = baseTextColor;
        _labelOfPrice.textColor = baseTextColor;
        _labelOfShoppName.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
        
        _labelOfNumber.font = [UIFont systemFontOfSize:14];
        _labelOfShoppName.font = [UIFont systemFontOfSize:14];
        _labelOfPrice.font = [UIFont systemFontOfSize:14];
        
        
        _btnOfSelected.backgroundColor = customGrayColor;
        
        [self.contentView addSubview:_labelOfNumber];
        [self.contentView addSubview:_labelOfPrice];
        [self.contentView addSubview:_labelOfShoppName];
        [self.contentView addSubview:_labelOfGoodsName];
        
        [self.contentView addSubview:_labelOfNumber];
        [self.contentView addSubview:_imageOfGoods];
        [self.contentView addSubview:_btnOfSelected];
    }
    return self;
}
- (void)awakeFromNib {
   
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageOfGoods.frame = CGRectMake(3, 3, 110, 70-6);
    
    _labelOfGoodsName.frame = CGRectMake(120, 5, 150, 20);
    _labelOfShoppName.frame = CGRectMake(120, 30, 150, 15);
    _labelOfPrice.frame = CGRectMake(120, 50, 150, 14);
    _labelOfNumber.frame = CGRectMake(self.frame.size.width-150, 50, 145, 20);
    
    _btnOfSelected.frame = CGRectMake(self.frame.size.width-30,70/2-15, 20, 20);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
