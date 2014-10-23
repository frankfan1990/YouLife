//
//  ForgetPasswordViewController.m
//  youmi
//
//  Created by frankfan on 14/10/23.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

//???:忘记密码模块


#import "ForgetPasswordViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <AFNetworking.h>
#import "ProgressHUD.h"
#import "Reachability.h"

@interface ForgetPasswordViewController ()
{
    
    UITextField *phoneNum_input;
    UITextField *securityCode_input;
    UITextField *newPassword_input;
    UITextField *checkoutPassword_input;
    
    UIButton *sendSecurityCode;
    UIButton *commitButton;
}
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    TPKeyboardAvoidingScrollView *theLoadView =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:theLoadView];
    
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"注册";
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

    //
    phoneNum_input =[[UITextField alloc]initWithFrame:CGRectMake(20, 30, self.view.bounds.size.width-130, 40)];
    phoneNum_input.keyboardType = UIKeyboardTypePhonePad;
    phoneNum_input.tag = 1001;
    phoneNum_input.backgroundColor = [UIColor whiteColor];
    phoneNum_input.layer.cornerRadius = 3;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    phoneNum_input.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  请输入手机号码" attributes:dict];
    [theLoadView addSubview:phoneNum_input];
    
    
    //获取验证码按钮
    sendSecurityCode =[UIButton buttonWithType:UIButtonTypeCustom];
    sendSecurityCode.frame = CGRectMake(self.view.bounds.size.width-100, 30, 80, 40);
    sendSecurityCode.backgroundColor =[UIColor colorWithRed:48/255.0 green:52/255.0 blue:65/255.0 alpha:1];
    [sendSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendSecurityCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendSecurityCode.layer.cornerRadius = 3;
    sendSecurityCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendSecurityCode addTarget:self action:@selector(getTheSecurityCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [theLoadView addSubview:sendSecurityCode];
    
    //
    checkoutPassword_input =[[UITextField alloc]initWithFrame:CGRectMake(20, 80, self.view.bounds.size.width-130, 40)];
    checkoutPassword_input.keyboardType = UIKeyboardTypePhonePad;
    checkoutPassword_input.tag = 1002;
    checkoutPassword_input.backgroundColor = [UIColor whiteColor];
    checkoutPassword_input.layer.cornerRadius = 3;
    checkoutPassword_input.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  请输入验证码" attributes:dict];
    [theLoadView addSubview:checkoutPassword_input];
    
    //输入密码框
    newPassword_input =[[UITextField alloc]initWithFrame:CGRectMake(20, 130, self.view.bounds.size.width-40, 40)];
    newPassword_input.tag = 1003;
    newPassword_input.secureTextEntry = YES;
    newPassword_input.backgroundColor = [UIColor whiteColor];
    newPassword_input.layer.cornerRadius = 3;
    newPassword_input.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  请输入密码(6-12个字符)" attributes:dict];
    [theLoadView addSubview:newPassword_input];
    
    //再次输入密码
    checkoutPassword_input =[[UITextField alloc]initWithFrame:CGRectMake(20, 180, self.view.bounds.size.width-40, 40)];
    checkoutPassword_input.tag = 1004;
    checkoutPassword_input.secureTextEntry = YES;
    checkoutPassword_input.backgroundColor = [UIColor whiteColor];
    checkoutPassword_input.layer.cornerRadius = 3;
    checkoutPassword_input.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  请再次输入密码" attributes:dict];
    [theLoadView addSubview:checkoutPassword_input];
    
    
    //提交
    commitButton =[UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(20,240,self.view.bounds.size.width-40, 40);
    commitButton.backgroundColor = baseRedColor;
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    commitButton.layer.cornerRadius = 3;
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [commitButton addTarget:self action:@selector(commitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [theLoadView addSubview:commitButton];

    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark 获取验证码触发方法
- (void)getTheSecurityCodeButtonClicked{

    [self startTime];
    

}


#pragma mark 提交按钮
- (void)commitButtonClicked{

    NSLog(@"提交");
}



#pragma mark 倒计时
-(void)startTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [sendSecurityCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [sendSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                sendSecurityCode.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [sendSecurityCode setTitle:[NSString stringWithFormat:@"%@s已发送",strTime] forState:UIControlStateNormal];
                [sendSecurityCode setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
                sendSecurityCode.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}




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
