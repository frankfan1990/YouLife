//
//  LocationManager.h
//  MyMoon
//
//  Created by wei on 14-7-21.
//  Copyright (c) 2014年 kklink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//编译地理位置的回调
typedef void (^getAddressFinishBlock)(BOOL success,NSString *address);

//获取用户当前经纬度回调
typedef void (^getUserLocationFinishBlock)(BOOL success,CLLocation *userLocation);

@interface LocationManager : NSObject

-(id)initWithSearch;

/**
 *  获取经纬度
 *
 *  @param alert 没有开启定位时是否需要提醒
 *  @param block 定位成功回调
 */
- (void)getUserNowLocationInfoWithAlert:(BOOL)alert getUserLocationFinish:(getUserLocationFinishBlock)block;

/**
 *  根据经纬度获取具体地址
 *
 *  @param lan 经度
 *  @param lon 纬度
    @param block 编码成功的回调block
 *
 *  @return 具体地址
 */
- (void)getAddressStringWithLan:(double)lan Lon:(double)lon getAddressBlock:(getAddressFinishBlock)block;

@end
