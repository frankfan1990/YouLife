//
//  PdownMenuViewController.m
//  youmi
//
//  Created by frankfan on 14-9-29.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "PdownMenuViewController.h"
#import <TMCache.h>

@interface PdownMenuViewController ()
{

    /*fake data 模拟缓存的后台数据类型*/
    NSArray *cacheDataRead_0;
    
    NSMutableArray *businessCircleName;
    NSMutableArray *businessCircleDetail;
    
    /*标志点击的模块*/
    NSUInteger whichModel,whichButton;
    
    NSInteger whickRow;//三大模块的第一个模块，选择的右侧菜单的哪一行，默认是第一行，值为0

}

@property (nonatomic,strong)UIView *touchView;

/*data source*/
@property (nonatomic,strong)NSMutableArray *_0_left_dataSource;
@property (nonatomic,strong)NSMutableArray *_0_right_dataSource;

@property (nonatomic,strong)NSMutableArray *_left_outPutSource;
@property (nonatomic,strong)NSMutableArray *_right_outPutSource;
@end

@implementation PdownMenuViewController

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
    self.view.backgroundColor =[UIColor clearColor];
    
    whickRow = 0;
    
    self.touchView =[[UIView alloc]initWithFrame:CGRectMake(0, 114, self.view.bounds.size.width, self.view.bounds.size.height-50)];
    self.touchView.backgroundColor =[UIColor colorWithWhite:0.1 alpha:0.5];
    [self.view addSubview:self.touchView];
    
    
    /**/

#pragma mark 创建theLoadView
    self.theLoadView =[[UIView alloc]initWithFrame:CGRectMake(0, -156, self.view.bounds.size.width, 300)];
    [self.view addSubview:self.theLoadView];
    
    
    /*创建tableView*/
    if(self.selectedTag==1001||self.selectedTag==1002){
    
        self.tableView_left =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 130, self.theLoadView.frame.size.height) style:UITableViewStylePlain];
        self.tableView_left.showsVerticalScrollIndicator = NO;
        self.tableView_left.tag = 10010;
        self.tableView_left.delegate = self;
        self.tableView_left.dataSource = self;
        self.tableView_left.separatorStyle = NO;
        [self.theLoadView addSubview:self.tableView_left];
        
        self.tableView_right =[[UITableView alloc]initWithFrame:CGRectMake(130, 0, self.view.bounds.size.width-130, self.theLoadView.frame.size.height) style:UITableViewStylePlain];
        self.tableView_right.showsVerticalScrollIndicator = NO;
        self.tableView_right.tag = 10011;
        self.tableView_right.delegate = self;
        self.tableView_right.dataSource = self;
        [self.theLoadView addSubview:self.tableView_right];
        
        CGRect rect = CGRectZero;
        UIView *footView =[[UIView alloc]initWithFrame:rect];
        self.tableView_right.tableFooterView = footView;
    
    

    }
    else{
    
        self.tableView_single =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.theLoadView.frame.size.height) style:UITableViewStylePlain];
        self.tableView_single.showsVerticalScrollIndicator = NO;
        self.tableView_single.tag = 10012;
        self.tableView_single.delegate = self;
        self.tableView_single.dataSource = self;
        [self.theLoadView addSubview:self.tableView_single];
    
    }
   
    
    //接受传来的数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readTheMessage:) name:kPassLeftData_0 object:nil];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)reloadTheData{

    [self.tableView_left reloadData];
    [self.tableView_right reloadData];
}


