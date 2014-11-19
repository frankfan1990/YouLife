//
//  WhichWayToGoViewController.m
//  youmi
//
//  Created by frankfan on 14/11/18.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "WhichWayToGoViewController.h"
#import "MapDetailViewController.h"

@interface WhichWayToGoViewController ()<AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)AMapSearchAPI *search;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *busLineProjectArray;//公交路线方案
@end

@implementation WhichWayToGoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    /**
     *  @Author frankfan, 14-11-18 10:11:43
     *
     *  参数初始化区
     */
    
    self.busLineProjectArray =[NSMutableArray array];
    
    //
    /*头部导航按钮*/
    UIImage *busImage =[UIImage imageNamed:@"公交车"];
    UIImage *carImage =[UIImage imageNamed:@"驾车"];
    UIImage *footImage =[UIImage imageNamed:@"步行"];
    
    NSArray *itemArray =@[busImage,carImage,footImage];
    
    UISegmentedControl *sg =[[UISegmentedControl alloc]initWithItems:itemArray];
    sg.frame = CGRectMake(0, 0, 200, 40);
    self.navigationItem.titleView = sg;
    sg.tintColor =baseRedColor;
    sg.backgroundColor = [UIColor clearColor];
    
    /*回退*/
    UIButton *searchButton0 =[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton0.tag = 10006;
    searchButton0.frame = CGRectMake(0, 0, 30, 30);
    [searchButton0 setImage:[UIImage imageNamed:@"朝左箭头icon"] forState:UIControlStateNormal];
    [searchButton0 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftitem =[[UIBarButtonItem alloc]initWithCustomView:searchButton0];
    self.navigationItem.leftBarButtonItem = leftitem;

    
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, 50+64, self.view.bounds.size.width, 1)];
    line1.backgroundColor = customGrayColor;
    [self.view addSubview:line1];
    
    UIView *line2 =[[UIView alloc]initWithFrame:CGRectMake(0, 100+64, self.view.bounds.size.width, 1)];
    line2.backgroundColor = customGrayColor;
    [self.view addSubview:line2];
    
    UILabel *myPositionLabel =[[UILabel alloc]initWithFrame:CGRectMake(45, 64, self.view.bounds.size.width, 49)];
    myPositionLabel.font =[UIFont systemFontOfSize:16];
    myPositionLabel.textColor = baseTextColor;
    [self.view addSubview:myPositionLabel];
    myPositionLabel.text = @"我的位置";
    
    UIView *myPositionCircle =[[UIView alloc]initWithFrame:CGRectMake(10, 64+15, 20, 20)];
    myPositionCircle.layer.cornerRadius = 10;
    myPositionCircle.layer.masksToBounds = YES;
    myPositionCircle.backgroundColor =baseTextColor;
    
    UILabel *originLabel =[[UILabel alloc]initWithFrame:myPositionCircle.bounds];
    originLabel.font =[UIFont systemFontOfSize:12];
    originLabel.textColor =[UIColor whiteColor];
    originLabel.text = @"始";
    originLabel.textAlignment = NSTextAlignmentCenter;
    [myPositionCircle addSubview:originLabel];
    [self.view addSubview:myPositionCircle];
    
    
    //显示目的地
    UILabel *destinationLabel =[[UILabel alloc]initWithFrame:CGRectMake(45, 64+51, self.view.bounds.size.width, 49)];
    destinationLabel.font =[UIFont systemFontOfSize:16];
    destinationLabel.textColor = baseTextColor;
    [self.view addSubview:destinationLabel];
    destinationLabel.text = @"天马小区";

    UIView *myDestination =[[UIView alloc]initWithFrame:CGRectMake(10, 64+51+15, 20, 20)];
    myDestination.layer.cornerRadius = 10;
    myDestination.layer.masksToBounds = YES;
    myDestination.backgroundColor =baseTextColor;
    
    UILabel *static_deatinationLabel =[[UILabel alloc]initWithFrame:myDestination.bounds];
    static_deatinationLabel.font =[UIFont systemFontOfSize:12];
    static_deatinationLabel.textColor =[UIColor whiteColor];
    static_deatinationLabel.text = @"终";
    static_deatinationLabel.textAlignment = NSTextAlignmentCenter;
    [myDestination addSubview:static_deatinationLabel];
    [self.view addSubview:myDestination];

    
    
    /**
     高德地图配置
     */
    self.search =[[AMapSearchAPI alloc]initWithSearchKey:kGaoDeAppKey Delegate:self];
    
    if(self.whichWay==3001){
    
       
        sg.selectedSegmentIndex = 0;
    }
    
    
#pragma mark - 创建tableView
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64+101, self.view.bounds.size.width, self.view.bounds.size.height-49-64-60)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 60;
   
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - cell的创建个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(_whichWay==3001){
    
        return [self.trsnasts_bus count];
    }
    return 0;
}

