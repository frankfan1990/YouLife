//
//  MainMapViewController.m
//  youmi
//
//  Created by frankfan on 14/11/17.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MainMapViewController.h"
#import "WhichWayToGoViewController.h"
#import "ChineseToPinyin.h"


@interface MainMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    
    MAPointAnnotation *annotation0;
}
@property (nonatomic,strong)AMapSearchAPI *search;
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)AMapRoute *route;//公交
@property (nonatomic,strong)AMapRoute *route2;//驾车

@property (nonatomic,strong)NSArray *trsnasts_bus;//公交导航信息组
@property (nonatomic,strong)NSArray *paths;//驾车/徒步导航信息组
@end

@implementation MainMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    self.shopperName = @"店铺名";
    title.text = self.shopperName;
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
    UIView *staticLine =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 1)];
    staticLine.backgroundColor = baseRedColor;
    [self.view addSubview:staticLine];
    
    
    //开始创建下面的3个button
    UIView *busView =[self createButtonItemView:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width/3.0, 49) andTitle:@" 公交" andImageName:@"公交车"];
    busView.tag = 3001;
    [self.view addSubview:busView];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whichWayToGO:)];
    [busView addGestureRecognizer:tap];
    
    UIView *carView =[self createButtonItemView:CGRectMake(self.view.bounds.size.width/3.0, self.view.bounds.size.height-49, self.view.bounds.size.width/3.0, 49) andTitle:@" 驾车" andImageName:@"驾车"];
    carView.tag = 3002;
    [self.view addSubview:carView];
    
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whichWayToGO:)];
    [carView addGestureRecognizer:tap2];

    
    
    UIView *footView =[self createButtonItemView:CGRectMake(self.view.bounds.size.width/3.0*2, self.view.bounds.size.height-49, self.view.bounds.size.width/3.0, 49) andTitle:@" 步行" andImageName:@"步行"];
    footView.tag = 3003;
    [self.view addSubview:footView];
    
    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whichWayToGO:)];
    [footView addGestureRecognizer:tap3];

   
    self.search =[[AMapSearchAPI alloc]initWithSearchKey:kGaoDeAppKey Delegate:self];
    [self searchReGeoCode:28.1604559362 and:112.9536337433];
    
    
    
    
    self.startCoordinate = CLLocationCoordinate2DMake(28.1604559362, 112.9536337433);
    self.destinationCoordinate = CLLocationCoordinate2DMake(28.2602631576, 112.9779605718);
   
    /**
     *  @Author frankfan, 14-11-18 12:11:32
     *
     *  在这里获取对应导航数据
     *  公交/驾车/步行
     *  @return
     */
#warning 此处为垃圾代码
    [self searchNaviBus:self.startCoordinate.latitude andLongitude:self.startCoordinate.longitude
            andLatitude:self.destinationCoordinate.latitude andLongitude:self.destinationCoordinate.longitude
                andCity:@"长沙市"];//公交导航数据
    
    
    [self searchNaviDrive:self.startCoordinate.latitude andLongitude:self.startCoordinate.longitude
              andLatitude:self.destinationCoordinate.latitude andLongitude:self.destinationCoordinate.longitude];//驾车导航
    
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 创建高德地图
/**
 *  @Author frankfan, 14-11-17 16:11:20
 *
 *  创建高德地图
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.mapView =[[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50)];
 
    //添加标注
    annotation0 =[[MAPointAnnotation alloc]init];
    annotation0.coordinate = CLLocationCoordinate2DMake(28.1604559362, 112.9536337433);

   
    
    self.mapView.showsScale = YES;
    self.mapView.delegate = self;
    
    //让视图缩放适配
    MACoordinateSpan span ={0.06, 0.06};
    MACoordinateRegion region={annotation0.coordinate,span};
    [self.mapView setRegion:region animated:YES];
    self.mapView.centerCoordinate = annotation0.coordinate;
    
    [self.mapView addAnnotation:annotation0];

    [self.view addSubview:self.mapView];
    
}


//地理逆向编码
- (void)searchReGeoCode:(CGFloat)latitude and:(CGFloat)longtitude{
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longtitude];
    regeoRequest.radius = 500;
    regeoRequest.requireExtension = YES;
    [self.search AMapReGoecodeSearch: regeoRequest];

}


- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{

    NSLog(@"response:%@",response.regeocode);

}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
  
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
    
        return annotationView;
    }
    
    return nil;
}



//创建下面的三个button
- (UIView *)createButtonItemView:(CGRect)frame andTitle:(NSString *)title andImageName:(NSString *)imageName{
    
    UIView *loadView =[[UIView alloc]initWithFrame:frame];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2.0-15, frame.size.height/2.0-15, 30, 30)];
    [loadView addSubview:imageView];
    imageView.image =[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled = YES;

    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2.0-13.5, frame.size.height/2.0-15+26, 30, 15)];
    titleLabel.text = title;
    titleLabel.font =[UIFont systemFontOfSize:10];
    titleLabel.textColor = baseTextColor;
    [loadView addSubview:titleLabel];
    
    
    return loadView;
}



#pragma mark - 导航方式触发
/**
 *  @Author frankfan, 14-11-18 00:11:18
 *
 *  采用哪种方式导航
 *
 *  @param gesture
 */
