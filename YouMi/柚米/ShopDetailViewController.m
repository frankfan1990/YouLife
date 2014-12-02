//
//  ShopDetailViewController.m
//  youmi
//
//  Created by frankfan on 14/11/10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "EDStarRating.h"
#import "BusinessInformationViewController.h"
#import "AppointmentDetailViewController.h"
#import "ActivityDetailViewController.h"
#import "BusinessMenInfoViewController.h"
#import "UserCommentTableViewCell.h"
#import "UserCommentListViewController.h"
#import "MainMapViewController.h"
#import "ShopPicsObjcModel.h"
#import "ShopDetailObjcModel.h"
#import <AFNetworking.h>
#import "ProgressHUD.h"
#import "Reachability.h"
#import "ShopNewsObjcModel.h"
#import "GoodsObjcModel.h"
#import "UserCommentsObjcModel.h"
#import "SignInViewController.h"
#import "ShopCollectedObjcModel.h"
#import <TMCache.h>

const NSString *application_josn = @"application/json";
const NSString *text_html = @"text/html";

@interface ShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource,EDStarRatingProtocol,UIAlertViewDelegate>
{

    /*收藏按钮是否点击*/
    BOOL isCollectioned;
    NSArray *itemTitles;//headerView上的文字
    
    NSString *string1;//第一个footerView的标题文字
    
    NSString *string2;//第二个footerView的标题文字
    
    CycleScrollView *cyclePlayImage;//轮播控件
    EDStarRating *star1;//星级评分控件
    
    NSString *userComment;//用户评论
    
    Reachability *reachability;
    
    ShopDetailObjcModel *shopDetailObjcModel;//营业信息
    ShopNewsObjcModel *shopNewsObjcModel;//商家资讯
    //
    NSArray *delegateDataSourceForBusiniessNews;//商铺资讯的代理数据源
    NSArray *delegateDataSouorceForBusiniessActivity;//商铺特惠活动代理资源
    
    BOOL businiessinfoClicked;
    BOOL businiessActivityClicked;
    
    UIButton *footerbutton1;
    NSString *globalAttentionId;
    NSDictionary *parameters2;
    
}

@property (nonatomic,strong)UITableView *tableView;//骨架
/**
 *  @Author frankfan, 14-11-10 23:11:56
 *
 *  开始创建各类dataSource
 */
@property (nonatomic,strong)NSMutableArray *shopperInfoArray;//商家资讯
@property (nonatomic,strong)NSMutableArray *originShopInfoArray;//后台发来的原始商家资讯

@property (nonatomic,strong)NSMutableArray *discountActivityArray;//特惠活动
@property (nonatomic,strong)NSMutableArray *originDiscountActivityArray;//后台发来的原始特惠活动

@property (nonatomic,strong)NSMutableArray *userCommentArray;//用户评论

