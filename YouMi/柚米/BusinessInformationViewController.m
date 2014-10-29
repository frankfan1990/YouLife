//
//  BusinessInformationViewController.m
//  youmi
//
//  Created by frankfan on 14/10/29.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "BusinessInformationViewController.h"

@interface BusinessInformationViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    NSArray *shopInfo;
    //
    UILabel *detailInfoLabel;//动态高度cell
}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation BusinessInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    /**
     基本信息配置
     */
    shopInfo = @[@"营业时间",@"",@"",@"餐厅特色",@"",@"公交信息"];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"商铺营业信息";
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

    //
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - 创建tableView的相关方法
/**
 *  @Author frankfan, 14-10-29 19:10:46
 *
 *  创建tableView相关方法
 *
 *  @return nil
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITableViewCell *cell2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    if(indexPath.row ==0 || indexPath.row ==3 || indexPath.row==5){
    
        UIImageView *logImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 25, 25)];
        logImageView.image =[UIImage imageNamed:@"竖标签"];
        [cell1.contentView addSubview:logImageView];
        
        UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(3, 5, 120, 40)];
        nameLabel.font =[UIFont systemFontOfSize:14];
        nameLabel.textColor = baseTextColor;
        cell1.layer.cornerRadius = 3;
        
        nameLabel.text = shopInfo[indexPath.row];
        
        cell1.backgroundColor = customGrayColor;
        return cell1;
        
    }else{
        
        /**
         *  @Author frankfan, 14-10-29 21:10:56
         *
         *  这里返回的cell应该是动态高度的
         */
        return cell2;
    
    }

}






#pragma mark - 导航栏按触发
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
