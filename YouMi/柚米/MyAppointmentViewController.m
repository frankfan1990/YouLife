//
//  MyAppointmentViewController.m
//  youmi
//
//  Created by frankfan on 14/11/10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MyAppointmentViewController.h"
#import "ModifyAppointmentPhoneViewController.h"

@interface MyAppointmentViewController ()<UITableViewDelegate,UITableViewDataSource>
{

}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation MyAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"预约详情";
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

    
    
    /**
     *  @Author frankfan, 14-11-10 13:11:34
     *
     *  开头的几根分割线
     *
     *  @return nil
     */
    
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, 64+50, self.view.bounds.size.width, 1)];
    line1.backgroundColor = customGrayColor;
    [self.view addSubview:line1];
    
    
    UIView *line2 =[[UIView alloc]initWithFrame:CGRectMake(0, 64+44+60, self.view.bounds.size.width, 1)];
    line2.backgroundColor = customGrayColor;
    [self.view addSubview:line2];
    
    //定座电话
    UILabel *orderPhone =[[UILabel alloc]initWithFrame:CGRectMake(0, 64, 100, 50)];
    orderPhone.textColor = baseTextColor;
    orderPhone.font = [UIFont systemFontOfSize:16];
    orderPhone.textAlignment = NSTextAlignmentCenter;
    orderPhone.text = @"订座手机";
    [self.view addSubview:orderPhone];
    
    UIImageView *arrowImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-50, 64+15, 20, 20)];
    arrowImage.image =[UIImage imageNamed:@"左箭头"];
    [self.view addSubview:arrowImage];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.bounds.size.width-100, 64+18, 100, 35);
    [button addTarget:self action:@selector(modifyThePhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //现有订单
    UILabel *nowhavenOrder =[[UILabel alloc]initWithFrame:CGRectMake(0, 64+50, 100, 50)];
    nowhavenOrder.textColor = baseTextColor;
    nowhavenOrder.font = [UIFont systemFontOfSize:16];
    nowhavenOrder.textAlignment = NSTextAlignmentCenter;
    nowhavenOrder.text = @"现有订单";
    [self.view addSubview:nowhavenOrder];
    
    /**
     *  @Author frankfan, 14-11-10 15:11:09
     *
     *  创建tableView
     *
     *  @return nil
     */
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64+44+60+1, self.view.bounds.size.width, self.view.bounds.size.height-64-44-60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 65;
    
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - tableView代理开始
/**
 *  @Author frankfan, 14-11-10 15:11:56
 *
 *  开始tableView代理
 *
 *  @return nil
 */

#pragma mark - cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
}

#pragma mark - 创建tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellName = @"cell1";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
        /**
         *  @Author frankfan, 14-11-10 16:11:41
         *
         *  开始创建控件
         */
        
        //头部imageView
        UIImageView *headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 40, 40)];
        headerImageView.tag = 1002;
        headerImageView.layer.cornerRadius = 3;
        headerImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:headerImageView];
        
        UILabel *infoLabel1 =[[UILabel alloc]initWithFrame:CGRectMake(25+40+10, 5, 200, 35)];//文字显示控件1
        infoLabel1.tag = 1003;
        infoLabel1.textColor = baseTextColor;
        infoLabel1.font =[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:infoLabel1];
        
        UILabel *infoLabel2 =[[UILabel alloc]initWithFrame:CGRectMake(25+40+10, 15+40-25, 200, 35)];//文字显示控件2
        infoLabel2.tag = 1004;
        infoLabel2.textColor = baseTextColor;
        infoLabel2.font =[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:infoLabel2];

        
        
    }
    
    //图像
    UIImageView *headerImageView = (UIImageView *)[cell viewWithTag:1002];
    headerImageView.backgroundColor =[UIColor blackColor];
    
    //信息1
    UILabel *infoLabel1 =(UILabel *)[cell viewWithTag:1003];
    infoLabel1.text = @"信息一行";
    
    //信息2
    UILabel *infoLabel2 =(UILabel *)[cell viewWithTag:1004];
    infoLabel2.text = @"信息二行";
    
    return cell;

}









#pragma mark - 修改手机号码按钮触发
- (void)modifyThePhoneNumber{

    ModifyAppointmentPhoneViewController *modifyAppointPhone =[ModifyAppointmentPhoneViewController new];
    modifyAppointPhone.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:modifyAppointPhone animated:YES];
}




//回退
- (void)navi_buttonClicked:(UIButton *)sender{


    [self.navigationController popViewControllerAnimated:YES];
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
