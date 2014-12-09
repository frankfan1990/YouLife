//
//  ActivityDetailViewController.m
//  youmi
//
//  Created by frankfan on 14/11/11.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "CycleScrollView.h"
#import "UserCommentListViewController.h"
#import "UIImageView+WebCache.h"
#import "MoreActivityDetailViewController.h"
#import "UserCommentTableViewCell.h"
#import "BuyNowViewController.h"

#import "ProgressHUD.h"
#import <AFNetworking.h>
#import "GoodsObjcModel.h"
#import "RuleDetail.h"
#import "CycleDisplayImage.h"
#import "RTLabel.h"
#import <TMCache.h>
#import "SignInViewController.h"
#import "UserCommentsObjcModel.h"
#import "SignInViewController.h"
#import "Reachability.h"
#import "SignInViewController.h"

const NSString *text_html_goods = @"text/html";
const NSString *application_json_goods = @"application/json";

@interface ActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UITextFieldDelegate>
{
    

    /*收藏按钮是否点击*/
    BOOL isCollectioned;
    
    NSArray *itemTitles;//headerView上的文字
    
    CycleScrollView *cyclePlayImage;//轮播控件

    NSString *userComment;//用户评论
    
    UIWebView *webView1;//活动介绍部分的webView
    UIWebView *webView2;//商品详情部分的webView
    UIWebView *webView3;//活动规则部分的webView
    
    UIView *courseAppointLoadView;//创建底部loadView
    UITextField *memberField;//显示购物的数量
    NSInteger gloabalAcount;
    
    NSDictionary *globalDict;//全局字数据典
    
    CGFloat webViewHeight;//富文本高度
    CGFloat webViewHeight2;
    CGFloat webViewHeight3;
   
    RTLabel *rtLabel2;
    RTLabel *rtLable3;
    
    NSArray *comments;//评论数组
    NSString *globalAttentionId;
    
    
}
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *cycleImageArrayURLs;//轮播图片的URL
@property (nonatomic,strong)NSMutableArray *iamgeViewArrays;//轮播图片
@property (nonatomic,strong)NSMutableArray *titlesArray;//餐饮模块的菜品文字

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    /**
     在这里初始化参数
     */
    
    isCollectioned = NO;
    itemTitles = @[@"",@"活动介绍",@"商品详情",@"活动规则",@"用户评论"];
    userComment = @"这里的菜啊真是特特特特别的不好吃，以前来这里的时候感觉还一般，没想到这次这么不行了！！！擦简直就是大垃圾！";
    
    self.cycleImageArrayURLs =[NSMutableArray array];
    self.iamgeViewArrays =[NSMutableArray array];

    gloabalAcount = 1;
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"活动详情";
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
    

#pragma mark - 创建tableView
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = customGrayColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = NO;
    
    
    /**
     活动介绍
     */
    webView1 = webView1 =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 84)];
    webView1.tag = 2001;
    webView1.delegate = self;
    webView1.scrollView.scrollEnabled = NO;


    
    /**
     商品详情
     */
    rtLabel2 =[[RTLabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-30, 0)];
    
    
    /**
     活动规则
     */
    rtLable3 = [[RTLabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-30, 0)];
    
    
    //立即购买
    UIButton *payItNow =[UIButton buttonWithType:UIButtonTypeCustom];
    payItNow.frame = CGRectMake(10, self.view.bounds.size.height-40, (self.view.bounds.size.width-20)/2.0, 40);
    payItNow.backgroundColor =[UIColor colorWithRed:239/255.0 green:118/255.0 blue:109/255.0 alpha:1];
    payItNow.tag = 5001;
    payItNow.titleLabel.font =[UIFont systemFontOfSize:14];
    [payItNow setTitle:@"立即购买" forState:UIControlStateNormal];
    [payItNow addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payItNow];
    
  
    UIButton *appointmentNow =[UIButton buttonWithType:UIButtonTypeCustom];
    appointmentNow.frame = CGRectMake(10+(self.view.bounds.size.width-20)/2.0, self.view.bounds.size.height-40, (self.view.bounds.size.width-20)/2.0, 40);
    appointmentNow.backgroundColor = baseRedColor;
    appointmentNow.tag = 5002;
    appointmentNow.titleLabel.font =[UIFont systemFontOfSize:14];
    [appointmentNow setTitle:@"加入购物车" forState:UIControlStateNormal];
    [appointmentNow addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appointmentNow];
    
    
    /**
     创建轮播控件部分
     */
    cyclePlayImage =[[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)
                                        animationDuration:2.8];
    cyclePlayImage.userInteractionEnabled = YES;
    
  
    
