//
//  ShoppingCartTableViewCell.h
//  youmi
//
//  Created by H.DX on 14-10-31.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @Author frankfan, 14-11-02 19:11:35
 *
 *  我的购物车
 */


@interface ShoppingCartTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *labelOfPrice;
@property(nonatomic,strong)UILabel *labelOfNumber;
@property(nonatomic,strong)UILabel *labelOfGoodsName;
@property(nonatomic,strong)UILabel *labelOfShoppName;
@property(nonatomic,strong)UIButton *btnOfSelected;
@property(nonatomic,strong)UIImageView *imageOfGoods;
@end
