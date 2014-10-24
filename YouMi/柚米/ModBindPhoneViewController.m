//
//  ModBindPhoneViewController.m
//  youmi
//
//  Created by frankfan on 14/10/21.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ModBindPhoneViewController.h"
#import "ProgressHUD.h"
#import "Reachability.h"
#import <AFNetworking.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "Email_Phone.h"
#import <TMCache.h>

#import "Userinfo.h"

@interface ModBindPhoneViewController ()<UITextFieldDelegate>
{
    Reachability *reachabity;
    int securityCode;
}
@property (nonatomic,strong)TPKeyboardAvoidingScrollView *theLoadView;

@property (nonatomic,strong)UITextField *phoneNum_input;
@property (nonatomic,strong)UITextField *securityCode_inout;

@property (nonatomic,strong)UIButton *getSecurityCode;
@end

@implementation ModBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    self.theLoadView =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.theLoadView];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"手机绑定";
    title.textColor = baseRedColor;
    self.navigationItem.titleView = title;

    //
    /*leftbarbutton*/
    UIButton *leftbarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    leftbarButton.tag = 401;
    leftbarButton.frame = CGRectMake(0, 0, 25, 25);
    [leftbarButton setImage:[UIImage imageNamed:@"朝左箭头icon"] forState:UIControlStateNormal];
    [leftbarButton addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithCustomView:leftbarButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    //
    UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMake(20, -5, 100, 70)];
    label1.font =[UIFont systemFontOfSize:17];
    label1.textColor =baseTextColor;
    label1.text = @"已绑定手机";
    [self.theLoadView addSubview:label1];
    
    //
    UILabel *theBindPhone =[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-180, -5, 150, 70)];
    theBindPhone.font =[UIFont systemFontOfSize:17];
    theBindPhone.textColor = baseTextColor;
    theBindPhone.textAlignment = NSTextAlignmentRight;
    [self.theLoadView addSubview:theBindPhone];
#warning 这里应该是从userDefault里面读取
    theBindPhone.text = @"15575829007";
    
    /*static line*/
    UIView *staticLine =[[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 1)];
    staticLine.backgroundColor =[UIColor colorWithWhite:0.85 alpha:0.8];
    [self.theLoadView addSubview:staticLine];
    
    
    //
    UILabel *newPhoneBind =[[UILabel alloc]initWithFrame:CGRectMake(20, 55, 150, 70)];
    newPhoneBind.font =[UIFont systemFontOfSize:17];
    newPhoneBind.textColor = baseTextColor;
    [self.theLoadView addSubview:newPhoneBind];
    newPhoneBind.text = @"绑定新手机";

    
    
    /*手机号输入框*/
    self.phoneNum_input =[[UITextField alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.2, self.view.bounds.size.width-40, 45)];
    self.phoneNum_input.tag = 1001;
    self.phoneNum_input.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNum_input.delegate = self;
    self.phoneNum_input.backgroundColor =[UIColor whiteColor];
    self.phoneNum_input.layer.cornerRadius = 3;
    NSDictionary *dict =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.phoneNum_input.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  请输入手机号" attributes:dict];
    [self.theLoadView addSubview:self.phoneNum_input];
    
    
    /*获取验证码button*/
    self.getSecurityCode =[UIButton buttonWithType:UIButtonTypeCustom];
    self.getSecurityCode.frame = CGRectMake(20, self.view.bounds.size.height*0.2+60, self.view.bounds.size.width-40, 35);
    self.getSecurityCode.layer.cornerRadius = 3;
    self.getSecurityCode.backgroundColor = [UIColor colorWithRed:48/255.0 green:52/255.0 blue:65/255.0 alpha:1];
    [self.getSecurityCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.getSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getSecurityCode addTarget:self action:@selector(getSecurityButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.theLoadView addSubview:self.getSecurityCode];
    
    
    /*输入验证码*/
    self.securityCode_inout =[[UITextField alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.2+110, self.view.bounds.size.width-40, 45)];
    self.securityCode_inout.keyboardType = UIKeyboardTypeNumberPad;
    self.securityCode_inout.delegate = self;
    self.securityCode_inout.backgroundColor =[UIColor whiteColor];
    self.securityCode_inout.layer.cornerRadius = 3;
    self.securityCode_inout.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  请输入验证码" attributes:dict];
    [self.theLoadView addSubview:self.securityCode_inout];
    
    
    /*确定按钮*/
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, self.view.bounds.size.height*0.2+170, self.view.bounds.size.width-40, 35);
    button.backgroundColor = baseRedColor;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 3;
    [button addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.theLoadView addSubview:button];
    
    
    reachabity =[Reachability reachabilityWithHostName:kCheckNetWork_flag];
    
    // Do any additional setup after loading the view.
}


