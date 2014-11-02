//
//  CourseDetailsViewController.m
//  youmi
//
//  Created by frankfan on 14/10/30.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "CourseDetailsViewController.h"

#define defaultCellHeight 44

@interface CourseDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    /*分享按钮是否点击*/
    BOOL isCollectioned;
    
    /**
     *  @Author frankfan, 14-10-30 17:10:23
     *
     *  以下系列变量为课程详情内容相关字段
     *
     *  @param nonatomic nil
     *  @param strong    nil
     *
     *  @return nil
     */
    
    NSMutableArray *UserCommentsArray;//用户评论

}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation CourseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    
    /*分享按钮是否点击*/
    isCollectioned = NO;
    
    /**
     这里是一系列参数的初始化
     */
    
    UserCommentsArray = [NSMutableArray array];
    
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"课程详情";
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

    
#pragma make - 创建tableView
    /**
     *  @Author frankfan, 14-10-30 16:10:15
     *
     *  这里创建的tableView是整个页面的骨架
     *
     *  @return nil
     */
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = customGrayColor;
    
    UIView *footerView =[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
    
    
    // Do any additional setup after loading the view.
}




#pragma  mark - tableView相关部分
/**
 *  @Author frankfan, 14-10-30 16:10:35
 *
 *  以下一系列方法用于处理tableView
 *
 *  @return nil
 */

#pragma mark - tableView的cell创建个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 9+[UserCommentsArray count];//基本数据个数+用户评论个数
}


#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *headerImageCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//轮播图片的cell
    UITableViewCell *infoItemCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//项目Item的名字
    UITableViewCell *shcoolInfoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//学校信息
    UITableViewCell *addressInfoCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//地址信息
    UITableViewCell *courseDetialCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//课程详情
    UITableViewCell *othersCourseCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//同校其他课程
    UITableViewCell *userCommentsCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//用户评论
    
    
    
    
    
    
    
    
    
    return nil;

}


#pragma mark - tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   #warning 这里的数据需要跟后台配合
    /**
     *  @Author frankfan, 14-10-30 22:10:55
     *
     *  说明：课程详情，同类课程以及用户评论部分的高度是动态的，根据
     *  后台传过来的说明【字数】进行动态高度的调节，因此返回的高度需要
     *  跟后台接口进行配合
     *
     *  @param CGFloat nil
     *
     *  @return cell的高度
     */
    
    
    
    
    /*暂时先去掉错误提示*/
    return 0;


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





/**
 *  @Author frankfan, 14-10-29 18:10:34
 *
 *  导航栏按钮触发
 *
 *  @return nil
 */
#pragma mark - 导航栏按钮触发

- (void)buttonClicked:(UIButton *)sender{
    if(sender.tag==1002){
        
        NSLog(@"1002");
    }else if (sender.tag==10006){
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        if(!isCollectioned){
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
            
            isCollectioned = YES;
        }else{
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            isCollectioned = NO;
        }
        
        
        NSLog(@"收藏");
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
