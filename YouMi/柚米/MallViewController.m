//
//  MallViewController.m
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MallViewController.h"
#import  "CycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "MainPageCustomTableViewCell.h"

/*fake data*/
#define arrayCount 10

@interface MallViewController ()
{
    
    NSString *_metereString;


}

@property (nonatomic,strong)UIButton *button_meter;
@property (nonatomic,strong)UIButton *button_sort;
@property (nonatomic,strong)UIButton *button_default;

@property (nonatomic,strong)UIImageView *arrow1;
@property (nonatomic,strong)UIImageView *arrow2;
@property (nonatomic,strong)UIImageView *arrow3;


@property (nonatomic,strong)NSMutableArray *imagesArray;/*装载图片*/
@property (nonatomic,strong)NSMutableArray *titlesArray;/*装载菜名*/
@property (nonatomic,strong)CycleScrollView *mainScrillerView;/*轮播图片*/
@end

@implementation MallViewController

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
    /*搜索按钮*/
    UIButton *searchButton =[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton setImage:[UIImage imageNamed:@"搜索icon"] forState:UIControlStateNormal];
    
    UIBarButtonItem *searchItem =[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    /*imagesArray初始化*/
    self.imagesArray =[NSMutableArray array];
    
    /*创建3按钮*/
#warning fake date 这个数字根据用户选择的米数做相应显示
    _metereString =[NSString stringWithFormat:@"%@m",@"1000"];
    self.button_meter =[UIButton buttonWithType:UIButtonTypeCustom];
    self.button_meter.tag = 1001;
    self.button_meter.frame = CGRectMake(5, 74, 75, 30);
    [self.button_meter setTitle:_metereString forState:UIControlStateNormal];
    [self.button_meter setTitleColor:baseTextColor forState:UIControlStateNormal];
    self.button_meter.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.button_meter addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button_meter];
    /*创建指示器*/
    self.arrow1 =[[UIImageView alloc]initWithFrame:CGRectMake(65, 76, 20, 23)];
    self.arrow1.image =[UIImage imageNamed:@"向下箭头icon"];
    [self.view addSubview:self.arrow1];

    
    
    self.button_sort = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button_sort.frame = CGRectMake(105, 74, 80, 30);
    self.button_sort.tag = 1002;
    [self.button_sort setTitle:@"全部分类" forState:UIControlStateNormal];
    [self.button_sort setTitleColor:baseTextColor forState:UIControlStateNormal];
    self.button_sort.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.button_sort addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button_sort];
    /*创建指示器*/
    self.arrow2 =[[UIImageView alloc]initWithFrame:CGRectMake(175, 76, 20, 23)];
    self.arrow2.image =[UIImage imageNamed:@"向下箭头icon"];
    [self.view addSubview:self.arrow2];
    
    
    
    self.button_default = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button_default.frame = CGRectMake(218, 74, 80, 30);
    self.button_default.tag = 1003;
    [self.button_default setTitle:@"默认排序" forState:UIControlStateNormal];
    [self.button_default setTitleColor:baseTextColor forState:UIControlStateNormal];
    self.button_default.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.button_default addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button_default];
    /*创建指示器*/
    self.arrow3 =[[UIImageView alloc]initWithFrame:CGRectMake(288, 76, 20, 23)];
    self.arrow3.image =[UIImage imageNamed:@"向下箭头icon"];
    [self.view addSubview:self.arrow3];
    
#warning fake data 假数据
    
    NSArray *urls = @[@"http://pica.nipic.com/2008-05-15/2008515134227836_2.jpg",@"http://pic3.nipic.com/20090629/1481322_100443048_2.jpg",@"http://pica.nipic.com/2008-04-17/20084172038621_2.jpg",@"http://pica.nipic.com/2008-05-19/2008519184321988_2.jpg",@"http://pic1a.nipic.com/2008-12-05/200812585526170_2.jpg"];
    
    /*fake data*/
    self.titlesArray = [NSMutableArray arrayWithObjects:@"红烧腊肉",@"红烧鱼",@"油焖小龙虾",@"荷包蛋",@"红烧肉", nil];
    
    
    if([urls count]<=5){/*5为图片显示最多数目*/
        
        UILabel *titleLabel = nil;
        for (int i=0; i<[urls count];i++) {
            
            UIImageView *tempImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
            titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(2, 155, 130, 30)];
            titleLabel.text = self.titlesArray[i];
            titleLabel.textColor =[UIColor whiteColor];
            titleLabel.font =[UIFont systemFontOfSize:14];
            
            
            /*创建blackView*/
            UIView *blackView =[[UIView alloc]initWithFrame:CGRectMake(0, 157, self.view.bounds.size.width, 24)];
            blackView.backgroundColor =[UIColor blackColor];
            blackView.alpha = 0.5;
            [tempImageView addSubview:blackView];
            [tempImageView addSubview:titleLabel];
            
            
            
            [tempImageView sd_setImageWithURL:[NSURL URLWithString:urls[i]]];/*从链接获取图像*/
            [self.imagesArray addObject:tempImageView];
        
        }
        
    }
    
    /*创建轮播效果控件*/
    
    self.mainScrillerView =[[CycleScrollView alloc]initWithFrame:CGRectMake(0, 114, self.view.bounds.size.width, 180) animationDuration:3.2];
    __weak MallViewController *_self = self;
    self.mainScrillerView.totalPagesCount = ^NSInteger(void){
    
    
        return [_self.imagesArray count];
    };
    
    self.mainScrillerView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
    
        return _self.imagesArray[pageIndex];
    };
    
    self.mainScrillerView.TapActionBlock = ^(NSInteger pageIndex){
    
    
        NSLog(@"index:%ld",pageIndex);
    };
    
    
    [self.view addSubview:self.mainScrillerView];
    
    
#pragma mark 创建tableView
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 294, self.view.bounds.size.width, self.view.bounds.size.height-49-294) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = commomCellHeight;
    [self.view addSubview:self.tableView];
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark 3个按钮触发事件

- (void)buttonClicked:(UIButton *)sender{
    if(sender.tag==1001){
        
        NSLog(@"1001");
    }



}


#pragma mark tableView代理方法——tableView生成cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return arrayCount;
}


#pragma mark tableView代理方法-tableView创建cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MainPageCustomTableViewCell *cell =[MainPageCustomTableViewCell cellWithTableView:tableView];

    return cell;

}


#pragma mark cell的触发回调

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"selectIndex:%ld",(long)indexPath.row);


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
