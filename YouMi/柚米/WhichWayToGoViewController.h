//
//  WhichWayToGoViewController.h
//  youmi
//
//  Created by frankfan on 14/11/18.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>

@interface WhichWayToGoViewController : UIViewController

@property (nonatomic,assign)NSInteger whichWay;
@property (nonatomic,strong)NSArray *trsnasts_bus;//公交导航信息组
@property (nonatomic,strong)AMapRoute *route;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
@end
