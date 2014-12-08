//
//  SportsFitnessViewController.m
//  youmi
//
//  Created by frankfan on 14/10/28.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "SportsFitnessViewController.h"
#import "MainPageCustomTableViewCell.h"
#import "MJRefresh/MJRefresh.h"
#import "PdownMenuViewController.h"
#import <TMCache.h>
#import "POP/POP.h"//用来处理“三大模块”的标示旋转动画

#import <AFNetworking.h>
#import "Reachability.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "ShopObjectModel.h"
#import "convert2_new.h"
#import "convert_oc.h"
#import "ShopObjectModel.h"
#import "ShopDetailViewController.h"

const NSString *text_html_sports = @"text/html";
const NSString *application_json_sports = @"application/json";

static NSInteger _start = 10;

@interface SportsFitnessViewController ()
{
    NSString *_metereString;
    /*modul_begin*///
    NSMutableArray *statuRecode_array;
    /*modul_end*////
    NSMutableArray *storeTheTag;//存储点击的tag
    
    //
    NSMutableArray *shopObjcList_sports;
    Reachability *_reachAbility_sports;

}

@property (nonatomic,strong)UIButton *button_meter;
@property (nonatomic,strong)UIButton *button_sort;
@property (nonatomic,strong)UIButton *button_default;

@property (nonatomic,strong)UIImageView *arrow1;
@property (nonatomic,strong)UIImageView *arrow2;
@property (nonatomic,strong)UIImageView *arrow3;

@property (nonatomic,strong)PdownMenuViewController *downMenu;
@property (nonatomic,strong)TMCache *tmcache_sports;
@end

@implementation SportsFitnessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    //
    storeTheTag =[NSMutableArray array];//存放被点击的tag
    statuRecode_array =[NSMutableArray array];
    
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"运动健身";
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
    
    
#pragma mark - 网络请求开始
    /**
     *  @author frankfan, 14-12-06 21:12:26
     *
     *  开始进行网络请求
     *
     *  @return
     */
    
    self.tmcache_sports =[[TMCache alloc]initWithName:@"sportShop_cache"];//初始化一个缓存对象
    _reachAbility_sports =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if([self.tmcache_sports objectForKey:@"key_sportShop_cache"]){
        
        NSDictionary *resultDict = [self.tmcache_sports objectForKey:@"key_sportShop_cache"];
        shopObjcList_sports = [[resultDict objectForKey:@"data"] mutableCopy];
    }
    
    
    AFHTTPRequestOperationManager *manager =[self createNetworkRequestObjc:application_json_sports];
    NSDictionary *parameters = @{api_typeId:self.shopType_sports,api_start:@0,api_limit:@10};
    if([_reachAbility_sports isReachable]){//网络正常
    
        [manager GET:API_ShopList parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *tempDict = (NSDictionary *)responseObject;
            shopObjcList_sports = [tempDict[@"data"]mutableCopy];
            
            [self.tableView reloadData];
            [self.tmcache_sports setObject:tempDict forKey:@"key_sportShop_cache"];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error:%@",[error localizedDescription]);
            [ProgressHUD showError:@"网络异常"];
        }];
        

    
    }else{//网络异常
    
        [ProgressHUD showError:@"网络异常"];
    }
    
    
    
    
    // Do any additional setup after loading the view.
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
    
    
    return [shopObjcList_sports count];
}


#pragma mark tableView创建cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainPageCustomTableViewCell *cell =[MainPageCustomTableViewCell cellWithTableView:tableView];
    if([shopObjcList_sports count]){
    
        NSDictionary *tempDict = shopObjcList_sports[indexPath.row];
        ShopObjectModel *shopObjcModel =[ShopObjectModel modelWithDictionary:tempDict error:nil];
        
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:shopObjcModel.header] placeholderImage:[UIImage imageNamed:@"defaultBackimageSmall"]];//头像

        cell.TheShopName.text = shopObjcModel.shopName;//店铺名
        
        cell.aboutUpay.text = shopObjcModel.shopTitle;//U币
        
        if([shopObjcModel.tagWords length] && [shopObjcModel.circleName length]){//标签&所属商圈
        
            cell.TheShopAddress.text = [NSString stringWithFormat:@"%@ | %@",shopObjcModel.tagWords,shopObjcModel.circleName];
            
        }else{
            
            if([shopObjcModel.tagWords length]){
            
                cell.TheShopAddress.text = shopObjcModel.tagWords;
                
            }else{
                
                cell.TheShopAddress.text = shopObjcModel.circleName;
            }
        
        }
        
        if(shopObjcModel.perCpitaConsumption){//人均消费
            
            cell.averageMoney.text = [NSString stringWithFormat:@"%f",shopObjcModel.perCpitaConsumption];
        }else{
        
            cell.averageMoney.text = @"暂无数据";
        }
        
        if([[NSUserDefaults standardUserDefaults]objectForKey:kUserLocation][@"lat"] && shopObjcModel.lat){//已有定位数据
        
            //将对象坐标转成火星坐标
            double mar_lat,mar_lng;//目的坐标
            NSDictionary *destinationDict = [[NSUserDefaults standardUserDefaults]objectForKey:kUserLocation];
            double originLat = [destinationDict[@"lat"]doubleValue];//当前坐标
            double originLng = [destinationDict[@"lng"]doubleValue];
            
            bd_decrypt_new(shopObjcModel.lat, shopObjcModel.lng, &mar_lat, &mar_lng);
            double distanceFromAToB = [convert_oc LantitudeLongitudeDist:mar_lng andlat:mar_lat andlon2:originLng andlat2:originLat];
            cell.distanceFromShop.text = [NSString stringWithFormat:@"%.2fkm",distanceFromAToB/1000.0];
            
            
        }else{
        
            cell.distanceFromShop.text = @"暂无数据";
        }
        
    }
    
    
    return cell;
    
}


