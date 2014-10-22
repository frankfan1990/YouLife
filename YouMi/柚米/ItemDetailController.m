//
//  MallViewController.m
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//美食-商铺详情

#import "ItemDetailController.h"
#import  "CycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "MainPageCustomTableViewCell.h"

#import "ShopDetai_Row1TableViewCell.h"
#import "BusinessInfoTableViewCell.h"
#import "ShopAddressTableViewCell.h"
#import "ContactInfoTableViewCell.h"



/*fake data*/
#define arrayCount 10

@interface ItemDetailController ()
{
    /*用来记录是否点击展开*/
    BOOL sellerInfoState;
    BOOL activityInfoState;
    
    /*项目名称*/
    NSArray *itemTitles;

}




@property (nonatomic,strong)NSMutableArray *imagesArray;/*装载图片*/
@property (nonatomic,strong)NSMutableArray *titlesArray;/*装载菜名*/
@property (nonatomic,strong)CycleScrollView *mainScrillerView;/*轮播图片*/

@property (nonatomic,strong)UILabel *shopName;
@property (nonatomic,strong)UILabel *kindofFood;
@property (nonatomic,strong)UILabel *aboutUpay;

@property (nonatomic,assign)float rating;//评分

@property (nonatomic,assign)int commentCount;/*评论的条数*/


@end

@implementation ItemDetailController

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
    self.view.backgroundColor = customGrayColor;
    //状态初始化
    sellerInfoState = NO;
    activityInfoState = NO;
    
    //初始化名字
    itemTitles = @[@"店铺信息",@"商家资讯",@"特惠活动",@"用户评论"];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"店铺详情";
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
    
    /*imagesArray初始化*/
    self.imagesArray =[NSMutableArray array];
    
        
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
    
    self.mainScrillerView =[[CycleScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 180) animationDuration:3];
    __weak ItemDetailController *_self = self;
    
//    
//    float sizeOfContent = 0;
//    UIView *lLast = [self.mainScrillerView.scrollView.subviews lastObject];
//    NSInteger wd = lLast.frame.origin.y;
//    NSInteger ht = lLast.frame.size.height;
//    
//    sizeOfContent = wd+ht;
    
    self.mainScrillerView.scrollView.contentSize = CGSizeMake(self.mainScrillerView.frame.size.width, 0);

    
    
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
    
    /*fix magic bugs 这是一个未知原因bug,但此fix可行--这是什么垃圾先不管了*/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.mainScrillerView.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0)];

    });
    
    
    
#pragma mark创建tableView
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 244, self.view.bounds.size.width, self.view.bounds.size.height-44-244) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = customGrayColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark 导航栏按钮触发

- (void)buttonClicked:(UIButton *)sender{
    if(sender.tag==1001){
        
        NSLog(@"1001");
    }else if (sender.tag==10006){
    
    
        [self.navigationController popViewControllerAnimated:YES];
    }

    NSLog(@"clicked...");

}


#pragma tableView section的生产个数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 4;
}

#pragma mark cell的生成个数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(section==0){
    
        return 4;
    }else if (section==1){
    
        if(!sellerInfoState){
        
            return 3;
            sellerInfoState = YES;
          
        }else{
        
            return 10+2;/*fake data*/
            sellerInfoState = NO;
        }
    
    }else if (section==2){
    
        if(!activityInfoState){
        
            return 3;
            activityInfoState = YES;
        }else{
        
            return 10+2;/*fake data*/
            activityInfoState = NO;
        }
        
    }else{
    
        return 10+2;/*fake data*/
    
    }



}


