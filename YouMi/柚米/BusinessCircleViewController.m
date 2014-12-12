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
#import "ProgressHUD.h"
#import <AFNetworking.h>
#import <TMCache.h>
#import "PinYinForObjc.h"

@interface BusinessCircleViewController ()


@property (nonatomic,strong)NSDictionary *dict1;
@property (nonatomic,strong)NSMutableArray *oupPutData;

@property (nonatomic,strong)NSMutableArray *allkeys;
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
    self.allkeys =[NSMutableArray array];
    
    
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
    
    self.static_tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 55+64, 123, self.view.bounds.size.height-49*2-50-20) style:UITableViewStylePlain];
    self.static_tableView.backgroundColor =[UIColor colorWithWhite:0.95 alpha:1];
    self.static_tableView.tag = 3001;
    self.static_tableView.rowHeight = 50;
    self.static_tableView.separatorStyle = NO;
    self.static_tableView.delegate = self;
    self.static_tableView.dataSource = self;
    self.static_tableView.showsVerticalScrollIndicator = NO;
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
//    self.dict1 =@{@"A":@[@"阿波罗广场",@"奥特莱斯广场"],@"W":@[@"王婆臭豆腐",@"万家惠",@"吴家林"],@"B":@[@"百盛商圈",@"博富国际",@"百乐门"],@"C":@[@"超级卖场",@"策划商业街"],@"D":@[@"大碗厨",@"大上海",@"大海门"],@"F":@[@"飞鸟店铺",@"粉饼店"]};
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
    
    
       AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary *parameters = @{@"cityId":@"177"};
    
    [manager GET:API_GetCircleInfoByCityId parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tempArray = responseObject[@"data"];
        [[TMCache sharedCache]setObject:tempArray forKey:kCircleInfo];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",[error localizedDescription]);
        [ProgressHUD showError:@"网络异常"];
        
    }];
    
    
    NSMutableArray *array =[[[TMCache sharedCache]objectForKey:kCircleInfo]mutableCopy];
    if([array count]){
        
        [array removeObjectAtIndex:0];
        NSArray *resultArray = array;
        
        self.BusinessCirArray = [resultArray mutableCopy];
    }
    
    

    
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark section的个数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(tableView.tag==3002){
    
        return [self.allkeys count];
    }else{
    
    
        return 1;
    }


}


#pragma mark cell的个数 faka data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(tableView.tag==3001){
    
        return [self.BusinessCirArray count];/*fake data*/

    }else{
    
     
        NSArray *temp_array = self.oupPutData[section];
        return [temp_array count];
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
        
        NSDictionary *tempDict = self.BusinessCirArray[indexPath.row];
        NSString *circleName = tempDict[@"regionName"];
        cell.textLabel.text = circleName;
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
    
    
//    /*fake data 此处self.dict1为某个商圈下得详情数据，从接口处获取*/
//    NSArray *tempAlpha = [self.dict1 allKeys];
//    NSMutableArray *temp_array = [tempAlpha mutableCopy];
//    /*字母排序*/
//    [temp_array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        
//        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch]==NSOrderedDescending;
//    }];
    
    thLabel.text = self.allkeys[section];
    [backgroundView addSubview:thLabel];
    
    return backgroundView;
}


#pragma mark - cell被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag==3001){//左侧
    
    [ProgressHUD show:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
     
        NSDictionary *tempDict = self.BusinessCirArray[indexPath.row];
        NSArray *circles = tempDict[@"circles"];
        
        //创建一个可变数组，放入circleName
        NSMutableArray *circleNames =[NSMutableArray array];
        for (NSDictionary *tempDict in circles) {
            
            [circleNames addObject:tempDict[@"circleName"]];
        }
        
        NSMutableArray *pinyins = [NSMutableArray array];
        for (NSString *circleNameChinese in circleNames) {
            
            NSString *pinyin = [self converChinessToPinYinHeader:circleNameChinese];
            [pinyins addObject:pinyin];
        }
        
        //保障首字母的不重复
        NSSet *pinyinHeaderSet =[NSSet setWithArray:pinyins];
        
        
        //创建字典容器
        NSMutableArray *dataSource_left = [NSMutableArray array];
        
        //开始放入字典对象
        for (NSString *string in pinyinHeaderSet) {
            
            NSString *dictKey = string;
            NSMutableArray *dictObject = [NSMutableArray array];
            
            for (NSString *circleName in circleNames) {
                
                if([string isEqualToString:[self converChinessToPinYinHeader:circleName]]){
                    
                    [dictObject addObject:circleName];
                }
                
            }
            
            NSDictionary *dict = @{dictKey:dictObject};
            [dataSource_left addObject:dict];
            
            
        }
        
        
        /*创建最终输出的商圈数据*/
        self.oupPutData =[NSMutableArray array];
        
        NSMutableArray *allkeys = [NSMutableArray array];
        for (NSDictionary *tempDict in dataSource_left) {
            
            NSString *key =[[tempDict allKeys]firstObject];
            [allkeys addObject:key];
        }
        
        
        NSArray *OrderAllkeys =[allkeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [obj1 compare:obj2 options:NSCaseInsensitiveSearch]==NSOrderedDescending;
        }];
        
        
        self.allkeys = [OrderAllkeys mutableCopy];
        
        
        for (NSString *keys in OrderAllkeys) {
            
            for (NSDictionary *tempDict in dataSource_left) {
                
                NSString *tempKey = [[tempDict allKeys]firstObject];
                if([tempKey isEqualToString:keys]){
                    
                    NSArray *tempData = [tempDict objectForKey:tempKey];
                    [self.oupPutData addObject:tempData];
                }
                
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.flex_tableView reloadData];
            [ProgressHUD dismiss];
        });
        
      
        
    });
        
    
    }


}



#pragma mark - 根据汉字返回首字母
- (NSString *)converChinessToPinYinHeader:(NSString *)chinese{

    CFStringRef cfstring = (__bridge CFStringRef)chinese;
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, cfstring);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSString *resultString = (__bridge NSString *)(string);
    NSArray *pinyinHeader = [resultString componentsSeparatedByString:@""];
    resultString =[[pinyinHeader firstObject]uppercaseString];
    NSString *finalDone = [resultString substringToIndex:1];
    if([finalDone isEqualToString:@" "]){
    
        resultString = [resultString substringWithRange:NSMakeRange(1, 1)];
        return resultString;
        
    }else{
    
        return finalDone;

    }
    
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
