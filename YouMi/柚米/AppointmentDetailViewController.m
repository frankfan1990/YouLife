//
//  AppointmentDetailViewController.m
//  youmi
//
//  Created by frankfan on 14/10/28.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "AppointmentDetailViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PMCalendar.h"
#import "KPTimePicker.h"
#import "Categories.h"
#import "NSDate+Additions.h"
#import "ZSYPopoverListView.h"
#import "NSDate+Additions.h"
#import "ProgressHUD/ProgressHUD.h"

#import "Reachability.h"
#import <AFNetworking.h>
#import <TMCache.h>
#import "Email_Phone.h"

const NSString *text_html_appointment = @"text/html";
const NSString *application_json_appointment = @"application/json";

@interface AppointmentDetailViewController ()<PMCalendarControllerDelegate,KPTimePickerDelegate,ZSYPopoverListDelegate,ZSYPopoverListDatasource>
{
    NSArray *genderArray;
    BOOL isButtonSelected;
    
    UIButton *button;//日历按钮
    
    /*选择人数的人数数据源*/
    NSMutableArray *peopleCountArray;
    
    //
    UILabel *label1;//选择日期
    UILabel *label2;//人数
    UILabel *label3;//时间
    
    
    NSMutableArray *dateArray;//用以存放选择的日期
    NSMutableArray *dateArray2;//用以存放特殊的日期
    
    NSInteger sex;//性别
    NSInteger peopleNumbers;
    
    Reachability *_reachability_shopDetail;
    
    
}
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;//选择人数控件的参数

@property (nonatomic,strong)TPKeyboardAvoidingScrollView *theLoadView;
@property (nonatomic,strong)PMCalendarController *pmCalendere;

@property (nonatomic,strong)UITextField *nameInput;
@property (nonatomic,strong)UITextField *phoneInput;
@end

@implementation AppointmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    //
    /**
     *  @Author frankfan, 14-11-15 01:11:06
     *
     *  变量初始化地方
     */
    
    dateArray =[NSMutableArray array];
    dateArray2 =[NSMutableArray array];
    
    
    /**
     *  @Author frankfan, 14-10-29 18:10:49
     *
     *  初始化peopleCountArray
     */
    peopleCountArray =[NSMutableArray array];
    for (int i=1; i<51; i++) {
        
        [peopleCountArray
          addObject:[NSNumber numberWithInt:i]];
        
    }
    
    
    //
    isButtonSelected = NO;
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"预定";
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

    
    self.theLoadView =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    self.theLoadView.scrollEnabled = YES;
    [self.view addSubview:self.theLoadView];
    
    
#pragma mark - 开始创建界面元素 选择日期栏
    UIImageView *candlerView =[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
    candlerView.image =[UIImage imageNamed:@"日历"];
    [self.theLoadView addSubview:candlerView];
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 200, 30)];
    label1.font =[UIFont systemFontOfSize:17];
    label1.textColor = baseTextColor;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"请选择日期";
    [self.theLoadView addSubview:label1];
    
    UIImageView *arrowImage =[[UIImageView alloc]initWithFrame:CGRectMake(270, 20, 25, 25)];
    arrowImage.image =[UIImage imageNamed:@"向下箭头icon"];
    [self.theLoadView addSubview:arrowImage];
    arrowImage.userInteractionEnabled = YES;
    
    UIView *touchView =[[UIView alloc]initWithFrame:CGRectMake(260, 10, 40, 40)];
    [self.theLoadView addSubview:touchView];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCalendar:)];
    [touchView addGestureRecognizer:tap];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = customGrayColor;
    [self.theLoadView addSubview:lineView];
    
