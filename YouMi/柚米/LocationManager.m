//
//  LocationManager.m
//  MyMoon
//
//  Created by wei on 14-7-21.
//  Copyright (c) 2014年 kklink. All rights reserved.
//

#import "LocationManager.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>
#import "ValueKeyConfig.h"

@interface LocationManager ()<AMapSearchDelegate,CLLocationManagerDelegate,MAMapViewDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) getAddressFinishBlock getAddressBlock;
@property (nonatomic, strong) getUserLocationFinishBlock getUserLocationBlock;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locManager;

@end

@implementation LocationManager

- (void)getUserNowLocationInfoWithAlert:(BOOL)alert getUserLocationFinish:(getUserLocationFinishBlock)block
{
    _getUserLocationBlock = block;
    
    //根据时间判断数据有效性，是否需要重新定位获取经纬度(每2分钟获取一次经纬度)
    NSString *key = @"LocationTime";
    NSString *latKey = @"latitudeKey";
    NSString *lonKey = @"lontitudeKey";
    double time = [ValueKeyConfig readWithKey:key];
    if(![ValueKeyConfig isTimeOut:time andKey:key]){
        double lat = [[ValueKeyConfig readValueWithKey:latKey] doubleValue];
        double lon = [[ValueKeyConfig readValueWithKey:lonKey] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        
        _getUserLocationBlock(YES,location);
        return;
    }
    
    if(![CLLocationManager locationServicesEnabled]){
        if(alert){
//            [RegularExpressionsMethod alrtTitle:@"定位服务未开启" AndMessage:@"请在手机设置中开启定位服务"];
        }
        
        if(_getUserLocationBlock){
            _getUserLocationBlock(NO,nil);
        }
        
        return ;
    }
    
    if(!_locManager){
        _locManager = [[CLLocationManager alloc] init];
        _locManager.delegate = self;
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locManager.distanceFilter = 1000.00f;
        

        if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
        {
//                    设置定位权限，仅ios8有意义
            [_locManager requestWhenInUseAuthorization];
        }else{

            if(!_mapView){
                self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0,0, 0,250)];
                self.mapView.delegate = self;
                self.mapView.mapType=MAMapTypeStandard;
                self.mapView.userTrackingMode = MAUserTrackingModeFollow;
            }
            self.mapView.showsUserLocation = YES;

       }


        
    }else{
        
//        if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse){
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
            if(alert){
                // 没有打开该app定位功能
//                [NSRegularExpressionSearch alrtTitle:@"定位服务未开启" AndMessage:@"请在手机设置中开启定位服务"];
            }
            
            if(_getUserLocationBlock){
                _getUserLocationBlock(NO,nil);
            }
            
            return ;
        }
        
        if(!_mapView){
            self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0,0, 0,250)];
            self.mapView.delegate = self;
            self.mapView.mapType=MAMapTypeStandard;
            self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        }
        self.mapView.showsUserLocation = YES;
    }
}

#pragma mark MAMapViewDelegate
//得到自己当前位置
-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
updatingLocation:(BOOL)updatingLocation
{
    NSString *key = @"LocationTime";
    NSString *latKey = @"latitudeKey";
    NSString *lonKey = @"lontitudeKey";
    [ValueKeyConfig saveValue:[NSNumber numberWithDouble:userLocation.location.coordinate.latitude] andKey:latKey];
    [ValueKeyConfig saveValue:[NSNumber numberWithDouble:userLocation.location.coordinate.longitude] andKey:lonKey];
    [ValueKeyConfig saveWithKey:key];
    
    if(_getUserLocationBlock){
        _getUserLocationBlock(YES,userLocation.location);
    }
    self.mapView.showsUserLocation = NO;
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    self.mapView.showsUserLocation = NO;
    [_locManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    NSString *key = @"LocationTime";
    NSString *latKey = @"latitudeKey";
    NSString *lonKey = @"lontitudeKey";
    [ValueKeyConfig saveValue:[NSNumber numberWithDouble:newLocation.coordinate.latitude] andKey:latKey];
    [ValueKeyConfig saveValue:[NSNumber numberWithDouble:newLocation.coordinate.longitude] andKey:lonKey];
    [ValueKeyConfig saveWithKey:key];
    
    if(_getUserLocationBlock){
        _getUserLocationBlock(YES,newLocation);
    }
    
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失败时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(_getUserLocationBlock){
        _getUserLocationBlock(NO,nil);
    }
    
    // 停止位置更新
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    NSLog(@"调用代理");
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:{
            

            if ([_locManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locManager requestWhenInUseAuthorization];
            }


        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            // 没有打开该app定位功能
//            [RegularExpressionsMethod alrtTitle:@"定位服务未开启" AndMessage:@"请在手机设置中开启定位服务"];
            if(_getUserLocationBlock){
                _getUserLocationBlock(NO,nil);
            }
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            // 没有打开该app定位功能
//            [RegularExpressionsMethod alrtTitle:@"定位服务未开启" AndMessage:@"请在手机设置中开启定位服务"];
            if(_getUserLocationBlock){
                _getUserLocationBlock(NO,nil);
            }
        }
            break;
        case kCLAuthorizationStatusAuthorized:{
            if(!_mapView){
                self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0,0, 0,250)];
                self.mapView.delegate = self;
                self.mapView.mapType=MAMapTypeStandard;
                self.mapView.userTrackingMode = MAUserTrackingModeFollow;
            }
            self.mapView.showsUserLocation = YES;
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            if(!_mapView){
                self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0,0, 0,250)];
                self.mapView.delegate = self;
                self.mapView.mapType=MAMapTypeStandard;
                self.mapView.userTrackingMode = MAUserTrackingModeFollow;
            }
            self.mapView.showsUserLocation = YES;
        }
            break;
            
        default:{
            if(_getUserLocationBlock){
                _getUserLocationBlock(NO,nil);
            }
        }
            break;
    }
}

- (id)initWithSearch
{
    self = [super init];
    if(self){
        NSLog(@"%@",[MAMapServices sharedServices].apiKey);
        if (!_search) {
            _search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
            
        }
        
    }
    return self;
}

- (void)getAddressStringWithLan:(double)lan Lon:(double)lon getAddressBlock:(getAddressFinishBlock)block
{
    _getAddressBlock = block;
    CLLocationCoordinate2D cencord = CLLocationCoordinate2DMake(lan, lon);
    
    //更新UI操作
    [self searchReGeocodeWithCoordinate:cencord];
    
}

//根据坐标搜索位置
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    //    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    //    regeo.searchType=AMapSearchType_Geocode;
    //    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //    regeo.requireExtension = YES;
    //    regeo.radius=10000;
    //    [_search AMapReGoecodeSearch:regeo];
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        if(placemark){
            NSString *addressStr = [NSString stringWithFormat:@"%@·%@",placemark.locality,placemark.subLocality];
            if(_getAddressBlock){
                _getAddressBlock(YES,addressStr);
            }
        }
    }];
    
}

#pragma mark - AMapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"%@",response.regeocode.formattedAddress);
    if (response.regeocode != nil){
        if(_getAddressBlock){
            _getAddressBlock(YES,response.regeocode.formattedAddress);
        }
    }
}

@end
