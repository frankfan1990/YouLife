//
//  CConvenienceViewController.m
//  youmi
//
//  Created by frankfan on 14-9-17.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//社区便利

#import "CConvenienceViewController.h"
#import "CommunityDetailsViewController.h"

//static NSMutableArray *outPutData;

@interface CConvenienceViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    
    NSIndexPath *recodeIndexPath;//记录选择的indexPath,以便到时操作改cell
}

//测试
//@property (nonatomic,strong)NSMutableArray *outPutData;
@property (nonatomic,strong)NSMutableArray *dataSource1;
@property (nonatomic,strong)NSMutableArray *dataSource2;
@property (nonatomic,strong)NSMutableArray *dataSource3;
@property (nonatomic,strong)NSMutableArray *outPutData;

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *community;
@property (nonatomic,strong)NSMutableArray *communityNameList;
@end

@implementation CConvenienceViewController

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
    self.view.backgroundColor =customGrayColor;
    //
    
    self.community =[NSMutableArray array];
    self.communityNameList =[NSMutableArray array];
    /**/
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"社区便利";
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

    
#pragma mark 创建collectionView
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(75, 40);
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    
    self.collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(10, 40, self.view.bounds.size.width-20, 150) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = customGrayColor;
    [self.view addSubview:self.collectionView];

    /*竖标签*/
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, -30, 25, 25)];
    imageView.image =[UIImage imageNamed:@"竖标签"];
    [self.collectionView addSubview:imageView];
    
    /*请设置社区*/
    UILabel *communityLabel =[[UILabel alloc]initWithFrame:CGRectMake(25, -32, 125, 30)];
    communityLabel.text = @"请设置社区";
    communityLabel.font =[UIFont systemFontOfSize:14];
    communityLabel.textColor = baseTextColor;
    [self.collectionView addSubview:communityLabel];
    
    /*f分割线*/
    UIView *seperateLine =[[UIView alloc]initWithFrame:CGRectMake(0, -5, self.view.bounds.size.width, 1)];
    seperateLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.89];
    [self.collectionView addSubview:seperateLine];
    
    /*竖标签*/
    UIImageView *imageView2 =[[UIImageView alloc]initWithFrame:CGRectMake(10, 200, 25, 25)];
    imageView2.image =[UIImage imageNamed:@"竖标签"];
    [self.view addSubview:imageView2];

    /*请设置社区*/
    UILabel *communityLabel2 =[[UILabel alloc]initWithFrame:CGRectMake(35, 200, 125, 30)];
    communityLabel2.text = @"小区列表";
    communityLabel2.font =[UIFont systemFontOfSize:14];
    communityLabel2.textColor = baseTextColor;
    [self.view addSubview:communityLabel2];

    
#pragma mark 创建tableView
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 230, self.view.bounds.size.width-20, self.view.bounds.size.height-49-220) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor =[UIColor clearColor];
    self.tableView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
    
    
    /*fake data*/
    self.community =[NSMutableArray arrayWithObjects:@"岳麓区",@"开福区",@"天心区",@"雨花区",@"高新区",@"芙蓉区",@"长沙县",@"星沙", nil];
    
    /*fake date*/
    self.communityNameList =[NSMutableArray arrayWithObjects:@"A小区",@"B小区",@"C小区" ,@"D小区",@"E小区",nil];
    
    
    self.dataSource1 = [NSMutableArray arrayWithObjects:@"A小区",@"Bx小区",@"C小区",@"D小区",@"E小区",nil];
    self.dataSource2 = [NSMutableArray arrayWithObjects:@"k_1",@"k_2",@"k_3", nil];
    self.dataSource3 = [NSMutableArray arrayWithObjects:@"11",@"22",@"33",@"44",@"55",@"66",@"77",@"88",@"99",@"00",@"111",@"222",@"333",@"444" ,nil];
    
    
    _outPutData = self.dataSource1;
    
    // Do any additional setup after loading the view.
}


#pragma mark 在这里取消对cell的选择

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self.tableView deselectRowAtIndexPath:recodeIndexPath animated:NO];

}



#pragma mark cell的个数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


//    return [self.communityNameList count];
    return [_outPutData count];
}


#pragma mark 创建cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellName = @"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    
    UIImageView *arrowImageView = nil;
    if(!cell){
    
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.backgroundColor =[UIColor whiteColor];
        arrowImageView =[[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 20, 20)];
        arrowImageView.image =[UIImage imageNamed:@"箭头icon"];
        
        UIImageView *line =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 1)];
        line.image =[UIImage imageNamed:@"虚线"];
        [cell.contentView addSubview:line];

        
        UILabel *comunityName_text =[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 123, 30)];
        comunityName_text.font =[UIFont systemFontOfSize:14];
        comunityName_text.textColor = baseTextColor;
        comunityName_text.tag = 10086;
        [cell.contentView addSubview:comunityName_text];
        
    }
    
    
    UILabel *dataBind = (UILabel *)[cell viewWithTag:10086];
    dataBind.text = self.outPutData[indexPath.row];
    [cell.contentView addSubview:arrowImageView];
    return cell;

}


#pragma mark tableViewcell的选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    recodeIndexPath = indexPath;
    CommunityDetailsViewController *communityDetails = [[CommunityDetailsViewController alloc]init];
    communityDetails.communityName = self.outPutData[indexPath.row];
    [self.navigationController pushViewController:communityDetails animated:YES];

}



#pragma mark collectionView的item生成个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    
    return [self.community count];
//    return 20;
}

#pragma mark 创建collectionView Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    UICollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 2;
    cell.backgroundColor = [UIColor whiteColor];
    
    UIView *selectView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 40)];
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 40)];
    label.font =[UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    [selectView addSubview:label];
    label.text = self.community[indexPath.row];
    
    selectView.layer.cornerRadius = 2;
    selectView.backgroundColor =baseRedColor;
    cell.selectedBackgroundView = selectView;
    
    
    UILabel *comunityName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 40)];
    comunityName.font = [UIFont systemFontOfSize:14];
    comunityName.textAlignment = NSTextAlignmentCenter;
    comunityName.textColor = baseTextColor;
    comunityName.text = self.community[indexPath.row];
    cell.backgroundView = comunityName;
    
    
    return cell;

}


#pragma mark collectionVieCell 被选中

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%ld",(long)indexPath.row);
    if(indexPath.row==1){
    

        _outPutData = self.dataSource2;
        [self.tableView reloadData];
    
    }else if (indexPath.row==0){

        _outPutData = self.dataSource1;
        [self.tableView reloadData];
    }else if (indexPath.row==2) {
     

        _outPutData = self.dataSource3;
        [self.tableView reloadData];
    }

}





#pragma mark 回退触发

- (void)buttonClicked:(UIButton *)sender{

    if(sender.tag ==10006){
    
    
        [self.navigationController popViewControllerAnimated:YES];
    }


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
//