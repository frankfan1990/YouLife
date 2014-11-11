//
//  AboutYouMiViewController.m
//  youmi
//
//  Created by frankfan on 14/11/10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "AboutYouMiViewController.h"
#import <AFNetworking.h>
#import "ProgressHUD.h"
#import <TMCache.h>

@interface AboutYouMiViewController ()
{

}
@property (nonatomic,strong)UITextView *textView;
@end

@implementation AboutYouMiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    
    //
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"关于优米";
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
    
    //创建textView
    self.textView =[[UITextView alloc]initWithFrame:self.view.bounds];
    self.textView.textColor = baseTextColor;
    self.textView.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.textView];
    
    

    //如果本地没有‘关于优米’的简介，那么就从网络上请求数据，否则，从本地取
    if(![[[TMCache sharedCache]objectForKey:@"kAboutYoumi"] length]){
    
        AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [ProgressHUD show:nil];
        [manager GET:API_AboutYouMi parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [ProgressHUD dismiss];
#warning 在这里进行持久化
            NSLog(@"responseObject");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [ProgressHUD dismiss];
            NSLog(@"error:%@",[error localizedDescription]);
            
        }];
    
    }else{
    
        
#warning 在这里进行数据处理
    
    
    
    
    }
    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    if([ProgressHUD shared]){
        
        [ProgressHUD dismiss];
    
    }
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
