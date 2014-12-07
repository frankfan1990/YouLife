//
//  convert_oc.h
//  youmi
//
//  Created by frankfan on 14/11/29.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface convert_oc : NSObject

//地球转火星
+ (CLLocationCoordinate2D)CLLocationCoordinate2D_transform:(CLLocationCoordinate2D)wgsCoordinate;


/**
 *  @Author frankfan, 14-11-21 10:11:15
 *
 *  给定两点坐标计算两地距离
 *
 *  @param lon1 A点经度
 *  @param lat1 A点纬度
 *  @param lon2 B点经度
 *  @param lat2 B点纬度
 *
 *  @return A-B距离
 */

//一定要注意这里的经纬度顺序
+ (double)LantitudeLongitudeDist:(double)lon1 andlat:(double)lat1 andlon2:(double)lon2 andlat2:(double)lat2;

@end