#pragma mark - 进行网络请求
    
    /**
     *  @author frankfan, 14-12-05 14:12:22
     *
     *  获取是否收藏状态
     */
    
    if([[[TMCache sharedCache]objectForKey:kUserInfo][memberID] length]){
    
        AFHTTPRequestOperationManager *manager_isCollection =[self createNetworkingRequestObjc:text_html_goods];
        
        NSDictionary *tempDict = [[TMCache sharedCache]objectForKey:kUserInfo];
        NSDictionary *parameters_isCollection = @{memberID:tempDict[memberID],@"goodsId":self.goodsId,};
        [manager_isCollection GET:API_IsColltionShopOrProducation parameters:parameters_isCollection success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *tempDict = responseObject[@"data"];
            GoodsObjcModel *goodObjcModel = [GoodsObjcModel modelWithDictionary:tempDict error:nil];
            if(goodObjcModel.attention){
            
                 [searchButton setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
                globalAttentionId = goodObjcModel.attentionId;
                isCollectioned = YES;
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"...233%@",[error localizedDescription]);
        }];
    
    }
    
    
    /**
     *  @author frankfan, 14-12-03 10:12:50
     *
     *  进行网络请求-获取页面内容
     *
     *  @return nil
     */
    
    AFHTTPRequestOperationManager *manager =[self createNetworkingRequestObjc:application_json_goods];
    NSDictionary *parameters = @{@"goodsId":self.goodsId};
    [manager GET:API_GoodsDetail parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        globalDict = (NSDictionary *)responseObject[@"data"];
        GoodsObjcModel *goodsObjcModel =[GoodsObjcModel modelWithDictionary:globalDict error:nil];

        [webView1 loadHTMLString:goodsObjcModel.introduction baseURL:nil];
        
        rtLabel2.text = [self handleStringForRTLabel:goodsObjcModel.detailContent];
        CGSize size2 = rtLabel2.optimumSize;
        rtLabel2.frame = CGRectMake(10, 10, self.view.bounds.size.width-30, size2.height+20);
        webViewHeight2 = size2.height+20;
       
        
        NSDictionary *tempDict = goodsObjcModel.ruleDetail;
        RuleDetail *ruleDetailObjc =[RuleDetail modelWithDictionary:tempDict error:nil];
        rtLable3.text = [self handleStringForRTLabel:ruleDetailObjc.rules];
        CGSize size3 = rtLable3.optimumSize;
        rtLable3.frame = CGRectMake(10, 10, self.view.bounds.size.width-30, size2.height+20);
        webViewHeight3 = size3.height+20;
        
        [self.tableView reloadData];
        
        //
        [self handleTheCyclePlayingImages:goodsObjcModel.pictures];
        
        __weak ActivityDetailViewController *_self = self;
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
    
  
    
    // Do any additional setup after loading the view.
}

#pragma mark - webView加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    if(webView.tag ==2001){
        
        CGRect frame = webView.frame;
        frame.size.height = 1;
        webView.frame = frame;
        CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        webView.frame = frame;
        webViewHeight = fittingSize.height+5;
        
        [self.tableView reloadData];
       
    }
  
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
//    webViewLoads_--;
    NSLog(@"error:%@",[error localizedDescription]);

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
            
            CycleDisplayImage *cycleDisplayImageObjc =[CycleDisplayImage modelWithDictionary:picsDict error:nil];
            
            
            NSURL *imageURL =[NSURL URLWithString:cycleDisplayImageObjc.fileCopy];
            
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
            
            titleLabel.text =[NSString stringWithFormat:@" %@",cycleDisplayImageObjc.pictureName];
            
            [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"defaultBackgroundImage"]];
            [self.iamgeViewArrays addObject:imageView];
        }
        
    }
    
}



