//
//  RegisterAcountViewController.m
//  youmi
//
//  Created by frankfan on 14-10-15.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "RegisterAcountViewController.h"
#import "TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h"
#import "Email_Phone.h"
#import "RegisterAcount2ViewController.h"
#import "Reachability.h"
#import <AFNetworking.h>
#import "ProgressHUD/ProgressHUD.h"

@interface RegisterAcountViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *phoneNumTextField;
@property (nonatomic,strong)TPKeyboardAvoidingScrollView *theLoadView;
@property (nonatomic,strong)Reachability *reachAbility;
@end

@implementation RegisterAcountViewController

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
    
    
    //
    self.theLoadView =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.theLoadView];
    
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

    
    /*手机号输入*/
    self.phoneNumTextField =[[UITextField alloc]initWithFrame:CGRectMake(20, 60, self.view.bounds.size.width-40, 50)];
    self.phoneNumTextField.delegate = self;
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTextField.backgroundColor =[UIColor whiteColor];
    self.phoneNumTextField.layer.cornerRadius = 3;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    self.phoneNumTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  请输入手机号码" attributes:dict];
    [self.theLoadView addSubview:self.phoneNumTextField];
    
    ///
    UILabel *textLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 120, 300, 20)];
    textLabel.textColor =[UIColor colorWithWhite:0.45 alpha:1];
    textLabel.font=[UIFont systemFontOfSize:12];
    textLabel.text = @"此手机号用来接收验证码，以此完成下一步操作";
    [self.theLoadView addSubview:textLabel];
    
    
    /*下一步Button*/
    UIButton *buttonNext =[UIButton buttonWithType:UIButtonTypeCustom];
    buttonNext.frame = CGRectMake(20, 175, self.view.bounds.size.width-40, 40);
    buttonNext.backgroundColor = baseRedColor;
    buttonNext.layer.cornerRadius = 3;
    [buttonNext setTitle:@"下一步" forState:UIControlStateNormal];
    [buttonNext setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
    [buttonNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.theLoadView addSubview:buttonNext];
    [buttonNext addTarget:self action:@selector(nextStepButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.reachAbility =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    
    // Do any additional setup after loading the view.
}


#pragma mark 文本输入框代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    textField.text = nil;

}


#pragma mark 下一步按钮触发
- (void)nextStepButtonClicked:(UIButton *)sender{
    
    if(isValidatePhone(self.phoneNumTextField.text) && [self.reachAbility isReachable]){/*合法输入*/
        
        [ProgressHUD show:@"正在发送..." Interaction:NO];
        AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
        NSDictionary *dict = @{@"telphone":self.phoneNumTextField.text};
        
        [manager POST:API_RegisterPhoneNum parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSLog(@"responseObject:%@",responseObject[@"data"]);
            
            if([responseObject[@"success"]integerValue]==0){
            
                [ProgressHUD showError:@"此手机号码已经被注册,请重新输入其他手机号码!" Interaction:NO];
                return ;
            
            }
            
            
            if([responseObject[@"success"]integerValue]==1){
            
                [ProgressHUD showSuccess:@"号码已发送" Interaction:NO];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    RegisterAcount2ViewController *registerAcount2 =[[RegisterAcount2ViewController alloc]init];
                    registerAcount2.userPhoneNum = self.phoneNumTextField.text;
                    registerAcount2.securityCode = responseObject[@"data"];
                    [self.navigationController pushViewController:registerAcount2 animated:YES];
                    
                });
            
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [ProgressHUD showError:@"发送失败" Interaction:NO];
            NSLog(@"网络异常,error:%@",[error description]);
            
        }];
        
    }else{/*非法输入*/
    
        if(!isValidatePhone(self.phoneNumTextField.text)){
            
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"电话号码格式不正确" message:@"请重新输入正确的电话号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                self.phoneNumTextField.text = nil;
            });
            
        }else{
        
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"链接异常" message:@"请求数据发生异常，请检查网络链接情况" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                self.phoneNumTextField.text = nil;
            });
        }
    
    }
    
   
#warning debug模式
#if 0
    RegisterAcount2ViewController *registerAcount2 =[[RegisterAcount2ViewController alloc]init];
    
    registerAcount2.userPhoneNum = self.phoneNumTextField.text;
    [self.navigationController pushViewController:registerAcount2 animated:YES];
#endif

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
