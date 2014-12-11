//
//  CourseDetailsViewController.m
//  youmi
//
//  Created by frankfan on 14/10/30.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "BuyNowViewController.h"

#import "ProgressHUD.h"
#import <AFNetworking.h>
#import "Reachability.h"
#import "SignInViewController.h"
#import "CycleScrollView.h"
#import "ShopPicsObjcModel.h"
#import "ShopDetailObjcModel.h"
#import "ShopNewsObjcModel.h"

static const NSString *text_html_education = @"text/html";
static const NSString *application_json_education = @"application/json";

#define defaultCellHeight 44

@interface CourseDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{

    /*分享按钮是否点击*/
    BOOL isCollectioned;
    
    /**
     *  @Author frankfan, 14-10-30 17:10:23
     *
     *  以下系列变量为课程详情内容相关字段
     *
     *  @param nonatomic nil
     *  @param strong    nil
     *
     *  @return nil
     */
    
    NSMutableArray *UserCommentsArray;//用户评论
    CycleScrollView *cyclePlayImage;//轮播控件
    
    UIView *bottomView;//底部的bottom
    
    
    UIView *courseAppointLoadView;//创建底部loadView
    UITextField *memberField;//显示购物的数量
    NSInteger gloabalAcount;
    
    Reachability *_reachability_education;
    NSDictionary *globalDict;
    ShopDetailObjcModel *shopDetailObjcModel;//营业信息;

}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *cycleImageArrayURLs;//轮播图片的URL
@property (nonatomic,strong)NSMutableArray *iamgeViewArrays;//轮播图片
@end

