//
//  AboutMineViewController.m
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

//???:我的模块

#import "AboutMineViewController.h"
#import "SignInViewController.h"
#import "SignInViewController.h"
#import "PersonalSettingsViewController.h"
#import "UIButton+WebCache.h"

#import "ProgressHUD.h"
#import <TMCache.h>

#import "EGOCache.h"
#import "Userinfo.h"


@interface AboutMineViewController ()<UIAlertViewDelegate>
{

    NSArray *itemNames;
//    UserInfoModel *userinfo;
}
@end

@implementation AboutMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    UIView *backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 218, self.view.bounds.size.width, 480)];
    backgroundView.backgroundColor = customGrayColor;
    [self.view addSubview:backgroundView];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"我的";
    title.textColor = baseRedColor;
    self.navigationItem.titleView = title;

    
    /*头部背景图片*/
    UIImageView *headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, 150)];
    headerImageView.userInteractionEnabled = YES;
    [self.view addSubview:headerImageView];
    headerImageView.image =[UIImage imageNamed:@"bg"];
    
    /*用户头像*/
    self.headerImage =[UIButton buttonWithType:UIButtonTypeCustom];
    self.headerImage.frame = CGRectMake(self.view.bounds.size.width/2.0-35, 80, 70, 70);
    [self.headerImage setImage:[UIImage imageNamed:@"头像啊"] forState:UIControlStateNormal];
    self.headerImage.layer.cornerRadius = 35;
    self.headerImage.layer.borderWidth = 2;
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.headerImage addTarget:self action:@selector(headerButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.headerImage];
    

    /*用户id*/
    self.userID =[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-60, 90, 120, 30)];
    self.userID.userInteractionEnabled = YES;
    self.userID.textColor =[UIColor whiteColor];
    self.userID.textAlignment = NSTextAlignmentCenter;
    self.userID.font = [UIFont systemFontOfSize:15];
    [headerImageView addSubview:self.userID];

    
//    userinfo =[[UserInfoModel alloc]initWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:nil];
//    
//    if([userinfo.telphone length]){
//    
//        [];
//        
//    }else{
//    
//        self.userID.text = @"登录";
//        
//        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToLandUI)];
//        [self.userID addGestureRecognizer:tap];
//        
//
//    }
//    
    
    
    
    /*手机号*/
    self.phoneNumber =[UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneNumber.frame = CGRectMake(self.view.bounds.size.width/2.0-70, 100, 140, 40);
    [self.phoneNumber setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.phoneNumber.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.phoneNumber.titleLabel.font = [UIFont systemFontOfSize:14];
    self.phoneNumber.userInteractionEnabled = YES;
    [self.phoneNumber addTarget:self action:@selector(jumpToLandUI) forControlEvents:UIControlEventTouchUpInside];
    [headerImageView addSubview:self.phoneNumber];
    
    
//    self.phoneNumber =[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-70, 115, 140, 30)];
//    self.phoneNumber.textColor =[UIColor whiteColor];
//    self.phoneNumber.textAlignment = NSTextAlignmentCenter;
//    self.phoneNumber.font = [UIFont systemFontOfSize:12.5];
//    [headerImageView addSubview:self.phoneNumber];
    

    
    
    
    /*创建tableView*/
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 218, self.view.bounds.size.width, self.view.bounds.size.height-49-115) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 53;
    self.tableView.backgroundColor =customGrayColor;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    
    /**/
    itemNames = @[@"我的购物车",@"我的订单",@"我的U币",@"我的关注",@"我的点评",@"我的预约"];
    
    

    
    
    
    // Do any additional setup after loading the view.
}



#pragma mark 读取用户头像
/*
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    userinfo =[[UserInfoModel alloc]initWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:nil];
    
    if([userinfo.avatar length]){
        
        NSURL *userHeaderImageURL = [NSURL URLWithString:userinfo.avatar];
        [self.headerImage sd_setBackgroundImageWithURL:userHeaderImageURL forState:UIControlStateNormal];
    
    }else{
    
        [self.headerImage setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    if([userinfo.telphone length]){
    
        [self.phoneNumber setTitle:userinfo.telphone forState:UIControlStateNormal];
        self.phoneNumber.enabled = NO;
        
    }else{
    
        [self.phoneNumber setTitle:@"登陆" forState:UIControlStateNormal];
        self.phoneNumber.enabled = YES;
    
    }
    
    
}*/



//???:这里是有问题的
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
//    userinfo =[[UserInfoModel alloc]initWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:nil];
    Userinfo *userinfo =[Userinfo modelWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
  
    
    
    if([userinfo.avatar length]){
        
        NSURL *userHeaderImageURL = [NSURL URLWithString:userinfo.avatar];
        [self.headerImage sd_setBackgroundImageWithURL:userHeaderImageURL forState:UIControlStateNormal];
        
    }else{
        
        [self.headerImage setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    if([userinfo.telphone length]){
        
        [self.phoneNumber setTitle:userinfo.telphone forState:UIControlStateNormal];
        self.phoneNumber.enabled = NO;
        
    }else{
        
        [self.phoneNumber setTitle:@"登陆" forState:UIControlStateNormal];
        self.phoneNumber.enabled = YES;
        
    }



}






#pragma mark 头像点击回调
- (void)headerButtonClicked:(UIButton *)sender{
    
#pragma mark 这里有警告

    

     Userinfo *userinfo =[Userinfo modelWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
    if([userinfo.memberId length]){
        
        PersonalSettingsViewController *personalSetting =[PersonalSettingsViewController new];
        personalSetting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalSetting animated:YES];
        
    
    }else{

        [ProgressHUD showError:@"请先登录" Interaction:NO];
        
        
    }
    
    
    NSLog(@"headButtonClicked");

}


#pragma mark 回调-跳转到登陆界面
- (void)jumpToLandUI{

    SignInViewController *signInView =[[SignInViewController alloc]init];
    signInView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signInView animated:YES];
    
}




#pragma mark 登陆回调
/*alertView 回调*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{


    if(buttonIndex==0){
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }else{
    
        SignInViewController *siginView =[[SignInViewController alloc]init];
        siginView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:siginView animated:YES];
        NSLog(@"跳转到登陆界面");
    
    }


}





#pragma mark tableView 代理-cell个数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return 7+2;

}


#pragma mark tableView 代理-cell生成

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = nil;
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = customGrayColor;
    if(indexPath.row>0 &&indexPath.row<=6){
    
        UILabel *backgroundLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 48)];
        backgroundLabel.backgroundColor =[UIColor whiteColor];
        [cell.contentView addSubview:backgroundLabel];
        
        /*左箭头*/
        UIImageView *arrow_imageView =[[UIImageView alloc]initWithFrame:CGRectMake(285, 20, 20, 20)];
        arrow_imageView.image =[UIImage imageNamed:@"左箭头"];
        [cell.contentView addSubview:arrow_imageView];
        
        /*项目名字*/
        UILabel *itemName =[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 30)];
        itemName.font =[UIFont systemFontOfSize:14];
        itemName.textColor  =baseTextColor;
        [cell.contentView addSubview:itemName];
        itemName.text = itemNames[indexPath.row-1];
        
    
    }else{
    
        cell.selectionStyle = NO;
    
    }
    
    return cell;

}





#pragma mark cell被选择回调方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    NSLog(@"indexPath.row:%ld",(long)indexPath.row);
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
