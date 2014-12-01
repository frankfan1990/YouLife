//
//  FoodDetailViewController.m
//  youmi
//
//  Created by frankfan on 14-9-10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//美食饮茶

#import "FoodDetailViewController.h"
#import "ItemDetailController.h"

#import "MainPageCustomTableViewCell.h"
#import "MJRefresh/MJRefresh.h"
#import "PdownMenuViewController.h"
#import <TMCache.h>
#import "POP/POP.h"//用来处理“三大模块”的标示旋转动画
#import "ShopDetailViewController.h"

#import "LocationManager.h"
#import "UIImageView+WebCache.h"
#import <AFNetworking.h>
#import "ShopObjectModel.h"
#import "ProgressHUD.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import <TMCache.h>
#import <MapKit/MapKit.h>
#import "convert.h"
#import "convert2.h"

#import <MAMapKit/MAMapKit.h>

static NSInteger _start = 10;
@interface FoodDetailViewController ()<MKMapViewDelegate,MAMapViewDelegate>
{

    NSString *_metereString;
    /*modul_begin*///
    NSMutableArray *statuRecode_array;
    /*modul_end*////
    NSMutableArray *storeTheTag;//存储点击的tag
    
    Reachability *rechability;
    
    BOOL isPullUpMode;//如果向上加载更多方法被执行,则改变数据加载逻辑
    
    CLLocationManager *locationManager;//定位当前
    CLLocationCoordinate2D currentMarsLocation;//当前位置的火星坐标
 
    MAMapView *mamapView;
}


@property (nonatomic,strong)UIButton *button_meter;
@property (nonatomic,strong)UIButton *button_sort;
@property (nonatomic,strong)UIButton *button_default;

@property (nonatomic,strong)UIImageView *arrow1;
@property (nonatomic,strong)UIImageView *arrow2;
@property (nonatomic,strong)UIImageView *arrow3;

@property (nonatomic,strong)PdownMenuViewController *downMenu;

//
@property (nonatomic,strong)TMCache *tmCache;
@property (nonatomic,strong)NSMutableArray *shopObjects;//商铺对象列表
@property (nonatomic,strong)NSMutableArray *shopMarLocations;//商品火星坐标数组
@property (nonatomic,strong)NSMutableArray *distanceFromAtoB;//计算两地距离

@end

@implementation FoodDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    //
    storeTheTag =[NSMutableArray array];//存放被点击的tag
    statuRecode_array =[NSMutableArray array];
    self.whichMode = self.index;
    /**
     在这里开始初始化数据
     */
    
    self.shopObjects = [NSMutableArray array];
    
    isPullUpMode = NO;
    
    self.shopMarLocations =[NSMutableArray array];
    
    self.distanceFromAtoB =[NSMutableArray array];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"美食饮茶";
    title.textColor = baseRedColor;
    self.navigationItem.titleView = title;
    
    /*leftbarbutton*/
    UIButton *leftbarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    leftbarButton.tag = 401;
    leftbarButton.frame = CGRectMake(0, 0, 25, 25);
    [leftbarButton setImage:[UIImage imageNamed:@"朝左箭头icon"] forState:UIControlStateNormal];
    [leftbarButton addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithCustomView:leftbarButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    /*rightbarButton*/
    UIButton *rightbarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rightbarButton.tag = 402;
    rightbarButton.frame = CGRectMake(0, 0, 25, 25);
    [rightbarButton setImage:[UIImage imageNamed:@"搜索icon"] forState:UIControlStateNormal];
    [rightbarButton addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightbarButton];
    self.navigationItem.rightBarButtonItem = rightbarButtonItem;
    
 
    
    /*创建tableView105-----114*/
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, self.view.bounds.size.height-100) style:UITableViewStylePlain];
    self.tableView.rowHeight = commomCellHeight;
    self.tableView.tag = 3003;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    #pragma mark 添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(pullDownToReferesh)];

