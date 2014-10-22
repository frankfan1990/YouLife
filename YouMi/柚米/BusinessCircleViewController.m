//
//  BusinessCircleViewController.m
//  youmi
//
//  Created by frankfan on 14-9-11.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "BusinessCircleViewController.h"
#import "BusinessCircleTableViewCell.h"
#import "THLabel/THLabel.h"

@interface BusinessCircleViewController ()

#warning 假数据源
@property (nonatomic,strong)NSDictionary *dict1;
@property (nonatomic,strong)NSMutableArray *oupPutData;
@end

@implementation BusinessCircleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    /**/
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"全部商圈";
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

    
    /*创建staticHeaderView*/
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, 123, 55)];
    headerView.backgroundColor =[UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:headerView];
    
    UILabel *all_business =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 123, 55)];
    all_business.textAlignment = NSTextAlignmentCenter;
    all_business.text = @"全部商圈";
    all_business.font = [UIFont systemFontOfSize:14];
    all_business.textColor = baseTextColor;
    [headerView addSubview:all_business];
    
    
    /*创建flexHeaderView*/
    UIView *flex_headerView =[[UIView alloc]initWithFrame:CGRectMake(123, 64, self.view.bounds.size.width-123, 55)];
    flex_headerView.backgroundColor =[UIColor colorWithWhite:0.89 alpha:1];
    [self.view addSubview:flex_headerView];
    
    UILabel *all_flexBusiness =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-123, 55)];
    all_flexBusiness.textAlignment = NSTextAlignmentCenter;
    all_flexBusiness.text = @"全部商圈";
    all_flexBusiness.font =[UIFont systemFontOfSize:14];
    all_flexBusiness.textColor = baseTextColor;
    [flex_headerView addSubview:all_flexBusiness];
    
    
    
#pragma mark 创建static_tableView
    
    self.static_tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 55+64, 123, self.view.bounds.size.height-49*2-50) style:UITableViewStylePlain];
    self.static_tableView.backgroundColor =[UIColor colorWithWhite:0.95 alpha:1];
    self.static_tableView.tag = 3001;
    self.static_tableView.rowHeight = 50;
    self.static_tableView.separatorStyle = NO;
    self.static_tableView.delegate = self;
    self.static_tableView.dataSource = self;
    [self.view addSubview:self.static_tableView];
    
    
#pragma mark 创建商圈数组
    self.BusinessCirArray = [NSMutableArray array];
    /*fake data*/
    self.BusinessCirArray =[NSMutableArray arrayWithObjects:@"芙蓉区",@"开福区",@"雨花区",@"天心区",@"岳麓区", nil];
    
    
#pragma mark 创建flex_tableView
    
    self.flex_tableView =[[UITableView alloc]initWithFrame:CGRectMake(123, 55+64, self.view.bounds.size.width-123, self.view.bounds.size.height-49*2-80) style:UITableViewStylePlain];
    self.flex_tableView.tag = 3002;
    self.flex_tableView.delegate = self;
    self.flex_tableView.dataSource = self;
    [self.view addSubview:self.flex_tableView];
    
    
#warning 模拟从后台获取的数据
    /*开始构造假数据，模拟从后台获取的数据*/
    self.dict1 =@{@"A":@[@"阿波罗广场",@"奥特莱斯广场"],@"W":@[@"王婆臭豆腐",@"万家惠",@"吴家林"],@"B":@[@"百盛商圈",@"博富国际",@"百乐门"],@"C":@[@"超级卖场",@"策划商业街"],@"D":@[@"大碗厨",@"大上海",@"大海门"],@"F":@[@"飞鸟店铺",@"粉饼店"]};
    ///**///
    
    /*创建最终输出的商圈数据*/
    self.oupPutData =[NSMutableArray array];
    
    NSArray *OrderAllkeys =[[self.dict1 allKeys]sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch]==NSOrderedDescending;
    }];
    for (NSString *keys in OrderAllkeys) {
        
        NSArray *tempData = [self.dict1 objectForKey:keys];
        [self.oupPutData addObject:tempData];
        
    }
    
    
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark section的个数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(tableView.tag==3002){
    
        return [[self.dict1 allKeys]count];
    }else{
    
    
        return 1;
    }


}


#pragma mark cell的个数 faka data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(tableView.tag==3001){
    
        return [self.BusinessCirArray count];/*fake data*/

    }else{
    
        /*fake data*/
        NSArray *temp_array = self.oupPutData[section];
        return [temp_array count];/*fake data*/
    }

}


#pragma mark 创建cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BusinessCircleTableViewCell *businiessCell = nil;
    static NSString *cellName = @"cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
    
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    if(tableView.tag==3001){
        
        cell.backgroundColor =[UIColor colorWithWhite:0.9 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        UIView *selectView =[[UIView alloc]init];
        selectView.backgroundColor =[UIColor whiteColor];
        cell.selectedBackgroundView = selectView;
        
        /*bind data*/
        cell.textLabel.text = self.BusinessCirArray[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font =[UIFont systemFontOfSize:14];
        cell.textLabel.textColor = baseTextColor;
        return cell;
        
    }else{
        
        businiessCell = [BusinessCircleTableViewCell cellWithTableView:tableView];
        NSArray *temp_array = self.oupPutData[indexPath.section];
        
        businiessCell.BusiniessCircleName.text = temp_array[indexPath.row];
        
        return businiessCell;
    
    }
    
    

    

}

#pragma mark headerView的创建生成

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-123, 40)];
    backgroundView.backgroundColor =[UIColor whiteColor];
    
    /*红色的条带*/
    UIView *redView =[[UIView alloc]initWithFrame:CGRectMake(0, 12, self.view.bounds.size.width-123, 8)];
    redView.backgroundColor = baseRedColor;
    [backgroundView addSubview:redView];
    
    /*文字描边*/
    THLabel *thLabel =[[THLabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    thLabel.strokeSize = 2;
    thLabel.strokeColor =[UIColor whiteColor];
    thLabel.textColor = baseRedColor;
    thLabel.font =[UIFont systemFontOfSize:14];
    
    
    /*fake data 此处self.dict1为某个商圈下得详情数据，从接口处获取*/
    NSArray *tempAlpha = [self.dict1 allKeys];
    NSMutableArray *temp_array = [tempAlpha mutableCopy];
    /*字母排序*/
    [temp_array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch]==NSOrderedDescending;
    }];
    
    thLabel.text = temp_array[section];
    [backgroundView addSubview:thLabel];
    
    return backgroundView;
}




#pragma mark tableView头部高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if(tableView.tag==3002){
    
        return 20;
    }
    
    return 0;

}








#pragma mark 回退
- (void)navi_buttonClicked:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
