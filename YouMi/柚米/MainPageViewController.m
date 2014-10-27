//
//  MainPageViewController.m
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//waring: POP必须局部生成对象，全局对象仅执行一次
//首页

#import "MainPageViewController.h"
#import "MainPageCustomTableViewCell.h"
#import "DataAboutTitle.h"
#import "CCSegmentedControl.h"
#import "POP.h"
#import "MJRefresh.h"
#import "LuggageBagsTableViewCell.h"
#import "MainPage_subViewControllers.h"/*公共子页面*/

#import "PdownMenuViewController.h"
#import <TMCache.h>
#import "CityListSelectViewController.h"

@interface MainPageViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{

    UIButton *four_Button1;
    UIButton *four_Button2;
    UIButton *four_Button3;
    UIButton *four_Button4;
    
    UIButton *leftbarButton;
    
    CCSegmentedControl *ccsegementCV;

}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)DataAboutTitle *titles;
@property (nonatomic,strong)NSString *titleString;//leftBarButtonItem上显示的城市名
@property (nonatomic,strong)NSArray *images1;//首页按钮的图片

@end

static NSInteger myCollectionCurrentIndex;/*我的收藏，当前所选索引*/

@implementation MainPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.navigationController.navigationBar.backgroundColor =[UIColor whiteColor];
    /*我的收藏，初始化索引值*/
    myCollectionCurrentIndex = 0;
    //
    
    
    /**
     *  @Author frankfan, 14-10-27 17:10:41
     *
     *  以下代码为遗留代码【不可用】
     */
    
    
