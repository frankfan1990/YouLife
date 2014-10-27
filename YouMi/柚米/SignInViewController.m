//
//  SignInViewController.m
//  youmi
//
//  Created by frankfan on 14-10-13.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#pragma mark 登陆模块

#import "SignInViewController.h"
#import "TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h"
#import "RegisterAcountViewController.h"
#import "Email_Phone.h"
#import <AFNetworking.h>
#import "ProgressHUD.h"
#import "Reachability.h"
#import <JSONModel.h>
#import <TMCache.h>
#import "ForgetPasswordViewController.h"


@interface SignInViewController ()<UITextFieldDelegate>
{

    Reachability *reachability;
}
@property (nonatomic,strong)UITextField *userID_input;
@property (nonatomic,strong)UITextField *userPassword_input;
@property (nonatomic,strong)TPKeyboardAvoidingScrollView *theLoadView;
@end

@implementation SignInViewController

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
    self.view.userInteractionEnabled = YES;
    
    /*创建theLoad*/
    self.theLoadView =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    self.theLoadView.userInteractionEnabled = YES;
    [self.view addSubview:self.theLoadView];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"登陆";
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

    
    
    NSInteger Threshold = 0;
    if(self.view.bounds.size.height<=480){
        
        Threshold = 60;
    }
    /*创建ID输入框*/
  
    self.userID_input =[[UITextField alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.3-Threshold, self.view.bounds.size.width-40, 45)];
    self.userID_input.returnKeyType = UIReturnKeyDone;
    self.userID_input.tag = 1001;
    self.userID_input.delegate =self;
    self.userID_input.backgroundColor =[UIColor whiteColor];
    self.userID_input.layer.cornerRadius = 3;
    NSDictionary *dict =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.userID_input.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"手机/邮箱" attributes:dict];
    self.userID_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.theLoadView addSubview:self.userID_input];
    
    UIImageView *id_leftView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    id_leftView.image =[UIImage imageNamed:@"id"];
    self.userID_input.leftViewMode = UITextFieldViewModeAlways;
    self.userID_input.leftView = id_leftView;
    
    
    /*创建密码输入框*/
    self.userPassword_input =[[UITextField alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.3+55-Threshold, self.view.bounds.size.width-40, 45)];
    self.userPassword_input.secureTextEntry = YES;
    self.userPassword_input.returnKeyType = UIReturnKeyDone;
    self.userPassword_input.tag = 1002;
    self.userPassword_input.delegate = self;
    self.userPassword_input.backgroundColor =[UIColor whiteColor];
    self.userPassword_input.layer.cornerRadius = 3;
    self.userPassword_input.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:dict];
    [self.theLoadView addSubview:self.userPassword_input];
    
    UIImageView *pass_leftView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    pass_leftView.image =[UIImage imageNamed:@"password"];
    self.userPassword_input.leftViewMode = UITextFieldViewModeAlways;
    self.userPassword_input.leftView = pass_leftView;
    
    
    /*登陆*/
    UIButton *buttonLogin =[UIButton buttonWithType:UIButtonTypeCustom];
    buttonLogin.tag = 1003;
    buttonLogin.frame = CGRectMake(20, self.view.bounds.size.height*0.3+130-Threshold, self.view.bounds.size.width-40, 35);
    buttonLogin.backgroundColor = baseRedColor;
    buttonLogin.layer.cornerRadius = 3;
    [buttonLogin setTitle:@"登陆" forState:UIControlStateNormal];
    [buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.theLoadView addSubview:buttonLogin];
    [buttonLogin addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /*忘记密码*/
    UIButton *forgetPassBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    forgetPassBtn.tag = 1004;
    forgetPassBtn.frame = CGRectMake(20, self.view.bounds.size.height*0.3+185-Threshold, self.view.bounds.size.width/3.0, 22);
    [forgetPassBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
    [forgetPassBtn setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
    forgetPassBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.theLoadView addSubview:forgetPassBtn];
    [forgetPassBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /*注册*/
    UIButton *registerAccount =[UIButton buttonWithType:UIButtonTypeCustom];
    registerAccount.tag = 1005;
    registerAccount.frame = CGRectMake(self.view.bounds.size.width-100, self.view.bounds.size.height*0.3+185-Threshold, self.view.bounds.size.width/3.0, 22);
    [registerAccount setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
    [registerAccount setTitle:@"注册" forState:UIControlStateNormal];
    registerAccount.titleLabel.font = [UIFont systemFontOfSize:15];
    registerAccount.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.theLoadView addSubview:registerAccount];
    [registerAccount addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    ////红线
    UIView *footLine =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height*0.83, self.view.bounds.size.width, 1)];
    footLine.backgroundColor = baseRedColor;
    [self.view addSubview:footLine];
    
    NSInteger labelWidth = self.view.bounds.size.width*0.45;
    UILabel *_3rthPartLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.5-labelWidth*0.45, self.view.bounds.size.height*0.83-14, labelWidth, 30)];
    _3rthPartLabel.text = @"使用第三方账号登陆";
    _3rthPartLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    _3rthPartLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_3rthPartLabel];
    _3rthPartLabel.textAlignment = NSTextAlignmentCenter;
    _3rthPartLabel.backgroundColor =customGrayColor;
    
    
    //////第三方登陆
    UIImageView *WeiboLogin =[[UIImageView alloc]initWithFrame:CGRectMake(45, self.view.bounds.size.height*0.83+30, 35, 35)];
    WeiboLogin.tag = 1006;
    WeiboLogin.userInteractionEnabled = YES;
    WeiboLogin.image = [UIImage imageNamed:@"weibo"];
    [self.view addSubview:WeiboLogin];
    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTaped:)];
    [WeiboLogin addGestureRecognizer:tap1];
    
    
    UIImageView *QQLogin =[[UIImageView alloc]initWithFrame:CGRectMake(143, self.view.bounds.size.height*0.83+30, 35, 35)];
    QQLogin.tag = 1007;
    QQLogin.userInteractionEnabled = YES;
    QQLogin.image = [UIImage imageNamed:@"qq"];
    [self.view addSubview:QQLogin];
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTaped:)];
    [QQLogin addGestureRecognizer:tap2];
    
    
    UIImageView *WeixinLogin =[[UIImageView alloc]initWithFrame:CGRectMake(240, self.view.bounds.size.height*0.83+30, 35, 35)];
    WeixinLogin.tag = 1008;
    WeixinLogin.userInteractionEnabled = YES;
    WeixinLogin.image = [UIImage imageNamed:@"weix"];
    [self.view addSubview:WeixinLogin];
    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTaped:)];
    [WeixinLogin addGestureRecognizer:tap3];
    
    //
    reachability =[Reachability reachabilityWithHostName:kCheckNetWork_flag];
    
    // Do any additional setup after loading the view.
}

