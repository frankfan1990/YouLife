//
//  CommunityDetailsViewController.m
//  youmi
//
//  Created by frankfan on 14-9-19.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//社区便利->小区

#import "CommunityDetailsViewController.h"
#import "VillageDynamicTableViewCell.h"
#import "Village2DynamicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShopDetail_CommunityViewController.h"


@interface CommunityDetailsViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{

    NSIndexPath *recodeIndexPath;//记录选择的indexPath,以便到时操作改cell

}
@property (nonatomic,strong)NSMutableArray *mechineItem;
@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *villageDynamicList;/*小区动态文字*/
@property (nonatomic,strong)NSMutableArray *restaurantNameList;/*餐厅名字*/
@property (nonatomic,strong)NSMutableArray *restaurantDetailList;/*餐厅备注*/
@property (nonatomic,strong)NSMutableArray *imageUrlsList;/*图片链接*/

@end

@implementation CommunityDetailsViewController

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
    //
    /**/
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = self.communityName;
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

    ////创建collectionView
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(65, 35);

    
    
    self.collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(10, 64, self.view.bounds.size.width-20, 130) collectionViewLayout:flowLayout];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = customGrayColor;
    [self.view addSubview:self.collectionView];
    
    /*创建小区设施图标*/
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(-5, -50, 25, 25)];
    imageView.image =[UIImage imageNamed:@"竖标签"];
    [self.collectionView addSubview:imageView];
    
    UILabel *mechineText =[[UILabel alloc]initWithFrame:CGRectMake(15, -52, 100, 30)];
    mechineText.font = [UIFont systemFontOfSize:14];
    mechineText.textColor = baseTextColor;
    mechineText.text = @"小区设施";
    [self.collectionView addSubview:mechineText];
    
    UIView *sepaLine =[[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 1)];
    sepaLine.backgroundColor =[UIColor colorWithWhite:0.8 alpha:0.9];
    [self.collectionView addSubview:sepaLine];
    
    
    /*fake data*/
    self.mechineItem =[NSMutableArray arrayWithObjects:@"医疗保健",@"维修",@"房屋超市",@"中介",@"物业", nil];
    
    
#pragma mark 数据
    
    /*假数据*/
    self.villageDynamicList = [NSMutableArray arrayWithObjects:@"小区开业",@"超市开业",@"马杀鸡开业",@"垃圾要清理哦",@"大碗厨开业", nil];
    self.restaurantNameList = [NSMutableArray arrayWithObjects:@"好再来",@"大碗厨",@"杨记虾尾",@"大煲仔饭",@"清凉夏季",@"油爆龙虾", nil];
    self.restaurantDetailList = [NSMutableArray arrayWithObjects:@"2折",@"2折",@"2折",@"2折",@"2折",@"2折", nil];
    self.imageUrlsList = [NSMutableArray arrayWithObjects:@"http://114.0372.cn/upload/Shoppic/2012/4/13854420120401709024000.jpg",@"http://bj.bendibao.com/Upload/200611231758638.JPG",@"http://www.phone-yes.com.tw/uploadpic/g_pic_5_20120412143946.jpg",@"http://www.yeke.cn/attachments/art/2010/04/16/100416150800ae3jizcoelvn.jpg",@"http://pic18.nipic.com/20120105/6755670_103159100000_2.jpg",@"http://www.lvshedesign.com/wordpress/wp-content/uploads/2011/10/201110260303.jpg", nil];
#pragma 假数据__end
    
    
    
#pragma mark 创建tableView
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 210, self.view.bounds.size.width-20, self.view.bounds.size.height-49-210) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = NO;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

////////////////////////////////tableView
#pragma mark tableView创建头部距离

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 25;

}

#pragma mark创建分组

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return 2;
}

#pragma mark创建rowHeight

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
    
        return 44;
    }else{
    
    
        return 100;
    }

}



#pragma mark创建tableViewCell的个数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    if(section==0){
    
        return [self.villageDynamicList count];
    }else{
    
        
        return [self.restaurantNameList count];
    }


}


