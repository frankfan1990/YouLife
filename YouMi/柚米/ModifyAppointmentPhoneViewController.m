//
//  ModifyAppointmentPhoneViewController.m
//  youmi
//
//  Created by frankfan on 14/11/10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ModifyAppointmentPhoneViewController.h"
#import "Email_Phone.h"
#import "ProgressHUD.h"

@interface ModifyAppointmentPhoneViewController ()<UITextFieldDelegate>
{
    
    UIView *touchView;//检测手势

}
@property (nonatomic,strong)UITextField *phoneNumTextField;
@end

@implementation ModifyAppointmentPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"定座手机";
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

    //定座手机号
    UILabel *appointmentPhoneNum =[[UILabel alloc]initWithFrame:CGRectMake(10, 64+10, 100, 35)];
    appointmentPhoneNum.font =[UIFont systemFontOfSize:14];
    appointmentPhoneNum.textColor = baseTextColor;
    appointmentPhoneNum.text = @"定座手机号";
    [self.view addSubview:appointmentPhoneNum];
    
    UILabel *textLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 64+10+25, 250, 35)];
    textLabel.font =[UIFont systemFontOfSize:13];
    textLabel.textColor =[UIColor colorWithWhite:0.85 alpha:1];
    textLabel.text = @"若手机号码有误，点击号码进行修改";
    [self.view addSubview:textLabel];
    
    
    //定座手机号
    self.phoneNumTextField =[[UITextField alloc]initWithFrame:CGRectMake(215, 64+10, 100, 35)];
    self.phoneNumTextField.delegate = self;
    self.phoneNumTextField.textColor = baseTextColor;
    self.phoneNumTextField.font =[UIFont systemFontOfSize:14];
    self.phoneNumTextField.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.phoneNumTextField];
#warning fake data
    self.phoneNumTextField.text = @"15575829007";
    
    
    /**
     *  @Author frankfan, 14-11-10 15:11:34
     *
     *  创建检测手势的View
     *
     *  @return nil
     */
    
    UIView *customTouchView =[[UIView alloc]initWithFrame:CGRectMake(0, 64+10+25+15, self.view.bounds.size.width, self.view.bounds.size.height-64+20)];
    customTouchView.tag = 1001;
    [self.view addSubview:customTouchView];

    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 手机号码修改代理
- (void)textFieldDidEndEditing:(UITextField *)textField{

#warning 在这里提交修改
    
    if([self.phoneNumTextField.text length]==0 || !isValidatePhone(self.phoneNumTextField.text)){
        
        [ProgressHUD showError:@"手机号码错误"];
        
        if([self.phoneNumTextField.text length]==0){
            
            self.phoneNumTextField.backgroundColor =[UIColor colorWithWhite:0.75 alpha:1];
        }
        
        return;
    }
    
    
    
    NSLog(@"停止编辑，提交修改");
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    self.phoneNumTextField.backgroundColor =[UIColor whiteColor];

}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.phoneNumTextField resignFirstResponder];
}




#pragma mark - 回退按钮
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
