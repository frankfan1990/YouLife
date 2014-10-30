//
//  BusinessInformationViewController.m
//  youmi
//
//  Created by frankfan on 14/10/29.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "BusinessInformationViewController.h"

@interface BusinessInformationViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    NSArray *shopInfo;
    //
    UILabel *detailInfoLabel;//动态高度cell
    NSString *restaurantFeatures;//餐厅特色
    NSString *busInformation;//公交信息
    
}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation BusinessInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;

    /**
     基本信息配置
     */
    
#warning fake data
    //fake data
    restaurantFeatures = @"餐馆特征特征特征特征特征特征特征特征特征特征特征特征特征";
    busInformation = @"公交信息信息信信息信息信息信";
    shopInfo = @[@"营业时间",@"",@"",@"餐厅特色",restaurantFeatures,@"公交信息",busInformation];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"商铺营业信息";
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

    //
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = customGrayColor;
    self.tableView.allowsSelection = NO;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectZero];
    footerView.backgroundColor = customGrayColor;
    self.tableView.tableFooterView = footerView;
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - 创建tableView的相关方法
/**
 *  @Author frankfan, 14-10-29 19:10:46
 *
 *  创建tableView相关方法
 *
 *  @return nil
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITableViewCell *cell2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    if(indexPath.row ==0 || indexPath.row ==3 || indexPath.row==5){
    
        UIImageView *logImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 25, 25)];
        logImageView.image =[UIImage imageNamed:@"竖标签"];
        [cell1.contentView addSubview:logImageView];
        
        UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(23, -3, 120, 40)];
        nameLabel.font =[UIFont systemFontOfSize:14];
        nameLabel.textColor = baseTextColor;
        [cell1.contentView addSubview:nameLabel];
        
        nameLabel.text = shopInfo[indexPath.row];
        cell1.selected = NO;
        cell1.backgroundColor = customGrayColor;
        return cell1;
        
    }else{
        
        /**
         *  @Author frankfan, 14-10-29 21:10:56
         *
         *  这里返回的cell应该是动态高度的
         */
        
        cell2.layer.cornerRadius = 5;
        if(indexPath.row==1){
            
            UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 44, cell2.bounds.size.width, 1)];
            line.backgroundColor = customGrayColor;
            [cell2.contentView addSubview:line];
        }
        
        /**
         处理label的多行显示
         */
        
        CGFloat labelHeight;
        if(indexPath.row==6){
        
            labelHeight = [self caculateTheTextHeight:[shopInfo lastObject] andFontSize:14];
        }else if (indexPath.row==4){
        
            labelHeight = [self caculateTheTextHeight:shopInfo[4] andFontSize:14];
        }
        
        detailInfoLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell2.bounds.size.width-4, labelHeight)];
        detailInfoLabel.font =[UIFont systemFontOfSize:14];
        detailInfoLabel.textColor = baseTextColor;
        detailInfoLabel.numberOfLines = 0;
        detailInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        if(indexPath.row==4 || indexPath.row==6){
            
            
            detailInfoLabel.text = shopInfo[indexPath.row];
            [cell2.contentView addSubview:detailInfoLabel];
        }
    
        
        return cell2;
    
    }

}


#pragma mark - tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row ==0 || indexPath.row ==3 || indexPath.row==5){
    
        return 35;
    }else{
        
        /**
         *  @Author frankfan, 14-10-30 00:10:07
         *
         *  在这里处理cell的输出高度
         */
        
        if(indexPath.row==4 || indexPath.row==6){
        
            
            NSString *text = [shopInfo objectAtIndex:[indexPath row]];
            
            
            CGFloat height = MAX([self caculateTheTextHeight:text andFontSize:14], 44.0f);
            
            
            return height + 1;

        
        }
        
        
        return 44;
    }

}

/**
 *  @Author frankfan, 14-10-30 01:10:23
 *
 *  动态计算文字在固定宽度的情况下，其高度的大小
 *
 *  @param string   输入要计算的文字
 *  @param fontSize 该字体的大小
 *
 *  @return 返回所占高度
 */
- (CGFloat)caculateTheTextHeight:(NSString *)string andFontSize:(int)fontSize{
  
    /*非彻底性封装*/
    CGSize constraint = CGSizeMake(self.view.bounds.size.width-20, CGFLOAT_MAX);
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:string
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;


    return size.height;
}



#pragma mark - 导航栏按触发
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