#pragma mark - 创建时间人数栏
    
    UIView *lineView2 =[[UIView alloc]initWithFrame:CGRectMake(0, 130, self.view.bounds.size.width, 1)];
    lineView2.backgroundColor = customGrayColor;
    [self.theLoadView addSubview:lineView2];
    
    UIImageView *peopleCount =[[UIImageView alloc]initWithFrame:CGRectMake(20, 85, 30, 30)];
    peopleCount.image =[UIImage imageNamed:@"人数"];
    [self.theLoadView addSubview:peopleCount];
    
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 85, 100, 30)];
    label2.font =[UIFont systemFontOfSize:17];
    label2.textColor = baseTextColor;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"人数";
    [self.theLoadView addSubview:label2];

    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-0.5, 65, 1, 65)];
    line3.backgroundColor = customGrayColor;
    [self.theLoadView addSubview:line3];
    
    UIImageView *timer =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.0+20, 85, 30, 30)];
    timer.image =[UIImage imageNamed:@"时间我的预定"];
    [self.theLoadView addSubview:timer];
    
    label3 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.0+35, 85, 100, 30)];
    label3.font =[UIFont systemFontOfSize:17];
    label3.textColor = baseTextColor;
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"时间";
    [self.theLoadView addSubview:label3];

    
    UIImageView *arrowImage2 =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-45, 85, 25, 25)];
    arrowImage2.image =[UIImage imageNamed:@"向下箭头icon"];
    [self.theLoadView addSubview:arrowImage2];
    arrowImage2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PeopleCountfunc)];
    [arrowImage2 addGestureRecognizer:tap2];
    
    UIImageView *arrowImage3 =[[UIImageView alloc]initWithFrame:CGRectMake(270, 85, 25, 25)];
    arrowImage3.image =[UIImage imageNamed:@"向下箭头icon"];
    [self.theLoadView addSubview:arrowImage3];
    arrowImage3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AppointTime)];
    [arrowImage3 addGestureRecognizer:tap3];

    
#pragma mark - 包厢栏
    
    UIView *lineView4 =[[UIView alloc]initWithFrame:CGRectMake(0, 195, self.view.bounds.size.width, 1)];
    lineView4.backgroundColor = customGrayColor;
    [self.theLoadView addSubview:lineView4];

    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 100, 30)];
    label4.font =[UIFont systemFontOfSize:17];
    label4.textColor = baseTextColor;
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"需要包厢";
    [self.theLoadView addSubview:label4];

    UIButton *isNeedSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    isNeedSelect.frame = CGRectMake(270, 160, 15, 15);
    isNeedSelect.layer.borderWidth = 4;
    isNeedSelect.layer.masksToBounds = YES;
    isNeedSelect.layer.borderColor = (__bridge CGColorRef)(customGrayColor);
    isNeedSelect.backgroundColor =[UIColor colorWithWhite:0.7 alpha:1];
    [self.theLoadView addSubview:isNeedSelect];
    [isNeedSelect addTarget:self action:@selector(boxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark - 姓名栏
    
    UIView *nameLine =[[UIView alloc]initWithFrame:CGRectMake(0, 260,self.view.bounds.size.width, 1)];
    nameLine.backgroundColor = customGrayColor;
    [self.theLoadView addSubview:nameLine];
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(20, 215, 100, 30)];
    label5.font =[UIFont systemFontOfSize:17];
    label5.textColor = baseTextColor;
    label5.textAlignment = NSTextAlignmentCenter;
    label5.text = @"请输入姓名";
    [self.theLoadView addSubview:label5];

    self.nameInput = [[UITextField alloc]initWithFrame:CGRectMake(125, 210, 100, 40)];
    self.nameInput.tag = 1001;
    self.nameInput.textColor = [UIColor colorWithWhite:0.35 alpha:1];
    self.nameInput.textAlignment = NSTextAlignmentCenter;
    self.nameInput.backgroundColor = customGrayColor;
    self.nameInput.layer.cornerRadius = 2;
    [self.theLoadView addSubview:self.nameInput];
    
    genderArray = @[@"男士",@"女士"];
    UISegmentedControl *segmentControl =[[UISegmentedControl alloc]initWithItems:genderArray];
    segmentControl.frame = CGRectMake(233, 215, 80, 30);
    segmentControl.tintColor = baseTextColor;
    segmentControl.layer.cornerRadius = 1;
    [segmentControl addTarget:self action:@selector(segmentsCon:) forControlEvents:UIControlEventValueChanged];
    [self.theLoadView addSubview:segmentControl];
    

#pragma mark - 创建手机号一栏
    
    UIView *phoneLine =[[UIView alloc]initWithFrame:CGRectMake(0, 325,self.view.bounds.size.width, 1)];
    phoneLine.backgroundColor = customGrayColor;
    [self.theLoadView addSubview:phoneLine];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(20, 275, 100, 30)];
    label6.font =[UIFont systemFontOfSize:17];
    label6.textColor = baseTextColor;
    label6.textAlignment = NSTextAlignmentCenter;
    label6.text = @"输入手机号";
    [self.theLoadView addSubview:label6];

    self.phoneInput = [[UITextField alloc]initWithFrame:CGRectMake(125, 275, 130, 40)];
    self.phoneInput.tag = 1002;
    self.phoneInput.textColor = [UIColor colorWithWhite:0.35 alpha:1];
    self.phoneInput.textAlignment = NSTextAlignmentCenter;
    self.phoneInput.backgroundColor = customGrayColor;
    self.phoneInput.layer.cornerRadius = 2;
    [self.theLoadView addSubview:self.phoneInput];


