//
//  RegisterAcount2ViewController.m
//  youmi
//
//  Created by frankfan on 14-10-15.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "RegisterAcount2ViewController.h"
#import "TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h"
#import "ProgressHUD/ProgressHUD.h"
#import <AFNetworking.h>
#import "Reachability.h"

@interface RegisterAcount2ViewController ()<UITextFieldDelegate>
{

    UIButton *l_timeButton;
    UILabel *timeLabel;
    TPKeyboardAvoidingScrollView *theLoadView;
}
@property (nonatomic,strong)UITextField *SecurityCodeTextField;
@property (nonatomic,strong)UITextField *PasswordInput;
@property (nonatomic,strong)UITextField *CheckPassword;
@property (nonatomic,strong)Reachability *reachability;
@end

@implementation RegisterAcount2ViewController

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
    self.view.backgroundColor = customGrayColor;
    

    theLoadView =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
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

    
    /*验证码输入框*/
    self.SecurityCodeTextField =[[UITextField alloc]initWithFrame:CGRectMake(20, 50, self.view.bounds.size.width-40, 45)];
    self.SecurityCodeTextField.tag = 1001;
    self.SecurityCodeTextField.delegate = self;
    self.SecurityCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.SecurityCodeTextField.backgroundColor =[UIColor whiteColor];
    self.SecurityCodeTextField.layer.cornerRadius = 3;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.SecurityCodeTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"   请输入验证码" attributes:dict];
    [theLoadView addSubview:self.SecurityCodeTextField];
    
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 95, 300, 30)];
    timeLabel.font =[UIFont systemFontOfSize:12];
    timeLabel.textColor =[UIColor colorWithWhite:0.4 alpha:1];
    [theLoadView addSubview:timeLabel];
    
    
    /*验证码发送按钮*/
    l_timeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    l_timeButton.tag = 1002;
    l_timeButton.frame = CGRectMake(20, 135, self.view.bounds.size.width-40, 35);
    l_timeButton.backgroundColor = [UIColor colorWithRed:48/255.0 green:52/255.0 blue:65/255.0 alpha:1];
    [l_timeButton setTitle:@"重新获取" forState:UIControlStateNormal];
    [l_timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    l_timeButton.layer.cornerRadius = 3;
    l_timeButton.titleLabel.font =[UIFont systemFontOfSize:15];
    [theLoadView addSubview:l_timeButton];
    [l_timeButton addTarget:self action:@selector(getSecurityCodeAgainButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /*密码输入框*/
    self.PasswordInput =[[UITextField alloc]initWithFrame:CGRectMake(20, 210, self.view.bounds.size.width-40, 40)];
    self.PasswordInput.secureTextEntry = YES;
    self.PasswordInput.delegate = self;
    self.PasswordInput.backgroundColor =[UIColor whiteColor];
    self.PasswordInput.layer.cornerRadius = 3;
    self.PasswordInput.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  请输入密码(6-12)个字符" attributes:dict];
    self.PasswordInput.tag = 1003;
    self.PasswordInput.returnKeyType = UIReturnKeyNext;
    [theLoadView addSubview:self.PasswordInput];
    
    
    /*再次输入确认密码*/
    self.CheckPassword =[[UITextField alloc]initWithFrame:CGRectMake(20, 265, self.view.bounds.size.width-40, 40)];
    self.CheckPassword.secureTextEntry = YES;
    self.CheckPassword.tag = 1004;
    self.CheckPassword.delegate = self;
    self.CheckPassword.backgroundColor =[UIColor whiteColor];
    self.CheckPassword.layer.cornerRadius = 3;
    self.CheckPassword.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  再次输入密码确认" attributes:dict];
    self.CheckPassword.returnKeyType = UIReturnKeyDone;
    [theLoadView addSubview:self.CheckPassword];
    if(![self.PasswordInput.text length]){
    
        self.CheckPassword.enabled = NO;
    }
    
    
    
    
    /*提交按钮*/
    UIButton *commitButton =[UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.layer.cornerRadius = 3;
    commitButton.frame = CGRectMake(20, 340, self.view.bounds.size.width-40, 40);
    commitButton.backgroundColor = baseRedColor;
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [theLoadView addSubview:commitButton];
    [commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //网络链接状态验证
    self.reachability =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    
    
    [self startTime];
    
    // Do any additional setup after loading the view.
}


#pragma mark textField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if(textField.tag==1001){
    
        textField.text = nil;
    }else if (textField.tag==1003){
    
        textField.text = nil;
    }else{
    
        textField.text = nil;
    }


}


#pragma mark 文本框结束输入后的回调方法
- (void)textFieldDidEndEditing:(UITextField *)textField{

    if(textField.tag==1003){/*密码输入框*/
    
        if([textField.text length]>5){/*密码最短不得小于6位*/
            
            
            self.CheckPassword.enabled = YES;
        }else{
            
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"密码长度太短" message:@"请重新输入符合长度要求的密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                textField.text = nil;
                
            });
            self.CheckPassword.enabled = NO;
        }
    
    }

    
    
}