#pragma mark - 底部按钮点击触发【立即购买商品】
- (void)bottomButtonClicked:(UIButton *)sender{

    if(sender.tag==5001){//立即购买
    
        NSDictionary *userinfo = [[TMCache sharedCache]objectForKey:kUserInfo];
        NSString *memId = userinfo[memberID];
        if(![memId length]){
            
            [ProgressHUD showError:@"请先登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                SignInViewController *signViewController =[SignInViewController new];
                [self.navigationController pushViewController:signViewController animated:YES];
            });
            return;
        }
        
        BuyNowViewController *buyNow =[BuyNowViewController new];
        buyNow.hidesBottomBarWhenPushed = YES;
        
        if([[globalDict allKeys]count]){
        
            GoodsObjcModel *goodObjcModel = [GoodsObjcModel modelWithDictionary:globalDict error:nil];
            buyNow.goodsName = goodObjcModel.goodsName;
            buyNow.price = goodObjcModel.promotePrice;
            buyNow.goodsId = goodObjcModel.goodsId;
            buyNow.memberId = memId;
        
        }else{
            
            [ProgressHUD showError:@"数据缺失"];
        }

        
        [self.navigationController pushViewController:buyNow animated:YES];

    }else{//加入购物车
    
        
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
        theGoodsImage.backgroundColor = customGrayColor;

    
        GoodsObjcModel *goodObjcModel = nil;
        if([[globalDict allKeys]count]){
        
            goodObjcModel =[GoodsObjcModel modelWithDictionary:globalDict error:nil];
            [theGoodsImage sd_setImageWithURL:[NSURL URLWithString:self.goodsPic] placeholderImage:[UIImage imageNamed:@"defaultBackimageSmall"]];
        }
        
        
        
        /*商品名*/
        UILabel *goodsname =[[UILabel alloc]initWithFrame:CGRectMake(90, -7, 123, 50)];
        goodsname.font =[UIFont boldSystemFontOfSize:16];
        goodsname.textAlignment = NSTextAlignmentLeft;
        goodsname.adjustsFontSizeToFitWidth = YES;
        goodsname.textColor = baseTextColor;

        if(goodObjcModel){
        
            goodsname.text = goodObjcModel.goodsName;;
        }
        
        
        [courseAppointLoadView addSubview:goodsname];
        
        /*价格*/
        UILabel *price =[[UILabel alloc]initWithFrame:CGRectMake(90, 55, 60, 30)];
        price.font =[UIFont boldSystemFontOfSize:14];
        price.textColor = baseTextColor;
        price.textAlignment = NSTextAlignmentLeft;
        price.adjustsFontSizeToFitWidth = YES;

        if(goodObjcModel){
            
            price.text = [NSString stringWithFormat:@"￥%ld",(long)goodObjcModel.promotePrice];
        }

        
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
        NSLog(@"预约课程");
    }

}

#pragma mark - 创建步进器
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
    
    
    
}

#pragma mark - 取消
- (void)cancelBottomView{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        courseAppointLoadView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, courseAppointLoadView.bounds.size.height);
        courseAppointLoadView = nil;
        
    }];
    
    [memberField resignFirstResponder];
    
}


