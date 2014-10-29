//
//  CityListSelectViewController.m
//  youmi
//
//  Created by frankfan on 14/10/27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "CityListSelectViewController.h"
#import "THLabel.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface CityListSelectViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{

    NSMutableArray *titleIndex;
   
    NSMutableArray *dataArray;//用于搜索的数据源
    NSMutableArray *searchResults;//用于存放搜索的结果
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    
    BOOL isNormonModo;//不同模式下的标志
    
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *cityLetters;
@property (nonatomic,strong)NSMutableArray *cityLists;
@property (nonatomic,strong)NSMutableDictionary *citys;//citys的plist文件
@end

@implementation CityListSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    isNormonModo = YES;
    
    //
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"城市列表";
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

    
#pragma mark - tableView
    self.tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tag = 1001;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionIndexBackgroundColor =customGrayColor;
    self.tableView.sectionIndexColor =baseTextColor;
    [self.view addSubview:self.tableView];
    
    
    
    /*处理数据源*/
    NSArray *hotCity = @[@"长沙",@"北京",@"上海",@"广州",@"深圳"];
    
    
    NSString *cityDataPath = [[NSBundle mainBundle]pathForResource:@"citys" ofType:@"plist"];
    self.citys = [NSMutableDictionary dictionaryWithContentsOfFile:cityDataPath ];
    
    self.cityLetters =[NSMutableArray array];
    self.cityLists = [NSMutableArray array];
 
    
    [self.cityLetters addObjectsFromArray:[[self.citys allKeys] sortedArrayUsingSelector:@selector(compare:)]];//拿到字母表
    
    /*拿到城市表*/
    for (NSString *lette in self.cityLetters) {
        
        NSArray *tempArray =[self.citys objectForKey:lette];
        [self.cityLists addObject:tempArray];
    }
    
    /*处理字母表*/
    [self.cityLetters insertObject:@"GPS" atIndex:0];
    [self.cityLetters insertObject:@"" atIndex:1];
    
    
    /*title索引表*/
    titleIndex =  [self.cityLetters mutableCopy];
    titleIndex[0] = @"热";

    
    /*处理城市表*/

    if(![self.currentCity length]){
    
        if([[NSUserDefaults standardUserDefaults]objectForKey:kUserLocationCity]){
            
            NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:kUserLocationCity];
            
            [self.cityLists insertObject:@[city] atIndex:0];

        }else{
        
            [self.cityLists insertObject:@[@"无法定位当前所在城市"] atIndex:0];
        }
        
    }else{
    
        [self.cityLists insertObject:@[self.currentCity] atIndex:0];
       
    }
    [self.cityLists insertObject:hotCity atIndex:1];

    
    /**
     *  @Author frankfan, 14-10-27 14:10:54
     *
     *  这里是搜索部分的处理
     */
    
    
    /*用来处理搜索数据源*/
    NSMutableArray *tempArray = [self.cityLists mutableCopy];
    [tempArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
    
    dataArray =[NSMutableArray array];
    for (NSArray *array in tempArray) {
        
        [dataArray addObjectsFromArray:array];
    }
  
    mySearchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"搜索";
    
    searchDisplayController =[[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.displaysSearchBarInNavigationBar = NO;
    [searchDisplayController.searchBar setShowsCancelButton:NO];
    
    self.tableView.tableHeaderView = mySearchBar;
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 分组个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(isNormonModo){

        return [self.cityLetters count];
    }else{
    
        return 1;
    }
    
    
}

#pragma mark - 每分组下得cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
    
        return [searchResults count];
    }else{
    
        
        NSArray *tempArray = self.cityLists[section];
        
        return [tempArray count];

    }
    
    
}


#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellName = @"cell1";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
    
        cell.textLabel.text = searchResults[indexPath.row];
    }else{
    
        NSArray *tmpArray = self.cityLists[indexPath.section];
        cell.textLabel.text = tmpArray[indexPath.row];
        if(indexPath.section==0){
            cell.selectionStyle = NO;
        }
        
    }
    
    
    return cell;
}

#pragma mark - tableView头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 20;
}

#pragma mark - 创建头部的View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIView *redView =[[UIView alloc]initWithFrame:CGRectMake(0, 15, self.view.bounds.size.width, 10)];
    redView.backgroundColor = baseRedColor;
    [backView addSubview:redView];
    
    if(section==1){
        
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 61, 22)];
        [backView addSubview:imageView];
        
        UIImage *image =[UIImage imageNamed:@"热门城市"];
        imageView.image = image;
        
    }
    
    THLabel *thLabel =[[THLabel alloc]initWithFrame:CGRectMake(5, 0, 123, 30)];
    thLabel.strokeSize = 1;
    thLabel.strokeColor =[UIColor whiteColor];
    thLabel.textColor = baseRedColor;
    thLabel.font =[UIFont systemFontOfSize:14];
    [backView addSubview:thLabel];
    thLabel.text = self.cityLetters[section];
    
    return backView;
}



#pragma mark - 创建索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    return titleIndex;
}


#pragma mark - tableViewCell 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(isNormonModo){
    
        NSArray *tempArray = self.cityLists[indexPath.section];
        NSString *city = tempArray[indexPath.row];
        
        if(indexPath.section==0){
        
            return;
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:city forKey:kUserCity];

        if(![city length]){
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
        NSLog(@"city:%@",city);
    }else{

        
        NSString *city = searchResults[indexPath.row];
        
        if(![city length]){
            return;
        }
     
        [[NSUserDefaults standardUserDefaults]setObject:city forKey:kUserCity];
        
        [self.navigationController popViewControllerAnimated:YES];

        
        NSLog(@"%@",searchResults[indexPath.row]);
    }
    
    
}


#pragma mark - 搜索代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchResults = [[NSMutableArray alloc]init];
    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i<dataArray.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:dataArray[i]]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:dataArray[i]];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:dataArray[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
            }
            else {
                NSRange titleResult=[dataArray[i] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (NSString *tempStr in dataArray) {
            NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tempStr];
            }
        }
    }
}




- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    isNormonModo = NO;
    [self.tableView reloadData];

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    isNormonModo = YES;
    [self.tableView reloadData];
}



- (void)navi_buttonClicked:(UIButton *)sender{
    
    if(sender.tag==401){
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        NSLog(@"搜索...");
    }
    
    
    
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