#pragma mark - 提交预定
    int threshold;
    if(self.view.bounds.size.height>480){
        threshold = 0;
    }else{
    
        threshold = 70;
    }
    UIButton *commitButton =[UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(20, 400-threshold, self.view.bounds.size.width-40, 35);
    commitButton.layer.cornerRadius = 3;
    commitButton.backgroundColor = baseRedColor;
    [commitButton setTitle:@"提交预定" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateHighlighted];
    [commitButton addTarget:self action:@selector(commitButtonCLicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.theLoadView addSubview:commitButton];
    
    
    _reachability_shopDetail =[Reachability reachabilityWithHostName:@"www.baidu.com"];
 
    // Do any additional setup after loading the view.
}

/**
 *  @Author frankfan, 14-10-29 13:10:30
 *
 *  提交按钮触发
 *
 *  @return nil
 */


#pragma mark - 提交订单按钮触发
- (void)commitButtonCLicked:(UIButton *)sender{
    
    if(![_reachability_shopDetail isReachable]){
    
        [ProgressHUD showError:@"网络异常"];
        return;
    }
    
    if(!isValidatePhone(self.phoneInput.text)){
    
        [ProgressHUD showError:@"手机号码格式错误"];
        return;
    }
    
    
    
    if([label1.text length]>5 && peopleNumbers && [label3.text length]>2 && [self.nameInput.text length] && [self.phoneInput.text length] && sex
       ){//信息完整
        
        NSDictionary *parameters = nil;
        NSDictionary *userinfo = [[TMCache sharedCache]objectForKey:kUserInfo];
        NSString *memid = userinfo[memberID];
        if([self.shopName length] && [self.shopId length]){
        
            parameters = @{@"shopId":self.shopId,@"shopName":self.shopName,
                           @"memberId":memid,@"reserveDate":label1.text,
                           @"reserveTime":label3.text,@"reserveNumber":[NSNumber numberWithInteger:peopleNumbers],
                           @"box":[NSNumber numberWithBool:isButtonSelected],@"reserveName":self.nameInput.text,
                           @"reservePhone":self.phoneInput.text,@"sex":[NSNumber numberWithInteger:sex]};
        
            AFHTTPRequestOperationManager *manager = [self createNetworkRequestObject:application_json_appointment];
            [ProgressHUD show:nil];
            [manager POST:API_Appointment parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"%@",responseObject);
                [ProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [ProgressHUD showError:@"提交失败"];
            }];
            
        }
        
        
    }else{//信息不完整
        
        [ProgressHUD showError:@"请将信息填写完整"];
    }
}



/**
 *  @Author frankfan, 14-10-29 13:10:11
 *
 *  给分段控制器添加触发方法
 *
 *  @return nil
 */

- (void)segmentsCon:(UISegmentedControl *)segment{

    NSInteger index =  segment.selectedSegmentIndex;
    NSLog(@"选择的是：%@",genderArray[index]);
    sex = index+1;
}




#pragma mark - 是否需要包间触发
/**
 *  @Author frankfan, 14-10-29 11:10:18
 *
 *  包间是否需要的选择
 *
 *  @return nil
 */
- (void)boxButtonClicked:(UIButton *)sender{
    
    if(!isButtonSelected){
    
        [sender setBackgroundColor:baseRedColor];
        isButtonSelected = YES;
    }else{
    
        [sender setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:1]];
        isButtonSelected = NO;
    }


}



#pragma mark - 点餐人数触发方法
/**
 *  @Author frankfan, 14-10-29 10:10:30
 *
 *  点餐人数触发方法
 *
 *  @return nil
 */