#pragma mark创建tableViewCell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VillageDynamicTableViewCell *villageDynamic1 = nil;
    Village2DynamicTableViewCell *village2Dynamic2 = nil;
    
    if(indexPath.section==0){
        
        villageDynamic1 = [VillageDynamicTableViewCell cellWithTableView:tableView];
        villageDynamic1.moreDetail.text = self.villageDynamicList[indexPath.row];
        
        return villageDynamic1;
    }else{
    
        village2Dynamic2 = [Village2DynamicTableViewCell cellWithTableView:tableView];
        
        /*数据绑定->begin*/
        village2Dynamic2.labelName.text = self.restaurantNameList[indexPath.row];//餐厅名字
        [village2Dynamic2.headerImageView sd_setImageWithURL:self.imageUrlsList[indexPath.row]];//头部图片
        village2Dynamic2.labeDetail.text = self.restaurantDetailList[indexPath.row];
        /*数据绑定->end*/
        
        return village2Dynamic2;
    }
    
}

#pragma mark创建tableView的头部View

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 25)];
    headerView.backgroundColor = customGrayColor;
    
    /*竖标签*/
    UIImageView *imageView2 =[[UIImageView alloc]initWithFrame:CGRectMake(-2, 1, 25, 25)];
    imageView2.image =[UIImage imageNamed:@"竖标签"];
    [headerView addSubview:imageView2];
    
    /*标签文字*/
    UILabel *textLabel =[[UILabel alloc]initWithFrame:CGRectMake(19, 1, 123, 25)];
    [headerView addSubview:textLabel];
    
    if(section==0){
    
        textLabel.text = @"小区动态";
        textLabel.font =[UIFont systemFontOfSize:14];
        textLabel.textColor = baseTextColor;
        
    }else{
    
        textLabel.text = @"附近优惠活动列表";
        textLabel.font =[UIFont systemFontOfSize:14];
        textLabel.textColor = baseTextColor;
        
        /*more*/
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(250, 0, 50, 25);
        button.titleLabel.font =[UIFont systemFontOfSize:14];
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button setTitleColor:baseTextColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        
        UIImageView *arrow_imageView =[[UIImageView alloc]initWithFrame:CGRectMake(285, 2.5, 20, 20)];
        arrow_imageView.image =[UIImage imageNamed:@"箭头icon"];
        [headerView addSubview:arrow_imageView];
        
    }
    
    
    return headerView;
}

#pragma mark  tableViewCell点击触发

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    recodeIndexPath = indexPath;
    if(indexPath.section==1){
    
        ShopDetail_CommunityViewController *shopDetail_community =[[ShopDetail_CommunityViewController alloc]init];
        /*data binding ->begin*/
        shopDetail_community.headerTitle = self.communityName;
        shopDetail_community.imageUrl = self.imageUrlsList[indexPath.row];
        shopDetail_community.shopName_string = self.restaurantNameList[indexPath.row];
        
        [self.navigationController pushViewController:shopDetail_community animated:YES];

    
    }
    


}





#pragma mark 更多_触发

- (void)showMoreButtonClicked:(UIButton *)sender{

    NSLog(@"more");

}



///////////////////////////////////////collectionView
#pragma mark collectionViewCell生成的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    return [self.mechineItem count];

}


#pragma mark collectionViewCell的创建
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{


    UICollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    cell.backgroundColor =[UIColor whiteColor];
    
    UILabel *namelabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    cell.backgroundView = namelabel;
    namelabel.textAlignment = NSTextAlignmentCenter;
    namelabel.backgroundColor =[UIColor whiteColor];
    namelabel.font =[UIFont systemFontOfSize:13];
    namelabel.textColor = baseTextColor;
    namelabel.layer.cornerRadius = 3;
    
    namelabel.text = self.mechineItem[indexPath.row];
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 0, 0, 0);

}


#pragma mark    collectionViewCell点击触发

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    NSLog(@"indexRow:%ld",(long)indexPath.row);

}



#pragma mark - 导航栏按钮触发
/**
 *  @Author frankfan, 14-10-29 18:10:17
 *
 *  导航栏上得按钮触发
 *
 *  @param sender 传过来的button
 */

- (void)buttonClicked:(UIButton *)sender{

    
    
    [self.navigationController popViewControllerAnimated:YES];


    
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self.tableView deselectRowAtIndexPath:recodeIndexPath animated:NO];
    
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