@implementation CourseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    
    
    gloabalAcount = 1;
    /*分享按钮是否点击*/
    isCollectioned = NO;
    
    /**
     这里是一系列参数的初始化
     */
    
    UserCommentsArray = [NSMutableArray array];
    self.cycleImageArrayURLs =[NSMutableArray array];
    self.iamgeViewArrays =[NSMutableArray array];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"课程详情";
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

    
#pragma make - 创建tableView
    /**
     *  @Author frankfan, 14-10-30 16:10:15
     *
     *  这里创建的tableView是整个页面的骨架
     *
     *  @return nil
     */
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = customGrayColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIView *footerView =[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
 
    
    
    /**
     *  @Author frankfan, 14-11-03 15:11:17
     *
     *  创建下端2个button
     *
     *  @param NSInteger nil
     *
     *  @return nil
     */
    
    bottomView =[[UIView alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height-44, self.view.bounds.size.width, 44)];
    [self.view addSubview:bottomView];
    
    UIButton *payNow =[UIButton buttonWithType:UIButtonTypeCustom];
    payNow.tag = 1001;
    payNow.frame = CGRectMake(0, 0, self.view.bounds.size.width/2.0, 40);
    [payNow setTitle:@"立即购买" forState:UIControlStateNormal];
    [payNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payNow.titleLabel.font =[UIFont systemFontOfSize:14];
    [payNow addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [payNow setBackgroundColor:[UIColor colorWithRed:239/255.0 green:118/255.0 blue:109/255.0 alpha:1]];
    [payNow setTitleColor:baseRedColor forState:UIControlStateHighlighted];
    [bottomView addSubview:payNow];
    
    
    UIButton *courseAppoint =[UIButton buttonWithType:UIButtonTypeCustom];
    courseAppoint.tag = 1002;
    courseAppoint.frame = CGRectMake(self.view.bounds.size.width/2.0, 0, self.view.bounds.size.width/2.0-20, 40);
    [courseAppoint setTitle:@"预约课程" forState:UIControlStateNormal];
    [courseAppoint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    courseAppoint.titleLabel.font =[UIFont systemFontOfSize:14];
    [courseAppoint addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [courseAppoint setBackgroundColor:baseRedColor];
    [courseAppoint setTitleColor:[UIColor colorWithRed:239/255.0 green:118/255.0 blue:109/255.0 alpha:1] forState:UIControlStateHighlighted];
    [bottomView addSubview:courseAppoint];

    
    
    /**
     创建轮播控件
     */
    
    cyclePlayImage =[[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)
                                        animationDuration:2.8];
    cyclePlayImage.userInteractionEnabled = YES;
    
    
    _reachability_education =[Reachability reachabilityWithHostName:@"www.baidu.com"];
#pragma mark - 网络请求
    /**
     *  @author frankfan, 14-12-10 10:12:39
     *
     *  开始网络请求
     *
     *  @return
     */
    
    AFHTTPRequestOperationManager *manager =[self createNetworkRequestObjc:application_json_education];
    NSDictionary *parameters = @{api_shopId:self.shopModel.shopId};
    if(![_reachability_education isReachable]){
        
        [ProgressHUD showError:@"网络异常"];
    
    }else{
    
        [manager GET:API_ShopDetails parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *tempArray = responseObject[@"data"];
            globalDict = [tempArray firstObject];
            shopDetailObjcModel =[ShopDetailObjcModel modelWithDictionary:globalDict error:nil];
            NSLog(@"globalDict:%@",globalDict);
            
            /******/
            [self handleTheCyclePlayingImages:shopDetailObjcModel.pictures];
            [self.tableView reloadData];
            /********************/
            
            __weak CourseDetailsViewController *_self = self;
            cyclePlayImage.totalPagesCount = ^NSInteger{
                
                return [_self.iamgeViewArrays count];
            };
            
            cyclePlayImage.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                
                return _self.iamgeViewArrays[pageIndex];
            };

            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error:%@",[error localizedDescription]);
            [ProgressHUD showError:@"网络错误"];
        }];
    
    
    }
    

    
    
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - 底部按钮点击触发方法
- (void)bottomButtonClicked:(UIButton *)sender{

    if(sender.tag==1001){//立即购买
    
        BuyNowViewController *buyNow =[BuyNowViewController new];
        buyNow.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:buyNow animated:YES];
        
    
    }else{//预约课程
    
        courseAppointLoadView =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];
        courseAppointLoadView.backgroundColor = [UIColor whiteColor];
        
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        line.backgroundColor = baseRedColor;
        [courseAppointLoadView addSubview:line];
        
        /*商品图像*/
        UIImageView *theGoodsImage =[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 65, 65)];
        theGoodsImage.layer.cornerRadius = 3;
        theGoodsImage.layer.masksToBounds = YES;
        [courseAppointLoadView addSubview:theGoodsImage];
        
        theGoodsImage.backgroundColor =[UIColor blackColor];
        

        /*商品名*/
        UILabel *goodsname =[[UILabel alloc]initWithFrame:CGRectMake(90, -7, 123, 50)];
        goodsname.font =[UIFont boldSystemFontOfSize:16];
        goodsname.textAlignment = NSTextAlignmentLeft;
        goodsname.adjustsFontSizeToFitWidth = YES;
        goodsname.textColor = baseTextColor;
#warning fake data
        goodsname.text = @"商品名";
        [courseAppointLoadView addSubview:goodsname];
        
        /*价格*/
        UILabel *price =[[UILabel alloc]initWithFrame:CGRectMake(90, 55, 60, 30)];
        price.font =[UIFont boldSystemFontOfSize:14];
        price.textColor = baseTextColor;
        price.textAlignment = NSTextAlignmentLeft;
        price.adjustsFontSizeToFitWidth = YES;
#warning fake data
        price.text = @"价格";
        [courseAppointLoadView addSubview:price];
        
        
        /*购买数*/
        UILabel *payAcount =[[UILabel alloc]initWithFrame:CGRectMake(20, 70, 123, 50)];
        payAcount.font =[UIFont boldSystemFontOfSize:16];
        payAcount.textAlignment = NSTextAlignmentLeft;
        payAcount.adjustsFontSizeToFitWidth = YES;
        payAcount.textColor = baseTextColor;
        [courseAppointLoadView addSubview:payAcount];
        payAcount.text = @"购买数";
        
        UIView *line2 =[[UIView alloc]initWithFrame:CGRectMake(0, 112, self.view.bounds.size.width, 1)];
        line2.backgroundColor = customGrayColor;
        [courseAppointLoadView addSubview:line2];
        
        /*确定按钮*/
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 130, self.view.bounds.size.width-20, 35);
        button.backgroundColor = baseRedColor;
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.75 alpha:1] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(payForButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        [courseAppointLoadView addSubview:button];
        
        
        UIView *line3 =[[UIView alloc]initWithFrame:CGRectMake(0, 175, self.view.bounds.size.width, 1)];
        line3.backgroundColor = baseRedColor;
        [courseAppointLoadView addSubview:line3];
        
        UIButton *cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(280, 10, 30, 30);
        [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelBottomView) forControlEvents:UIControlEventTouchUpInside];
        [courseAppointLoadView addSubview:cancelButton];
        
        
        [self.view addSubview:courseAppointLoadView];
        [self addStepperToView];
        
        
        [self.view bringSubviewToFront:courseAppointLoadView];
        [UIView animateWithDuration:0.35 animations:^{
            
            courseAppointLoadView.frame = CGRectMake(0, self.view.bounds.size.height-courseAppointLoadView.bounds.size.height, self.view.bounds.size.width, courseAppointLoadView.bounds.size.height);
        }];
        
        
    
    }


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