#pragma mark - 加入购物车
- (void)payForButtonClicked:(UIButton *)sender{
    
    NSDictionary *userinfo = [[TMCache sharedCache]objectForKey:kUserInfo];
    NSString *membId = userinfo[memberID];
    if(![membId length]){
    
        [ProgressHUD showError:@"请登录"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            SignInViewController *sigViewController =[SignInViewController new];
            [self.navigationController pushViewController:sigViewController animated:YES];
            
        });
        
        return;
    }
    
    Reachability *_reachability =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    if(![_reachability isReachable]){
        
        [ProgressHUD showError:@"网络异常"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager =[self createNetworkingRequestObjc:application_json_goods];
    
    GoodsObjcModel *goodObjcModel =[GoodsObjcModel modelWithDictionary:globalDict error:nil];
    if(!goodObjcModel.price){
        
        [ProgressHUD showError:@"数据异常"];
        return;
    }
    
    double totalPrice = goodObjcModel.promotePrice * [memberField.text integerValue];
    NSDictionary *parameters = @{@"memberId":membId,
                                 @"goodsId":self.goodsId,
                                 @"markerPrice":[NSNumber numberWithInteger:goodObjcModel.promotePrice],
                                 @"goodsPrice":[NSNumber numberWithDouble:goodObjcModel.price],
                                 @"goodsNumber":[NSNumber numberWithInteger:[memberField.text integerValue]],
                                 @"totalAmount":[NSNumber numberWithDouble:totalPrice]};
    [ProgressHUD show:nil];
    [manager POST:API_Cart parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"response:%@",responseObject);
        [ProgressHUD showSuccess:@"加入成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [ProgressHUD showError:@"加入失败"];
        NSLog(@"error:%@",[error localizedDescription]);
    }];
    
    
}


#pragma mark - 创建section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 5;
    
}

#pragma mark - 创建cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0 ||section==2 ||section==4){
    
        return 1;
    }
    
    if(section==1){
    
        return 5;
    }
    
    if(section==3){
    
        return 2;
    }
    
    
    return 0;

}

#pragma mark - 创建tabkeView headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section!=0){
    
        return 25;
    }

    return 0;
}


#pragma mark - 创建HeaderView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    if(section!=0){
    
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
            
            GoodsObjcModel *goodObjcModel = nil;
            if([[globalDict allKeys]count]){
            
                goodObjcModel = [GoodsObjcModel modelWithDictionary:globalDict error:nil];
            }
            
            //在这里显示一共有多少条评论
            [button setTitle:[NSString stringWithFormat:@"%lu条",(unsigned long)[goodObjcModel.comments count]] forState:UIControlStateNormal];
            [backView addSubview:button];
            [button addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        }
        
        return backView;
    
    }

    return nil;
}


#pragma mark - 跳转到评论
- (void)commentButtonClicked{
    
    UserCommentListViewController *userCommentList =[UserCommentListViewController new];
    userCommentList.hidesBottomBarWhenPushed = YES;
    GoodsObjcModel *goodObjcModel = nil;
    if([[globalDict allKeys]count]){
    
        goodObjcModel =[GoodsObjcModel modelWithDictionary:globalDict error:nil];
    }
    
    if([goodObjcModel.comments count]>1){
    
        userCommentList.userComments = goodObjcModel.comments;
        [self.navigationController pushViewController:userCommentList animated:YES];
    }
    
    
}


#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0){
    
        return 180;
    }
    
    if(indexPath.section==1){
        
        if(indexPath.row==0){
        
            return 70;
        }
        
        if(indexPath.row==1){//商品介绍
        
            return webViewHeight;

        }
        
        if(indexPath.row==2 || indexPath.row==3 ||indexPath.row==4){
        
        
            return 44;
        }
     
    }

    if(indexPath.section==2){
    
        
        return webViewHeight2;
    }
    
    if(indexPath.section==3){
    
        if(indexPath.row==0){
        
            return webViewHeight3;
        }else{
        
            return 50;
        }
    
    }

    if(indexPath.section==4){//评论
    
        if([[globalDict allKeys]count]){
        
            GoodsObjcModel *goodObjcModel = [GoodsObjcModel modelWithDictionary:globalDict error:nil];
            if([goodObjcModel.comments count]){
            
                NSDictionary *tempDict = goodObjcModel.comments[indexPath.row];
                UserCommentsObjcModel *userComment_local = [UserCommentsObjcModel modelWithDictionary:tempDict error:nil];
                CGFloat commentContentHeight = [self caculateTheTextHeight:userComment_local.content andFontSize:14];
                return commentContentHeight+35+10;
            }
        }else{
            
            return 10+35;
        }
       
    }
    
    return 0;
  
}


