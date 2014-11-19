//
//  MainMapViewController.h
//  youmi
//
//  Created by frankfan on 14/11/17.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MainMapViewController : UIViewController

@property (nonatomic,strong)NSString *shopperName;//店铺名
@property (nonatomic,assign)double latitude;//纬度
@property (nonatomic,assign)double longitude;//经度

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
@end
