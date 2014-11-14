//
//  MoreActivityDetailViewController.m
//  youmi
//
//  Created by frankfan on 14/11/14.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MoreActivityDetailViewController.h"

@interface MoreActivityDetailViewController ()<UIWebViewDelegate>
{

    UIWebView *webView;
}
@end

@implementation MoreActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"活动规则";
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

    
    
    webView =[[UIWebView alloc]initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.taobao.com"]]];
    [self.view addSubview:webView];
    webView.backgroundColor =[UIColor whiteColor];
    webView.delegate = self;
    
    
    
    // Do any additional setup after loading the view.
}




-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    NSLog(@"error:%@",error);
}




#pragma mark - 导航栏按钮触发
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