- (void)whichWayToGO:(UITapGestureRecognizer *)gesture{

    WhichWayToGoViewController *whichWayToGo =[WhichWayToGoViewController new];
    whichWayToGo.startCoordinate = self.startCoordinate;
    whichWayToGo.destinationCoordinate = self.destinationCoordinate;
    
    if(gesture.view.tag==3001){//公交
    
        whichWayToGo.whichWay = 3001;
    }else if (gesture.view.tag==3002){//驾车
    
        whichWayToGo.whichWay = 3002;
    }else{//步行
    
        whichWayToGo.whichWay = 3003;
    }
    
    
    [self.navigationController pushViewController:whichWayToGo animated:YES];


}

#pragma mark - 公交导航
/**
 *  @Author frankfan, 14-11-18 16:11:18
 *
 *  这里面如果是公交导航的话city字段是不能少的
 *  city字段为汉语拼音，且不能含有“市”字,方法内有处理
 *  @param ori_latitude  出发地纬度
 *  @param ori_longitude 出发地经度
 *  @param des_latitude  目的地纬度
 *  @param des_longitude 目的地经度
 *  @param city          所在城市【公交导航所需】
 */
- (void)searchNaviBus:(CGFloat)ori_latitude andLongitude:(CGFloat)ori_longitude andLatitude:(CGFloat)des_latitude andLongitude:(CGFloat)des_longitude andCity:(NSString *)city{
    
    AMapNavigationSearchRequest *naviRequest = [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviBus;
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:ori_latitude longitude:ori_longitude];
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:des_latitude longitude:des_longitude];
    
    
    NSString *cityName = nil;
    if([city isEqualToString:@"长沙市"]){
        
        cityName = @"changsha";
    }else if ([city isEqualToString:@"重庆市"]){
    
        cityName = @"chongqing";
    }else{
        
        NSString *local_cityName = nil;
        if([city containsString:@"市"]){
        
            NSArray *cityEleArray = [city componentsSeparatedByString:@"市"];
            local_cityName = [cityEleArray firstObject];
        }else{
        
            local_cityName = city;
        }
        
        NSString *pingyin = [ChineseToPinyin pinyinFromChiniseString:local_cityName];
        NSString *realCityName = [pingyin lowercaseStringWithLocale:[NSLocale systemLocale]];
        cityName = realCityName;
    }
  
    naviRequest.city = cityName;
    [self.search AMapNavigationSearch: naviRequest];
}


#pragma mark -驾车导航
/* 驾车导航搜索. */
- (void)searchNaviDrive:(CGFloat)ori_latitude andLongitude:(CGFloat)ori_longitude andLatitude:(CGFloat)des_latitude andLongitude:(CGFloat)des_longitude{

    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviDrive;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:ori_latitude
                                           longitude:ori_longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:des_latitude
                                                longitude:des_latitude];

    [self.search AMapNavigationSearch:navi];
}





#pragma mark - 从代理中获取导航数据
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response{
    
    if(request.searchType == AMapSearchType_NaviBus){//公交
        
        self.trsnasts_bus = response.route.transits;//公交方案
        self.route = response.route;
    }
    
    if(request.searchType == AMapSearchType_NaviDrive){//驾车
        
        self.paths = response.route.paths;
        self.route2 = response.route;
    
    }



}




#pragma mark - 导航栏按钮触发
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