#pragma mark 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ShopDetai_Row1TableViewCell *cell1 = nil;
    BusinessInfoTableViewCell *cell2 = nil;
    ShopAddressTableViewCell *cell3 =nil;
    ContactInfoTableViewCell *cell4 = nil;
    
    UITableViewCell *cell = nil;
    
    if(indexPath.section==0){
    
        if(indexPath.row==0){
        
            cell1 = [ShopDetai_Row1TableViewCell cellWithTableView:tableView ];
            
            /*fake data*/
            cell1.shopName.text = @"店铺名";
            return cell1;
        }else if (indexPath.row==1){
        
            cell2 =[BusinessInfoTableViewCell cellWithTableView:tableView];
            return cell2;
        }else if (indexPath.row==2){
        
            cell3 =[ShopAddressTableViewCell celWithTableView:tableView];
            
            /*fake data*/
            cell3.shopADDress.text = @"雨花区井圭路";
            cell3.selectionStyle = NO;
            return cell3;
        }else{
        
        
            cell4 =[ContactInfoTableViewCell cellWithTableView:tableView];
            
            /*fake data*/
            cell4.phoneNUM.text = @"0123-456789";
            cell4.selectionStyle = NO;
            [cell4.button addTarget:self action:@selector(appointmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            return cell4;
        }
    
    
    }else{
        
        if(indexPath.section==1){/*商家资讯*/
        
//            static NSString *cellName =@"cell";
//            cell =[tableView dequeueReusableCellWithIdentifier:cellName];
            if(!cell){
                
                cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            }
            
            /*fake data*/
            cell.textLabel.text = @"今日免费";
            cell.detailTextLabel.text = @"2014.9.16";
            
        
            cell.selectionStyle = NO;
            cell.textLabel.font =[UIFont systemFontOfSize:14];
            cell.detailTextLabel.font =[UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.9];
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.9];
            return cell;

        
        }else{
        
        
            if(indexPath.section==2){/*特惠活动*/
            
//                static NSString *cellName =@"cell";
//                cell =[tableView dequeueReusableCellWithIdentifier:cellName];
                
                UIImageView *headerImageView = nil;
                UILabel *ShopName = nil;
                UILabel *money = nil;
                if(!cell){
                    
                    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 60, 60)];
                    headerImageView.layer.cornerRadius = 30;
                    headerImageView.layer.masksToBounds = YES;
                    headerImageView.layer.borderColor = customGrayColor.CGColor;
                    headerImageView.layer.borderWidth = 2;
                    [cell.contentView addSubview:headerImageView];
                    
                    ShopName =[[UILabel alloc]initWithFrame:CGRectMake(90, 8, 123, 30)];
                    ShopName.font =[UIFont systemFontOfSize:14];
                    ShopName.textColor = baseTextColor;
                    [cell.contentView addSubview:ShopName];
                    
                    money =[[UILabel alloc]initWithFrame:CGRectMake(90, 40, 123, 30)];
                    money.font =[UIFont systemFontOfSize:14];
                    money.textColor = baseTextColor;
                    [cell.contentView addSubview:money];

                    
                    
                    
                    
                    
                }
                
                ShopName.text = @"大碗厨";
                headerImageView.image =[UIImage imageNamed:@"火车站"];
                money.text = @"￥30";
                
                
                return cell;

            
            
            }else{/*评论*/
            
                static NSString *cellName =@"cell";
                cell =[tableView dequeueReusableCellWithIdentifier:cellName];
                if(!cell){
                    
                    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                }
                
                cell.backgroundColor =[UIColor orangeColor];
                
                return cell;

            
            
            }
            
            
        
        
        }
        
        
        
    }




}

#pragma mark cell的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0 && indexPath.row==0){
        
        return 70;
    }else if (indexPath.section==1||indexPath.section==2){
    
        
        if(indexPath.section==1){
        
            return 50;
        }else{
        
            return 80;
        }
        
    }if(indexPath.section==0){
        
        if(indexPath.row !=0){
        
            return 55;
        }
    
    
    }

    return 75;
}


#pragma mark header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0;
}

#pragma mark 创建headerView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, 53)];

    if(section==0){
    
       UIImageView *widget =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        widget.image = [UIImage imageNamed:@"竖标签"];
        [backView addSubview:widget];
        
        UILabel *itemTitle =[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 123, 30)];
        [backView addSubview:itemTitle];
        itemTitle.font =[UIFont systemFontOfSize:14];
        itemTitle.textColor = baseTextColor;
        itemTitle.text = itemTitles[section];

    }else{
    
        UIImageView *widget = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, 25, 25)];
        widget.image = [UIImage imageNamed:@"竖标签"];
        [backView addSubview:widget];
        
        UILabel *itemTitle =[[UILabel alloc]initWithFrame:CGRectMake(30, -12, 123, 30)];
        [backView addSubview:itemTitle];
        itemTitle.font =[UIFont systemFontOfSize:14];
        itemTitle.textColor = baseTextColor;
        itemTitle.text = itemTitles[section];
        
        if(section==3){
        
            UILabel *commentCount =[[UILabel alloc]initWithFrame:CGRectMake(270, -12, 100, 30)];
            [backView addSubview:commentCount];
            commentCount.font =[UIFont systemFontOfSize:14];
            commentCount.textColor = baseTextColor;
            
            /*fake date*/
            self.commentCount = 32;
            NSString *commentCountString = [NSString stringWithFormat:@"共%d条",self.commentCount];
            commentCount.text = commentCountString;
        
        }
        
    
    }
    
    

    return backView;
}


#pragma mark ”预约“按钮触发点击

- (void)appointmentButtonClicked:(UIButton *)sender{


    NSLog(@"appointmentButtonClicked...");


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
