//
//  BuyNowViewController.m
//  youmi
//
//  Created by frankfan on 14/11/3.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "BuyNowViewController.h"

#import "Reachability.h"
#import "ProgressHUD.h"
#import <AFNetworking.h>
#import <TMCache.h>

static NSInteger gloabalAcount;
@interface BuyNowViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{

 
    UITextField *memberField;//显示购物的数量
  
    UILabel *allPrice;//总价
    
    Reachability *_reachability_commitOrder;
    
    double totalMoney;
}

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation BuyNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    gloabalAcount = 1;
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"确认订单";
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
    
    /**
     *  @Author frankfan, 14-11-03 16:11:04
     *
     *  创建骨架tableView
     *
     *  @return nil
     */
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    self.tableView.userInteractionEnabled = YES;
    
    
    /**
     *  @Author frankfan, 14-11-03 22:11:58
     *
     *  实时监测uitextField内容的变化
     *
     *  @param textFieldDidChanged: nil
     *
     *  @return nil
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChanged:) name:@"UITextFieldTextDidChangeNotification" object:memberField];
    
    
    
    UILabel *priceLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 170+30, 50, 40)];
    priceLabel.font =[UIFont boldSystemFontOfSize:16];
    priceLabel.textColor = baseTextColor;
    [self.view addSubview:priceLabel];
    priceLabel.text = @"总价";
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 170+30+50, self.view.bounds.size.width, 1)];
    line.backgroundColor =customGrayColor;
    [self.view addSubview:line];
    
    
    /*总价*/
    allPrice =[[UILabel alloc]initWithFrame:CGRectMake(140, 170+30, 123, 40)];
    allPrice.font =[UIFont boldSystemFontOfSize:14];
    allPrice.textColor = baseTextColor;
    [self.view addSubview:allPrice];
    allPrice.text =[NSString stringWithFormat:@"￥%.2f",_price*gloabalAcount];
    totalMoney = _price*gloabalAcount;
    /**
     *  @Author frankfan, 14-11-03 19:11:46
     *
     *  创建提交订单按钮
     */
    UIButton *orderButton =[UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.frame = CGRectMake(20, 170+30+50+50, self.view.bounds.size.width-40, 40);
    orderButton.backgroundColor = baseRedColor;
    [orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [orderButton setTitleColor:[UIColor colorWithWhite:0.75 alpha:1] forState:UIControlStateHighlighted];
    orderButton.layer.cornerRadius = 3;
    [orderButton addTarget:self action:@selector(orderCommit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderButton];

    
    //
    _reachability_commitOrder =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    
    // Do any additional setup after loading the view.
}





/**
 *  @Author frankfan, 14-11-03 22:11:24
 *
 *  接受textField发来的通知 实时监测uitextField内容的变化
 *
 *  @param notification nil
 */

- (void)textFieldDidChanged:(NSNotification *)notification{

    UITextField *textfield =[notification object];
    NSLog(@"...String:%@",textfield.text);
    
}




/**
 *  @Author frankfan, 14-11-03 16:11:10
 *
 *  开始实现tableView各项代理方法
 *
 *  @param NSInteger nil
 *
 *  @return nil
 */


#pragma mark - 创建cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 2;
}


#pragma mark - 创建tableView cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell1 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell1.selectionStyle = NO;
    UITableViewCell *cell2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell2.selectionStyle = NO;
//    UITableViewCell *cell3 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell3.selectionStyle = NO;
    
    /*商品单价*/
    if(indexPath.row==0){
    
        /*商品名*/

        UILabel *nameOfCommodity =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 123, 40)];
        nameOfCommodity.font =[UIFont boldSystemFontOfSize:15];
        nameOfCommodity.textColor = baseTextColor;
        nameOfCommodity.adjustsFontSizeToFitWidth = YES;
        [cell1.contentView addSubview:nameOfCommodity];
        nameOfCommodity.text = self.goodsName;
        
        
        UILabel *unitPrice =[[UILabel alloc]initWithFrame:CGRectMake(10, 46, 123, 40)];
        unitPrice.font =[UIFont boldSystemFontOfSize:15];
        unitPrice.textColor = baseTextColor;
        [cell1.contentView addSubview:unitPrice];
        unitPrice.text = @"单价";
        
        /*单价*/
        UILabel *showMoney =[[UILabel alloc]initWithFrame:CGRectMake(140, 46, 100, 40)];
        showMoney.font =[UIFont boldSystemFontOfSize:14];
        showMoney.textColor = baseTextColor;
        [cell1.contentView addSubview:showMoney];
        showMoney.text = [NSString stringWithFormat:@"￥%.2f",_price];
        
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 1)];
        line.backgroundColor = customGrayColor;
        [cell1.contentView addSubview:line];
  
        
        return cell1;
        
        
    }
    
    if(indexPath.row==1){
    
        UILabel *payCount =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 123, 40)];
        payCount.font =[UIFont boldSystemFontOfSize:16];
        payCount.textColor = baseTextColor;
        [cell2.contentView addSubview:payCount];
        payCount.text = @"购买数";
        
        
        /**
         *  @Author frankfan, 14-11-03 18:11:50
         *
         *  创建步进器
         */
        UIButton *stepButton =[UIButton buttonWithType:UIButtonTypeCustom];
        stepButton.frame = CGRectMake(190, 10, 95, 30);
        stepButton.layer.borderWidth = 2;
        stepButton.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
        stepButton.layer.cornerRadius = 3;
        [cell2.contentView addSubview:stepButton];
        
        UIButton *subButton =[UIButton buttonWithType:UIButtonTypeCustom];
        subButton.frame = CGRectMake(191, 14, 22, 22);
        [subButton setBackgroundImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
        [subButton setTitleColor:[UIColor colorWithWhite:0.85 alpha:1] forState:UIControlStateNormal];
        [subButton setTitleColor:[UIColor colorWithWhite:0.65 alpha:1] forState:UIControlStateHighlighted];
        [cell2.contentView addSubview:subButton];
        subButton.tag = 1003;
        [subButton addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
       
        UIButton *plus =[UIButton buttonWithType:UIButtonTypeCustom];
        plus.frame = CGRectMake(255, 14, 22, 19);
        [plus setBackgroundImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
        [plus setTitleColor:[UIColor colorWithWhite:0.85 alpha:1] forState:UIControlStateNormal];
        [plus setTitleColor:[UIColor colorWithWhite:0.65 alpha:1] forState:UIControlStateHighlighted];
        [cell2.contentView addSubview:plus];
        plus.tag = 1004;
        [plus addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        /*显示数量*/
        memberField =[[UITextField alloc]initWithFrame:CGRectMake(220, 14, 30, 23)];
        memberField.delegate = self;
        memberField.keyboardType = UIKeyboardTypeNumberPad;
        memberField.textAlignment = NSTextAlignmentCenter;
        memberField.backgroundColor = customGrayColor;
        memberField.textColor = baseTextColor;
        [cell2.contentView addSubview:memberField];
        memberField.text = [NSString stringWithFormat:@"%ld",(long)gloabalAcount];
        
        
        /**
         创建完成
         */
        
        
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 50, cell2.bounds.size.width, 1)];
        line.backgroundColor =customGrayColor;
        [cell2.contentView addSubview:line];
        
        return cell2;
        
    }
    return nil;
}