#pragma mark - 添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(pullUpCallBack)];
    
    
    /*创建3按钮*/
#warning fake date 这个数字根据用户选择的米数做相应显示
    _metereString =[NSString stringWithFormat:@"%@m",@"1000"];
    self.button_meter =[UIButton buttonWithType:UIButtonTypeCustom];
    self.button_meter.tag = 1001;
    self.button_meter.frame = CGRectMake(5, 74, 75, 30);
    [self.button_meter setTitle:_metereString forState:UIControlStateNormal];
    [self.button_meter setTitleColor:baseTextColor forState:UIControlStateNormal];
    self.button_meter.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.button_meter addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button_meter];
    /*创建指示器*/
    self.arrow1 =[[UIImageView alloc]initWithFrame:CGRectMake(65, 76, 20, 23)];
    self.arrow1.image =[UIImage imageNamed:@"向下箭头icon"];
    self.arrow1.tag=2001;
    [self.view addSubview:self.arrow1];
    
    
    
    self.button_sort = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button_sort.frame = CGRectMake(105, 74, 80, 30);
    self.button_sort.tag = 1002;
    [self.button_sort setTitle:@"全部分类" forState:UIControlStateNormal];
    [self.button_sort setTitleColor:baseTextColor forState:UIControlStateNormal];
    self.button_sort.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.button_sort addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button_sort];
    /*创建指示器*/
    self.arrow2 =[[UIImageView alloc]initWithFrame:CGRectMake(175, 76, 20, 23)];
    self.arrow2.image =[UIImage imageNamed:@"向下箭头icon"];
    self.arrow2.tag=2002;
    [self.view addSubview:self.arrow2];
    
    
    
    self.button_default = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button_default.frame = CGRectMake(218, 74, 80, 30);
    self.button_default.tag = 1003;
    [self.button_default setTitle:@"默认排序" forState:UIControlStateNormal];
    [self.button_default setTitleColor:baseTextColor forState:UIControlStateNormal];
    self.button_default.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.button_default addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button_default];
    /*创建指示器*/
    self.arrow3 =[[UIImageView alloc]initWithFrame:CGRectMake(288, 76, 20, 23)];
    self.arrow3.image =[UIImage imageNamed:@"向下箭头icon"];
    self.arrow3.tag = 2003;
    [self.view addSubview:self.arrow3];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearArray) name:@"clearArray" object:nil];
    
    //添加遮挡
    UIView *static_headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 50)];
    static_headerView.backgroundColor =[UIColor whiteColor];
    [self.view insertSubview:static_headerView belowSubview:self.button_meter];
    
    /*添加header_line*/
    UIView *headerLine =[[UIView alloc]initWithFrame:CGRectMake(0, 113, self.view.bounds.size.width, 1)];
    headerLine.backgroundColor = customGrayColor;
    [self.view addSubview:headerLine];

    
    /**
     *  @Author frankfan, 14-11-21 10:11:54
     *
     *  获取当前坐标
     *
     *  @return 当前坐标
     */
    
    locationManager =[[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
   
    //当前位置的火星坐标-这里待商榷是否需要转火星坐标
    currentMarsLocation = transform(locationManager.location.coordinate);

    
    
    
    locationManager =[[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
#pragma mark - 网络请求
    /**
     *  @Author frankfan, 14-11-20 11:11:28
     *
     *  从这里开始网络请求,这里的逻辑是：先从本地缓存读取数据，如果有就呈现，然后进行网络请求
     *  如果没有缓存，就直接进行网络请求
     *  这里缓存逻辑的目的并非节省用户流量，而是“尽快”给用户显示内容
     *  @return
     */
    
    self.tmCache =[[TMCache alloc]initWithName:@"foodShop_cache"];//初始化一个缓存对象
    rechability =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if([self.tmCache objectForKey:@"key_foodShopCache"]){
        
        NSDictionary *resultDict = [self.tmCache objectForKey:@"key_foodShopCache"];
        self.shopObjects = [[resultDict objectForKey:@"data"] mutableCopy];
    }
    
    //请求商铺列表
    
    NSDictionary *parameters = @{api_typeId:self.shopTypeID,api_start:@0,api_limit:@10};
    AFHTTPRequestOperationManager *getShopList_manager =[AFHTTPRequestOperationManager manager];
    getShopList_manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
    
        if([rechability isReachable]){//网络正常
            
            //开始进行网络请求
//            [ProgressHUD show:nil];
            [getShopList_manager GET:API_ShopList parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *resultDict = (NSDictionary *)responseObject;
                self.shopObjects = [[resultDict objectForKey:@"data"] mutableCopy];

                
                //将百度坐标转火星坐标，并放入相应数组
                [self theDistanceBetweenAandB];
                
                [self.tableView reloadData];
        
                [self.tmCache setObject:resultDict forKey:@"key_foodShopCache"];
                
//                [ProgressHUD dismiss];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@".....error:%@\n",[error localizedDescription]);
                [ProgressHUD showError:@"网络错误" Interaction:NO];
            }];
        }else{//网络异常
            
            [ProgressHUD showError:@"网络异常" Interaction:NO];
        }

  
    // Do any additional setup after loading the view.
   
}





/**
 *  @Author frankfan, 14-11-21 16:11:12
 *
 *  计算两地的距离
 *
 *  @return
 */

#warning 这里不适用上拉加载更多
#pragma mark - 计算两地距离
- (void)theDistanceBetweenAandB{

    //将百度坐标转火星坐标，并放入相应数组
    for (NSDictionary *tempDict in self.shopObjects) {
        
        double mar_lat;//火星坐标纬度
        double mar_longitude;//火星坐标经度
        
        double bd_lat;
        double bd_lng;
        if([tempDict[@"lat"]isKindOfClass:[NSNull class]]){
            
            bd_lat = 0.0;
            bd_lng = 0.0;
        }else{
            
            bd_lat = [[tempDict objectForKey:@"lat"]doubleValue];
            bd_lng = [[tempDict objectForKey:@"lng"]doubleValue];
        }
        
        
        
        bd_decrypt(bd_lat, bd_lng, &mar_lat, &mar_longitude);//百度坐标转火星坐标
        
        
        //计算两地距离
        double distanceAB;
        if(currentMarsLocation.latitude){
            
            if(bd_lat==0.0){
                
                distanceAB = 0.0;
            }else{
                
                distanceAB = LantitudeLongitudeDist(currentMarsLocation.longitude, currentMarsLocation.latitude, bd_lng, bd_lat);
            }
            
            
        }
        [self.distanceFromAtoB addObject:[NSNumber numberWithDouble:distanceAB]];
        
        
    }


}


#pragma mark 三个按钮回调

- (void)buttonClicked:(UIButton *)sender{

    /*动画模块_begin*/
    NSInteger whichTag;
    if(sender.tag==1001){
        
        whichTag = 2001;
    }else if (sender.tag==1002){
        
        whichTag = 2002;
    }else{
        
        whichTag = 2003;
    }
    
    
    if([storeTheTag count]<3){
        
        if([storeTheTag count]==2){
            
            [storeTheTag removeObjectAtIndex:0];
            [storeTheTag addObject:[NSNumber numberWithInteger:whichTag]];
            
        }else{
            
            [storeTheTag addObject:[NSNumber numberWithInteger:whichTag]];
        }
        
    }
    
    if([storeTheTag count]==2){
        
        if([storeTheTag[0]integerValue] == [storeTheTag[1]integerValue]){
            
            UIImageView *arrow = (UIImageView *)[self.view viewWithTag:[storeTheTag[0]integerValue]];
            
            POPSpringAnimation *rotate_animation =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotate_animation.toValue = @(0);
            [arrow.layer pop_addAnimation:rotate_animation forKey:@"1"];
            [storeTheTag removeAllObjects];
            
        }else{
            
            UIImageView *arrow_old = (UIImageView *)[self.view viewWithTag:[storeTheTag[0]integerValue]];
            UIImageView *arrow_new =(UIImageView *)[self.view viewWithTag:[storeTheTag[1]integerValue]];
            
            POPSpringAnimation *arrow_oldAniamtion =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            arrow_oldAniamtion.toValue = @(0);
            [arrow_old.layer pop_addAnimation:arrow_oldAniamtion forKey:@"2"];
            
            POPSpringAnimation *arrow_newAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            arrow_newAnimation.toValue = @(M_PI);
            [arrow_new.layer pop_addAnimation:arrow_newAnimation forKey:@"3"];
            
        }
        
    }else{
        
        UIImageView *arrow =(UIImageView *)[self.view viewWithTag:[storeTheTag[0]integerValue]];
        
        POPSpringAnimation *rorate_animation =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rorate_animation.toValue = @(M_PI);
        [arrow.layer pop_addAnimation:rorate_animation forKey:@"4"];
        
        
    }
    /*动画模块_end*/

    
    
    ////////////////////
        /*状态机 begin*/
    if([statuRecode_array count]<3){
        
        if([statuRecode_array count]==2){
            
            [statuRecode_array removeObjectAtIndex:0];
            [statuRecode_array addObject:[NSNumber numberWithInteger:sender.tag]];
            
        }else{
            
            [statuRecode_array addObject:[NSNumber numberWithInteger:sender.tag]];
        }
        
    }
    /*状态机 end*/
    
    
    if([statuRecode_array count]==2){
        
        if([statuRecode_array[0]integerValue]==[statuRecode_array[1]integerValue]){
            
            if(self.downMenu.theLoadView.frame.origin.y>0){

                self.downMenu.view = nil;
                self.downMenu = nil;
                [statuRecode_array removeAllObjects];
                
            }else{
               
                [UIView animateWithDuration:0.35 animations:^{
                    
                    self.downMenu.theLoadView.frame = CGRectMake(0, 114, self.view.bounds.size.width, 300);
                }];
            }
            
            
            
        }else{
            
            self.downMenu.view = nil;
            self.downMenu = nil;
            self.downMenu =[[PdownMenuViewController alloc]init];
            self.downMenu.selectedTag = sender.tag;
            
//            [self.view insertSubview:self.downMenu.view belowSubview:self.tableView];
            [self.view insertSubview:self.downMenu.view aboveSubview:self.tableView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.35 animations:^{
                    
                    self.downMenu.theLoadView.frame = CGRectMake(0, 114, self.view.bounds.size.width, 300);
                }];
                
            });
            
            
        }
    }else{
        
        
        self.downMenu.view = nil;
        self.downMenu = nil;
        self.downMenu =[[PdownMenuViewController alloc]init];
        self.downMenu.selectedTag = sender.tag;
        
//        [self.view insertSubview:self.downMenu.view belowSubview:self.tableView];
        [self.view insertSubview:self.downMenu.view aboveSubview:self.tableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.35 animations:^{
                
                self.downMenu.theLoadView.frame = CGRectMake(0, 114, self.view.bounds.size.width, 300);
            }];
            
        });
        
        
    }
    
    //if(self.downMenu && sender.tag==1001)
    if(self.downMenu){
        
        
        NSArray *flag = @[[NSNumber numberWithInteger:self.index],[NSNumber numberWithInteger:sender.tag]];//将两个标志[首页按钮,三个按钮]传过去，区别的加载数据
        [[NSNotificationCenter defaultCenter]postNotificationName:kPassLeftData_0 object:flag];
    }
    
}



