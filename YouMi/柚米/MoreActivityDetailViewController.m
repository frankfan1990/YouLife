//
//  MoreActivityDetailViewController.m
//  youmi
//
//  Created by frankfan on 14/11/14.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MoreActivityDetailViewController.h"
#import "RTLabel.h"

@interface MoreActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *itemTitles;
    
    RTLabel *rtlabel1;
    RTLabel *rtlabel2;
    RTLabel *rtlabel3;
    
    CGFloat itemHeight1;
    CGFloat itemHeight2;
    CGFloat itemHeight3;
    
    CGFloat thresholdHeight;
}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation MoreActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    itemTitles = @[@"活动详情",@"购买须知",@"温馨提示"];
    
    
    //
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"活动规则";
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

    
    /**
     *  @author frankfan, 14-12-05 10:12:01
     *
     *  创建tableView
     *
     *  @return nil
     */
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor =customGrayColor;
    self.tableView.allowsSelection = NO;
    
    CGRect size = CGRectZero;
    UIView *footView = [[UIView alloc]initWithFrame:size];
    self.tableView.tableFooterView = footView;
    
    /**
     *  @author frankfan, 14-12-05 10:12:03
     *
     *  创建rtlabel
     */
  
    rtlabel1 =[[RTLabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
    rtlabel2 =[[RTLabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
    rtlabel3 =[[RTLabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
    
    rtlabel1.text =[self handleStringForRTLabel:self.activityContents];
    rtlabel2.text =[self handleStringForRTLabel:self.needToKnow];
    rtlabel3.text =[self handleStringForRTLabel:self.tips];
    
   
    [self handleTheIfNoDataForRtlable:rtlabel1];
    [self handleTheIfNoDataForRtlable:rtlabel2];
    [self handleTheIfNoDataForRtlable:rtlabel3];
    
    itemHeight1 = rtlabel1.optimumSize.height+thresholdHeight;
    itemHeight2 = rtlabel2.optimumSize.height+thresholdHeight;
    itemHeight3 = rtlabel3.optimumSize.height+thresholdHeight;
    
    rtlabel1.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, itemHeight1);
    rtlabel2.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, itemHeight2);
    rtlabel3.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, itemHeight3);
  
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 处理无数据情况
- (void)handleTheIfNoDataForRtlable:(RTLabel *)rtlabel{
    
    if(![rtlabel.text length]){
    
        thresholdHeight = 30;
        rtlabel.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 30);
        rtlabel.textAlignment = NSTextAlignmentLeft;
        rtlabel.text = @"暂无数据";
    }
}



#pragma mark - section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

#pragma mark - cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0){
    
        return itemHeight1+10;
    }else if (indexPath.section==1){
    
        return itemHeight2+10;
    }else{
    
        return itemHeight3+10;
    }

}


#pragma mark - headView创建
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.tableView.bounds.size.width, 32)];
    backView.backgroundColor = customGrayColor;
    
    UIImageView *widget =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    widget.image = [UIImage imageNamed:@"竖标签"];
    [backView addSubview:widget];
    
    UILabel *itemTitle =[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 123, 30)];
    [backView addSubview:itemTitle];
    itemTitle.font =[UIFont systemFontOfSize:14];
    itemTitle.textColor = baseTextColor;
    itemTitle.text = itemTitles[section];

    return backView;

}

#pragma mark - headView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 32;
}


#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellName = @"cell";
    UITableViewCell *cell = nil;
    cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if(indexPath.section==0){
    
        [cell.contentView addSubview:rtlabel1];
    }
    
    if(indexPath.section==1){
    
        [cell.contentView addSubview:rtlabel2];
    }
    
    if(indexPath.section==2){
    
        [cell.contentView addSubview:rtlabel3];
    }
    
    return cell;

}



#pragma mark - 处理富文本格式字符串，使之适配RTLabel的使用
- (NSString *)handleStringForRTLabel:(NSString *)htmlString{
    
    NSString *tempString = [htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [htmlString length])];
    
    NSString *resultString =[tempString stringByReplacingOccurrencesOfString:@"div" withString:@"br" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempString length])];
    
    return resultString;
}




#pragma mark - 导航栏按钮触发
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
