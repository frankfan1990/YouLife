//
//  ShoppingCartViewController.m
//  youmi
//
//  Created by frankfan on 14/10/30.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartTableViewCell.h"
@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrOfgoodsName;
    NSArray *arrOfPrice;
    NSArray *arrOfshopName;
    NSArray *arrOfnumber;
}
@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    
    //导航栏上一些元素初始化
    [self createTabBar];
    
    //一些变量的初始化
    [self VariableInitialization];

    //创建tableView
    [self createTableView];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)createTabBar
{
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"我的购物车";
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
    
    /*右侧按钮*/
    UIButton *searchButton =[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.tag = 1000;
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateSelected];
    [searchButton addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    UIButton *searchButton2 =[UIButton buttonWithType:UIButtonTypeCustom];
    //    searchButton2.tag = 1002;
    //    searchButton2.frame = CGRectMake(0, 0, 30, 30);
    //    [searchButton2 setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
    //    [searchButton2 addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 =[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    //    UIBarButtonItem *item2 =[[UIBarButtonItem alloc]initWithCustomView:searchButton2];
    //    NSArray *itemArrays = @[item1,item2];
    //    self.navigationItem.rightBarButtonItems  =itemArrays;
    self.navigationItem.rightBarButtonItem = item1;
}
-(void)VariableInitialization
{
    arrOfPrice = [[NSArray alloc] initWithObjects:@"1800.00", @"1800.00", @"1800.00", @"1800.00",@"1800.00",@"1800.00",@"1800.00",@"1800.00",@"1800.00",@"1800.00",nil];
    arrOfnumber = [[NSArray alloc] initWithObjects:@"1", @"1", @"180", @"18",@"2",@"4",@"8",@"1",@"7",@"9",nil];
    arrOfshopName = [[NSArray alloc] initWithObjects:@"爱上美鞋",@"安踏",@"特步",@"美特使邦威",@"飞翔的小鸡",@"爱上美鞋",@"爱上美鞋",@"爱上美鞋",@"爱上美鞋",@"爱上美鞋",nil];;
    arrOfgoodsName = [[NSArray alloc] initWithObjects:@"美鞋",@"美鞋",@"美鞋",@"美鞋",@"美鞋",@"美鞋",@"美鞋",@"美鞋",@"美鞋",@"美鞋",nil];
}
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(15,0, self.view.frame.size.width-30, self.view.frame.size.height-60) style:UITableViewStylePlain];
    tableView.backgroundColor = customGrayColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator= NO;
    [tableView reloadData];
    [self.view addSubview:tableView];
    
}



#pragma mark - tableView的代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrOfPrice.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 8)];
    headView.backgroundColor = customGrayColor;
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellname = @"cell";
    ShoppingCartTableViewCell *cell = (ShoppingCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellname];
    if (cell == nil) {
        cell = [[ShoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
    }
    cell.labelOfGoodsName.text = arrOfgoodsName[indexPath.section];
    cell.labelOfShoppName.text = arrOfshopName[indexPath.section];
    cell.labelOfPrice.text = [NSString stringWithFormat:@"价格: %@元",arrOfPrice[indexPath.section]];
    cell.labelOfNumber.text = [NSString stringWithFormat:@"数量:%@",arrOfnumber[indexPath.section]];
    cell.imageOfGoods.image = [UIImage imageNamed:@"测试图片.png"];
    [cell.btnOfSelected addTarget:self action:@selector(didBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)didBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
#pragma mark - 导航栏按钮触发
/**
 *  @Author frankfan, 14-10-30 11:10:02
 *
 *  导航栏上按钮的触发
 *
 *  @param sender 传过来的button
 */
- (void)navi_buttonClicked:(UIButton *)sender{

    if(sender.tag==401){
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender.tag==1000){
    
    
        sender.selected = !sender.selected;
        NSLog(@"编辑");
        
        
    }else{
    
        NSLog(@"购物车");
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
