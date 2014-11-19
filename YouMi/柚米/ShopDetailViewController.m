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


@interface ShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource,EDStarRatingProtocol>
{

    /*收藏按钮是否点击*/
    BOOL isCollectioned;
    NSArray *itemTitles;//headerView上的文字
    
    NSString *string1;//第一个footerView的标题文字
    NSString *string2;//第二个footerView的标题文字
    
    CycleScrollView *cyclePlayImage;//轮播控件
    EDStarRating *star1;//星级评分控件
    
    NSString *userComment;//用户评论
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
     *  @Author frankfan, 14-11-11 11:11:06
     *
     *  开始创建轮播
     *
     *  @param count]<3
     *
     *  @return
     */
    
#warning fake data
    self.cycleImageArrayURLs = [@[@"http://vip.biznav.cn/20090615162541/pic/20090701134141962.jpg",@"http://a3.att.hudong.com/10/45/01300001024098130129454552574.jpg",@"http://qic.tw/upload/school/MID_20110503003627550.jpg",@"http://img5.imgtn.bdimg.com/it/u=2127817408,3685587629&fm=23&gp=0.jpg",@"http://image.3607.com/2012/03/31/20120320180128640.jpg"]mutableCopy];
    
    /*保证图片数组里元素不大于5个*/
    NSArray *imageArrays = nil;
    if([self.cycleImageArrayURLs count]){
        
        if([self.cycleImageArrayURLs count]>5){
            
            imageArrays =[self.cycleImageArrayURLs subarrayWithRange:NSMakeRange(0, 5)];
            
        }
        
    }
    
    if(!imageArrays){
        
        for (NSString *urlString in self.cycleImageArrayURLs) {
            
            NSURL *imageURL =[NSURL URLWithString:urlString];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
            [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"defaultBackgroundImage"]];
            [self.iamgeViewArrays addObject:imageView];
            
        }
        
    }else{
        
        
        for (NSString *urlString in imageArrays) {
            
            NSURL *imageURL =[NSURL URLWithString:urlString];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
            [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"defaultBackgroundImage"]];
            [self.iamgeViewArrays addObject:imageView];
            
        }
        
        
    }
    
    
    
    
    cyclePlayImage =[[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)
                                        animationDuration:2.8];
    cyclePlayImage.userInteractionEnabled = YES;
    
    __weak ShopDetailViewController *_self = self;
    cyclePlayImage.totalPagesCount = ^NSInteger{
        
        return [_self.iamgeViewArrays count];
    };
    
    cyclePlayImage.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        
        return _self.iamgeViewArrays[pageIndex];
    };

    
    
    
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
    
    if(section==2){
       
        return [self.shopperInfoArray count]+2;
    }
    
    if(section==3){
    
        return [self.discountActivityArray count]+2;
    }
    
    if(section==4){
    
        if([self.userCommentArray count]>=1){
        
            return 1;
        }else{
        
            return 1;
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
        [button setTitle:[NSString stringWithFormat:@"%@条",@111] forState:UIControlStateNormal];
        [backView addSubview:button];
        [button addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return backView;

}


#pragma mark - 跳转到评论
- (void)commentButtonClicked{

    UserCommentListViewController *userCommentList =[UserCommentListViewController new];
    userCommentList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userCommentList animated:YES];
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
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 4002;
        button.frame = CGRectMake(0, 0, self.view.bounds.size.width-20, 30);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:baseTextColor forState:UIControlStateNormal];
        button.titleLabel.font =[UIFont systemFontOfSize:14];
        
        UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        line1.backgroundColor = customGrayColor;
        [button addSubview:line1];
        
        [button setTitle:string1 forState:UIControlStateNormal];
        return button;
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

        
        [button setTitle:string2 forState:UIControlStateNormal];
        return button;
    }

    return nil;
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

        if([userComment length]){
            
            CGFloat commentContentHeight = [self caculateTheTextHeight:userComment andFontSize:14];
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
            businiessInfo.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:businiessInfo animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        }
        
        if(indexPath.row==2){//店铺地址
        
            MainMapViewController *mainMap =[MainMapViewController new];
            mainMap.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mainMap animated:YES];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        }
        
    }

    
    if(indexPath.section==3){//特惠活动
    
        ActivityDetailViewController *activityDetail =[ActivityDetailViewController new];
        activityDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityDetail animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }
    
    if(indexPath.section==2){//商家资讯
    
        BusinessMenInfoViewController *businessMenInfo =[BusinessMenInfoViewController new];
        businessMenInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:businessMenInfo animated:YES];
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
            UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 45)];
            shopName.tag = 2001;
            shopName.font = [UIFont systemFontOfSize:17];
            shopName.textColor = baseTextColor;
            [cell1_0.contentView addSubview:shopName];
            
            
            //评分控件
            [cell1_0.contentView addSubview:star1];
            star1.tag = 2002;


            //菜品
            UILabel *foodInfo =[[UILabel alloc]initWithFrame:CGRectMake(10, 45, 200, 15)];
            foodInfo.tag = 2003;
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
            shopName.text = @"店铺名";
            //评分
            star1.rating = (float)2.5;
            //菜品
            foodInfo.text = @"墨鱼排骨";
            //金币规则
            goldAbout.text = @"满5块送100U币";
            
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
            shopAddress.text = @"湘江世纪城";
            
            return cell1_2;
        }
        
        if(indexPath.row==3){
        
            cell1_3 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            UIImageView *phoneIcon =[[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 15, 17)];
            phoneIcon.image =[UIImage imageNamed:@"电话"];
            [cell1_3.contentView addSubview:phoneIcon];
        
            UILabel *phoneNumLabel =[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 280, 35)];
            phoneNumLabel.font =[UIFont systemFontOfSize:14];
            phoneNumLabel.textColor = baseTextColor;
            [cell1_3.contentView addSubview:phoneNumLabel];
            
            
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
            phoneNumLabel.text = @"15575829000";
            
            return cell1_3;
        
        }
        
        
    
    }
    
    if(indexPath.section==2){//第三段
    
        cell2 = [tableView dequeueReusableCellWithIdentifier:cellName2];
        if(!cell2){
            
            cell2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName2];
            
            UILabel *shopperInfo =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20,cell2.self.bounds.size.height)];
            shopperInfo.tag = 3000;
            shopperInfo.font =[UIFont systemFontOfSize:14];
            shopperInfo.textColor = [UIColor colorWithWhite:0.75 alpha:1];
            [cell2.contentView addSubview:shopperInfo];
        
        }
        
        UILabel *shopperInfo =(UILabel *)[cell2 viewWithTag:3000];
        shopperInfo.textAlignment = NSTextAlignmentCenter;
        shopperInfo.adjustsFontSizeToFitWidth = YES;
        //商家资讯
        shopperInfo.text = [NSString stringWithFormat:@"%@  %@     %@",@"2014.11.11",@"所有商品4折优惠",@"2014.11.11"];
        
        cell2.selectionStyle = NO;
        return cell2;
        
    }
    
    
    if(indexPath.section==3){//第四段
        
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
        
        //头部图像
        UIImageView *headerImageView =(UIImageView *)[cell3 viewWithTag:3001];
        headerImageView.backgroundColor =[UIColor blackColor];
        
        //店铺名称/菜品名称
        UILabel *shopperInfo =(UILabel *)[cell3 viewWithTag:3002];
        shopperInfo.text = @"大碗厨";
        
        //价格
        UILabel *price =(UILabel *)[cell3 viewWithTag:3003];
        price.text = @"￥88";
        return cell3;
    }
    
    if(indexPath.section==4){//第四段
    
        cell4 = [UserCommentTableViewCell cellWithTableView:tableView];
        cell4.selectionStyle = NO;
        
        cell4.commentContent.text = userComment;
       
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
        cell4.theCommenter.text = @"frankfan";
        //评论时间
        cell4.theDay.text = @"2014.12.28";
        //评论时间time
        cell4.theTime.text = @"12:22";
        
        return cell4;
    
    }
    
    
    
    
       return nil;
    
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
    
    if(sender.tag==1000){//收藏
    
        if(!isCollectioned){
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
            
            isCollectioned = YES;
        }else{
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            isCollectioned = NO;
        }

    
    
    }

    if(sender.tag==1002){//分享
    
    
        NSLog(@"分享");
    
    }


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