#pragma mark消息内容读取-----处理
- (void)readTheMessage:(NSNotification *)notification{
    
    NSArray *readFlag = [notification object];//读取传过来的数组
    NSLog(@"readFlag:%@",readFlag);
   
    if([readFlag count]){
        
        whichModel = [readFlag[0] integerValue];
        whichButton =[readFlag[1] integerValue];
    }
    
    /**
     *  @Author frankfan, 14-10-28 11:10:01
     *
     *  这里需要添加whichModel-whichModel==0 || whichModel==1 || whichModel==5 || whichModel==2 || whichModel==4 ||whichModel ==6 ||whichModel==7
     */
    if(whichModel != 3){
        
        if(whichButton==1001){
      #pragma mark 从缓存中读取“三大模块”的数据
            /*容器初始化*/
            businessCircleName =[NSMutableArray array];
            businessCircleDetail =[NSMutableArray array];
            
            /*index为0模块的数据【即第一个模块,附近商圈等】*/
            NSMutableArray *circleInfoArray = [[[TMCache sharedCache]objectForKey:kCircleInfo]mutableCopy];
          
            
            self._0_left_dataSource = circleInfoArray;
            self._left_outPutSource = self._0_left_dataSource;
        
            if([circleInfoArray count]){

                self._0_right_dataSource = [@[@"1000",@"3000",@"5000"]mutableCopy];
            }else{
                
                self._0_right_dataSource = nil;
            }
            
            self._right_outPutSource = self._0_right_dataSource;
            
            [self.tableView_right reloadData];
            [self.tableView_left reloadData];
        }
        if(whichButton==1002){
            
            NSArray *iconList = @[@"美食.png",@"娱乐.png",@"教育.png",@"社区.png",@"健身.png",@"医疗.png",@"美容.png",@"酒店.png"];//hard coding
            self._left_outPutSource = [iconList mutableCopy];
            [self.tableView_left reloadData];
        }
    
    }
    
}




#pragma mark tableView的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    if(tableView.tag==10010){
    
        return [self._left_outPutSource count];
    
    }else if(tableView.tag==10011){
    
    
        return [self._right_outPutSource count];
    }else{
    
        return 0;
    }
  

}


#pragma mark 创建tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellName1 = @"cell1";
    static NSString *cellName2 =@"cell2";
    
    static NSString *cellName3 = @"cell3";
    
    UITableViewCell *cell1 = nil;
    UITableViewCell *cell2 = nil;
    
    UITableViewCell *cell3 = nil;
    
    if((whichModel==0 && whichButton ==1001 && tableView.tag ==10010) ||(whichModel==1 && whichButton==1001 && tableView.tag==10010) ||(whichModel==5 && whichButton==1001 && tableView.tag==10010) || (whichModel==2 && whichButton==1001 && tableView.tag==10010) ||(whichModel==4 && whichButton==1001 && tableView.tag==10010)||(whichModel==6 && whichButton==1001 && tableView.tag==10010)||(whichModel==7 && whichButton==1001 && tableView.tag==10010)){
    
        cell1 =[tableView dequeueReusableCellWithIdentifier:cellName1];
        if(!cell1){
        
            cell1 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName1];
            
            UIView *backgroundView =[[UIView alloc]initWithFrame:cell1.bounds];
            backgroundView.backgroundColor =[UIColor colorWithWhite:0.85 alpha:0.8];
            cell1.backgroundView = backgroundView;
            
            UIView *selectedView =[[UIView alloc]initWithFrame:cell1.bounds];
            selectedView.backgroundColor =[UIColor whiteColor];
            cell1.selectedBackgroundView = selectedView;
            
            UILabel *textLabel1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell1.bounds.size.width, cell1.bounds.size.height)];
            textLabel1.font =[UIFont systemFontOfSize:14];
            textLabel1.textColor = baseTextColor;
            textLabel1.tag = 101;
            [cell1.contentView addSubview:textLabel1];
            
        
        }
    
        UILabel *textLabel =(UILabel *)[cell1 viewWithTag:101];
        if(indexPath.row==0){
        
            NSDictionary *tempDict = self._left_outPutSource[indexPath.row];
            textLabel.text = [[tempDict allKeys]firstObject];
            
        }else{
        
            NSDictionary *tempDict = self._left_outPutSource[indexPath.row];
            textLabel.text = tempDict[@"regionName"];
        }
        
        
        return cell1;
    
    }
    if((whichModel==0 && whichButton==1001 && tableView.tag==10011) ||(whichModel==1 && whichButton==1001 && tableView.tag==10011) ||(whichModel==5 && whichButton==1001 && tableView.tag==10011) || (whichModel==2 && whichButton==1001 && tableView.tag==10011) ||(whichModel==4 && whichButton==1001 && tableView.tag==10011)||(whichModel==6 && whichButton==1001 && tableView.tag==10011)||(whichModel==7 && whichButton==1001 && tableView.tag==10011)){
    
        cell2 =[tableView dequeueReusableCellWithIdentifier:cellName2];
        if(!cell2){
            
            cell2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName2];
            
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
            textLabel.tag = 102;
            textLabel.font = [UIFont systemFontOfSize:14];
            textLabel.textColor = baseTextColor;
            [cell2.contentView addSubview:textLabel];
        }
        
        UILabel *textLabel = (UILabel *)[cell2 viewWithTag:102];
      
        if(![[self._right_outPutSource firstObject]isKindOfClass:[NSDictionary class]]){
        
            textLabel.text = self._right_outPutSource[indexPath.row];
            
        }else{
        
            NSDictionary *dict = self._right_outPutSource[indexPath.row];
            textLabel.text = dict[@"circleName"];
        }
        
        
     
        return cell2;
    }
    if((whichModel==0 &&whichButton==1002 && tableView.tag==10010) || (whichModel==1 && whichButton==1002 && tableView.tag==10010) || (whichModel==5 && whichButton==1002 && tableView.tag==10010) || (whichModel==2 && whichButton==1002 && tableView.tag==10010) || (whichModel==4 && whichButton==1002 && tableView.tag==10010)||(whichModel==6 && whichButton==1002 && tableView.tag==10010)||(whichModel==7 && whichButton==1002 && tableView.tag==10010)){
    
        cell3 =[tableView dequeueReusableCellWithIdentifier:cellName3];
        if(!cell3){
        
            cell3 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName3];
            
            /*自定义控件-header imageView*/
            UIImageView *headerImagerView =[[UIImageView alloc]initWithFrame:CGRectMake(5, 3, 30, 30)];
            headerImagerView.tag = 103;
            [cell3.contentView addSubview:headerImagerView];
            
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 1, 80, 40)];
            textLabel.tag = 104;
            textLabel.font =[UIFont systemFontOfSize:14];
            textLabel.textColor = baseTextColor;
            [cell3.contentView addSubview:textLabel];
            
        }
        
        NSArray *nameList = @[@"美食饮茶",@"休闲娱乐",@"文化教育",@"社区便利",@"运动健身",@"医疗保健",@"丽人美容",@"旅游酒店"];
        
        UIImageView *headerImageView = (UIImageView *)[cell3 viewWithTag:103];
        headerImageView.image =[UIImage imageNamed:self._left_outPutSource[indexPath.row]];
        
        UILabel *textLabel = (UILabel*)[cell3 viewWithTag:104];
        textLabel.text = nameList[indexPath.row];
        
        return cell3;
    
    }

    return nil;
}