#pragma mark - textField 代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField{


    [textField resignFirstResponder];
    if(![textField.text length] || [textField.text integerValue]==0){
        
        textField.text = @"1";
    }
    
     allPrice.text =[NSString stringWithFormat:@"￥%.2f",_price*([memberField.text integerValue])];
     totalMoney = _price*([memberField.text integerValue]);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}




#pragma mark - 订单按钮触发
- (void)orderCommit:(UIButton *)sender{
    
    if(![_reachability_commitOrder isReachable]){
    
        [ProgressHUD showError:@"网络异常"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
    
    NSDictionary *userinfo = [[TMCache sharedCache]objectForKey:kUserInfo];
    NSString *telPhoneNumber = userinfo[phoneNum];
    
    NSDictionary *parameters = @{@"goodsId":self.goodsId,
                                 @"memberId":self.memberId,
                                 @"number":[NSNumber numberWithInteger:[memberField.text integerValue]],
                                 @"totalAmount":[NSNumber numberWithDouble:totalMoney],
                                 @"telphone":telPhoneNumber};
    
    [ProgressHUD show:nil];
    [manager POST:API_Order parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        [ProgressHUD showSuccess:@"提交成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",[error localizedDescription]);
        [ProgressHUD showError:@"提交失败"];
    }];

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
    
    allPrice.text =[NSString stringWithFormat:@"￥%.2f",_price*([memberField.text integerValue])];
    totalMoney = _price*([memberField.text integerValue]);
}




#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==0){
    
        return 80;
    }else if (indexPath.row==1){
    
        return 50;
    }else{
    
    
        return 200;
    }
    

}



#pragma mark - cell被选择回调 在这里取消textField的第一响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [memberField resignFirstResponder];


}

#pragma mark - textField的实时动态





#pragma mark -导航栏按钮
- (void)buttonClicked:(UIButton *)sender{

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