#pragma mark - 创建tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *headerViewCell =nil;
    UITableViewCell *cell1_0 = nil;
    UITableViewCell *cell1_1 = nil;
    UITableViewCell *cell1_2 = nil;
    UITableViewCell *cell1_3_4 = nil;
    
    UITableViewCell *cell2 = nil;
    UITableViewCell *cell3 = nil;
    UITableViewCell *cell3_1 = nil;
    
    UserCommentTableViewCell *userCommentContentCell = nil;
    
    GoodsObjcModel *goodsObjcModel = nil;
    
    if(indexPath.section==0){//轮播图
    
        headerViewCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        headerViewCell.selectionStyle = NO;
        [headerViewCell.contentView addSubview:cyclePlayImage];
        
        return headerViewCell;
    }
    
    if(indexPath.section==1){
    
        if(indexPath.row==0){
        
            cell1_0 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell1_0.selectionStyle = NO;

            
            //info1_0_0
            UILabel *info1_0 =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
            info1_0.tag = 1001;
            info1_0.font =[UIFont systemFontOfSize:14];
            info1_0.textColor = [UIColor colorWithWhite:0.75 alpha:1];
            [cell1_0.contentView addSubview:info1_0];
            
            //info1_0_1
            UILabel *info1_0_1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 55)];
            info1_0_1.adjustsFontSizeToFitWidth = YES;
            info1_0_1.tag = 1002;
            info1_0_1.font =[UIFont systemFontOfSize:22];
            info1_0_1.textColor = baseRedColor;
            [cell1_0.contentView addSubview:info1_0_1];
            
           
            //info1_0_2
            UILabel *info1_0_2 =[[UILabel alloc]initWithFrame:CGRectMake(115, 20, 100, 55)];
            info1_0_2.adjustsFontSizeToFitWidth = YES;
            info1_0_2.tag = 1003;
            info1_0_2.font =[UIFont systemFontOfSize:14];
            info1_0_2.textColor = [UIColor colorWithWhite:0.75 alpha:1];
            [cell1_0.contentView addSubview:info1_0_2];

            
            //
            
            if([[globalDict allKeys]count]){
                
                goodsObjcModel = [GoodsObjcModel modelWithDictionary:globalDict error:nil];
                //cell1_0上得信息
                info1_0.text = goodsObjcModel.goodsName;
                
                //cell1_0_1上得信息
                NSString *price = [NSString stringWithFormat:@"￥%.2ld",(long)goodsObjcModel.promotePrice];
                info1_0_1.text = price;
                
                //cell1_0_2上得信息
                NSString *promotorPrice =[NSString stringWithFormat:@"原价:￥%.2f",goodsObjcModel.price];
                info1_0_2.text = promotorPrice;
             
                
            }else{
                
                //cell1_0上得信息
                info1_0.text = @"暂无数据";
                
                //cell1_0_1上得信息
                info1_0_1.text = @"暂无数据";
                
                info1_0_2.text = @"暂无数据";
            }
            
            return cell1_0;
            
        }
        
        if(indexPath.row==1){//这里放uiwebview
            
            cell1_1 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell1_1.selectionStyle = NO;
            
            //webView显示内容
            [cell1_1.contentView addSubview:webView1];
            
            if(![[globalDict allKeys]count]){
            
                [webView1 loadHTMLString:@"暂无数据" baseURL:nil];

            }
            
            UIView *topline =[[UIView alloc]initWithFrame:CGRectMake(0, 0 ,cell1_1.bounds.size.width, 1)];
            topline.backgroundColor =customGrayColor;
            [cell1_1.contentView addSubview:topline];
            
            return cell1_1;
        }
        
        if(indexPath.row==2){//三个选项
        
            cell1_2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell1_2.selectionStyle = NO;
            
            UIView *topLine =[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell1_2.bounds.size.width, 1)];
            topLine.backgroundColor = customGrayColor;
            [cell1_2.contentView addSubview:topLine];
            
            
            UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 43, cell1_2.bounds.size.width, 1)];
            line.backgroundColor =customGrayColor;
            [cell1_2.contentView addSubview:line];
            
            
            UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(100, 0, 1, 44)];
            line1.backgroundColor = customGrayColor;
            [cell1_2.contentView addSubview:line1];
            
            UIView *line3 =[[UIView alloc]initWithFrame:CGRectMake(205, 0, 1, 44)];
            line3.backgroundColor =customGrayColor;
            [cell1_2 addSubview:line3];
            
            
            //支持随时退
            UILabel *supportPayback =[[UILabel alloc]initWithFrame:CGRectMake(25, 0, 80, 43)];
            supportPayback.font =[UIFont systemFontOfSize:13];
            supportPayback.textColor = baseTextColor;
            supportPayback.text = @"支持随时退";
            [cell1_2.contentView addSubview:supportPayback];
            
            //支持过期退
            UILabel *supportDelay =[[UILabel alloc]initWithFrame:CGRectMake(130, 0, 80, 43)];
            supportDelay.font =[UIFont systemFontOfSize:13];
            supportDelay.textColor = baseTextColor;
            supportDelay.text = @"支持过期退";
            [cell1_2.contentView addSubview:supportDelay];
            
            
            //无需预约
            UILabel *noAppointment =[[UILabel alloc]initWithFrame:CGRectMake(235, 0, 80, 43)];
            noAppointment.font =[UIFont systemFontOfSize:13];
            noAppointment.textColor = baseTextColor;
            noAppointment.text = @"无需预约";
            [cell1_2.contentView addSubview:noAppointment];

            
            //对勾1
            UIImageView *mark1 =[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 15, 15)];
            mark1.image =[UIImage imageNamed:@"绿色勾"];
     
            //对勾2
            UIImageView *mark2 =[[UIImageView alloc]initWithFrame:CGRectMake(115, 15, 15, 15)];
            mark2.image =[UIImage imageNamed:@"绿色勾"];
            
            
            //对勾3
            UIImageView *mark3 =[[UIImageView alloc]initWithFrame:CGRectMake(220, 15, 15, 15)];
            mark3.image =[UIImage imageNamed:@"绿色勾"];
            
            if([[globalDict allKeys]count]){
                
                goodsObjcModel =[GoodsObjcModel modelWithDictionary:globalDict error:nil];
                if(goodsObjcModel.readyToRetire){
                    
                    [cell1_2.contentView addSubview:mark1];
                }else{
                
                    supportPayback.frame = CGRectMake(15, 0, 80, 43);
                }
                
                if(goodsObjcModel.expiredRetreat){
                
                    [cell1_2.contentView addSubview:mark2];

                }else{
                
                    supportDelay.frame = CGRectMake(120, 0, 80, 43);
                }
                
                if(goodsObjcModel.noAppoinment){
                
                    [cell1_2.contentView addSubview:mark3];

                }else{
                
                    noAppointment.frame = CGRectMake(225, 0, 80, 43);
                }
            
            }
            
            return cell1_2;
        }
        
        if(indexPath.row==3 || indexPath.row==4){
      
            cell1_3_4 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell1_3_4.selectionStyle = NO;
            
            UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 43, cell1_3_4.bounds.size.width, 1)];
            line.backgroundColor =customGrayColor;
            [cell1_3_4.contentView addSubview:line];

            UIImageView *view =[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 15, 17)];
            
            UILabel *infoLabel =[[UILabel alloc]initWithFrame:CGRectMake(25, 5, self.view.bounds.size.width-50, 35)];
            infoLabel.font =[UIFont systemFontOfSize:14];
            infoLabel.textColor =baseTextColor;
            infoLabel.adjustsFontSizeToFitWidth = YES;
            
            [cell1_3_4.contentView addSubview:view];
            [cell1_3_4.contentView addSubview:infoLabel];
            
            if(indexPath.row==3){//店铺地址
            
                view.image =[UIImage imageNamed:@"地标"];
                infoLabel.text = self.shopAddress;
            }else{//电话号码
            
                view.image =[UIImage imageNamed:@"电话"];
                infoLabel.text = self.phoneNumber;
            }
            
            return cell1_3_4;
        }
        
    }
    
    if(indexPath.section==2){//商品详情
        
        cell2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell2.selectionStyle = NO;
        
        [cell2.contentView addSubview:rtLabel2];
        if(![[globalDict allKeys]count]){
        
            rtLabel2.text = @"暂无数据";
        }
        
        
        return cell2;
    
    }
    
    if(indexPath.section==3){//活动规则
        
        if(indexPath.row==0){
        
            cell3 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell3.selectionStyle = NO;
            [cell3.contentView addSubview:rtLable3];
         
            
            return cell3;

        }else{
        
            cell3_1 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell3_1.userInteractionEnabled = YES;
            
            UIButton *moreDetail =[UIButton buttonWithType:UIButtonTypeCustom];
            moreDetail.userInteractionEnabled = YES;
            moreDetail.frame = CGRectMake(3, 8, cell3_1.bounds.size.width-25, 40);
            [moreDetail setTitle:@"更多详情" forState:UIControlStateNormal];
            [moreDetail setTitleColor:baseTextColor forState:UIControlStateNormal];
            moreDetail.layer.borderWidth = 1;
            moreDetail.layer.borderColor = customGrayColor.CGColor;
            moreDetail.backgroundColor =[UIColor whiteColor];
            [cell3_1.contentView addSubview:moreDetail];
            moreDetail.titleLabel.font =[UIFont systemFontOfSize:14];
            [moreDetail addTarget:self action:@selector(showMoreThing) forControlEvents:UIControlEventTouchUpInside];
            
            return cell3_1;
        }
     
    }
    
    if(indexPath.section==4){
    
        userCommentContentCell =[UserCommentTableViewCell cellWithTableView:tableView];
        UserCommentsObjcModel *userCommentObjc = nil;
        if([[globalDict allKeys]count]){
        
            GoodsObjcModel *goodObjcModel =[GoodsObjcModel modelWithDictionary:globalDict error:nil];
            NSArray *comments_local = goodObjcModel.comments;
            if([comments_local count]){
            
                NSDictionary *tempDict_local =comments_local[indexPath.row];
                userCommentObjc = [UserCommentsObjcModel modelWithDictionary:tempDict_local error:nil];
            }
            
        }
        
        userCommentContentCell.commentContent.text = userCommentObjc.content;
        
        CGFloat contentHeight;
        if([userCommentContentCell.commentContent.text length]){
            
            contentHeight = [self caculateTheTextHeight:userCommentContentCell.commentContent.text andFontSize:14];
        }else{
            
            contentHeight = 0;
        }
        
        /**
         *  @Author frankfan, 14-11-12 10:11:09
         *  这里是必须要设置的！
         */
        userCommentContentCell.commentContent.frame = CGRectMake(10, 36, self.view.bounds.size.width-40, contentHeight);
        userCommentContentCell.selectionStyle = NO;
        
        //来自某评论者
        userCommentContentCell.theCommenter.text = userCommentObjc.nickName;
        //某天
        NSString *yearString = nil;
        NSString *timeString = nil;
        if([userCommentObjc.createTime length]){
            
            NSArray *timeArray =[userCommentObjc.createTime componentsSeparatedByString:@" "];
            yearString = [timeArray firstObject];
            timeString = [timeArray lastObject];
            
        }
        
        userCommentContentCell.theDay.text = yearString;
        //某时
        userCommentContentCell.theTime.text = timeString;
    
        return userCommentContentCell;
    }

    return nil;
}


