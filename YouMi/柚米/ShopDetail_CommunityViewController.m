//
//  ShopDetail_CommunityViewController.m
//  youmi
//
//  Created by frankfan on 14-9-23.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//首页->社区便利->小区列表->附近优惠活动列表->店铺详情

#import "ShopDetail_CommunityViewController.h"
#import "UIImageView+WebCache.h"


@interface ShopDetail_CommunityViewController ()

@property (nonatomic,strong)UIImageView *headerImageView;

@end

@implementation ShopDetail_CommunityViewController

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
    self.view.backgroundColor = customGrayColor;
    /**/
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = self.headerTitle;
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

    /*右侧按钮*/
    UIButton *searchButton =[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.tag = 1000;
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchButton2 =[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton2.tag = 1002;
    searchButton2.frame = CGRectMake(0, 0, 30, 30);
    [searchButton2 setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [searchButton2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 =[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    UIBarButtonItem *item2 =[[UIBarButtonItem alloc]initWithCustomView:searchButton2];
    
    NSArray *itemArrays = @[item1,item2];
    self.navigationItem.rightBarButtonItems  =itemArrays;

    
    /*头部imageView*/
    self.headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 180)];
    [self.view addSubview:self.headerImageView];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    
#pragma mark创建tableView
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 244, self.view.bounds.size.width-20, self.view.bounds.size.height-244-49) style:UITableViewStyleGrouped];

    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = NO;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark创建分组个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return 2;
}

#pragma mark 创建cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

#pragma mark 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell1 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITableViewCell *cell2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell1.backgroundColor =[UIColor clearColor];
    cell2.backgroundColor =[UIColor clearColor];
    
   
    
    UIView *cell1_view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 190)];
    cell1_view.backgroundColor =[UIColor whiteColor];
    cell1_view.layer.cornerRadius = 3;
    [cell1.contentView addSubview:cell1_view];
    
    UIView *cell2_view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 150)];
    cell2_view.backgroundColor =[UIColor whiteColor];
    cell2_view.layer.cornerRadius = 3;
    [cell2.contentView addSubview:cell2_view];

    /*cell1 创建控件*/
    CGSize shopNameSize = [self.shopName_string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21]}];
    self.shopName = nil;
    self.shopTag = nil;
    
    if(shopNameSize.width < 200){
    
        self.shopName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, shopNameSize.width+2, 40)];
        self.shopTag =[[UILabel alloc]initWithFrame:CGRectMake(shopNameSize.width+20, 0, 100, 50)];

    }else{
    
        self.shopName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
        self.shopTag =[[UILabel alloc]initWithFrame:CGRectMake(230, 0, 100, 50)];
    }
    
    self.shopName.font = [UIFont systemFontOfSize:21];
    self.shopName.textColor = baseTextColor;
    self.shopName.text = self.shopName_string;
    [cell1.contentView addSubview:self.shopName];
    
    self.shopTag.font =[UIFont systemFontOfSize:14];
    self.shopTag.textColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    /*fake data bingding*/
    self.shopTag.text = @"香菜火锅";
    [cell1.contentView addSubview:self.shopTag];
    
    UIImageView *timeLogo =[[UIImageView alloc]initWithFrame:CGRectMake(10, 55, 18, 18)];
    timeLogo.image =[UIImage imageNamed:@"时间"];
    [cell1.contentView addSubview:timeLogo];
    
    self.workingTime =[[UILabel alloc]initWithFrame:CGRectMake(30, 38, 200, 50)];
    self.workingTime.font =[UIFont systemFontOfSize:15];
    self.workingTime.textColor = baseTextColor;
    [cell1.contentView addSubview:self.workingTime];
    /*fake data binding*/
    self.workingTime.text = @"店铺营业时间";
    
    UIImageView *whereLogo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 21, 21)];
    whereLogo.image =[UIImage imageNamed:@"地标"];
    [cell1.contentView addSubview:whereLogo];
    
    self.shopAddress = [[UILabel alloc]initWithFrame:CGRectMake(30, 85, 200, 50)];
    self.shopAddress.font =[UIFont systemFontOfSize:15];
    self.shopAddress.textColor = baseTextColor;
    [cell1.contentView addSubview:self.shopAddress];
    /*fake data dinding*/
    self.shopAddress.text = @"天马小区";
    
    UIImageView *phoneNumberImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 148, 19, 19)];
    phoneNumberImageView.image  =[UIImage imageNamed:@"电话"];
    [cell1.contentView addSubview:phoneNumberImageView];
    
    
    /*fake data dinding*/
    self.phoneNumber_string = @"15575829007";
    
    self.phoneNumber =[UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneNumber.frame = CGRectMake(15, 130, 120, 50);
    self.phoneNumber.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.phoneNumber setTitle:self.phoneNumber_string forState:UIControlStateNormal];
    [self.phoneNumber setTitleColor:baseTextColor forState:UIControlStateNormal];
    [self.phoneNumber addTarget:self action:@selector(phonrButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell1.contentView addSubview:self.phoneNumber];
    
    
    /*fake data dinding*/
    self.content_string = @"这是详情";
    UITextView *contentDetail =[[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    [cell2.contentView addSubview:contentDetail];
    contentDetail.textColor = baseTextColor;
    contentDetail.font = [UIFont systemFontOfSize:14];
    contentDetail.text = self.content_string;
    contentDetail.editable = NO;
    
    
    if(indexPath.section==0){
        
        return cell1;
    }else{
    
        return cell2;
    }


}




#pragma mark tableView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0){
    
        return 190;
    }else{
    
    
        return 150;/*此处有可能是动态调整高度*/
    }

}



#pragma mark tableView group间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 25;
}

#pragma mark tableView的headerView创建
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 25)];
    backView.backgroundColor =customGrayColor;
    
    /*竖标签*/
    UIImageView *imageView2 =[[UIImageView alloc]initWithFrame:CGRectMake(-4, 1, 25, 25)];
    imageView2.image =[UIImage imageNamed:@"竖标签"];
    [backView addSubview:imageView2];
 
    /*标签文字*/
    UILabel *textLabel =[[UILabel alloc]initWithFrame:CGRectMake(19, 1, 123, 25)];
    [backView addSubview:textLabel];
    textLabel.font =[UIFont systemFontOfSize:14];
    textLabel.textColor = baseTextColor;
    
    if(section==0){
    
        textLabel.text = @"店铺介绍";
    }else{
    
        textLabel.text = @"详细信息";
    }
    
    
    
    return backView;
}



#pragma mark回退
- (void)buttonClicked:(UIButton *)sender{

    if(sender.tag==10006){
    
        [self.navigationController popViewControllerAnimated:YES];

    }else if (sender.tag==1000){
    
    
    
    }else{
    
    
    }
    
    
}


#pragma mark 拨打电话
- (void)phonrButtonClicked:(UIButton *)sender{


    NSLog(@"15575829007");
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
