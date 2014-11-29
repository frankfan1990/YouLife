//
//  ShopDetailViewController.h
//  youmi
//
//  Created by frankfan on 14/11/10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopObjectModel.h"
#import <MapKit/MapKit.h>

@interface ShopDetailViewController : UIViewController

@property (nonatomic,assign)int model;//接受传过来的模块
@property (nonatomic,strong)ShopObjectModel *shopModel;
@property (nonatomic,assign)CLLocationCoordinate2D originPosition;//当前定位坐标
@end