#pragma mark tableView生成cell的个数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return [self.shopObjects count];
}


#pragma mark tableView创建cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MainPageCustomTableViewCell *cell =[MainPageCustomTableViewCell cellWithTableView:tableView];
    
    if([self.tmCache objectForKey:@"key_foodShopCache"] && !isPullUpMode){
    
        //从缓存中获取字典
        NSDictionary *tempDictCache = [self.tmCache objectForKey:@"key_foodShopCache"];
        if(tempDictCache){
        
            NSArray *whichCreateShopModels = tempDictCache[@"data"];
            NSDictionary *whichCreateShopModel = whichCreateShopModels[indexPath.row];
            
            NSError *error;
            ShopObjectModel *shopModel = [ShopObjectModel modelWithDictionary:whichCreateShopModel error:&error];
            
            cell.TheShopName.text = shopModel.shopName;//商铺名
            cell.TheShopAddress.text = [NSString stringWithFormat:@"%@ | %@",shopModel.typeName,shopModel.circleName];//商铺地址
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:shopModel.header] placeholderImage:[UIImage imageNamed:@"defaultBackimageSmall"]];//店铺头像
         
            
            if([self.distanceFromAtoB count]){
            
                if([self.distanceFromAtoB[indexPath.row]doubleValue]==0){
                    cell.distanceFromShop.text = @"无数据";
                }else{
                    
                    NSNumber *num = self.distanceFromAtoB[indexPath.row];
                    if(num.doubleValue>1000){
                    
                        cell.distanceFromShop.text = [NSString stringWithFormat:@"%.2fkm",num.doubleValue/1000.0];
                    }else{
                    
                        cell.distanceFromShop.text = [NSString stringWithFormat:@"%fm",num.doubleValue];
                    }
                    
                }
            }
            
        }
    }else{
        
        
        NSDictionary *tempDict = self.shopObjects[indexPath.row];
        NSError *error;
        ShopObjectModel *shopModel = [ShopObjectModel modelWithDictionary:tempDict error:&error];
        
        cell.TheShopName.text = shopModel.shopName;//商铺名
        cell.TheShopAddress.text = [NSString stringWithFormat:@"%@ | %@",shopModel.typeName,shopModel.circleName];//商铺地址
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:shopModel.header] placeholderImage:[UIImage imageNamed:@"defaultBackimageSmall"]];//店铺头像
        
        if([self.distanceFromAtoB count]){
            
            if([self.distanceFromAtoB[indexPath.row]doubleValue]==0){
                cell.distanceFromShop.text = @"无数据";
            }else{
                
                NSNumber *num = self.distanceFromAtoB[indexPath.row];
                if(num.doubleValue>1000){
                    
                    cell.distanceFromShop.text = [NSString stringWithFormat:@"%.2fkm",num.doubleValue/1000];
                }else{
                    
                    cell.distanceFromShop.text = [NSString stringWithFormat:@"%fm",num.doubleValue];
                }
                
            }
        }
        
        
        NSLog(@"else");
        NSLog(@"error:%@",[error localizedDescription]);
    }
    
    return cell;

}