#pragma mark - 显示更多详情按钮触发
- (void)showMoreThing{
 
    MoreActivityDetailViewController *moreActivityDetail =[MoreActivityDetailViewController new];
    moreActivityDetail.hidesBottomBarWhenPushed = YES;
    
    if([[globalDict allKeys]count]){
    
        GoodsObjcModel *goodsObjcModel = [GoodsObjcModel modelWithDictionary:globalDict error:nil];
        NSDictionary *tempDict = goodsObjcModel.ruleDetail;
        RuleDetail *ruleObjcModel =[RuleDetail modelWithDictionary:tempDict error:nil];
        if([ruleObjcModel.details length] || [ruleObjcModel.notes length] || [ruleObjcModel.tips length]){
            
            moreActivityDetail.activityContents = ruleObjcModel.details;
            moreActivityDetail.needToKnow = ruleObjcModel.notes;
            moreActivityDetail.tips = ruleObjcModel.tips;
            [self.navigationController pushViewController:moreActivityDetail animated:YES];
        }else{
        
            [ProgressHUD showError:@"暂无更多数据"];
        }
        
    }else{
    
        [ProgressHUD showError:@"数据异常"];
    }
 
}

#pragma mark - 导航栏按钮触发
- (void)buttonClicked:(UIButton *)sender{

    if(sender.tag==10006){//回退按钮
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(sender.tag==1000){//收藏
      
        if(![[[TMCache sharedCache]objectForKey:kUserInfo][memberID]length]){//如果没有登录
        
            [ProgressHUD showError:@"请先登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                SignInViewController *signViewController =[SignInViewController new];
                [self.navigationController pushViewController:signViewController animated:YES];
            });
        }else{//如果已经登录了
        
            AFHTTPRequestOperationManager *manager =[self createNetworkingRequestObjc:text_html_goods];
            if(!isCollectioned){//如果还没有收藏-点击收藏
            
                NSDictionary *parameters = @{memberID:[[TMCache sharedCache]objectForKey:kUserInfo][memberID],@"goodsId":self.goodsId,@"attentionType":@0};
                [ProgressHUD show:nil];
                [manager POST:API_CollectionShopOrProducation parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                {
                    NSLog(@"~~~收藏:%@",responseObject);
                    [sender setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
                    isCollectioned = YES;
                   
                    NSDictionary *tempDict = (NSDictionary *)responseObject[@"data"];
                    GoodsObjcModel *goodObjcModel = [GoodsObjcModel modelWithDictionary:tempDict error:nil];
                    globalAttentionId = goodObjcModel.attentionId;
                    [ProgressHUD dismiss];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [ProgressHUD showError:@"收藏失败"];
                    isCollectioned = NO;
                    NSLog(@"~~%@",[error localizedDescription]);
                  
                }];
                
            }else{//如果早已收藏-点击取消收藏
            
                AFHTTPRequestOperationManager *manager2 = [self createNetworkingRequestObjc:application_json_goods];;
                NSDictionary *parameters = nil;
                if([globalAttentionId length]){
                
                    parameters = @{@"attentionId":globalAttentionId};
                }
                [ProgressHUD show:nil];
                [manager2 POST:API_DecollectionShopOrProducation parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     NSLog(@"2~~~取消收藏:%@",responseObject);
                     
                     UIButton *button = (UIButton *)sender;
                     [button setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                     isCollectioned = NO;
                     [ProgressHUD dismiss];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [ProgressHUD showError:@"取消失败"];
                    NSLog(@"1224:%@",[error localizedDescription]);
                    
                }];
            }
            
        }
      
    }
    
    if(sender.tag==1002){//分享
        
        
        NSLog(@"分享");
        
    }

}


/**
 *  @Author frankfan, 14-11-13 11:11:30
 *
 *  根据文字动态计算高度
 *
 *  @param string   输入文字
 *  @param fontSize 文字font大小
 *
 *  @return 返回文字所占的高度
 */
- (CGFloat)caculateTheTextHeight:(NSString *)string andFontSize:(int)fontSize{
    
    /*非彻底性封装,这里给定固定的宽度,后面的被减掉的阀值与高度成正比*/
    CGSize constraint = CGSizeMake(self.view.bounds.size.width-80, CGFLOAT_MAX);
    
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



#pragma mark - 创建网络请求实体对象
- (AFHTTPRequestOperationManager *)createNetworkingRequestObjc:(const NSString *)content_type{

    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:content_type];
    
    return manager;
}

#pragma mark - 处理富文本格式字符串，使之适配RTLabel的使用
- (NSString *)handleStringForRTLabel:(NSString *)htmlString{
    
    NSString *tempString = [htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [htmlString length])];
    
    NSString *resultString =[tempString stringByReplacingOccurrencesOfString:@"div" withString:@"br" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempString length])];
    
    return resultString;
}


- (void)dealloc{

    if([ProgressHUD shared]){
    
        [ProgressHUD dismiss];
    }
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
