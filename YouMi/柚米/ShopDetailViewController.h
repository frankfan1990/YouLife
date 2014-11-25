//
//  ShopDetailViewController.h
//  youmi
//
//  Created by frankfan on 14/11/10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopObjectModel.h"

@interface ShopDetailViewController : UIViewController

@property (nonatomic,assign)int model;//接受传过来的模块
@property (nonatomic,strong)ShopObjectModel *shopModel;
@end
