//
//  EducationViewController.m
//  youmi
//
//  Created by frankfan on 14-9-11.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "EducationViewController.h"
#import "MainPageCustomTableViewCell.h"
#import "MJRefresh/MJRefresh.h"
#import "POP.h"
#import "PdownMenuViewController.h"

#import "CourseDetailsViewController.h"
#import "ProgressHUD/ProgressHUD.h"
#import "Reachability.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import <TMCache.h>
#import "ShopObjectModel.h"

const NSString *text_html_educaiotn = @"text/html";
const NSString *application_json_education = @"application/json";

static NSInteger _start = 10;
@interface EducationViewController ()
{

    NSString *_metereString;

    NSMutableArray *statuRecode_array;
    /*modul_end*////
    
    NSMutableArray *storeTheTag;//存储点击的tag
    
    //
    Reachability *rechability_education;
    
    NSDictionary *globalDict;
        
}

@property (nonatomic,strong)UIButton *button_meter;
@property (nonatomic,strong)UIButton *button_sort;
@property (nonatomic,strong)UIButton *button_default;

@property (nonatomic,strong)UIImageView *arrow1;
@property (nonatomic,strong)UIImageView *arrow2;
@property (nonatomic,strong)UIImageView *arrow3;

@property (nonatomic,strong)PdownMenuViewController *downMenu;
//
@property (nonatomic,strong)TMCache *tmcache_education;
@property (nonatomic,strong)NSMutableArray *shopObjects_education;//商铺对象列表
@end

@implementation EducationViewController

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
    /**/
    //
    storeTheTag =[NSMutableArray array];//存放被点击的tag
    statuRecode_array =[NSMutableArray array];

    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"文化教育";
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

    
#pragma mark 创建tableView
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, self.view.bounds.size.height-90) style:UITableViewStylePlain];
    self.tableView.tag = 3003;
    [self.tableView addHeaderWithTarget:self action:@selector(pullDownReferesh)];
    self.tableView.rowHeight = commomCellHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    

    
    
    /*创建按钮*/
    /*创建3按钮*/
#warning fake date 这个数字根据用户选择的米数做相应显示
    _metereString =[NSString stringWithFormat:@"%@",@"地区"];
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
    self.arrow1.tag = 2001;
    [self.view addSubview:self.arrow1];
    
    
    
    self.button_sort = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button_sort.frame = CGRectMake(105, 74, 80, 30);
    self.button_sort.tag = 1002;
    [self.button_sort setTitle:@"工商管理" forState:UIControlStateNormal];
    [self.button_sort setTitleColor:baseTextColor forState:UIControlStateNormal];
    self.button_sort.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.button_sort addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button_sort];
    /*创建指示器*/
    self.arrow2 =[[UIImageView alloc]initWithFrame:CGRectMake(175, 76, 20, 23)];
    self.arrow2.image =[UIImage imageNamed:@"向下箭头icon"];
    self.arrow2.tag = 2002;
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

    
    /*modul-begin*////
    //添加遮挡
    UIView *static_headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 50)];
    static_headerView.backgroundColor =[UIColor whiteColor];
    [self.view insertSubview:static_headerView belowSubview:self.button_meter];
    
    /*添加header_line*/
    UIView *headerLine =[[UIView alloc]initWithFrame:CGRectMake(0, 113, self.view.bounds.size.width, 1)];
    headerLine.backgroundColor = customGrayColor;
    [self.view addSubview:headerLine];
    /*modul_end*////

    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearArray) name:@"clearArray" object:nil];
    
#pragma mark - 上拉加载更多
    [self.tableView addFooterWithTarget:self action:@selector(pullUpCallBack)];

    
#pragma mark - 开始进来进行网络请求
    /**
     *  @Author frankfan, 14-11-20 11:11:28
     *
     *  从这里开始网络请求,这里的逻辑是：先从本地缓存读取数据，如果有就呈现，然后进行网络请求
     *  如果没有缓存，就直接进行网络请求
     *  这里缓存逻辑的目的并非节省用户流量，而是“尽快”给用户显示内容
     *  @return
     */
    
    self.tmcache_education =[[TMCache alloc]initWithName:@"educationShop_cache"];//初始化一个缓存对象
    rechability_education =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if([self.tmcache_education objectForKey:@"key_educationShop_cache"]){
        
        NSDictionary *resultDict = [self.tmcache_education objectForKey:@"key_educationShop_cache"];
        self.shopObjects_education = [[resultDict objectForKey:@"data"] mutableCopy];
    }

    NSDictionary *parameters = @{api_typeId:self.shopType_education,api_start:@0,api_limit:@10};
    AFHTTPRequestOperationManager *getShopList_manager =[self createNetworkRequstObjc:application_json_education];
  
    if([rechability_education isReachable]){//网络正常
        
        //开始进行网络请求
        [ProgressHUD show:nil];
        [getShopList_manager GET:API_ShopList parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *resultDict = (NSDictionary *)responseObject;
            self.shopObjects_education = [[resultDict objectForKey:@"data"] mutableCopy];
            
            
            [self.tableView reloadData];
            
            [self.tmcache_education setObject:resultDict forKey:@"key_educationShop_cache"];
            
            [ProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@".....error:%@\n",[error localizedDescription]);
            [ProgressHUD showError:@"网络错误" Interaction:NO];
        }];
    }else{//网络异常
        
        [ProgressHUD showError:@"网络异常" Interaction:NO];
    }

    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 三个按钮回调