@property (nonatomic,strong)NSMutableArray *cycleImageArrayURLs;//轮播图片的URL
@property (nonatomic,strong)NSMutableArray *iamgeViewArrays;//轮播图片
@property (nonatomic,strong)NSMutableArray *titlesArray;//餐饮模块的菜品文字
@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =customGrayColor;
    /**
     *  @Author frankfan, 14-11-10 23:11:57
     *
     *  在这里初始化各类数据
     */
    isCollectioned = NO;//收藏与否
    
    self.shopperInfoArray =[NSMutableArray array];
    self.discountActivityArray =[NSMutableArray array];
    
    businiessinfoClicked = NO;
    businiessActivityClicked = NO;
    
    reachability =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    itemTitles = @[@"",@"店铺信息",@"商家资讯",@"特惠活动",@"用户评论"];
    
    string1 = @"查看更多优惠";
    string2 = @"查看更多优惠";
    userComment = @"这是一条用户评论，我必须要说的是，这家店真的很烂！我必须要说的是，这家店真的很烂！我必须要说的是，这家店真的很烂！！！真是真是真的烂擦擦擦擦擦！！！！！";
    self.cycleImageArrayURLs =[NSMutableArray array];
    self.iamgeViewArrays =[NSMutableArray array];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"店铺详情";
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
    
    
    /*右侧按钮*/
    UIButton *searchButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    searchButton.enabled = NO;
    searchButton.tag = 1000;
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchButton2 =[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton2.tag = 1002;
    searchButton2.frame = CGRectMake(0, 0, 30, 30);
    [searchButton2 setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [searchButton2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 =[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    UIBarButtonItem *item2 =[[UIBarButtonItem alloc]initWithCustomView:searchButton2];
    
    NSArray *itemArrays = @[item1,item2];
    self.navigationItem.rightBarButtonItems  =itemArrays;

    
    /**
     *  @Author frankfan, 14-11-10 22:11:22
     *
     *  创建tableView
     *
     *  @return nil
     */
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = customGrayColor;
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    /**
     创建轮播控件
     */
    cyclePlayImage =[[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)
                                        animationDuration:2.8];
    cyclePlayImage.userInteractionEnabled = YES;
    __weak ShopDetailViewController *_self2 = self;
    cyclePlayImage.totalPagesCount = ^NSInteger{
        
        return [_self2.iamgeViewArrays count];
    };
    
    cyclePlayImage.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        
        return _self2.iamgeViewArrays[pageIndex];
    };
    

    /**
     *  @author frankfan, 14-12-02 13:12:04
     *
     *  在这里请求网络，判断是否收藏
     */

    if([[TMCache sharedCache]objectForKey:kUserInfo][memberID]){
    
        NSDictionary *var_userInfo = [[TMCache sharedCache]objectForKey:kUserInfo];
        AFHTTPRequestOperationManager *manager_isClooection =[self createNetworkObjc:application_josn];
        NSDictionary *parameters3 =@{api_shopId:self.shopModel.shopId,memberID:var_userInfo[memberID]};
        
        [manager_isClooection GET:API_IsColltionShopOrProducation parameters:parameters3 success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"收藏：%@",responseObject);
             NSDictionary *resultDict = (NSDictionary *)responseObject[@"data"];
             ShopCollectedObjcModel *shopCollectionModel = [ShopCollectedObjcModel modelWithDictionary:resultDict error:nil];
             
             if(shopCollectionModel.attention){
             
                 [searchButton setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
                 globalAttentionId = resultDict[@"attentionId"];
                 isCollectioned = YES;
//                 searchButton.enabled = YES;
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
             NSLog(@"%@",[error localizedDescription]);
         }];
    }
    
    
    
    /**
     *  @author frankfan, 14-11-26 11:11:35
     *
     *  在这里请求商铺详情【部分详情】
     */
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
    
    NSDictionary *parameters = @{api_shopId:self.shopModel.shopId};
    if([reachability isReachable]){
    
        [manager GET:API_ShopDetails parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *tempArray = (NSArray *)responseObject[@"data"];
            NSDictionary *shopDetaiObjcDict = [tempArray firstObject];
            shopDetailObjcModel =[ShopDetailObjcModel modelWithDictionary:shopDetaiObjcDict error:nil];
         
            if([shopDetailObjcModel.shopNewses count]>2){
            
               delegateDataSourceForBusiniessNews = [shopDetailObjcModel.shopNewses subarrayWithRange:NSMakeRange(0, 2)];
            }
            
            if([shopDetailObjcModel.goodses count]>2){
            
                delegateDataSouorceForBusiniessActivity = [shopDetailObjcModel.goodses subarrayWithRange:NSMakeRange(0, 2)];
            }
            
            /******/
            if([shopDetailObjcModel.shopNewses count]>2){
                
                string1 = @"点击查看更多";
               
                
            }else{
                
                string1 = @"没有更多信息";
                
            }
            
            if([shopDetailObjcModel.goodses count]>2){
                
                string2 = @"点击查看更多";
                
            }else{
            
                string2 = @"没有更多信息";
            
            }
            /******/
          
            /******/
            [self.tableView reloadData];
            [self handleTheCyclePlayingImages:shopDetailObjcModel.pictures];
            /********************/
            
            __weak ShopDetailViewController *_self = self;
            cyclePlayImage.totalPagesCount = ^NSInteger{
                
                return [_self.iamgeViewArrays count];
            };
            
            cyclePlayImage.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                
                return _self.iamgeViewArrays[pageIndex];
            };
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [ProgressHUD showError:@"数据错误" Interaction:NO];
            NSLog(@"error:%@",[error localizedDescription]);
        }];
        

    }else{
    
        [ProgressHUD showError:@"网络错误" Interaction:NO];
    
    }
  
    
    /**
     *  @Author frankfan, 14-11-11 13:11:38
     *
     *  创建星级评分控件
     *
     *  @param
     *
     *  @return
     */
    
    
    star1 =[[EDStarRating alloc]initWithFrame:CGRectMake(155, 10, 123, 30)];
    star1.delegate = self;
    star1.maxRating = 5;
    star1.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    star1.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    star1.horizontalMargin = 15.0;
    star1.displayMode=EDStarRatingDisplayHalf;
    star1.tintColor = baseRedColor;
    star1.editable = NO;
    [star1 setNeedsDisplay];
   
    
    
    /**
     *  @Author frankfan, 14-11-11 10:11:48
     *
     *  用来检查后台数据量
     */
    
    if([self.originShopInfoArray count]<3){
    
        string1 = @"没有更多优惠信息";
    }
    
    if([self.originDiscountActivityArray count]<3){
    
        string2 = @" 没有更多优惠信息";
    }
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - 处理轮播图片的URL以及标题
- (void)handleTheCyclePlayingImages:(NSArray *)pics{

    NSArray *imageArrays = nil;
    if([pics count]){
        
        if([pics count]>5){
            
            imageArrays =[pics subarrayWithRange:NSMakeRange(0, 5)];
            
        }else{
            
            imageArrays = pics;
        }
        
    }
    
    
    if(!imageArrays){
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
     
        
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width-10, 20)];
        titleLabel.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.22];
        titleLabel.text = @"暂无数据";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:titleLabel];
        
        [imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"defaultBackgroundImage"]];
        [self.iamgeViewArrays addObject:imageView];
        
        
    }else{

        
        for (NSDictionary *picsDict in imageArrays) {
            
            ShopPicsObjcModel *shopPicsModel =[ShopPicsObjcModel modelWithDictionary:picsDict error:nil];
           
            
            NSURL *imageURL =[NSURL URLWithString:shopPicsModel.fileCopy];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
            
            UILabel *backLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-150, 160, 150, 20)];
            backLabel.backgroundColor =[UIColor colorWithWhite:0.2 alpha:0.4];
            [imageView addSubview:backLabel];
            
            UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width-150, 20)];
            titleLabel.tag = 10087;
            titleLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
            titleLabel.textColor =[UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font =[UIFont systemFontOfSize:14];
            titleLabel.adjustsFontSizeToFitWidth = YES;
            [imageView addSubview:titleLabel];
           
            
            titleLabel.text =[NSString stringWithFormat:@" %@",shopPicsModel.pictureName];
          
            
            [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"defaultBackgroundImage"]];
            [self.iamgeViewArrays addObject:imageView];
        }
       
    }

}



