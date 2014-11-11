//
//  ActivityDetailViewController.m
//  youmi
//
//  Created by frankfan on 14/11/11.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ActivityDetailViewController.h"

@interface ActivityDetailViewController ()
{

    /*收藏按钮是否点击*/
    BOOL isCollectioned;
}

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    /**
     在这里初始化参数
     */
    
    isCollectioned = NO;
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"活动详情";
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
    
    
    /*右侧按钮*/
    UIButton *searchButton =[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.tag = 1000;
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchButton2 =[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton2.tag = 1002;
    searchButton2.frame = CGRectMake(0, 0, 30, 30);
    [searchButton2 setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [searchButton2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 =[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    UIBarButtonItem *item2 =[[UIBarButtonItem alloc]initWithCustomView:searchButton2];
    
    NSArray *itemArrays = @[item1,item2];
    self.navigationItem.rightBarButtonItems  =itemArrays;
    

    
    
    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - 导航栏按钮触发
- (void)buttonClicked:(UIButton *)sender{

    if(sender.tag==10006){//回退按钮
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(sender.tag==1000){//收藏
        
        if(!isCollectioned){
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
            
            isCollectioned = YES;
        }else{
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            isCollectioned = NO;
        }
        
        
        
    }
    
    if(sender.tag==1002){//分享
        
        
        NSLog(@"分享");
        
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
