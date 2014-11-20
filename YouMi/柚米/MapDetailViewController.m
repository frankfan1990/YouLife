//
//  MapDetailViewController.m
//  youmi
//
//  Created by frankfan on 14/11/18.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MapDetailViewController.h"
#import "LineDashPolyline.h"
#import "CommonUtility.h"

@interface MapDetailViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *polylines;
    
    NSMutableArray *heightArray;//存储cell高度的
   
    
}
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)AMapSearchAPI *search;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *NaviStepsArray;//公交
@property (nonatomic,strong)NSMutableArray *CarStepsArray;//驾车
@property (nonatomic,strong)NSMutableArray *WalkingStepArray;//步行
@end

@implementation MapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    /**
     参数初始化
     */
    
    self.NaviStepsArray =[NSMutableArray array];
    self.CarStepsArray =[NSMutableArray array];
    self.WalkingStepArray =[NSMutableArray array];
    
    heightArray =[NSMutableArray array];
  
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    if(self.whichWay==3001){
    
        title.text = [NSString stringWithFormat:@"公交第%ld方案",(long)self.projectNum];
    }
    
    if(self.whichWay==3002){
    
        title.text = @"驾车最佳方案";
    }
    
    if(self.whichWay==3003){
    
        title.text = @"步行最佳方案";
    }
    
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
    UIView *redLine =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-199, self.view.bounds.size.width, 1)];
    redLine.backgroundColor = baseRedColor;
    [self.view addSubview:redLine];
    
    
    //
    if(self.whichWay==3001){
    
        AMapTransit *transit = self.route.transits[self.projectNum-1];
        NSArray *segements = transit.segments;
        
        for (AMapSegment *segement in segements) {
            
            if([segement.walking.steps count]){
                
                for (AMapStep *step in segement.walking.steps) {
                    
                    [self.NaviStepsArray addObject:step.instruction];
                }
                
            }
            
            if([segement.busline.name length]){
                
                [self.NaviStepsArray addObject:[NSString stringWithFormat:@"%@:%@-%@(共经过%ld站)",segement.busline.name,segement.busline.departureStop.name,segement.busline.arrivalStop.name,(long)segement.busline.busStopsNum]];
                
            }
        }

    }
    
    if(self.whichWay==3002 ||self.whichWay==3003){
    
        NSArray *paths = self.route.paths;
        AMapPath *mapPath = [paths firstObject];
        
        NSArray *steps = mapPath.steps;
        for (AMapStep *step in steps) {
        
            if(self.whichWay==3002){
        
                [self.CarStepsArray addObject:step.instruction];
            }else{
            
                [self.WalkingStepArray addObject:step.instruction];
            }
            
        }
       
    }
    
       
#pragma mark - 创建tableView
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height-198, self.view.bounds.size.width, self.view.bounds.size.height-201-64-49-60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = customGrayColor;
    self.tableView.separatorStyle = NO;
    
       // Do any additional setup after loading the view.
}


#pragma mark - 创建cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.whichWay==3001){
        
        return [self.NaviStepsArray count];
        
    }else if (self.whichWay==3002){
    
        return [self.CarStepsArray count];
        
    }else{
    
        return  [self.WalkingStepArray count];
    }
    
    return 0;
    
}

