//
//  MapDetailViewController.h
//  youmi
//
//  Created by frankfan on 14/11/18.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MapDetailViewController : UIViewController

@property (nonatomic,assign)NSInteger whichWay;
@property (nonatomic,assign)NSInteger projectNum;//第几个方案
@property (nonatomic, strong)AMapRoute *route;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
@end