#pragma mark - 取消
- (void)cancelBottomView{

    [UIView animateWithDuration:0.3 animations:^{
        
        courseAppointLoadView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, courseAppointLoadView.bounds.size.height);
        courseAppointLoadView = nil;
        
    }];
    
    [memberField resignFirstResponder];
    
}


#pragma mark - 确定预定按钮触发
- (void)payForButtonClicked:(UIButton *)sender{

    NSLog(@"预定");

}



#pragma mark - 创建步进器
/**
 *  @Author frankfan, 14-11-03 23:11:23
 *
 *  创建步进器
 *
 *  @param NSInteger nil
 *
 *  @return nil
 */

- (void)addStepperToView{

    /**
     *  @Author frankfan, 14-11-03 18:11:50
     *
     *  创建步进器
     */
    UIButton *stepButton =[UIButton buttonWithType:UIButtonTypeCustom];
    stepButton.frame = CGRectMake(190, 80-10, 95+20, 30+10);
    stepButton.layer.borderWidth = 2;
    stepButton.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    stepButton.layer.cornerRadius = 3;
    [courseAppointLoadView addSubview:stepButton];
    
    UIButton *subButton =[UIButton buttonWithType:UIButtonTypeCustom];
    subButton.frame = CGRectMake(191, 84-5, 22+4, 22+4);
    [subButton setBackgroundImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
    [subButton setTitleColor:[UIColor colorWithWhite:0.85 alpha:1] forState:UIControlStateNormal];
    [subButton setTitleColor:[UIColor colorWithWhite:0.65 alpha:1] forState:UIControlStateHighlighted];
    [courseAppointLoadView addSubview:subButton];
    subButton.tag = 1003;
    [subButton addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *plus =[UIButton buttonWithType:UIButtonTypeCustom];
    plus.frame = CGRectMake(255+4+13, 84-4, 22+4, 22+1);
    [plus setBackgroundImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [plus setTitleColor:[UIColor colorWithWhite:0.85 alpha:1] forState:UIControlStateNormal];
    [plus setTitleColor:[UIColor colorWithWhite:0.65 alpha:1] forState:UIControlStateHighlighted];
    [courseAppointLoadView addSubview:plus];
    plus.tag = 1004;
    [plus addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    /*显示数量*/
    memberField =[[UITextField alloc]initWithFrame:CGRectMake(220+3, 84-7, 30+15, 23+3)];
    memberField.delegate = self;
    memberField.keyboardType = UIKeyboardTypeNumberPad;
    memberField.textAlignment = NSTextAlignmentCenter;
    memberField.backgroundColor = customGrayColor;
    memberField.textColor = baseTextColor;
    [courseAppointLoadView addSubview:memberField];
    memberField.text = [NSString stringWithFormat:@"%ld",(long)gloabalAcount];
    
    /**
     创建完成
     */


}


#pragma mark - textField 代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    if(![textField.text length] || [textField.text integerValue]==0){
        
        textField.text = @"1";
    }
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{

    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:500.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        
        courseAppointLoadView.frame = CGRectMake(0, self.view.bounds.size.height-courseAppointLoadView.bounds.size.height-216, self.view.bounds.size.width, courseAppointLoadView.bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        
    }];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - 步进器触发
- (void)stepperValueChanged:(UIButton *)sender{
    
    if(sender.tag==1003){
        
        NSInteger tempacount = [memberField.text integerValue];
        if(tempacount>1){
            
            memberField.text =[NSString stringWithFormat:@"%ld",tempacount-1];
            
        }
    }else{
        
        NSInteger tempacount = [memberField.text integerValue];
        memberField.text =[NSString stringWithFormat:@"%ld",tempacount+1];
        
    }
    
    [self.tableView reloadData];
    
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{


    [memberField resignFirstResponder];
}





#pragma  mark - tableView相关部分
/**
 *  @Author frankfan, 14-10-30 16:10:35
 *
 *  以下一系列方法用于处理tableView
 *
 *  @return nil
 */

#pragma mark - tableView的cell创建个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 9+[UserCommentsArray count];//基本数据个数+用户评论个数
}


#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    shopDetailObjcModel = [ShopDetailObjcModel modelWithDictionary:globalDict error:nil];
    
    ShopNewsObjcModel *shopNewsObjcModel = nil;
    if([shopDetailObjcModel.shopNewses count]){
        
        NSDictionary *tempDict = [shopDetailObjcModel.shopNewses firstObject];
        shopNewsObjcModel =[ShopNewsObjcModel modelWithDictionary:tempDict error:nil];
    
    }
    
    
    
    UITableViewCell *headerImageCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//轮播图片的cell
    UITableViewCell *infoItemCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//项目Item的名字
    UITableViewCell *shcoolInfoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//学校信息
    UITableViewCell *addressInfoCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//地址信息
    UITableViewCell *courseDetialCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//课程详情
    UITableViewCell *othersCourseCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//同校其他课程
    UITableViewCell *userCommentsCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//用户评论
    
    if(indexPath.row==0){
    
        [headerImageCell.contentView addSubview:cyclePlayImage];
        
        headerImageCell.selectionStyle = NO;
        return headerImageCell;
    }
    
    if(indexPath.row==1 || indexPath.row==4 || indexPath.row==6 ||indexPath.row==8){
    
        UIImageView *flagImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 25, 25)];
        flagImageView.image =[UIImage imageNamed:@"竖标签"];
        [infoItemCell.contentView addSubview:flagImageView];
        
        infoItemCell.backgroundColor =customGrayColor;
        
        UILabel *detialInfoLabel =[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
        detialInfoLabel.font = [UIFont systemFontOfSize:14];
        detialInfoLabel.textColor = baseTextColor;
        [infoItemCell.contentView addSubview:detialInfoLabel];
        
        infoItemCell.selectionStyle = NO;
        
        if(indexPath.row==1){
        
            detialInfoLabel.text = @"学校信息";
            
        }
        
        if(indexPath.row==4){
        
            detialInfoLabel.text = @"课程详情";
            
            UIButton *moreContent =[UIButton buttonWithType:UIButtonTypeCustom];
            moreContent.frame = CGRectMake(245, 1, 30, 30);
            moreContent.titleLabel.font =[UIFont systemFontOfSize:14];
            [moreContent setTitle:@"更多" forState:UIControlStateNormal];
            [moreContent setTitleColor:baseTextColor forState:UIControlStateNormal];
            [infoItemCell.contentView addSubview:moreContent];
            
            infoItemCell.selectionStyle = NO;
            infoItemCell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;

        }
        
        if(indexPath.row==6){
        
            detialInfoLabel.text = @"同校其他课程";
        }
        
        if(indexPath.row==8){
            
            detialInfoLabel.text = @"用户评论";
        }
        
        
        return infoItemCell;
       
    }
    
    if(indexPath.row==2){
    
        /*学校*/
        UILabel *schoolabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
        schoolabel.adjustsFontSizeToFitWidth = YES;
        schoolabel.textAlignment = NSTextAlignmentLeft;
        schoolabel.font =[UIFont systemFontOfSize:18];
        schoolabel.textColor = baseTextColor;
        [shcoolInfoCell.contentView addSubview:schoolabel];
        schoolabel.adjustsFontSizeToFitWidth = YES;
        schoolabel.text = shopDetailObjcModel.shopName;
        
        /*专业*/
        UILabel *specialtyLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 40)];
        specialtyLabel.adjustsFontSizeToFitWidth = YES;
        specialtyLabel.font =[UIFont systemFontOfSize:18];
        specialtyLabel.textAlignment = NSTextAlignmentLeft;
        specialtyLabel.textColor = baseTextColor;
        specialtyLabel.adjustsFontSizeToFitWidth = YES;
        [shcoolInfoCell.contentView addSubview:specialtyLabel];
        if(shopNewsObjcModel){
        
            specialtyLabel.text = shopNewsObjcModel.title;
        }
        
        
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(215, 0, 1, 80)];
        line.backgroundColor =customGrayColor;
        [shcoolInfoCell.contentView addSubview:line];
        
        /*学费*/
        UILabel *tuitionfeeLabel =[[UILabel alloc]initWithFrame:CGRectMake(215, 0, 85, 40)];
        tuitionfeeLabel.adjustsFontSizeToFitWidth = YES;
        tuitionfeeLabel.font =[UIFont systemFontOfSize:19];
        tuitionfeeLabel.textColor = baseTextColor;
        tuitionfeeLabel.textAlignment = NSTextAlignmentCenter;
        [shcoolInfoCell.contentView addSubview:tuitionfeeLabel];
        tuitionfeeLabel.text = @"学费";
        
        
        /*费用*/
        UILabel *pay =[[UILabel alloc]initWithFrame:CGRectMake(215, 40, 85, 40)];
        pay.adjustsFontSizeToFitWidth = YES;
        pay.textAlignment = NSTextAlignmentCenter;
        pay.font = [UIFont boldSystemFontOfSize:18];
        pay.textColor = baseTextColor;
        pay.adjustsFontSizeToFitWidth = YES;
        [shcoolInfoCell.contentView addSubview:pay];
        
        shcoolInfoCell.selectionStyle = NO;
        return shcoolInfoCell;
        
        
    }
    
    if(indexPath.row==3){
    
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 1)];
        line.backgroundColor =customGrayColor;
        [addressInfoCell.contentView addSubview:line];
        
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 3, 20, 22)];
        imageView.image =[UIImage imageNamed:@"红色地标"];
        [addressInfoCell.contentView addSubview:imageView];
        
        /*地址*/
        UILabel *addressLabel =[[UILabel alloc]initWithFrame:CGRectMake(33, 0, 200, 30)];
        addressLabel.font =[UIFont systemFontOfSize:14];
        addressLabel.textColor =baseTextColor;
        addressLabel.adjustsFontSizeToFitWidth = YES;
        [addressInfoCell.contentView addSubview:addressLabel];
        
        addressInfoCell.selectionStyle = NO;
        return addressInfoCell;
    }
 
    if(indexPath.row==5){
    
        courseDetialCell.selectionStyle = NO;
        return courseDetialCell;
    
    }
    
    if(indexPath.row==7){
    
    
        othersCourseCell.selectionStyle = NO;
        return othersCourseCell;
    
    }
    
    
    
    
    if(indexPath.row>8){
    
        userCommentsCell.selectionStyle = NO;
        return userCommentsCell;
    }
    
    
    
    
    
    
    return nil;

}