#pragma mark - cell的创建
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell  =nil;
    static NSString *cellName = @"cell";
    cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //创建分割线
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 59, self.view.bounds.size.width, 1)];
        line.backgroundColor = customGrayColor;
        [cell.contentView addSubview:line];
        
        //红色标示
        UIView *redCircle =[[UIView alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/2.0-15, 20, 20)];
        redCircle.layer.cornerRadius = 10;
        redCircle.layer.masksToBounds = YES;
        redCircle.backgroundColor = baseRedColor;
        
        UILabel *numLabel =[[UILabel alloc]initWithFrame:redCircle.bounds];
        numLabel.tag = 3001;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.adjustsFontSizeToFitWidth = YES;
        numLabel.font =[UIFont systemFontOfSize:14];
        numLabel.textColor =[UIColor whiteColor];
        [redCircle addSubview:numLabel];
        
        [cell.contentView addSubview:redCircle];
        
        
        //公交班线
        UILabel *busProject =[[UILabel alloc]initWithFrame:CGRectMake(35, cell.bounds.size.height/2.0-23, self.view.bounds.size.width-60, 35)];
        busProject.tag = 3002;
        busProject.font =[UIFont systemFontOfSize:14];
        busProject.textColor = baseTextColor;
        busProject.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:busProject];
        
        
        //时间
        UIImageView *timeClock =[[UIImageView alloc]initWithFrame:CGRectMake(35, cell.bounds.size.height/2.0-15+30, 20, 20)];
        timeClock.image =[UIImage imageNamed:@"时间我的预定"];
        [cell.contentView addSubview:timeClock];
        
        UILabel *timeNeed =[[UILabel alloc]initWithFrame:CGRectMake(60, cell.bounds.size.height/2.0-15+23, 80, 35)];
        timeNeed.tag = 3003;
        timeNeed.font =[UIFont systemFontOfSize:14];
        timeNeed.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        timeNeed.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:timeNeed];
        
        //步行米数
        UILabel *stepLabel =[[UILabel alloc]initWithFrame:CGRectMake(125, cell.bounds.size.height/2.0-15+23,self.view.bounds.size.width-50, 35)];
        stepLabel.font =[UIFont systemFontOfSize:14];
        stepLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        stepLabel.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:stepLabel];
        stepLabel.text = @"步行:";
        
        UILabel *stepsNum =[[UILabel alloc]initWithFrame:CGRectMake(165, cell.bounds.size.height/2.0-15+23, 100, 35)];
        stepsNum.tag = 3004;
        stepsNum.font =[UIFont systemFontOfSize:14];
        stepsNum.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        stepsNum.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:stepsNum];

        
    }

    //红色标示数
    UILabel *numLabel = (UILabel *)[cell viewWithTag:3001];
    if(_whichWay==3001){
    
        numLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    }
    
    
    //公交班线
    UILabel *busPreoject = (UILabel *)[cell viewWithTag:3002];
    
    /**
     *  @Author frankfan, 14-11-18 15:11:35
     *
     *  这里去解析相应的bus方案
     */
    AMapTransit *local_transits = self.trsnasts_bus[indexPath.row];
    NSArray *local_segements = local_transits.segments;
    NSMutableArray *array =[NSMutableArray array];
    for (AMapSegment *local_segement in local_segements) {
        
        if([local_segement.busline.departureStop.name length]&&[local_segement.busline.arrivalStop.name length]){
            
            
            [array addObject:[NSString stringWithFormat:@" %@",local_segement.busline.departureStop.name]];
            [array addObject:[NSString stringWithFormat:@"-%@",local_segement.busline.arrivalStop.name]];
        }
        
    }
    NSString *busPathString = [array componentsJoinedByString:@""];
    if(_whichWay==3001){
        
        busPreoject.text = busPathString;
    }
    
    
    //时间
    UILabel *timeNedd = (UILabel *)[cell viewWithTag:3003];
    AMapTransit *local_transit_bus = self.trsnasts_bus[indexPath.row];
    if(_whichWay==3001){
        
        timeNedd.text = [NSString stringWithFormat:@"%ld分钟",local_transit_bus.duration/60];
    }
    
    
    //步行米数
    UILabel *footMeters =(UILabel *)[cell viewWithTag:3004];
    if(_whichWay==3001){
        
        footMeters.text = [NSString stringWithFormat:@"%ldm",(long)local_transit_bus.walkingDistance];
    }
    
    return cell;
}


#pragma mark - cell被点击触发
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MapDetailViewController *mapDetail =[MapDetailViewController new];
    mapDetail.projectNum = indexPath.row+1;
    mapDetail.whichWay = self.whichWay;
    mapDetail.route = self.route;
    mapDetail.startCoordinate = self.startCoordinate;
    mapDetail.destinationCoordinate = self.destinationCoordinate;
    [self.navigationController pushViewController:mapDetail animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - 回退
//回退
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
