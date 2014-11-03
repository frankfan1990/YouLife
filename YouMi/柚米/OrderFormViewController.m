//
//  OrderFormViewController.m
//  youmi
//
//  Created by frankfan on 14/10/30.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "OrderFormViewController.h"
#import "ShoppingCartTableViewCell.h"
@interface OrderFormViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrOfgoodsName;
    NSArray *arrOfPrice;
    NSArray *arrOfshopName;
    NSArray *arrOfnumber;
}
@end

@implementation OrderFormViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    
    [self createHeadView];
    //导航栏上一些元素初始化
    [self createTabBar];
    
    //一些变量的初始化
    [self VariableInitialization];
    
    //创建tableView
    [self createTableView];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)createHeadView
{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"未付款",@"已付款"]];
    segment.frame = CGRectMake(15, 75, self.view.frame.size.width-30, 40);
    segment.selectedSegmentIndex = 0;
    
    segment.tintColor = baseRedColor;
    [segment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],UITextAttributeFont,nil] forState:UIControlStateNormal];
    [segment addTarget:self action:@selector(didsegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
}

-(void)createTabBar
{
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"我的订单";
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
    
    /*rightbarButton*/
    UIButton *rightbarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rightbarButton.tag = 402;
    rightbarButton.frame = CGRectMake(0, 0, 25, 25);
    [rightbarButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [rightbarButton setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateSelected];
    [rightbarButton addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightbarButton];
    self.navigationItem.rightBarButtonItem = rightbarButtonItem;
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(15,60+55, self.view.frame.size.width-30, self.view.frame.size.height-60-50-60) style:UITableViewStylePlain];
    tableView.backgroundColor = customGrayColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator= NO;
    [tableView reloadData];
    [self.view addSubview:tableView];
    
}
//点击事件
-(void)didsegment:(UISegmentedControl *)seg
{
    if(seg.selectedSegmentIndex == 0)
    {
        NSLog(@"未付款");
    }else if(seg.selectedSegmentIndex == 1)
    {
        NSLog(@"已付款");
    }
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
    cell.btnOfSelected.hidden = YES;
    return cell;
}

/**
 *  @Author frankfan, 14-10-30 11:10:02
 *
 *  导航栏上的按钮触发
 *
 *  @return nil
 */

#pragma mark - 导航栏按钮触发
- (void)navi_buttonClicked:(UIButton *)sender{
    
    if(sender.tag==401){
    
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
        sender.selected = !sender.selected;
        NSLog(@"编辑");
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
