//
//  ShoppingCartViewController.m
//  youmi
//
//  Created by frankfan on 14/10/30.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartTableViewCell.h"

#import "ProgressHUD.h"
#import "Reachability.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import <TMCache.h>
#import "UserCartObject.h"

@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrOfgoodsName;
    NSArray *arrOfPrice;
    NSArray *arrOfshopName;
    NSArray *arrOfnumber;
    
    //
    UILabel *totoalMoney;
    UITableView *_tableView;
    
    NSMutableArray *recodeIndexPath;
    Reachability *reachability;
    
    NSMutableArray *globalArray;
    
    
}
@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    
    //
    recodeIndexPath =[NSMutableArray array];
    globalArray =[NSMutableArray array];
    
    //导航栏上一些元素初始化
    [self createTabBar];
    
    //一些变量的初始化
    [self VariableInitialization];

    //创建tableView
    [self createTableView];
    
    
    /**
     *  @author frankfan, 14-12-15 17:12:42
     *
     *  创建底部结算按钮
     *
     *  @return
     */
    
    UIView *bottomBackView =[[UIView alloc]initWithFrame:CGRectMake(15, self.view.bounds.size.height-49, self.view.bounds.size.width-30, 49)];
    bottomBackView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bottomBackView];
    
    UIButton *payItButton =[UIButton buttonWithType:UIButtonTypeCustom];
    payItButton.frame = CGRectMake(bottomBackView.bounds.size.width-70, 5, 60, 39);
    payItButton.layer.cornerRadius = 3;
    payItButton.backgroundColor =baseRedColor;
    [payItButton setTitle:@"结算" forState:UIControlStateNormal];
    [bottomBackView addSubview:payItButton];
    [payItButton addTarget:self action:@selector(payItButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    //结算
    UILabel *payLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 49)];
    payLabel.textColor =[UIColor blackColor];
    payLabel.font =[UIFont boldSystemFontOfSize:14];
    payLabel.text = @"结算:";
    [bottomBackView addSubview:payLabel];
    
    totoalMoney =[[UILabel alloc]initWithFrame:CGRectMake(65, 0, 100, 49)];
    totoalMoney.textColor =[UIColor whiteColor];
    totoalMoney.font = [UIFont systemFontOfSize:14];
    [bottomBackView addSubview:totoalMoney];
    totoalMoney.adjustsFontSizeToFitWidth = YES;
  
#pragma mark - 开始网络请求
    
    reachability =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    if(![reachability isReachable]){
    
        [ProgressHUD showError:@"网络异常"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
    NSString *memberIdString = [[TMCache sharedCache]objectForKey:kUserInfo][memberID];
    NSDictionary *parameter = nil;
    if([memberIdString length]){
    
        parameter = @{memberID:memberIdString,
                      @"start":@0,
                      @"limit":@10};
    }
    
    [ProgressHUD show:nil];
    [manager GET:API_Cart parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"response:%@",responseObject);
        globalArray = [responseObject[@"data"]mutableCopy];
        [ProgressHUD dismiss];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",[error localizedDescription]);
        [ProgressHUD showError:@"网络错误"];
    }];
    
    
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
    
//    UIBarButtonItem *item1 =[[UIBarButtonItem alloc]initWithCustomView:searchButton];
//    self.navigationItem.rightBarButtonItem = item1;
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15,0, self.view.frame.size.width-30, self.view.frame.size.height-60) style:UITableViewStylePlain];
    _tableView.backgroundColor = customGrayColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator= NO;
    [_tableView reloadData];
    
    CGRect rect = CGRectZero;
    UIView *footerView = [[UIView alloc]initWithFrame:rect];
    _tableView.tableFooterView = footerView;
    
    [self.view addSubview:_tableView];
    
}



#pragma mark - tableView的代理


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  1;
}

#pragma mark - cell个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [globalArray count];
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


#pragma mark - 创建cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserCartObject *userCart = nil;
    if([globalArray count]){
    
        userCart = [UserCartObject modelWithDictionary:globalArray[indexPath.section] error:nil];
    }
    
    static NSString * cellname = @"cell";
    ShoppingCartTableViewCell *cell = (ShoppingCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellname];
    if (cell == nil) {
        cell = [[ShoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
    }
    cell.labelOfGoodsName.text = userCart.goodsName;
    cell.labelOfShoppName.text = nil;
    
    double marketPrice = userCart.markerPrice;
    cell.labelOfPrice.text = [NSString stringWithFormat:@"价格: %.f元",marketPrice];
    
    double numbers = userCart.goodsNumber;
    cell.labelOfNumber.text = [NSString stringWithFormat:@"数量:%.f",numbers];
    
    //商品图像
    [cell.imageOfGoods sd_setImageWithURL:[NSURL URLWithString:userCart.goodsPicture] placeholderImage:[UIImage imageNamed:@"defaultBackimageSmall"]];
    
    [cell.btnOfSelected addTarget:self action:@selector(didBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = NO;
    return cell;
}

#pragma mark - cell将要显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    UIButton *checkBox = (UIButton *)[cell viewWithTag:5001];
    if([recodeIndexPath containsObject:indexPath]){
    
        [checkBox setBackgroundColor:baseRedColor];
        
    }else{
    
        [checkBox setBackgroundColor:customGrayColor];
    }
}



#pragma mark - 结算按钮触发
- (void)payItButtonClicked{
    
    
}



#pragma mark - 复选框按钮触发
-(void)didBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    //检测点击按钮对应的indexPath
    CGPoint buttonPosition =[sender convertPoint:CGPointZero toView:_tableView];
    NSIndexPath *indexPath =[_tableView indexPathForRowAtPoint:buttonPosition];
    
    if(sender.selected){//被选中

        [recodeIndexPath addObject:indexPath];
        [sender setBackgroundColor:baseRedColor];
    
    }else{//被取消
    
        [recodeIndexPath removeObject:indexPath];
        [sender setBackgroundColor:customGrayColor];
    }
    
    
    
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


#pragma mark - 将要消失
- (void)viewWillDisappear:(BOOL)animated{
    
    [ProgressHUD dismiss];
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