#pragma mark 限制最大输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if(textField.tag==1003){
    
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 12 || returnKey;

    }else{
    
        return YES;
    }
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if(textField.tag==1003){
        
        if(![textField.text length]){
        
            return NO;
        }
        [textField resignFirstResponder];
        [self.CheckPassword becomeFirstResponder];
        [theLoadView setContentOffset:CGPointMake(0, 10) animated:YES];
    
    }else{
    
        [self.CheckPassword resignFirstResponder];
    }

    return YES;
}

#pragma mark 警告!
#pragma mark 提交按钮触发
- (void)commitButtonClicked:(UIButton *)sender{
    
    if([self.SecurityCodeTextField.text length] && [self.PasswordInput.text length] && [self.CheckPassword.text length]){
        
        if(![self.PasswordInput.text isEqualToString:self.CheckPassword.text]){
        
            [ProgressHUD showError:@"密码不一致" Interaction:NO];
            return;
        }
        
        if([self.reachability isReachable]){
            
            [ProgressHUD show:@"注册中..." Interaction:NO];
            AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            NSDictionary *parameters = @{phoneNum:self.userPhoneNum,passWord:self.PasswordInput.text};
            [manager POST:API_RegisterCommit parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
#warning 这里面还要查看返回结果，根据结果再做相应响应
                NSLog(@"response:%@",responseObject[@"data"]);
                NSDictionary *result = (NSDictionary *)responseObject;
                
                if(![self.securityCode isEqualToString:self.SecurityCodeTextField.text]){
                
                    [ProgressHUD showError:@"验证码错误" Interaction:NO];
                    return ;
                
                }
                
                if([result[@"success"]integerValue]==1){
                

                    [ProgressHUD showSuccess:@"注册成功" Interaction:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    });
                    
                    
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [ProgressHUD showError:@"注册失败" Interaction:NO];
                
            }];
            
        
        }else{
        
            [ProgressHUD showError:@"网络错误" Interaction:NO];
        
        }
    
    
    }else{
    
        
        [ProgressHUD showError:@"信息填写不全" Interaction:NO];
        
    }
    
    
    
    
    
    
    
    NSLog(@"提交注册信息");

}




#pragma mark 重新获取验证码按钮触发方法
- (void)getSecurityCodeAgainButtonClicked:(UIButton *)sender{
    
    if(sender.tag==1002){
    
        [self startTime];
        NSLog(@"重新获取");
    }


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
               
                [l_timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                timeLabel.text = @"点击重新获取按钮可重新获得验证码";
                [l_timeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"____%@",strTime);
                [l_timeButton setTitle:@"验证码已发送" forState:UIControlStateNormal];
                [l_timeButton setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
                timeLabel.text = [NSString stringWithFormat:@"验证码已发送 ( %@s ) 后可重新获取",strTime];
                l_timeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}



- (void)viewWillDisappear:(BOOL)animated{
    
    if([ProgressHUD shared]){
    
        [ProgressHUD dismiss];
    }

}




#pragma mark 回退触发按钮
- (void)navi_buttonClicked:(UIButton *)sender{
    
    if (sender.tag==401) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