- (void)PeopleCountfunc{

    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"选择人数";
    listView.datasource = self;
    listView.delegate = self;
    [listView show];


}


#pragma mark - 就餐日期触发方法
/**
 *  @Author frankfan, 14-10-29 10:10:58
 *
 *  就餐时间触发方法
 *
 *  @return nil
 */
- (void)AppointTime{
    
    KPTimePicker *kpTimer =[[KPTimePicker alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width , self.view.bounds.size.height)];
    kpTimer.delegate = self;
    [self.view addSubview:kpTimer];

}

#pragma mark - 获取选择的时间time
-(void)timePicker:(KPTimePicker*)timePicker selectedDate:(NSDate *)date{


    NSLog(@">>>%@",timePicker.clockLabel.text);
    label3.text = timePicker.clockLabel.text;
    [timePicker removeFromSuperview];
    
}


#pragma mark - 日历对象创建
/**
 *  @Author frankfan, 14-10-28 23:10:16
 *
 *  创建日历对象
 *
 *  @param gesture nil
 */
- (void)showCalendar:(UITapGestureRecognizer *)gesture{
    
    self.pmCalendere =[[PMCalendarController alloc]init];
    self.pmCalendere.delegate = self;
    self.pmCalendere.mondayFirstDayOfWeek = YES;
    self.pmCalendere.allowsLongPressYearChange = YES;
   
    [self.pmCalendere presentCalendarFromView:gesture.view permittedArrowDirections:PMCalendarArrowDirectionAny animated:YES];
    [self calendarController:self.pmCalendere didChangePeriod:self.pmCalendere.period];

    /**
     *  @Author frankfan, 14-10-29 17:10:28
     *
     *  添加确定按钮
     */
    button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithWhite:0.03 alpha:1];
    button.frame = CGRectMake(42, 344, 270, 30);
    button.layer.cornerRadius = 7;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(calendereButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
   
}


/**
 *  @Author frankfan, 14-10-29 14:10:50
 *
 *  日历按钮的触发
 *
 *  @return nil
 */

- (void)calendereButtonClicked:(UIButton *)sender{

    
    [UIView animateWithDuration:0.2 animations:^{
        
        sender.alpha = 0;
    }];
    
    
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];

    NSString *nowDateString = [dateFormatter stringFromDate:date];//当前系统时间
    NSString *selecteDateString = [dateArray2 lastObject];//选择的时间
    
    if([selecteDateString integerValue]<[nowDateString integerValue]){//如果选择的时间小于系统时间
    
        [ProgressHUD showError:@"非法时间"];
    }else{
    
        label1.text = [dateArray lastObject];
    }
    
    sender = nil;
    [sender removeFromSuperview];
    [self.pmCalendere dismissCalendarAnimated:YES];
    
}


#pragma mark - 取到选中的日期
/**
 *  @Author frankfan, 14-10-28 23:10:38
 *
 *  在这里取到用户选中的日期
 *
 *  @param calendarController
 *  @param newPeriod
 */
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod{

    NSString *date = [NSString stringWithFormat:@"%@"
                        , [newPeriod.startDate dateStringWithFormat:@"yyyy-MM-dd"]];
   
    NSString *date2 =[NSString stringWithFormat:@"%@",[newPeriod.startDate dateStringWithFormat:@"yyyyMMdd"]];
    
    [dateArray2 addObject:date2];
    [dateArray addObject:date];
    NSLog(@"date:%@",date);
    
}


#pragma mark - 选择人数的相关部分

- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [peopleCountArray count];
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@人",peopleCountArray[indexPath.row]];
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    NSLog(@"deselect:%ld", (long)indexPath.row);
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    NSLog(@"%@", peopleCountArray[indexPath.row]);
    peopleNumbers = [peopleCountArray[indexPath.row]integerValue];
    label2.text = [NSString stringWithFormat:@"%@人",peopleCountArray[indexPath.row]];
    
}


- (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController{

    [UIView animateWithDuration:0.09 animations:^{
        
        button.alpha = 0;
    }];
    button = nil;
    [button removeFromSuperview];

}


#pragma mark - 创建网络请求实体对象
- (AFHTTPRequestOperationManager *)createNetworkRequestObject:(const NSString *)content_type{

    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:content_type];
    
    return manager;
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