//    /*动态根据文字长度调整对齐*/
//    leftbarButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    leftbarButton.tag = 1001;
//    leftbarButton.frame = CGRectMake(0, 0, 123, 30);
//    /*动态获取文字长度*/
//    UIFont *tempFont =[UIFont systemFontOfSize:18];
//    NSDictionary *userAttr = @{NSFontAttributeName:tempFont};
//    CGSize cityTextSize = [self.titleString sizeWithAttributes:userAttr];
//    /*动态设置icon位置*/
//    UIImageView *arrowIcon =[[UIImageView alloc]initWithFrame:CGRectMake(cityTextSize.width-14, 2, 25, 25)];
//    arrowIcon.image =[UIImage imageNamed:@"箭头icon.png"];
//    [leftbarButton addSubview:arrowIcon];
//    
//    [leftbarButton setTitle:_titleString forState:UIControlStateNormal];
//    if([_titleString length]==2){
//        
//        
//        leftbarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -115, 0, -10);
//    }if([_titleString length]==3){
//    
//        leftbarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -100, 0, -10);
//    }if([_titleString length]==4){
//    
//        leftbarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -85, 0, -10);
//    }if([_titleString length]==5){
//    
//        leftbarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -65, 0, -10);
//    }
//    
//    [leftbarButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [leftbarButton setTitleColor:baseTextColor forState:UIControlStateHighlighted];
//    [leftbarButton addTarget:self action:@selector(barButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    leftbarButton.titleLabel.font = [UIFont systemFontOfSize:18];
//    UIBarButtonItem *barButton =[[UIBarButtonItem alloc]initWithCustomView:leftbarButton];
//    self.navigationItem.leftBarButtonItem = barButton;
    
    
    //
    UIButton *rightButton1 =[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton1.tag = 1002;
    rightButton1.frame = CGRectMake(230, 0, 30, 30);
    [rightButton1 setImage:[UIImage imageNamed:@"搜索icon"] forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(barButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBaritem1 =[[UIBarButtonItem alloc]initWithCustomView:rightButton1];
    
    UIButton *rightButton2 =[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton2.tag = 1003;
    rightButton2.frame = CGRectMake(300, 0, 30, 30);
    [rightButton2 setImage:[UIImage imageNamed:@"消息icon"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(barButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightBaritem2 =[[UIBarButtonItem alloc]initWithCustomView:rightButton2];
    NSArray *barButtonItems =@[rightBaritem2,rightBaritem1];
    self.navigationItem.rightBarButtonItems = barButtonItems;
    
   
    //
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *tableviewFooter =[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = tableviewFooter;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    ///*遮挡条*/
    UIView *maskView1 =[[UIView alloc]initWithFrame:CGRectMake(0, 1300, 10, 250)];
    maskView1.backgroundColor = customGrayColor;
    [self.tableView addSubview:maskView1];
    
    UIView *maskView2 =[[UIView alloc]initWithFrame:CGRectMake(310, 1300, 10, 250)];
    maskView2.backgroundColor = customGrayColor;
    [self.tableView addSubview:maskView2];

    
#pragma mark collectionView的创建
    //
    /*tableviewcell indexRow==0处添加的collectionView*/
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(60, 60);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing  = 10;
    
    self.collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(14, 6, self.view.bounds.size.width-20, 160) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collection_cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor =[UIColor clearColor];
    
    //硬编码，首页圆形按钮标题
    self.titles =[DataAboutTitle shareWithInstance];
    //////////////////////////////////////////////
    
    //
    four_Button1 =[UIButton buttonWithType:UIButtonTypeCustom];
    four_Button1.tag = 101;
    [four_Button1 setImage:[UIImage imageNamed:@"附近"] forState:UIControlStateNormal];
    four_Button1.frame = CGRectMake(7, 10, 137, 36.5);
    four_Button1.layer.cornerRadius = 3;//fake data
    [four_Button1 addTarget:self action:@selector(four_buttonsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMake(107, 4, 40, 30)];
    label1.text = @"附近";
    label1.font =[UIFont fontWithName:@"Avenir-Book" size:12];
    label1.textColor = baseTextColor;
    [four_Button1 addSubview:label1];
    
    //
    four_Button2 =[UIButton buttonWithType:UIButtonTypeCustom];
    four_Button2.tag = 102;
    [four_Button2 setImage:[UIImage imageNamed:@"51路"] forState:UIControlStateNormal];
    four_Button2.frame = CGRectMake(158, 10, 137, 36.5);
    four_Button2.layer.cornerRadius = 3;//fake data
    [four_Button2 addTarget:self action:@selector(four_buttonsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label2 =[[UILabel alloc]initWithFrame:CGRectMake(92, 5, 70, 30)];
    label2.text = @"五一路";
    label2.font =[UIFont fontWithName:@"Avenir-Book" size:12];
    label2.textColor = baseTextColor;
    [four_Button2 addSubview:label2];

    //
    four_Button3 =[UIButton buttonWithType:UIButtonTypeCustom];
    four_Button3.tag = 103;
    four_Button3.frame = CGRectMake(7, 60, 137, 36.5);
    [four_Button3 setImage:[UIImage imageNamed:@"火车站"] forState:UIControlStateNormal];
    four_Button3.layer.cornerRadius = 3;//fake data
    [four_Button3 addTarget:self action:@selector(four_buttonsClicked:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *label3 =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 30)];
    label3.text = @"火车站";
    label3.font =[UIFont fontWithName:@"Avenir-Book" size:12];
    label3.textColor = baseTextColor;
    [four_Button3 addSubview:label3];

    //
    four_Button4 =[UIButton buttonWithType:UIButtonTypeCustom];
    four_Button4.tag = 104;
    four_Button4.frame = CGRectMake(158, 60, 137, 36.5);
    four_Button4.layer.cornerRadius = 3;//fake data
    [four_Button4 setImage:[UIImage imageNamed:@"商圈"] forState:UIControlStateNormal];
    [four_Button4 addTarget:self action:@selector(four_buttonsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label4 =[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 70, 30)];
    label4.text = @"全部商圈";
    label4.font =[UIFont fontWithName:@"Avenir-Book" size:12];
    label4.textColor = baseTextColor;
    [four_Button4 addSubview:label4];

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ccsegementCV =[[CCSegmentedControl alloc]initWithItems:@[@"KTV",@"小吃",@"西餐",@"箱包"]];
    ccsegementCV.frame = CGRectMake(145, -8, 180, 50);
    UIView *stainView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 33, 50)];
    stainView.backgroundColor = baseRedColor;
    ccsegementCV.selectedStainView = stainView;
    ccsegementCV.backgroundColor =[UIColor clearColor];
    ccsegementCV.selectedSegmentTextColor = [UIColor whiteColor];
    [ccsegementCV addTarget:self action:@selector(ccsegementSelect:) forControlEvents:UIControlEventValueChanged];
    
    /*首页按钮图片名字数组*/
    self.images1 = @[@"美食.png",@"娱乐.png",@"教育.png",@"社区.png",@"健身.png",@"医疗.png",@"美容.png",@"酒店.png"];

#pragma mark 添加下拉刷新
    
    [self.tableView addHeaderWithTarget:self action:@selector(pullDownCallBack)];
    
    
    
    
#pragma mark 模拟数据-从后台拉去“三大类”数据
    /*模拟数据*/
    NSArray *businessCircleList = @[@{@"附近":@[@"100m",@"500m",@"1000m",@"1500m"]},@{@"芙蓉区":@[@"五一路",@"火宫殿",@"下河街",@"步行街"]},@{@"雨花区":@[@"东塘",@"西塘",@"南塘",@"北塘",@"中塘"]},@{@"岳麓区":@[@"麓山东路",@"麓山南路",@"麓山西路",@"麓山北路",@"麓山中路"]},@{@"开福区":@[@"天马小区",@"大学城",@"麓山北路",@"麓谷",@"大学北路"]}];
    
    /*设置缓存*/
    [[TMCache sharedCache]setObject:businessCircleList forKey:kThreePartData_0];

    
    // Do any additional setup after loading the view.
}




/**
 *  @Author frankfan, 14-10-27 17:10:17
 *
 *  这里的代码极度丑陋
 *
 *  @param animated 无意义
 */
- (void)viewWillAppear:(BOOL)animated{

    
    self.titleString = [[NSUserDefaults standardUserDefaults]objectForKey:kUserCity];

    if(![self.titleString length]){
        
        return;
    }
    
    /*动态根据文字长度调整对齐*/
    leftbarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    leftbarButton.tag = 1001;
    leftbarButton.frame = CGRectMake(0, 0, 123, 30);

    /*动态获取文字长度*/
    UIFont *tempFont =[UIFont systemFontOfSize:18];
    NSDictionary *userAttr = @{NSFontAttributeName:tempFont};
    CGSize cityTextSize = [self.titleString sizeWithAttributes:userAttr];
    /*动态设置icon位置*/
    UIImageView *arrowIcon =[[UIImageView alloc]initWithFrame:CGRectMake(cityTextSize.width-14, 2, 25, 25)];
    arrowIcon.image =[UIImage imageNamed:@"箭头icon.png"];
    [leftbarButton addSubview:arrowIcon];
    
    [leftbarButton setTitle:_titleString forState:UIControlStateNormal];
    if([_titleString length]==2){
        
        
        leftbarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -115, 0, -10);
    }if([_titleString length]==3){
        
        leftbarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -100, 0, -10);
    }if([_titleString length]==4){
        
        leftbarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -85, 0, -10);
    }if([_titleString length]==5){
        
        leftbarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -65, 0, -10);
    }
    
    [leftbarButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftbarButton setTitleColor:baseTextColor forState:UIControlStateHighlighted];
    [leftbarButton addTarget:self action:@selector(barButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftbarButton.titleLabel.font = [UIFont systemFontOfSize:18];
    UIBarButtonItem *barButton =[[UIBarButtonItem alloc]initWithCustomView:leftbarButton];
    self.navigationItem.leftBarButtonItem = barButton;

}



#pragma mark //KTY/小吃/西餐/箱包的事件触发
- (void)ccsegementSelect:(CCSegmentedControl *)sender{
    
    CCSegmentedControl *ccsegment = sender;
    myCollectionCurrentIndex = ccsegment.selectedSegmentIndex;
    [self.tableView reloadData];
    NSLog(@"ccsegements_index:%ld",(long)myCollectionCurrentIndex);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 90+3;//10是代表dataArray数中据的个数，3代表首页的固定三个位置

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainPageCustomTableViewCell *cell = nil;
    LuggageBagsTableViewCell *cell1 =nil;
    
    if(indexPath.row==0){
    
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor =[UIColor whiteColor];
        cell.selectionStyle = NO;
        
        /*添加阴影*/
        [cell.contentView addSubview:self.collectionView];
        cell.layer.shadowColor =[UIColor colorWithWhite:0.2 alpha:0.8].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.1, 0.89);
        cell.layer.shadowRadius = 0.3;
        cell.layer.shadowOpacity = 0.12;
        
        return cell;
        
    }if (indexPath.row==1) {
        
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = customGrayColor;
        cell.selectionStyle = NO;
        //
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 105)];
        view.backgroundColor =[UIColor whiteColor];
        view.layer.cornerRadius = 5.0f;
        view.layer.shadowColor =[UIColor colorWithWhite:0.4 alpha:0.8].CGColor;
        view.layer.shadowOffset = CGSizeMake(0.1, 0.89);
        view.layer.shadowRadius = 0.5;
        view.layer.shadowOpacity = 0.25;
        
        [view addSubview:four_Button1];
        [view addSubview:four_Button2];
        [view addSubview:four_Button3];
        [view addSubview:four_Button4];
        [cell.contentView addSubview:view];
        
        return cell;
    }if (indexPath.row==2) {
        
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor =[UIColor whiteColor];
        cell.selectionStyle = NO;
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 89, 30)];
        label.text = @"我的收藏";
        label.textColor =baseTextColor;
        label.font =[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:ccsegementCV];
        
        cell.layer.shadowColor =[UIColor colorWithWhite:0.1 alpha:0.85].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.1, 0.89);
        cell.layer.shadowRadius = 0.36;
        cell.layer.shadowOpacity = 0.16;
        
        return cell;

    }else{
        
        if(myCollectionCurrentIndex==3){
        
            cell1 = [LuggageBagsTableViewCell cellWithTableView:tableView];
            cell1.backgroundColor = customGrayColor;
            cell1.selectionStyle = NO;
        }else{
        
            cell = [MainPageCustomTableViewCell cellWithTableView:tableView];
            cell.backgroundColor = customGrayColor;
            cell.selectionStyle = NO;
        }
        
        
    }
    
    if(myCollectionCurrentIndex==3){
    
        return cell1;
    }else{
    
        return cell;
    
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==0){
    
        return 150;
    }else if (indexPath.row==1){
    
        return 125;
    }else if (indexPath.row==2){
    
        return 33;
    }else{
    
    
        return commomCellHeight;
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    return 8;
}

#pragma mark 8个按钮的生成
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    UICollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_cell" forIndexPath:indexPath];
    cell.backgroundColor =[UIColor clearColor];
    cell.layer.cornerRadius = 20;
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [cell.contentView addSubview:imageView];
    imageView.layer.cornerRadius = 25;
    imageView.layer.masksToBounds = YES;
    imageView.image = [UIImage imageNamed:self.images1[indexPath.row]];
    
    //
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(3, 50, 60, 20)];
    label.text = self.titles.titles[indexPath.row];
    label.font = [UIFont systemFontOfSize:11];
    [cell.contentView addSubview:label];
    label.textColor = [UIColor grayColor];
    
    return cell;

}