#pragma mark - tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   #warning 这里的数据需要跟后台配合
    /**
     *  @Author frankfan, 14-10-30 22:10:55
     *
     *  说明：课程详情，同类课程以及用户评论部分的高度是动态的，根据
     *  后台传过来的说明【字数】进行动态高度的调节，因此返回的高度需要
     *  跟后台接口进行配合
     *
     *  @param CGFloat nil
     *
     *  @return cell的高度
     */
    
    if(indexPath.row==0){
    
        return 180;
    }
    
    if(indexPath.row==1 || indexPath.row==4 || indexPath.row==6 ||indexPath.row==8){
    
        
        return 30;
    }
    
    if(indexPath.row==2){
    
        return 80;
    }
    
    if(indexPath.row==3){
    
        return 30;
    }
    
    if(indexPath.row==5){
    
        return 130;
    }
    
    
    if(indexPath.row==7)
    {
    
    
        return 50;
    }
    
    
    if(indexPath.row>7){
    
#warning fake data
    
        return 50;
    }
    
    /*暂时先去掉错误提示*/
    return 0;


}




/**
 *  @Author frankfan, 14-10-30 01:10:23
 *
 *  动态计算文字在固定宽度的情况下，其高度的大小
 *
 *  @param string   输入要计算的文字
 *  @param fontSize 该字体的大小
 *
 *  @return 返回所占高度
 */
- (CGFloat)caculateTheTextHeight:(NSString *)string andFontSize:(int)fontSize{
    
    /*非彻底性封装*/
    CGSize constraint = CGSizeMake(self.view.bounds.size.width-20, CGFLOAT_MAX);
    
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





/**
 *  @Author frankfan, 14-10-29 18:10:34
 *
 *  导航栏按钮触发
 *
 *  @return nil
 */
#pragma mark - 导航栏按钮触发

- (void)buttonClicked:(UIButton *)sender{
    if(sender.tag==1002){
        
        NSLog(@"1002");
    }else if (sender.tag==10006){
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        if(!isCollectioned){
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
            
            isCollectioned = YES;
        }else{
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            isCollectioned = NO;
        }
        
        
        NSLog(@"收藏");
    }
    
    
}


#pragma mark - 创建网络请求实体
- (AFHTTPRequestOperationManager *)createNetworkRequestObjc:(const NSString *)content_type{

    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:content_type];
    
    return manager;
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