#pragma mark - 创建section个数
/**
 *  @Author frankfan, 14-11-10 22:11:17
 *
 *  创建5个section
 *
 *  @param tableView
 *
 *  @return
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return 5;
}


#pragma mark - 创建每个section中得row个数
/**
 *  @Author frankfan, 14-11-10 23:11:03
 *
 *  给每个section创建相应个数的cell
 *
 *  @return
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(section==0){
    
        return 1;
    }

    if(section==1){
    
        return 4;
    }
    
    if(section==2){//商家资讯
       
        if([shopDetailObjcModel.shopNewses count]>2){
            
           
            return [delegateDataSourceForBusiniessNews count];
            
        }else{
            
          
            return [shopDetailObjcModel.shopNewses count];
        }
     
    }
    
    if(section==3){//特惠活动
    
        if([shopDetailObjcModel.goodses count]>2){
        
            return [delegateDataSouorceForBusiniessActivity count];
            
        }else{
        
            return [shopDetailObjcModel.goodses count];
            
        }
     
    }
    if(section==4){//用户评论
    
        if([shopDetailObjcModel.comments count]>1){
        
            return 1;
        }else{
        
            return [shopDetailObjcModel.comments count];
        }
   
    }
    
    return 0;
}


#pragma mark - headerView的高度
/**
 *  @Author frankfan, 14-11-10 23:11:18
 *
 *  这里返回headerView的高度
 *
 *  @return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if(section!=0){
    
        return 25;
        
    }
    
    return 0;

}


#pragma mark - haederView定义
/**
 *  @Author frankfan, 14-11-11 10:11:33
 *
 *  这里定义的是item的各部分内容
 *
 *  @param tableView
 *  @param section
 *
 *  @return
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, 53)];
    backView.backgroundColor = customGrayColor;
    
    UIImageView *widget =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    widget.image = [UIImage imageNamed:@"竖标签"];
    [backView addSubview:widget];
    
    UILabel *itemTitle =[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 123, 30)];
    [backView addSubview:itemTitle];
    itemTitle.font =[UIFont systemFontOfSize:14];
    itemTitle.textColor = baseTextColor;
    itemTitle.text = itemTitles[section];

    if(section==4){
    
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(255, 0, 45, 30);
        [button setTitleColor:[UIColor colorWithWhite:0.55 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font =[UIFont systemFontOfSize:14];
        //在这里显示一共有多少条评论
        NSString *commentsCount =[NSString stringWithFormat:@"%d",[shopDetailObjcModel.comments count]];
        [button setTitle:[NSString stringWithFormat:@"%@条",commentsCount] forState:UIControlStateNormal];
        [backView addSubview:button];
        [button addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return backView;

}


#pragma mark - 跳转到评论
- (void)commentButtonClicked{

    if([shopDetailObjcModel.comments count] > 1){
    
        UserCommentListViewController *userCommentList =[UserCommentListViewController new];
        userCommentList.hidesBottomBarWhenPushed = YES;
        userCommentList.userComments = shopDetailObjcModel.comments;
        [self.navigationController pushViewController:userCommentList animated:YES];
    }else{
    
        [ProgressHUD showError:@"暂无更多评论"];
    }
   
}



#pragma mark - footerView定义
/**
 *  @Author frankfan, 14-11-11 10:11:21
 *
 *  这里是处理点击显示更多
 *
 *  @param CGFloat
 *
 *  @return
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    
    if(section==2){
        footerbutton1 =[UIButton buttonWithType:UIButtonTypeCustom];
        footerbutton1.tag = 4002;
        footerbutton1.frame = CGRectMake(0, 0, self.view.bounds.size.width-20, 30);
        footerbutton1.backgroundColor = [UIColor whiteColor];
        [footerbutton1 setTitleColor:baseTextColor forState:UIControlStateNormal];
        footerbutton1.titleLabel.font =[UIFont systemFontOfSize:14];
        
        UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        line1.backgroundColor = customGrayColor;
        [footerbutton1 addSubview:line1];
        
        [footerbutton1 setTitle:string1 forState:UIControlStateNormal];
        [footerbutton1 addTarget:self action:@selector(footerViewDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        return footerbutton1;
    }
    
    if(section==3){
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 4003;
        button.frame = CGRectMake(0, 0, self.view.bounds.size.width-20, 30);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:baseTextColor forState:UIControlStateNormal];
        button.titleLabel.font =[UIFont systemFontOfSize:14];
        
        UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        line1.backgroundColor = customGrayColor;
        [button addSubview:line1];
        [button addTarget:self action:@selector(footerViewDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:string2 forState:UIControlStateNormal];
        return button;
    }

    return nil;
}



#pragma mark - footerView触发事件
- (void)footerViewDidClicked:(UIButton *)sender{

    if(sender.tag==4002){//商家资讯部分
    
        
        NSMutableArray *indexPaths =[NSMutableArray array];
        
        if([shopDetailObjcModel.shopNewses count]>2){//如果大于2,则允许点击扩展列表
           
            for (int index = 2; index<[shopDetailObjcModel.shopNewses count]; index++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:2];
                [indexPaths addObject:indexPath];
            }

            if(!businiessinfoClicked){//展开
                
                businiessinfoClicked = YES;
                delegateDataSourceForBusiniessNews = shopDetailObjcModel.shopNewses;//更新数据源
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
                
           
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    string1 = @"没有更多信息";
                    [footerbutton1 setTitle:string1 forState:UIControlStateNormal];
                    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
                    
                });
                
                return;
                
            }
        
            if(businiessinfoClicked){//收起
        
                businiessinfoClicked = NO;
                delegateDataSourceForBusiniessNews = [shopDetailObjcModel.shopNewses subarrayWithRange:NSMakeRange(0, 2)];
            
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];

           

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    string1 = @"点击查看更多";
                    [self.tableView reloadData];
                    
                });
            }
            
        }
        
        
    }else if (sender.tag==4003){//特惠活动
        
    
        NSMutableArray *indexPaths =[NSMutableArray array];
        
        if([shopDetailObjcModel.goodses count]>2){//如果大于2,则允许点击扩展列表
            
            for (int index = 2; index<[shopDetailObjcModel.goodses count]; index++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:3];
                [indexPaths addObject:indexPath];
            }
        
            
            if(!businiessActivityClicked){//展开
                
                businiessActivityClicked = YES;
                delegateDataSouorceForBusiniessActivity = shopDetailObjcModel.goodses;//更新数据源
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    string2 = @"没有更多信息";
                    [self.tableView reloadData];
                    
                });
                
                return;
                
            }
            
            if(businiessActivityClicked){//收起
                
                businiessActivityClicked = NO;
                delegateDataSouorceForBusiniessActivity = [shopDetailObjcModel.goodses subarrayWithRange:NSMakeRange(0, 2)];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                
//                string2 = @"点击查看更多";
//                [self.tableView reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    string2 = @"点击查看更多";
                    [self.tableView reloadData];
                });
            }
        
        }
        
    }

}



#pragma mark - footerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if(section==2 || section==3){
    
        return 35;
    }
    
    return 0;


}



#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0){
    
        return 180;
    }
    
    if(indexPath.section==1){
        
        if(indexPath.row==0){
        
            return 65;
        }else{
        
            return 44;
        }
        
    }
    
    if(indexPath.section==2){
    
        return 44;
    }


    if(indexPath.section==3){
    
        return 70;
    }
    
    if(indexPath.section==4){//用户评论

    
        NSDictionary *tempDict = nil;
        UserCommentsObjcModel *userComment_local = nil;
        if([shopDetailObjcModel.comments count]){
            
            tempDict =shopDetailObjcModel.comments[indexPath.row];
            userComment_local =[UserCommentsObjcModel modelWithDictionary:tempDict error:nil];
        }
        
        
        
        if([userComment_local.content length]){
            
            CGFloat commentContentHeight = [self caculateTheTextHeight:userComment_local.content andFontSize:14];
            return commentContentHeight+35;
        }else{
        
            return 10+35;
        }

    }
    
    return 0;

}

#pragma mark - cell被点击触发
/**
 *  @Author frankfan, 14-11-11 23:11:01
 *
 *  cell被点击，触发对应响应
 *
 *  @param UITableViewCell
 *
 *  @return
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    if(indexPath.section==1){
        
        if(indexPath.row==1){//营业信息
        
            BusinessInformationViewController *businiessInfo =[BusinessInformationViewController new];
            if([shopDetailObjcModel.businesses count]){
            
                businiessInfo.objecDict = shopDetailObjcModel.businesses[0];
                
                businiessInfo.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:businiessInfo animated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }else{
            
                [ProgressHUD showError:@"暂无数据"];
            }
       
        }
        
        if(indexPath.row==2){//店铺地址
        
            MainMapViewController *mainMap =[MainMapViewController new];
            mainMap.shopperName = self.shopModel.shopName;
           
            mainMap.lat = self.shopModel.lat;//店铺坐标
            mainMap.lng = self.shopModel.lng;
            
            mainMap.shopperName = self.shopModel.shopName;//店铺名
            mainMap.startCoordinate = self.originPosition;//当前定位坐标
            mainMap.destinationCoordinate = CLLocationCoordinate2DMake(self.shopModel.lat, self.shopModel.lng);
           
            
            mainMap.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mainMap animated:YES];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        }
        
    }

    if(indexPath.section==2){//商家资讯
        
        ShopNewsObjcModel *shopNewsObjcModel_local = nil;
        if([shopDetailObjcModel.shopNewses count]){
        
            NSDictionary *tempDict = shopDetailObjcModel.shopNewses[indexPath.row];
            shopNewsObjcModel_local = [ShopNewsObjcModel modelWithDictionary:tempDict error:nil];
        }
        
        if([shopNewsObjcModel_local.newsName length]){
        
            BusinessMenInfoViewController *businessMenInfo =[BusinessMenInfoViewController new];
            businessMenInfo.htmlString = shopNewsObjcModel_local.newsName;
            businessMenInfo.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:businessMenInfo animated:YES];
        }else{
        
            [ProgressHUD showError:@"暂无数据"];
        }
        
        
    }
    
    if(indexPath.section==3){//特惠活动
    
        ActivityDetailViewController *activityDetail =[ActivityDetailViewController new];
        activityDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityDetail animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }
    
}



#pragma mark - 创建tableViewCell
/**
 *  @Author frankfan, 14-11-10 23:11:16
 *
 *  创建cell
 *
 *  @return
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //section==0
    UITableViewCell *headerViewCell = nil;//头部轮播图
    
    
    //section==1
    UITableViewCell *cell1_0 = nil;
    UITableViewCell *cell1_1 = nil;
    UITableViewCell *cell1_2 = nil;
    UITableViewCell *cell1_3 = nil;
    
    //section==2
    UITableViewCell *cell2 = nil;
    
    //section==3
    UITableViewCell *cell3 = nil;
    
    //section==4
//    UITableViewCell *cell4 = nil;
    UserCommentTableViewCell *cell4 = nil;
    
    static NSString *cellName2 = @"cellName2";
    static NSString *cellName3 = @"cellName3";
//    static NSString *cellName4 = @"cellName4";
    
    if(indexPath.section==0){//第一段
        
        headerViewCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        headerViewCell.backgroundColor =[UIColor whiteColor];
        [headerViewCell.contentView addSubview:cyclePlayImage];
        headerViewCell.selected = NO;
        headerViewCell.userInteractionEnabled = YES;
        return headerViewCell;
        
    }
    
    if(indexPath.section==1){//第二段
    
        if(indexPath.row==0){
        
            cell1_0 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            //店铺名
            UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 45)];
            shopName.tag = 2001;
            shopName.adjustsFontSizeToFitWidth = YES;
            shopName.font = [UIFont systemFontOfSize:17];
            shopName.textColor = baseTextColor;
            [cell1_0.contentView addSubview:shopName];
            
            
            //评分控件
            [cell1_0.contentView addSubview:star1];
            star1.tag = 2002;


            //标签
            UILabel *foodInfo =[[UILabel alloc]initWithFrame:CGRectMake(10, 45, 200, 15)];
            foodInfo.tag = 2003;
            foodInfo.adjustsFontSizeToFitWidth = YES;
            foodInfo.textColor = [UIColor colorWithWhite:.75 alpha:1];
            foodInfo.font =[UIFont systemFontOfSize:14];
            [cell1_0.contentView addSubview:foodInfo];
            
            
            //金币处理规则
            UILabel *goldAbout =[[UILabel alloc]initWithFrame:CGRectMake(172, 45, 123, 15)];
            goldAbout.tag = 2004;
            goldAbout.font =[UIFont systemFontOfSize:14];
            goldAbout.textColor =[UIColor colorWithWhite:.75 alpha:1];
            [cell1_0.contentView addSubview:goldAbout];
            
            cell1_0.selectionStyle = NO;
            
            //店铺名
            shopName.text = self.shopModel.shopName;
            //评分
            star1.rating = self.shopModel.starsReviews;
            //标签
            if([self.shopModel.tagWords length]){
            
                foodInfo.text = self.shopModel.tagWords;
            }else{
                
                foodInfo.text = @"暂无数据";
            }
            
            //金币规则
            if([self.shopModel.shopTitle length]){
                
                goldAbout.text = self.shopModel.shopTitle;
            }else{
            
                goldAbout.text = @"暂无数据";
            }
            
            return cell1_0;
       }
        
        
        if(indexPath.row==1){//
        
            cell1_1 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
           
            
            UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 20, 20)];
            imageView.tag = 2005;
            imageView.image = [UIImage imageNamed:@"营业"];
            [cell1_1.contentView addSubview:imageView];
            
            UILabel *salesInfo =[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 35)];
            salesInfo.font =[UIFont systemFontOfSize:14];
            salesInfo.textColor = baseTextColor;
            salesInfo.text = @"营业信息";
            [cell1_1.contentView addSubview:salesInfo];
            
            
            UILabel *checkDetial =[[UILabel alloc]initWithFrame:CGRectMake(215, 5, 100, 35)];
            checkDetial.font =[UIFont systemFontOfSize:14];
            checkDetial.textColor = baseTextColor;
            checkDetial.text = @"查看详细";
            [cell1_1.contentView addSubview:checkDetial];
            
            
            UIImageView *arrowImageView =[[UIImageView alloc]initWithFrame:CGRectMake(255+15, 12, 20, 20)];
            arrowImageView.image =[UIImage imageNamed:@"箭头icon"];
            [cell1_1.contentView addSubview:arrowImageView];
            
            return cell1_1;
        
        }
        
        if(indexPath.row==2){
        
            cell1_2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            UIImageView *locationIcon =[[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 15, 17)];
            locationIcon.image =[UIImage imageNamed:@"地标"];
            [cell1_2.contentView addSubview:locationIcon];
            
            UILabel *shopAddress =[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 280, 35)];
            shopAddress.tag = 2006;
            shopAddress.font =[UIFont systemFontOfSize:14];
            shopAddress.textColor = baseTextColor;
            shopAddress.adjustsFontSizeToFitWidth = YES;
            [cell1_2.contentView addSubview:shopAddress];
            //地址
            shopAddress.text = self.shopModel.address;
            
            return cell1_2;
        }
        
        if(indexPath.row==3){
        
            cell1_3 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            UIImageView *phoneIcon =[[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 15, 17)];
            phoneIcon.image =[UIImage imageNamed:@"电话"];
            [cell1_3.contentView addSubview:phoneIcon];
        
            //手机号码
            UIButton *phoneNumLabel =[UIButton buttonWithType:UIButtonTypeCustom];
            phoneNumLabel.frame = CGRectMake(30, 5, 110, 35);
            phoneNumLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            phoneNumLabel.titleLabel.font =[UIFont systemFontOfSize:14];
            [phoneNumLabel setTitleColor:baseTextColor forState:UIControlStateNormal];
            [cell1_3.contentView addSubview:phoneNumLabel];
            [phoneNumLabel addTarget:self action:@selector(phoneNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            phoneNumLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//button文字靠左对齐
            
            UIButton *appointment =[UIButton buttonWithType:UIButtonTypeCustom];
            appointment.layer.cornerRadius = 3;
            appointment.frame = CGRectMake(180, 5, 100, 32);
            appointment.backgroundColor =baseRedColor;
            [appointment setTitle:@"预约" forState:UIControlStateNormal];
            [appointment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell1_3.contentView addSubview:appointment];
            cell1_3.selectionStyle = NO;
            [appointment addTarget:self action:@selector(appointmentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            
            //电话号码
            NSString *contactNumber = nil;
            if([self.shopModel.contact length]){
            
                NSArray *phoneNumbers = [self.shopModel.contact componentsSeparatedByString:@" "];
                if([phoneNumbers count]>=2){
                    
                    contactNumber = [phoneNumbers firstObject];
                }else{
                    
                    contactNumber = self.shopModel.contact;
                }
                
            }
            
            [phoneNumLabel setTitle:contactNumber forState:UIControlStateNormal];
            
            return cell1_3;
        
        }
        
    }
    
    if(indexPath.section==2){//第三段
    
        cell2 = [tableView dequeueReusableCellWithIdentifier:cellName2];
        if(!cell2){
            
            cell2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName2];
            
            UILabel *shopperInfo =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100,cell2.self.bounds.size.height)];
            shopperInfo.tag = 3000;
            shopperInfo.textAlignment = NSTextAlignmentLeft;
            shopperInfo.adjustsFontSizeToFitWidth = YES;
            shopperInfo.font =[UIFont systemFontOfSize:14];
            shopperInfo.textColor = [UIColor colorWithWhite:0.75 alpha:1];
            [cell2.contentView addSubview:shopperInfo];
            
            UILabel *shopperInfoYear =[[UILabel alloc]initWithFrame:CGRectMake(120, 0,190,cell2.self.bounds.size.height)];
            shopperInfoYear.tag = 3001;
            shopperInfoYear.textAlignment = NSTextAlignmentLeft;
            shopperInfoYear.adjustsFontSizeToFitWidth = YES;
            shopperInfoYear.font =[UIFont systemFontOfSize:14];
            shopperInfoYear.textColor = [UIColor colorWithWhite:0.75 alpha:1];
            [cell2.contentView addSubview:shopperInfoYear];
        
        }
        
        UILabel *shopperInfo =(UILabel *)[cell2 viewWithTag:3000];
        UILabel *shopperInfoYear = (UILabel *)[cell2 viewWithTag:3001];
     
        
        
        
        //商家资讯
        NSDictionary *tempDict = nil;
        ShopNewsObjcModel *shopNewsObjcModel_local  =nil;
        if([shopDetailObjcModel.shopNewses count]){
            
            tempDict = shopDetailObjcModel.shopNewses[indexPath.row];
            shopNewsObjcModel_local=[ShopNewsObjcModel modelWithDictionary:tempDict error:nil];
        }
        
        shopperInfo.text = shopNewsObjcModel_local.title;
        shopperInfoYear.text = shopNewsObjcModel_local.createTime;
        cell2.selectionStyle = NO;
        return cell2;
        
    }
    
    
    if(indexPath.section==3){//第四段-特惠活动
        
        cell3 = [tableView dequeueReusableCellWithIdentifier:cellName3];
        if(!cell3){
            
            cell3 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName3];
            
            UIImageView *headerImagerView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
            headerImagerView.tag = 3001;
            headerImagerView.layer.cornerRadius = 25;
            headerImagerView.layer.masksToBounds = YES;
            [cell3.contentView addSubview:headerImagerView];
        
            
            UILabel *shopperInfo =[[UILabel alloc]initWithFrame:CGRectMake(70, 5, 200, 35)];
            shopperInfo.tag = 3002;
            shopperInfo.font =[UIFont systemFontOfSize:14];
            shopperInfo.textColor = baseTextColor;
            shopperInfo.adjustsFontSizeToFitWidth = YES;
            [cell3.contentView addSubview:shopperInfo];
            
            
            UILabel *price =[[UILabel alloc]initWithFrame:CGRectMake(70, 35, 200, 35)];
            price.tag = 3003;
            price.font =[UIFont systemFontOfSize:14];
            price.textColor = baseTextColor;
            price.adjustsFontSizeToFitWidth = YES;
            [cell3.contentView addSubview:price];
        
        }
        
        NSDictionary *tempDict = nil;
        GoodsObjcModel *goodObjcModel = nil;
        if([shopDetailObjcModel.goodses count]){
            
            tempDict = shopDetailObjcModel.goodses[indexPath.row];
            goodObjcModel =[GoodsObjcModel modelWithDictionary:tempDict error:nil];
        }
        
        
        
        //头部图像
        UIImageView *headerImageView =(UIImageView *)[cell3 viewWithTag:3001];
        headerImageView.backgroundColor =customGrayColor;
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:goodObjcModel.goodsPicture] placeholderImage:[UIImage imageNamed:@"defaultBackimageSmall"]];
        
        //店铺名称/菜品名称
        UILabel *shopperInfo =(UILabel *)[cell3 viewWithTag:3002];
        shopperInfo.text = goodObjcModel.goodsName;
        
        //价格
        double price = goodObjcModel.price;
        UILabel *priceLabel =(UILabel *)[cell3 viewWithTag:3003];
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
        return cell3;
    }
    
    if(indexPath.section==4){//第四段
    
        cell4 = [UserCommentTableViewCell cellWithTableView:tableView];
        cell4.selectionStyle = NO;
        
        UserCommentsObjcModel *userComments = nil;
        if([shopDetailObjcModel.comments count]){
            
            NSDictionary *tempDict = shopDetailObjcModel.comments[indexPath.row];
            userComments =[UserCommentsObjcModel modelWithDictionary:tempDict error:nil];
        }
        
        cell4.commentContent.text = userComments.content;
       
        CGFloat contentHeight;
        if([cell4.commentContent.text length]){
            
            contentHeight = [self caculateTheTextHeight:cell4.commentContent.text andFontSize:14];
        }else{
            
            contentHeight = 0;
        }
        
        /**
         *  @Author frankfan, 14-11-12 10:11:09
         *  这里是必须要设置的！
         */
        cell4.commentContent.frame = CGRectMake(10, 36, self.view.bounds.size.width-40, contentHeight);
        
        //来自某用户评论
        cell4.theCommenter.text = userComments.userName;
        //评论时间
        NSArray *tempArray = nil;
        if([shopDetailObjcModel.comments count]){
            
            NSDictionary *tempDict = shopDetailObjcModel.comments[indexPath.row];
            userComments =[UserCommentsObjcModel modelWithDictionary:tempDict error:nil];
            NSString *tempString = userComments.createTime;
            tempArray = [tempString componentsSeparatedByString:@" "];
        }
        
        if([tempArray count]){
        
            cell4.theDay.text = tempArray[0];
            //评论时间time
            cell4.theTime.text = tempArray[1];
        }
        
        return cell4;
    
    }
    
    
    return nil;
    
}