#pragma mark cell被选择触发动作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    ShopDetailViewController *shopDetail =[ShopDetailViewController new];
    shopDetail.originPosition = CLLocationCoordinate2DMake(currentMarsLocation.latitude, currentMarsLocation.longitude);
    
    NSDictionary *modelDict = self.shopObjects[indexPath.row];
    shopDetail.shopModel = [ShopObjectModel modelWithDictionary:modelDict error:nil];
    
    
    if(shopDetail.shopModel){
    
        [self.navigationController pushViewController:shopDetail animated:YES];
    }else{
    
        [ProgressHUD showError:@"数据错误" Interaction:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES ];
}

#pragma mark - 下拉刷新回调方法

- (void)pullDownToReferesh{

    NSDictionary *parameters = @{api_typeId:self.shopTypeID,api_start:@0,api_limit:@10};
    AFHTTPRequestOperationManager *getShopList_manager =[AFHTTPRequestOperationManager manager];
    getShopList_manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
    if(![rechability isReachable]){
        
        [ProgressHUD showError:@"网络异常"];
        [self.tableView headerEndRefreshing];
        return;
    }else{
    
        [getShopList_manager GET:API_ShopList parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
             _start = 10;
            NSDictionary *resultDict = (NSDictionary *)responseObject;
            self.shopObjects = [[resultDict objectForKey:@"data"]mutableCopy];
            
            isPullUpMode = NO;
            [self.tableView reloadData];
            
            [self.tmCache setObject:resultDict forKey:@"key_foodShopCache"];
            [self.tableView headerEndRefreshing];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error:%@",[error localizedDescription]);
            [self.tableView headerEndRefreshing];
            [ProgressHUD showError:@"网络错误"];
            
        }];
    
    }
    
}

