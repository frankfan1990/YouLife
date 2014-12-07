//
//  AppDelegate.m
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllers.h"
#import "ADNavigationControllerDelegate.h"
#import "MMLocationManager.h"
#import <MAMapKit/MAMapKit.h>
#import "LocationManager.h"

@interface AppDelegate ()
{
  

    ADNavigationControllerDelegate *delegate;
    LocationManager *_lcManager;
    
    
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //
    /**
     *  @Author frankfan, 14-11-17 16:11:08
     *
     *  高德地图开始配置
     *
     *  @param addressString
     *
     *  @return
     */
    
    [MAMapServices sharedServices].apiKey = @"461e3b5c277c297c4fd64ed54c9fa634";
    _lcManager =[[LocationManager alloc]init];
    
    
    /**
     定位
     */
    [[MMLocationManager shareLocation]getCity:^(NSString *addressString) {
        
      
        [[NSUserDefaults standardUserDefaults]setObject:addressString forKey:kUserLocationCity];
        
    }];
    
    
    MainPageViewController *mainPageView =[[MainPageViewController alloc]init];
    ClassificationViewController *classificationView =[[ClassificationViewController alloc]init];
    MallViewController *mallView =[[MallViewController alloc]init];
    AboutMineViewController *aboutMineView =[[AboutMineViewController alloc]init];
    AboutMoreViewController *aboutMoreView =[[AboutMoreViewController alloc]init];
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    
    UINavigationController *main_navi =[[UINavigationController alloc]initWithRootViewController:mainPageView];
    

    delegate =[[ADNavigationControllerDelegate alloc]init];

    
    UINavigationController *classification_navi =[[UINavigationController alloc]initWithRootViewController:classificationView];

    
    UINavigationController *mall_navi =[[UINavigationController alloc]initWithRootViewController:mallView];

    
    UINavigationController *mine_navi =[[UINavigationController alloc]initWithRootViewController:aboutMineView];

    
    UINavigationController *more_navi =[[UINavigationController alloc]initWithRootViewController:aboutMoreView];

    
    NSArray *viewControllers =@[main_navi,classification_navi,mall_navi,mine_navi,more_navi];
    
    UITabBarController *tabbarCV =[[UITabBarController alloc]init];
    tabbarCV.viewControllers = viewControllers;
    
    UITabBarItem *item1 =[tabbarCV.tabBar.items objectAtIndex:0];
    UITabBarItem *item2 =[tabbarCV.tabBar.items objectAtIndex:1];
    UITabBarItem *item3 =[tabbarCV.tabBar.items objectAtIndex:2];
    UITabBarItem *item4 =[tabbarCV.tabBar.items objectAtIndex:3];
    UITabBarItem *item5 =[tabbarCV.tabBar.items objectAtIndex:4];
    
    item1.title = @"首页";
    item2.title = @"分类";
    item3.title = @"商城";
    item4.title = @"我的";
    item5.title = @"更多";
    
    UIImage *image = [UIImage imageNamed:@"首页未选中"];
    UIImage *selectedImage = [UIImage imageNamed:@"首页选中"];
    image =[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage =[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = image;
    item1.selectedImage = selectedImage;
    
    UIImage *image2 =[UIImage imageNamed:@"分类未选中"];
    UIImage *selectdeImage2 =[UIImage imageNamed:@"分类选中"];
    image2 =[image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectdeImage2 =[selectdeImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = image2;
    item2.selectedImage = selectdeImage2;
    
    UIImage *image3 =[UIImage imageNamed:@"商城"];
    UIImage *selectdeImage3 =[UIImage imageNamed:@"商城选中"];
    image3 =[image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectdeImage3 =[selectdeImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = image3;
    item3.selectedImage = selectdeImage3;
    
    UIImage *image4 =[UIImage imageNamed:@"我的未选中"];
    UIImage *selectdeImage4 =[UIImage imageNamed:@"我的选中"];
    image4 =[image4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectdeImage4 =[selectdeImage4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = image4;
    item4.selectedImage = selectdeImage4;

    UIImage *image5 =[UIImage imageNamed:@"更多未选中"];
    UIImage *selectdeImage5 =[UIImage imageNamed:@"更多选中"];
    image5 =[image5 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectdeImage5 =[selectdeImage5 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.image = image5;
    item5.selectedImage = selectdeImage5;
    
    tabbarCV.tabBar.backgroundImage =[UIImage imageNamed:@"底部红线"];

    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : baseRedColor }
                                             forState:UIControlStateSelected];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    self.window.rootViewController = tabbarCV;
    

    
    UIView *statusView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, 20)];
    statusView.backgroundColor = baseRedColor;
    [self.window.rootViewController.view addSubview:statusView];
    
    UIView *topLine =[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.window.bounds.size.width, 1)];
    topLine.backgroundColor = baseRedColor;
    [self.window.rootViewController.view addSubview:topLine];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


#pragma mark - 定位当前坐标
/**
 *  @author frankfan, 14-12-06 11:12:27
 *
 *  每当app被唤醒时都进行定位，并存储当前位置
 *
 *  @param application
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [_lcManager getUserNowLocationInfoWithAlert:YES getUserLocationFinish:^(BOOL success, CLLocation *userLocation) {
        
        if(userLocation){
        
            double _lat = userLocation.coordinate.latitude;
            double _lng = userLocation.coordinate.longitude;
            
            NSNumber *_latNumber =[NSNumber numberWithDouble:_lat];
            NSNumber *_lngNumber =[NSNumber numberWithDouble:_lng];
            
            if(_latNumber && _lngNumber){
            
                NSDictionary *userLocation =@{@"lat":_latNumber,@"lng":_lngNumber};
                [[NSUserDefaults standardUserDefaults]setObject:userLocation forKey:kUserLocation];

            }
  
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
