//
//  CourseDetailsViewController.h
//  youmi
//
//  Created by frankfan on 14/10/30.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopObjectModel.h"
#import <MapKit/MapKit.h>

@interface CourseDetailsViewController : UIViewController

@property (nonatomic,strong)ShopObjectModel *shopModel;
@property (nonatomic,assign)CLLocationCoordinate2D originPosition;//当前定位坐标
@end