#pragma mark 获取验证码按钮触发
- (void)getSecurityButtonClicked{

    if(isValidatePhone(self.phoneNum_input.text)){
    
        [self.phoneNum_input resignFirstResponder];
        if([reachabity isReachable]){
           
            [self startTime];

            [ProgressHUD show:@"正在发送" Interaction:NO];
            AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];

//            UserInfoModel *userInfo =[[UserInfoModel alloc]initWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:nil];
            
            Userinfo *userinfo =[Userinfo modelWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
            
            NSDictionary *parameters =@{memberID:userinfo.memberId,phoneNum:self.phoneNum_input.text};
            
            [manager POST:API_GetSecurityCode parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"responseObj:%@",responseObject);
                NSDictionary *result = (NSDictionary *)responseObject;
                securityCode = (int)result[@"data"];
                
                [ProgressHUD showSuccess:@"发送成功" Interaction:NO];
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error:%@",[error localizedDescription]);
                [ProgressHUD showError:@"发送失败" Interaction:NO];
            }];
            
            
        }else{
    
            [ProgressHUD showError:@"网络异常" Interaction:NO];
        }
        
      
    }else{
    
        [ProgressHUD showError:@"请输入正确的手机号码" Interaction:NO];
    
    }
   
}

#pragma mark 确定按钮触发
- (void)doneButtonClicked{
    
    if(![self.phoneNum_input.text length] || ![self.securityCode_inout.text length]){
    
        [ProgressHUD showError:@"信息不完整" Interaction:NO];
        
    }else{
    
        if(securityCode != [self.securityCode_inout.text integerValue]){
        
            [ProgressHUD showError:@"验证码输入错误" Interaction:NO];
        }else{
        
            if([reachabity isReachable]){//网络正常
                
                AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
                manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
                [ProgressHUD show:@"正在修改..." Interaction:NO];
                
                
                NSDictionary *parameters = nil;
//                UserInfoModel *userInfo =[[UserInfoModel alloc]initWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:nil];
                
                Userinfo *userinfo =[Userinfo modelWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
                
                if(userinfo.memberId){
                
                    parameters = @{memberID:userinfo.memberId,phoneNum:self.phoneNum_input.text};
                }
                
                
                [manager POST:API_ModiftPhoneBind parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    
                    NSDictionary *result = (NSDictionary *)responseObject;
                    NSLog(@"result:%@",result);
                    [ProgressHUD showSuccess:@"修改成功" Interaction:NO];
                    
                    [[TMCache sharedCache]setObject:responseObject[@"data"] forKey:kUserInfo];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                        [self.navigationController popViewControllerAnimated:YES];
                       
                    });
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"error:%@",[error localizedDescription]);
                    [ProgressHUD showError:@"修改失败" Interaction:NO];
                }];
                
            
            }else{//网络异常
            
            
                [ProgressHUD showError:@"网络异常" Interaction:NO];
            
            }
        
        }
    
    }
    
    
    
    

}




- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if(textField.tag==1001){
    
        if([textField.text length]){
        
            textField.text = nil;
        }
        
    }else{
    
        if([textField.text length]){
            
            textField.text = nil;
        }
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
                
                [self.getSecurityCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
              
                [self.getSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getSecurityCode.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"____%@",strTime);
                [self.getSecurityCode setTitle:[NSString stringWithFormat:@"%@s 后可重新获取",strTime] forState:UIControlStateNormal];
                [self.getSecurityCode setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
                self.getSecurityCode.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}


#pragma mark 导航栏按钮
- (void)navi_buttonClicked:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];

}


- (void)viewWillDisappear:(BOOL)animated{

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
