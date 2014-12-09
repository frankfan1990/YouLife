//
//  BuyNowViewController.h
//  youmi
//
//  Created by frankfan on 14/11/3.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyNowViewController : UIViewController

@property (nonatomic,copy)NSString *goodsName;
@property (nonatomic,assign)double price;
@property (nonatomic,assign)BOOL expiredRetreat;
@property (nonatomic,copy)NSString *goodsId;
@property (nonatomic,copy)NSString *memberId;
@end
