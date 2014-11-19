//
//  MapDetailViewController.m
//  youmi
//
//  Created by frankfan on 14/11/18.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MapDetailViewController.h"
#import "LineDashPolyline.h"
#import "CommonUtility.h"

@interface MapDetailViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    NSArray *polylines;
}
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)AMapSearchAPI *search;
@end

@implementation MapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = [NSString stringWithFormat:@"第%ld方案",(long)self.projectNum];
    title.textColor = baseRedColor;
    self.navigationItem.titleView = title;
    
    /*回退*/
    UIButton *searchButton0 =[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton0.tag = 10006;
    searchButton0.frame = CGRectMake(0, 0, 30, 30);
    [searchButton0 setImage:[UIImage imageNamed:@"朝左箭头icon"] forState:UIControlStateNormal];
    [searchButton0 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftitem =[[UIBarButtonItem alloc]initWithCustomView:searchButton0];
    self.navigationItem.leftBarButtonItem = leftitem;

    //
    UIView *redLine =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-199, self.view.bounds.size.width, 1)];
    redLine.backgroundColor = baseRedColor;
    [self.view addSubview:redLine];
    
    
       // Do any additional setup after loading the view.
}

#pragma mark - 初始化地图
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.mapView =[[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-200)];
    
    self.mapView.showsScale = YES;
    self.mapView.delegate = self;
    
    //让视图缩放适配
    MACoordinateSpan span ={0.11, 0.17};
    CLLocationCoordinate2D reginLocation = CLLocationCoordinate2DMake((self.startCoordinate.latitude+self.destinationCoordinate.latitude)/2.0, (self.startCoordinate.longitude+self.destinationCoordinate.longitude)/2.0);
    MACoordinateRegion region={reginLocation,span};
    [self.mapView setRegion:region];
    self.mapView.centerCoordinate = reginLocation;

    
    [self.view addSubview:self.mapView];
    [self presentCurrentCourse];
    [self addDefaultAnnotations];
}



/*初始化标注*/
- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = @"起点";
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = @"终点";
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}



/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    polylines = nil;
    
    /* 公交导航. */
    if (self.whichWay==3001)
    {
        polylines = [CommonUtility polylinesForTransit:self.route.transits[self.projectNum-1]];
    }
    /* 步行，驾车导航. */
    else
    {
        polylines = [CommonUtility polylinesForPath:self.route.paths[self.projectNum-1]];
    }
    
    [self.mapView addOverlays:polylines];
    
    /* 缩放地图使其适应polylines的展示. 被高德这句代码坑了！*/
//    self.mapView.visibleMapRect = [CommonUtility mapRectForOverlays:polylines];
    
   
}



- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:navigationCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        /* 起点. */
        if ([[annotation title] isEqualToString:@"起点"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
      
        }
        /* 终点. */
        else if([[annotation title] isEqualToString:@"终点"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{

    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        polylineRenderer.lineDashPattern = @[@5, @10];
        
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        
        return polylineRenderer;
    }
    
    return nil;



}



#pragma mark - 回退
- (void)buttonClicked:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