#pragma mark 8个按钮的方法触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==0){
        
        FoodDetailViewController *foodDetailViewCV =[[FoodDetailViewController alloc]init];
        foodDetailViewCV.index = indexPath.row;
        [self.navigationController pushViewController:foodDetailViewCV animated:YES];
    }else if (indexPath.row==1){
    
        EntertainmentDetailViewController *entertainmentDetailCV =[[EntertainmentDetailViewController alloc]init];
        entertainmentDetailCV.index = indexPath.row;
        [self.navigationController pushViewController:entertainmentDetailCV animated:YES];
    }else if (indexPath.row==2){
    
        EducationViewController *educationController =[[EducationViewController alloc]init];
        [self.navigationController pushViewController:educationController animated:YES];
    }else if (indexPath.row==5){
    
        MedicalViewController *medicalViewController =[[MedicalViewController alloc]init];
        medicalViewController.index = indexPath.row;
        [self.navigationController pushViewController:medicalViewController animated:YES];
    }else if (indexPath.row==3){
    
        CConvenienceViewController *cconvenceView =[[CConvenienceViewController alloc]init];
        [self.navigationController pushViewController:cconvenceView animated:YES];
        
    }
    


}


#pragma mark //附近/五一路/火车站/全部商圈的事件触发
- (void)four_buttonsClicked:(UIButton *)sender{

    /*View layer*/
    POPSpringAnimation *springAnimtion =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimtion.springSpeed = 20.0;
    springAnimtion.springBounciness = 20.0;
    springAnimtion.velocity = @200;
    sender.userInteractionEnabled = NO;
    [springAnimtion setCompletionBlock:^(POPAnimation *springAnimtion, BOOL finished) {
        
        sender.userInteractionEnabled = YES;
        
    }];
    if(sender.tag==101){
    
        BusinessCircleViewController *business =[[BusinessCircleViewController alloc]init];
        [self.navigationController pushViewController:business animated:YES];
        
        [four_Button1.layer pop_addAnimation:springAnimtion forKey:@"springAnimation1"];
    }else if (sender.tag==102){
    
        BusinessCircleViewController *business =[[BusinessCircleViewController alloc]init];
        [self.navigationController pushViewController:business animated:YES];

        [four_Button2.layer pop_addAnimation:springAnimtion forKey:@"springAnimation2"];

    }else if (sender.tag==103){
    
        BusinessCircleViewController *business =[[BusinessCircleViewController alloc]init];
        [self.navigationController pushViewController:business animated:YES];

        [four_Button3.layer pop_addAnimation:springAnimtion forKey:@"springAnimation3"];

    }else if (sender.tag==104){
        
        BusinessCircleViewController *business =[[BusinessCircleViewController alloc]init];
        [self.navigationController pushViewController:business animated:YES];

        [four_Button4.layer pop_addAnimation:springAnimtion forKey:@"springAnimation4"];
    }
    
    /**/
    
    
}



