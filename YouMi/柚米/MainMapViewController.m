//
//  MainMapViewController.m
//  youmi
//
//  Created by frankfan on 14/11/17.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MainMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@interface MainMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{

   
}
@property (nonatomic,strong)AMapSearchAPI *search;
@property (nonatomic,strong)MAMapView *mapView;
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
    
    UIView *carView =[self createButtonItemView:CGRectMake(self.view.bounds.size.width/3.0, self.view.bounds.size.height-49, self.view.bounds.size.width/3.0, 49) andTitle:@" 驾车" andImageName:@"驾车"];
    carView.tag = 3002;
    [self.view addSubview:carView];
    
    UIView *footView =[self createButtonItemView:CGRectMake(self.view.bounds.size.width/3.0*2, self.view.bounds.size.height-49, self.view.bounds.size.width/3.0, 49) andTitle:@" 步行" andImageName:@"步行"];
    footView.tag = 3003;
    [self.view addSubview:footView];
    
   
    
    self.search.delegate = self;
    
    [self searchReGeoCode:33.55 and:118.89];

    
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
    
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
}


//地理逆向编码
- (void)searchReGeoCode:(CGFloat)latitude and:(CGFloat)longtitude{
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longtitude];
    regeoRequest.radius = 1000;
    regeoRequest.requireExtension = YES;
    [self.search AMapReGoecodeSearch: regeoRequest];


}



- (UIView *)createButtonItemView:(CGRect)frame andTitle:(NSString *)title andImageName:(NSString *)imageName{
    
    UIView *loadView =[[UIView alloc]initWithFrame:frame];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2.0-15, frame.size.height/2.0-15, 30, 30)];
    [loadView addSubview:imageView];
    imageView.image =[UIImage imageNamed:imageName];

    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2.0-13.5, frame.size.height/2.0-15+26, 30, 15)];
    titleLabel.text = title;
    titleLabel.font =[UIFont systemFontOfSize:10];
    titleLabel.textColor = baseTextColor;
    [loadView addSubview:titleLabel];
    
    
    return loadView;
}



- (void)whichWayToGO:(UITapGestureRecognizer *)gesture{



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
