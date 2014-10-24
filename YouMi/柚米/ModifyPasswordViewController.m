//
//  ModifyPasswordViewController.m
//  youmi
//
//  Created by frankfan on 14/10/20.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import <AFNetworking.h>
#import "Reachability.h"
#import "ProgressHUD.h"
#import <TMCache.h>
#import "UserInfoModel.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>
{

    UITextField *oldPassword_inout;
    UITextField *newPassword_inout;
    UITextField *checkNewPassword_inout;
    
    Reachability *reachability;
}
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"修改密码";
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
    oldPassword_inout =[[UITextField alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.18, self.view.bounds.size.width-40, 40)];
    oldPassword_inout.backgroundColor =[UIColor whiteColor];
    oldPassword_inout.secureTextEntry = YES;
    oldPassword_inout.returnKeyType  = UIReturnKeyDone;
    oldPassword_inout.delegate =self;
    oldPassword_inout.layer.cornerRadius = 2;
    NSDictionary *dict =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    oldPassword_inout.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  当前密码" attributes:dict];
    [self.view addSubview:oldPassword_inout];
    
    //
    newPassword_inout =[[UITextField alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.18+40, self.view.bounds.size.width-40, 40)];
    newPassword_inout.secureTextEntry = YES;
    newPassword_inout.tag = 1001;
    newPassword_inout.backgroundColor =[UIColor whiteColor];
    newPassword_inout.returnKeyType  = UIReturnKeyDone;
    newPassword_inout.layer.cornerRadius = 2;
    newPassword_inout.delegate = self;
    newPassword_inout.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  新密码" attributes:dict];
    [self.view addSubview:newPassword_inout];
    
    //
    checkNewPassword_inout =[[UITextField alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.18+80, self.view.bounds.size.width-40, 40)];
    checkNewPassword_inout.secureTextEntry = YES;
    checkNewPassword_inout.tag = 1002;
    checkNewPassword_inout.backgroundColor =[UIColor whiteColor];
    checkNewPassword_inout.delegate = self;
    checkNewPassword_inout.returnKeyType  = UIReturnKeyDone;
    checkNewPassword_inout.layer.cornerRadius = 2;
    checkNewPassword_inout.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  重新输入新密码" attributes:dict];
    [self.view addSubview:checkNewPassword_inout];

    
    //
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, self.view.bounds.size.height*0.18+140, self.view.bounds.size.width-40, 40);
    button.backgroundColor = baseRedColor;
    button.layer.cornerRadius = 3;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
  
    if(self.view.bounds.size.height<=480){
    
        UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.18+40, self.view.bounds.size.width-40, 1)];
        line1.backgroundColor =[UIColor colorWithWhite:0.9 alpha:0.9];
        [self.view addSubview:line1];
        
        UIView *line2 =[[UIView alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height*0.18+80, self.view.bounds.size.width-40, 1)];
        line2.backgroundColor =[UIColor colorWithWhite:0.9 alpha:0.9];
        [self.view addSubview:line2];
    }
    
    
    reachability =[Reachability reachabilityWithHostName:kCheckNetWork_flag];
    
    
    // Do any additional setup after loading the view.
}

#warning 这里有警告
#pragma mark确定按钮触发
- (void)buttonClicked:(UIButton *)sender{
    
    if(![oldPassword_inout.text length] || ![newPassword_inout.text length] || ![checkNewPassword_inout.text length]){
    
        [ProgressHUD showError:@"信息不完整" Interaction:NO];
        return;
    }
    
    if(![newPassword_inout.text isEqualToString:checkNewPassword_inout.text]){
    
        [ProgressHUD showError:@"密码不一致" Interaction:NO];
        return;
    }
    
    if([reachability isReachable]){//网络正常
        
        AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        NSDictionary *parameters = nil;
        UserInfoModel *userInfo =[[UserInfoModel alloc]initWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:nil];
        if(userInfo.memberId){
        
            parameters = @{memberID:userInfo.memberId,userPassWord:newPassword_inout.text};
        }
        
        
        [ProgressHUD show:@"修改中" Interaction:NO];
        [manager POST:API_ModifyPassword parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"responseOBJ:%@",responseObject);
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            if([dict[@"success"]integerValue]==1){
            
                [ProgressHUD showSuccess:@"修改成功" Interaction:NO];
                [[TMCache sharedCache]setObject:dict[@"data"] forKey:kUserInfo];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error:%@",[error localizedDescription]);
            [ProgressHUD showError:@"修改失败" Interaction:NO];
            
        }];
    
    
    }else{//网络异常

        [ProgressHUD showError:@"网络异常" Interaction:NO];
    
    }
    

}


#pragma mark 结束编辑将会触发->
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField.tag==1001){
    
        if([textField.text length]<6){
        
            [ProgressHUD showError:@"密码长度过短" Interaction:NO];
            textField.text = nil;
        }
    
    }else if (textField.tag==1002){
      
        if([textField.text length]<6){
            
            [ProgressHUD showError:@"密码长度过短" Interaction:NO];
            textField.text = nil;
        }
    }


}

#pragma mark 开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if([textField.text length]){
    
        textField.text = nil;
    }


}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if(textField.tag==1001){
    
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 12 || returnKey;

    
    }

    return YES;
}



#pragma mark 导航栏按钮触发
- (void)navi_buttonClicked:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


#pragma mark fix Progress bug
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