#pragma mark 下拉刷新的回调方法
/*这个方法目前的实现是fake func 只是用来模拟网络请求的等待以及请求结束后的回调效果*/
- (void)pullDownCallBack{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView headerEndRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self theButtonShake1];
            [self theButtonShake2];
            [self theButtonShake3];
            [self theButtonShake4];
        });
    });

}

#pragma mark 下拉刷新回调方法次级回调方法【上下抖】
- (void)theButtonShake1{

    POPSpringAnimation *springAnimtion =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimtion.springSpeed = 16.0f;
    springAnimtion.springBounciness = 17.0;
    springAnimtion.velocity = @200;
    [four_Button1.layer pop_addAnimation:springAnimtion forKey:@"springAnimtion1"];
}

- (void)theButtonShake2{
    
    POPSpringAnimation *springAnimtion =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimtion.springSpeed = 16.0f;
    springAnimtion.springBounciness = 17.0;
    springAnimtion.velocity = @200;
    [four_Button2.layer pop_addAnimation:springAnimtion forKey:@"springAnimtion2"];
}

- (void)theButtonShake3{
    
    POPSpringAnimation *springAnimtion =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimtion.springSpeed = 16.0f;
    springAnimtion.springBounciness = 17.0;
    springAnimtion.velocity = @200;
    [four_Button3.layer pop_addAnimation:springAnimtion forKey:@"springAnimtion3"];
}

- (void)theButtonShake4{
    
    POPSpringAnimation *springAnimtion =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimtion.springSpeed = 16.0f;
    springAnimtion.springBounciness = 17.0;
    springAnimtion.velocity = @200;
    [four_Button4.layer pop_addAnimation:springAnimtion forKey:@"springAnimtion4"];
}


#pragma mark 首页导航栏按钮的触发方法
- (void)barButtonClicked:(UIButton *)sender{
    
    if(sender.tag==1001){
    
        CityListSelectViewController *cityListSelecter =[CityListSelectViewController new];
        [self.navigationController pushViewController:cityListSelecter animated:YES];
    
    
    }else if (sender.tag==1002){
    
        NSLog(@"1002");
    }else{
    
        NSLog(@"1003");
    }



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