#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.whichWay==3001){
    
        if(![self.NaviStepsArray[indexPath.row] length]){
            
            return 10;
        }else{
            
            CGFloat height = [self caculateTheTextHeight:self.NaviStepsArray[indexPath.row] andFontSize:14]+35;
            [heightArray addObject:[NSNumber numberWithFloat:height]];
            return [self caculateTheTextHeight:self.NaviStepsArray[indexPath.row] andFontSize:14]+35;
        }

    }
    
    if(self.whichWay==3002){
        
        if(![self.CarStepsArray[indexPath.row] length]){
            return 10;
        }else{
        
            CGFloat height = [self caculateTheTextHeight:self.CarStepsArray[indexPath.row] andFontSize:14]+35;
            [heightArray addObject:[NSNumber numberWithFloat:height]];
            return [self caculateTheTextHeight:self.CarStepsArray[indexPath.row] andFontSize:14]+35;
        }
    
    }
    
    if(self.whichWay==3003){
        
        if(![self.WalkingStepArray[indexPath.row] length]){
            
            return 10;
        }else{
            
            CGFloat height = [self caculateTheTextHeight:self.WalkingStepArray[indexPath.row] andFontSize:14]+35;
            [heightArray addObject:[NSNumber numberWithFloat:height]];
            return [self caculateTheTextHeight:self.WalkingStepArray[indexPath.row] andFontSize:14]+35;
        }
    
    }
   
    
    return 0;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = nil;
    static NSString *cellName = @"cell";
    cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.backgroundColor = customGrayColor;
        cell.selectionStyle = NO;
        
        //label
        UILabel *infoLabel =nil;
        if(self.whichWay==3001){

            infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, self.view.bounds.size.width-100, [heightArray[indexPath.row]floatValue]-10)];
            
        }
        
        if(self.whichWay==3002){
        
            infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, self.view.bounds.size.width-100, [self caculateTheTextHeight:self.CarStepsArray[indexPath.row] andFontSize:14]+25)];
            
        }
        
        if(self.whichWay==3003){
        
            infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, self.view.bounds.size.width-100, [self caculateTheTextHeight:self.WalkingStepArray[indexPath.row] andFontSize:14]+25)];

            
        }
        
        infoLabel.tag = 4001;
        infoLabel.font =[UIFont systemFontOfSize:14];
        infoLabel.textColor = baseTextColor;
        infoLabel.backgroundColor = [UIColor whiteColor];
        infoLabel.layer.cornerRadius = 5;
        infoLabel.layer.masksToBounds = YES;
        infoLabel.numberOfLines = 0;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.contentView addSubview:infoLabel];
        
        UIImageView *arrowImageView =[[UIImageView alloc]initWithFrame:CGRectMake(56, 0, 14, 10)];
        arrowImageView.center = CGPointMake(58, (infoLabel.bounds.size.height+10)/2.0);
        [cell.contentView addSubview:arrowImageView];
        arrowImageView.image = [UIImage imageNamed:@"白色箭头"];
   
        //redDot&line
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(30, 0, 2, infoLabel.bounds.size.height+10)];
        line.tag = 9001;
        line.backgroundColor =[UIColor whiteColor];
        [cell.contentView addSubview:line];
        
        UIView *redDot =[[UIView alloc]initWithFrame:CGRectMake(20, cell.bounds.size.height/2.0-10+5, 20, 20)];
        redDot.tag = 9002;
        redDot.center = CGPointMake(30, (infoLabel.bounds.size.height+10)/2.0);
        redDot.backgroundColor = baseRedColor;
        redDot.layer.borderWidth = 5;
        redDot.layer.cornerRadius = 10;
        redDot.layer.borderColor = [UIColor whiteColor].CGColor;
        [cell.contentView addSubview:redDot];
        
    }
    
    UILabel *infoLabel = nil;
    UIView *line = nil;
    
    if(self.whichWay==3001){
    
        infoLabel =(UILabel *)[cell viewWithTag:4001];
        infoLabel.frame = CGRectMake(60, 5, self.view.bounds.size.width-100, [heightArray[indexPath.row]floatValue]-10);
        infoLabel.text = self.NaviStepsArray[indexPath.row];
        
        line = (UIView *)[cell viewWithTag:9001];
        line.frame = CGRectMake(30, 0, 2, [heightArray[indexPath.row]floatValue]+10);
        
    }
    
    if(self.whichWay==3002){
        
        infoLabel =(UILabel *)[cell viewWithTag:4001];
        infoLabel.frame = CGRectMake(60, 5, self.view.bounds.size.width-100, [heightArray[indexPath.row]floatValue]-10);
        infoLabel.text = self.CarStepsArray[indexPath.row];
        
        line = (UIView *)[cell viewWithTag:9001];
        line.frame = CGRectMake(30, 0, 2, [heightArray[indexPath.row]floatValue]+10);
        
        infoLabel.text = self.CarStepsArray[indexPath.row];
    }
    
    if(self.whichWay==3003){
    
        infoLabel =(UILabel *)[cell viewWithTag:4001];
        infoLabel.frame = CGRectMake(60, 5, self.view.bounds.size.width-100, [heightArray[indexPath.row]floatValue]-10);
        infoLabel.text = self.WalkingStepArray[indexPath.row];
        
        line = (UIView *)[cell viewWithTag:9001];
        line.frame = CGRectMake(30, 0, 2, [heightArray[indexPath.row]floatValue]+10);

        infoLabel.text = self.WalkingStepArray[indexPath.row];
    }
 
    return cell;

}





#pragma mark - 初始化地图
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.mapView =[[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-200)];
    
    self.mapView.showsScale = YES;
    self.mapView.delegate = self;
    
    //让视图缩放适配
    MACoordinateSpan span ={0.11, 0.17};
    CLLocationCoordinate2D reginLocation = CLLocationCoordinate2DMake((self.startCoordinate.latitude+self.destinationCoordinate.latitude)/2.0, (self.startCoordinate.longitude+self.destinationCoordinate.longitude)/2.0);
    MACoordinateRegion region={reginLocation,span};
    [self.mapView setRegion:region];
    self.mapView.centerCoordinate = reginLocation;

    
    [self.view addSubview:self.mapView];
    [self presentCurrentCourse];
    [self addDefaultAnnotations];
}



/*初始化标注*/
- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = @"起点";
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = @"终点";
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}



/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    polylines = nil;
    
    /* 公交导航. */
    if (self.whichWay==3001)
    {
        polylines = [CommonUtility polylinesForTransit:self.route.transits[self.projectNum-1]];
    }
    /* 步行，驾车导航. */
    else
    {
        polylines = [CommonUtility polylinesForPath:self.route.paths[self.projectNum-1]];
    }
    
    [self.mapView addOverlays:polylines];
    
    /* 缩放地图使其适应polylines的展示. 被高德这句代码坑了！*/
//    self.mapView.visibleMapRect = [CommonUtility mapRectForOverlays:polylines];
    
   
}



- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:navigationCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        /* 起点. */
        if ([[annotation title] isEqualToString:@"起点"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
      
        }
        /* 终点. */
        else if([[annotation title] isEqualToString:@"终点"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{

    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        polylineRenderer.lineDashPattern = @[@5, @10];
        
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        polylineRenderer.strokeColor =baseRedColor;
        
        return polylineRenderer;
    }
    
    return nil;



}


#pragma mark - 动态计算文字高度
- (CGFloat)caculateTheTextHeight:(NSString *)string andFontSize:(int)fontSize{
    
    /*非彻底性封装,这里给定固定的宽度*/
    CGSize constraint = CGSizeMake(self.view.bounds.size.width-110, CGFLOAT_MAX);
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:string
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    
    return size.height;
}




#pragma mark - 回退
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