#pragma mark 这里有警告
#pragma mark UIButton的触发事件调用
- (void)buttonClicked:(UIButton *)sender{
    
    
    if(sender.tag==1003){//登陆部分触发
        
        if(![self.userID_input.text length] || ![self.userPassword_input.text length]){//如果填入信息不完整
            
            [ProgressHUD showError:@"信息不完整" Interaction:NO];
        
        }else{//正常填写信息
            
            if([self.userPassword_input.text length]<6){
            
                [ProgressHUD showError:@"密码过短" Interaction:NO];
                return;
            }
        
            [ProgressHUD show:@"登陆中..." Interaction:NO];
            if(![reachability isReachable]){//网络链接异常
                
                
                [ProgressHUD showError:@"网络异常" Interaction:NO];
            }else{//网络正常链接
            
                AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
                
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];


                NSDictionary *parameters = @{userAcount:self.userID_input.text,userPassWord:self.userPassword_input.text};
                [manager POST:API_UserLogin parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {


                    NSLog(@"这里是登陆模块:%@",responseObject);
                    
                    if([responseObject[@"success"]integerValue]==0){
                        
                        [ProgressHUD showError:@"账号或密码错误" Interaction:NO];
                        return ;
                    
                    }
                    
                    
                    if([responseObject[@"success"]integerValue]==1){
                        
                        [ProgressHUD showSuccess:@"登陆成功" Interaction:NO];
                        //!!!:如果登陆成功就将用户信息存储配置文件
                        NSDictionary *data = responseObject[@"data"];
                        //!!!:这里不能直接存自定义的类对象，应该先将data缓存，然后利用改缓存对象去映射为model层
                        [[TMCache sharedCache]setObject:data forKey:kUserInfo];
                        
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                        });
                    
                    }
                    
                           
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"这里是登陆模块error:%@",error);
                
                    [ProgressHUD showError:@"登陆失败" Interaction:NO];
                    
                }];
                
            }
        
        
        
        }
        
            NSLog(@"登陆");
    
    }else if (sender.tag==1004){
        
        
        ForgetPasswordViewController *forgetPassword = [ForgetPasswordViewController new];
        forgetPassword.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:forgetPassword animated:YES];
        
        NSLog(@"忘记密码");
    }else{
    
        RegisterAcountViewController *registerAcount = [[RegisterAcountViewController alloc]init];
        [self.navigationController pushViewController:registerAcount animated:YES];
        NSLog(@"注册");
    }

}



#pragma mark 社交分享调用
- (void)gestureTaped:(UIGestureRecognizer *)gesture{

    UIView *tapedView = gesture.view;
    if(tapedView.tag==1006){
    
        NSLog(@"微博分享");
    }else if (tapedView.tag ==1007){
    
        NSLog(@"QQ分享");
    }else{
    
        NSLog(@"微信分享");
    }
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;

}



#pragma mark 文本框完成了输入
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField.tag==1001){/*账号登陆框操作*/
    
        if(!isValidatePhone(textField.text) && !isValidateEmail(textField.text)){
            
            [ProgressHUD showError:@"非法输入" Interaction:NO];
            textField.text = nil;
            
        }
    
    }else{/*密码框输入框操作*/
    
     
    }

}


#pragma mark 文本框开始输入
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if(textField.tag ==1001){/*用户名*/
        
        self.userID_input.text = nil;
    }else{/*密码*/
    
        self.userPassword_input.text = nil;
    }
    
    
    self.theLoadView.scrollEnabled = NO;

}



-(void)dealloc{

    if([ProgressHUD shared]){
    
        [ProgressHUD dismiss];
    }

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
