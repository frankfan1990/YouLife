//
//  MyUBiViewController.m
//  youmi
//
//  Created by frankfan on 14/10/30.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MyUBiViewController.h"
#import "MyUbinTableViewCell.h"
@interface MyUBiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *numbOfMoneyStr;
    NSArray *arrOfDate;
    NSArray *arrOfTime;
    NSArray *arrOfDetails;
    NSArray *arrOfMoney;
}
@end

@implementation MyUBiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;

    //一些变量的初始化
    [self VariableInitialization];
    //tabBar的一些初始化
    [self createTabBar];
    
    //创建头部View
    [self createHeadView];
    
    //创建tableView
    [self createTableView];

}
-(void)VariableInitialization
{
    numbOfMoneyStr = @"99999999999";
    
    arrOfDate = [[NSArray alloc] initWithObjects:@"2014-11-11",@"2014-11-11" ,@"2014-11-11",@"2014-11-11",@"2014-11-11",@"2014-11-11",@"2014-11-11",@"2014-11-11",@"2014-11-11",nil];
    arrOfTime = [[NSArray alloc] initWithObjects:@"11:11",@"11:11" ,@"11:11",@"11:11",@"11:11",@"11:11",@"11:11",@"11:11",@"11:11",nil];
    arrOfDetails = [[NSArray alloc] initWithObjects:@"付款-支付宝",@"付款-支付宝" ,@"付款-支付宝",@"付款-支付宝",@"付款-支付宝",@"付款-支付宝",@"付款-支付宝",@"付款-支付宝",@"付款-支付宝",nil];
    arrOfMoney = [[NSArray alloc] initWithObjects:@"99999",@"99999" ,@"99999",@"99999",@"99999",@"99999",@"99999",@"99999",@"99999",nil];
}
-(void)createTabBar
{
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"我的U币";
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
    [rightbarButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [rightbarButton setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateSelected];
    [rightbarButton addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightbarButton];
    self.navigationItem.rightBarButtonItem = rightbarButtonItem;
}
-(void)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, 75)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 70, 20)];
    balanceLabel.text = @"柚米余额:";
    balanceLabel.textColor = baseTextColor;
    balanceLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:balanceLabel];
    
    UILabel *numberOfMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+70, 25, 130, 20)];
    numberOfMoneyLabel.textAlignment = NSTextAlignmentLeft;
    numberOfMoneyLabel.text = [@"￥" stringByAppendingString:numbOfMoneyStr];
    numberOfMoneyLabel.textColor = baseRedColor;
    numberOfMoneyLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:numberOfMoneyLabel];
    
    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 70, 20)];
    recordLabel.text = @"交易记录";
    recordLabel.textColor = baseTextColor;
    recordLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:recordLabel];
    
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rechargeBtn.frame =CGRectMake(self.view.frame.size.width-100, 20, 90, 35);
    rechargeBtn.backgroundColor = baseRedColor;
    rechargeBtn.layer.masksToBounds = YES;
    rechargeBtn.layer.cornerRadius = 3;
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(didrechargeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headView addSubview:rechargeBtn];
    
}
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66+75, self.view.frame.size.width,self.view.frame.size.height-66-75-10) style:UITableViewStyleGrouped];
  
    tableView.delegate = self;
    tableView.dataSource =self;
    tableView.showsVerticalScrollIndicator= NO;
    [tableView reloadData];
    [self.view addSubview:tableView];
}

-(void)didrechargeBtn:(UIButton *)sender
{
    NSLog(@"点击充值");
}

#pragma mark - 导航栏按钮触发
- (void)navi_buttonClicked:(UIButton *)sender{
    
    if(sender.tag==401){
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        NSLog(@"编辑");
        sender.selected = !sender.selected;
    }
    
    
}

#pragma mark - tableVie的打理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOfMoney.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headView.backgroundColor = customGrayColor;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 44, 30)];
    label1.text = @"时间";
    label1.textColor = baseTextColor;
    label1.font = [UIFont systemFontOfSize:15];
    [headView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-12, 0, 44, 30)];
    label2.text = @"详情";
    label2.textColor = baseTextColor;
    label2.font = [UIFont systemFontOfSize:15];
    [headView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-44, 0, 44, 30)];
    label3.text = @"金额";
    label3.textColor = baseTextColor;
    label3.font = [UIFont systemFontOfSize:15];
    [headView addSubview:label3];
    
    return headView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dentifier = @"cell";
    
    MyUbinTableViewCell *cell = (MyUbinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:dentifier];
    if (cell == nil) {
        cell = [[MyUbinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dentifier];
    }
    
    cell.labelOfDate.text = arrOfDate[indexPath.row];
    cell.labelOfTime.text = arrOfTime[indexPath.row];
    cell.labelOfDetails.text = arrOfDetails[indexPath.row];
    cell.labelOfMoney.text = [@"—" stringByAppendingString:arrOfMoney[indexPath.row]];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