/**
 *  @Author frankfan, 14-10-30 15:10:36
 *
 *  3个下拉菜单的处理
 *
 *  @param sender 当前点击的button
 */

- (void)buttonClicked:(UIButton *)sender{

    NSLog(@"senderTag:%ld",(long)sender.tag);
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



#pragma mark cell的生成个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return [self.shopObjects_education count];
}


#pragma mark cell的创建

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MainPageCustomTableViewCell *cell = nil;
    if(tableView.tag==3003){
    
        /*次级定制cell*/
        cell =[MainPageCustomTableViewCell cellWithTableView:tableView];
        [cell.averageMoney removeFromSuperview];
        [cell.distanceFromShop removeFromSuperview];
        [cell.label removeFromSuperview];
        [cell.locationView removeFromSuperview];
        ///////////////
        
        if([self.shopObjects_education count]){
        
            NSDictionary *tempDict = self.shopObjects_education[indexPath.row];
            ShopObjectModel *shopObjcModel =[ShopObjectModel modelWithDictionary:tempDict error:nil];
            
            cell.TheShopName.text = shopObjcModel.shopName;//商铺名
            cell.TheShopAddress.text = shopObjcModel.circleName;//所属商圈
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:shopObjcModel.header] placeholderImage:[UIImage imageNamed:@"defaultBackimageSmall"]];//头像
            cell.aboutUpay.text = shopObjcModel.shopTitle;
        }
     }
    

    return cell;
}


#pragma mark - cell点击回调函数
/**
 *  @Author frankfan, 14-10-30 15:10:04
 *
 *  cell被点击回调，在这里处理push到下一页面
 *
 *  @param tableView 当前tableView
 *  @param indexPath tableView参数
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CourseDetailsViewController *courseDetail =[CourseDetailsViewController new];
    courseDetail.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *tempDict =self.shopObjects_education[indexPath.row];
    ShopObjectModel *shopObjcModel =[ShopObjectModel modelWithDictionary:tempDict error:nil];
    
    courseDetail.shopModel = shopObjcModel;
    
    [self.navigationController pushViewController:courseDetail animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}








#pragma mark 下拉刷新

- (void)pullDownReferesh{

    NSDictionary *parameters = @{api_typeId:self.shopType_education,api_start:@0,api_limit:@10};
    AFHTTPRequestOperationManager *getShopList_manager =[self createNetworkRequstObjc:application_json_education];
    
    if([rechability_education isReachable]){//网络正常
        
        //开始进行网络请求
        //[ProgressHUD show:nil];
        [getShopList_manager GET:API_ShopList parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *resultDict = (NSDictionary *)responseObject;
            self.shopObjects_education = [[resultDict objectForKey:@"data"] mutableCopy];
            
            _start = 10;
            [self.tableView reloadData];
            
            [self.tmcache_education setObject:resultDict forKey:@"key_educationShop_cache"];
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
  
    AFHTTPRequestOperationManager *manager =[self createNetworkRequstObjc:application_json_education];
    NSDictionary *parameters = @{api_typeId:self.shopType_education,api_start:[NSNumber numberWithInteger:_start],api_limit:@10};
    if([rechability_education isReachable]){//如果网络正常
    
        [manager GET:API_ShopList parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *tempArray = responseObject[@"data"];
            [self.shopObjects_education addObjectsFromArray:tempArray];
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



/**
 *  @Author frankfan, 14-10-28 10:10:29
 *
 *  三大模块部分
 */
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
- (AFHTTPRequestOperationManager *)createNetworkRequstObjc:(const NSString *)content_type{

    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:content_type];
    
    return manager;
}

#pragma mark 搜索以及回退按钮回调
- (void)navi_buttonClicked:(UIButton *)sender{
    
    if (sender.tag==401) {
        
        _start = 10;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];

}



- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];;
    
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
