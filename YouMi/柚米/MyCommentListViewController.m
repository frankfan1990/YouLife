//
//  MyCommentListViewController.m
//  youmi
//
//  Created by frankfan on 14/11/10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MyCommentListViewController.h"
#import "MyCommentViewController.h"

@interface MyCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>
{

}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation MyCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"我的点评";
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

    
    /*segementsControl*/
    NSArray *itemname = @[@"未点评",@"已点评"];
    UISegmentedControl *segements =[[UISegmentedControl alloc]initWithItems:itemname];
    segements.frame = CGRectMake(10, 64+5, self.view.bounds.size.width-20, 40);
    segements.tintColor = baseRedColor;
    segements.backgroundColor = [UIColor whiteColor];
    segements.selectedSegmentIndex = 0;
    [self.view addSubview:segements];
    segements.layer.masksToBounds = YES;
    segements.layer.cornerRadius = 3;
    
    
    /**
     *  @Author frankfan, 14-11-10 09:11:26
     *
     *  创建tableView
     *
     *  @return nil
     */
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 64+5+40+5, self.view.bounds.size.width-20, self.view.bounds.size.height-49-64) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - tableView相关代理方法处理
#pragma mark - tableViewCell生成个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 10;
}







#pragma mark - 创建tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellName = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        
        /**
         *  @Author frankfan, 14-11-10 09:11:04
         *
         *  在这里开始创建cell
         *
         *  @return inl
         */
        
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
        //UIlabel 背景
        UILabel *theBackView =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 75)];
        theBackView.backgroundColor =[UIColor whiteColor];
        theBackView.layer.cornerRadius = 3;
        theBackView.layer.masksToBounds = YES;
        [cell.contentView addSubview:theBackView];
        
        //UIImageView 创建商品图像
        UIImageView *headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 75)];
        headerImageView.tag = 1001;
        headerImageView.layer.cornerRadius = 3;
        headerImageView.layer.masksToBounds = YES;
        [theBackView addSubview:headerImageView];
        
        
        //UILabel 创建信息栏1
        UILabel *infoLabel1 =[[UILabel alloc]initWithFrame:CGRectMake(headerImageView.bounds.size.width+5, -10, 123, 45)];
        infoLabel1.tag = 1002;
        infoLabel1.textColor = baseTextColor;
        infoLabel1.adjustsFontSizeToFitWidth = YES;
        infoLabel1.font =[UIFont systemFontOfSize:14];
        [theBackView addSubview:infoLabel1];
        
        //UILabel 创建信息栏2
        UILabel *infoLabel2 =[[UILabel alloc]initWithFrame:CGRectMake(headerImageView.bounds.size.width+5, 20, 123, 35)];
        infoLabel2.tag = 1003;
        infoLabel2.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        infoLabel2.adjustsFontSizeToFitWidth = YES;
        infoLabel2.font =[UIFont systemFontOfSize:14];
        [theBackView addSubview:infoLabel2];
        
        //UILabel 创建信息栏3
        UILabel *infoLabel3 =[[UILabel alloc]initWithFrame:CGRectMake(headerImageView.bounds.size.width+5, 45, 123, 35)];
        infoLabel3.tag = 1004;
        infoLabel3.textColor = baseTextColor;
        infoLabel3.adjustsFontSizeToFitWidth = YES;
        infoLabel3.font =[UIFont systemFontOfSize:14];
        [theBackView addSubview:infoLabel3];
        
    }

    //图像
    UIImageView *headerImageView = (UIImageView *)[cell viewWithTag:1001];
    headerImageView.backgroundColor = [UIColor blackColor];

    //信息1
    UILabel *infoLabel1 =(UILabel *)[cell viewWithTag:1002];
    infoLabel1.text = @"文字1";

    //信息2
    UILabel *infoLabel2 =(UILabel *)[cell viewWithTag:1003];
    infoLabel2.text = @"文字2";

    //信息3
    UILabel *infoLabel3 =(UILabel *)[cell viewWithTag:1004];
    infoLabel3.text = @"文字3";
    
    return cell;
    
}




#pragma mark - tableViewCell点击触发事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MyCommentViewController *myComment =[MyCommentViewController new];
    myComment.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myComment animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


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