#pragma mark - 上拉加载更多的回调方法
- (void)pullUpCallBack{
    
    
    NSDictionary *parameters = @{api_typeId:self.shopTypeID,api_start:[NSNumber numberWithInteger:_start],api_limit:@10};
    AFHTTPRequestOperationManager *getShopList_manager =[AFHTTPRequestOperationManager manager];
    getShopList_manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
    if(![rechability isReachable]){
        
        [ProgressHUD showError:@"网络异常"];
        [self.tableView footerEndRefreshing];
        return;
    }else{
        
        [getShopList_manager GET:API_ShopList parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *resultDict = (NSDictionary *)responseObject;
            NSArray *pageArray = [resultDict objectForKey:@"data"];
            isPullUpMode = YES;
            [self.shopObjects addObjectsFromArray:pageArray];
            

            
            //获得距离数组
            //将百度坐标转火星坐标，并放入相应数组
            for (NSDictionary *tempDict in pageArray) {
                
                double mar_lat;//火星坐标纬度
                double mar_longitude;//火星坐标经度
                
                double bd_lat;
                double bd_lng;
                if([tempDict[@"lat"]isKindOfClass:[NSNull class]]){
                    
                    bd_lat = 0.0;
                    bd_lng = 0.0;
                }else{
                    
                    bd_lat = [[tempDict objectForKey:@"lat"]doubleValue];
                    bd_lng = [[tempDict objectForKey:@"lng"]doubleValue];
                }
                
            
                bd_decrypt(bd_lat, bd_lng, &mar_lat, &mar_longitude);//百度坐标转火星坐标
                
                //计算两地距离
                double distanceAB;
                if(currentMarsLocation.latitude){
                    
                    if(bd_lat==0.0){
                        
                        distanceAB = 0.0;
                    }else{
                        
                        distanceAB = LantitudeLongitudeDist(currentMarsLocation.longitude, currentMarsLocation.latitude, bd_lng, bd_lat);

                    }
                    
                }

                [self.distanceFromAtoB addObject:[NSNumber numberWithDouble:distanceAB]];
                
            }
            
            [self.tableView reloadData];
        
            [self.tableView footerEndRefreshing];
            
            _start = _start+10;//假如数据拉取成功，则标志头向右滑动11个单位
        
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error:%@",[error localizedDescription]);
            [self.tableView footerEndRefreshing];
            [ProgressHUD showError:@"网络错误"];
            
            _start = _start;//假如数据拉取失败，则标志头维持不变【逻辑清晰代码-提示作用】
        }];
        
    }
    
}

#pragma mark 导航栏上的两个按钮触发回调

- (void)navi_buttonClicked:(UIButton *)sender{

    if(sender.tag==401){
    
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
        NSLog(@"搜索...");
    }

}

- (void)clearArray{
    
    NSInteger arrow_tag = [[storeTheTag lastObject]integerValue];
    UIImageView *arrow_imageView = (UIImageView *)[self.view viewWithTag:arrow_tag];
    
    POPSpringAnimation *rotate_animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotate_animation.toValue = @(0);
    [arrow_imageView.layer pop_addAnimation:rotate_animation forKey:@"5"];
    
    
    [statuRecode_array removeAllObjects];
    [storeTheTag removeAllObjects];
    self.downMenu = nil;
    
}




- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    if([ProgressHUD shared]){
        
        [ProgressHUD dismiss];
    }
    
}


- (void)dealloc{
    

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