#pragma mark - 手机号码被触发
- (void)phoneNumberButtonClicked:(UIButton *)sender{
    
    NSString *currentNumber = sender.currentTitle;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",currentNumber]]];

    NSLog(@"%@",currentNumber);
}


#pragma mark - 预约按钮触发 跳转
- (void)appointmentButtonClicked{
    
    AppointmentDetailViewController *appointmentDetail =[AppointmentDetailViewController new];
    appointmentDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:appointmentDetail animated:YES];

}


#pragma mark - 导航栏按钮触发
/**
 *  @Author frankfan, 14-11-10 22:11:03
 *
 *  导航栏按钮触发
 *
 *  @param sender nil
 */
- (void)buttonClicked:(UIButton *)sender{

    
    if(sender.tag==10006){//回退按钮
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(sender.tag==1000){//收藏模块
    
         NSDictionary *userInfo = [[TMCache sharedCache]objectForKey:kUserInfo];
        AFHTTPRequestOperationManager *manager =[self createNetworkObjc:text_html];
        AFHTTPRequestOperationManager *manager2 =[self createNetworkObjc:application_josn];
        NSDictionary *parameters = nil;
        if(userInfo[memberID]){
        
           parameters = @{memberID:userInfo[memberID],@"shopId":shopDetailObjcModel.shopId,@"attentionType":@1};//添加收藏
        }
 
        
        if(!isCollectioned){//如果还没收藏
            
            UIButton *button = (UIButton *)sender;
            if(![userInfo[memberID] length]){//如果没有登录
            
                [ProgressHUD showError:@"请先登录" Interaction:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    SignInViewController *signViewController =[SignInViewController new];
                    [self.navigationController pushViewController:signViewController animated:YES];
                });
            
            }else{//如果已登录
                
                [manager POST:API_CollectionShopOrProducation parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                {
                    NSLog(@"~~~收藏:%@",responseObject);
                    [button setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
                    isCollectioned = YES;
                  
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"error:%@",[error localizedDescription]);
                    [ProgressHUD showError:@"收藏失败" Interaction:NO];
                }];
               
            }
         
            
        }else{//如果早已收藏
            
            NSDictionary *parameters =@{@"attentionId":globalAttentionId};
            [manager2 POST:API_DecollectionShopOrProducation parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                
                 NSLog(@"2~~~取消收藏:%@",responseObject);
                
                UIButton *button = (UIButton *)sender;
                [button setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                isCollectioned = NO;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                 NSLog(@"error:%@",[error localizedDescription]);
                [ProgressHUD showError:@"操作失败" Interaction:NO];
            }];
         

        }
       
    }

    if(sender.tag==1002){//分享
    
    
        NSLog(@"分享");
    
    }

}


//创建忘了请求实体对象
- (AFHTTPRequestOperationManager *)createNetworkObjc:(const NSString *)contentType{
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:contentType];
    
    return manager;
}



/**
 *  @Author frankfan, 14-11-12 10:11:28
 *
 *  动态计算给定文字的高度
 *
 *  @param string   输入文字
 *  @param fontSize 文字font大小
 *
 *  @return 所占高度
 */
- (CGFloat)caculateTheTextHeight:(NSString *)string andFontSize:(int)fontSize{
    
    /*非彻底性封装,这里给定固定的宽度,后面的被减掉的阀值与高度成正比*/
    CGSize constraint = CGSizeMake(self.view.bounds.size.width-60, CGFLOAT_MAX);
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:string
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    
    return size.height;
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