#pragma mark cell被选择触发事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 10011){//右侧tableView点击
        
        [self dismissTheMenu];
        
    }else if (tableView.tag == 10010){//左侧tableView点击
    
        whickRow = indexPath.row;
        
        
        if(indexPath.row!=0){/*这里手动取消对第一行的选中,若不手动取消，则为bug*/
        
            UITableViewCell *cell =[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.selected = NO;
            
            //
            NSArray *circleinfoArray = [[TMCache sharedCache]objectForKey:kCircleInfo];
            NSDictionary *tempDict = circleinfoArray[indexPath.row];
            self._right_outPutSource = [tempDict[@"circles"]mutableCopy];
            
            
        }else{//第一行被选中
        
            self._right_outPutSource = [@[@"1000",@"3000",@"5000"]mutableCopy];
        }
        
        [self.tableView_right reloadData];
    
    }



}


#pragma mark 默认选中第一行
- (void)viewDidAppear:(BOOL)animated{
    
    NSIndexPath *firstIndex =[NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell =[self.tableView_left cellForRowAtIndexPath:firstIndex];
    cell.selected = YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    CGPoint position = [[touches anyObject]locationInView:self.view];
    if(position.y>100){
        
    
        [self dismissTheMenu];
    }

    
}



#pragma mark dismiss the menu
- (void)dismissTheMenu{

    [UIView animateWithDuration:0.4 animations:^{
        
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.view = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"clearArray" object:nil];
        
    }];
    
}


- (void)dealloc{


    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