#pragma mark cell被选择触发动作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if([shopObjcList_sports count]){
    
        NSDictionary *tempDict = shopObjcList_sports[indexPath.row];
        ShopObjectModel *shopobjcModel = [ShopObjectModel modelWithDictionary:tempDict error:nil];
        
        ShopDetailViewController *shopdetailController =[ShopDetailViewController new];
        shopdetailController.shopModel = shopobjcModel;
        
        NSDictionary *locationdict = [[NSUserDefaults standardUserDefaults]objectForKey:kUserLocation];
        shopdetailController.originPosition = CLLocationCoordinate2DMake([locationdict[@"lat"]doubleValue], [locationdict[@"lng"]doubleValue]);
        
        [self.navigationController pushViewController:shopdetailController animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }else{
    
        [ProgressHUD showError:@"数据异常"];
    }

    
}


#pragma mark 下拉刷新回调方法

- (void)pullDownToReferesh{

    NSDictionary *parameters = @{api_typeId:self.shopType_sports,api_start:@0,api_limit:@10};
    AFHTTPRequestOperationManager *getShopList_manager =[self createNetworkRequestObjc:application_json_sports];
    
    if([_reachAbility_sports isReachable]){//网络正常
        
        //开始进行网络请求
        //[ProgressHUD show:nil];
        [getShopList_manager GET:API_ShopList parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *resultDict = (NSDictionary *)responseObject;
            shopObjcList_sports = [[resultDict objectForKey:@"data"] mutableCopy];
            
            _start = 10;
            [self.tableView reloadData];
            
            [self.tmcache_sports setObject:resultDict forKey:@"key_sportShop_cache"];
            [self.tableView headerEndRefreshing];
            //[ProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@".....error:%@\n",[error localizedDescription]);
            [ProgressHUD showError:@"网络错误" Interaction:NO];
            [self.tableView headerEndRefreshing];
        }];
    }else{//网络异常
        
        [ProgressHUD showError:@"网络异常" Interaction:NO];
        [self.tableView headerEndRefreshing];
        
    }
    
}

#pragma mark - 上拉加载更多的回调方法
- (void)pullUpCallBack{
    
    AFHTTPRequestOperationManager *manager =[self createNetworkRequestObjc:application_json_sports];
    NSDictionary *parameters = @{api_typeId:self.shopType_sports,api_start:[NSNumber numberWithInteger:_start],api_limit:@10};
    if([_reachAbility_sports isReachable]){//如果网络正常
        
        [manager GET:API_ShopList parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *tempArray = responseObject[@"data"];
            [shopObjcList_sports addObjectsFromArray:tempArray];
            [self.tableView reloadData];
            _start = _start+10;
            
            [self.tableView footerEndRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [ProgressHUD showError:@"网络错误"];
            _start = _start;
            
            [self.tableView footerEndRefreshing];
        }];
        
        
    }else{//网络异常
        
        [ProgressHUD showError:@"网络异常"];
        [self.tableView footerEndRefreshing];
    }
    
}



#pragma mark 导航栏上的两个按钮触发回调

- (void)navi_buttonClicked:(UIButton *)sender{
    
    if(sender.tag==401){
        
        _start = 10;
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


#pragma mark - 创建网络请求实体对象
- (AFHTTPRequestOperationManager *)createNetworkRequestObjc:(const NSString *)content_type{

    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:content_type];
    
    return manager;

}



- (void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
