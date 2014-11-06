//
//  ModifyNicknameViewController.m
//  youmi
//
//  Created by frankfan on 14/10/20.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//
#pragma mark 修改昵称

#import "ModifyNicknameViewController.h"
#import "Reachability.h"
#import <AFNetworking.h>
#import "ProgressHUD.h"
#import <TMCache.h>
#import "Userinfo.h"



@interface ModifyNicknameViewController ()<UITextFieldDelegate>
{

    Reachability *reachAbility;
}
@property (nonatomic,strong)UITextField *nickName_input;
@end

@implementation ModifyNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"修改昵称";
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


    /*昵称输入框*/
    self.nickName_input =[[UITextField alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.23, self.view.bounds.size.width-40, 50)];
    self.nickName_input.delegate = self;
    self.nickName_input.returnKeyType = UIReturnKeyDone;
    self.nickName_input.backgroundColor =[UIColor whiteColor];
    self.nickName_input.layer.cornerRadius = 3;
    NSDictionary *dict =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.nickName_input.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"   请输入新昵称" attributes:dict];
    [self.view addSubview:self.nickName_input];
    
    /*确定按钮*/
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, self.view.bounds.size.height*0.23+75, self.view.bounds.size.width-40, 40);
    button.backgroundColor = baseRedColor;
    button.layer.cornerRadius = 3;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    reachAbility = [Reachability reachabilityWithHostName:kCheckNetWork_flag];
    
    // Do any additional setup after loading the view.
}


#pragma mark 确定按钮触发
- (void)loginButtonClicked:(UIButton *)sender{
    
    if([self.nickName_input isFirstResponder]){
    
        [self.nickName_input resignFirstResponder];
    }
    
    if([reachAbility isReachable]){//网络正常
        
        if([self.nickName_input.text length]){
        
            AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            

            NSDictionary *parameters = nil;
            
//            UserInfoModel *userInfo =[[UserInfoModel alloc]initWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:nil];
            Userinfo *userinfo =[Userinfo modelWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
        
            if(userinfo.memberId){
            
                parameters = @{memberID:userinfo.memberId,api_nickName:self.nickName_input.text};

            }
            
            [ProgressHUD show:nil Interaction:NO];
            [manager POST:API_ModifyNickname parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                NSLog(@"responsObject:%@",responseObject);
                
                if([responseObject[isSuccess]integerValue]==1){
                
                    [ProgressHUD showSuccess:@"修改成功" Interaction:NO];
                
                   
                    [[TMCache sharedCache] setObject:responseObject[@"data"] forKey:kUserInfo];
             
                    
                    NSLog(@"修改昵称:%@", [[TMCache sharedCache]objectForKey:kUserInfo]);
                    
                    [self.navigationController popViewControllerAnimated:YES];

                }
                
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error:%@",[error localizedDescription]);
                [ProgressHUD showError:@"修改失败" Interaction:NO];
                
            }];

           
        }else{
        
            [ProgressHUD showError:@"请输入昵称" Interaction:NO];
        
        }
        
        
        
    }else{//网络异常
    
        [ProgressHUD showError:@"网络异常" Interaction:NO];
    }
    
    
    
    


}





#pragma mark uitextField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if([textField.text length]){
        
        textField.text = nil;
    }

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self.nickName_input resignFirstResponder];
    return YES;
}



#pragma mark 导航栏按钮触发
- (void)navi_buttonClicked:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];


}









- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
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
