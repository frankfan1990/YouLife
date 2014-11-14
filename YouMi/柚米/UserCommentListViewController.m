//
//  UserCommentListViewController.m
//  youmi
//
//  Created by frankfan on 14/11/12.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "UserCommentListViewController.h"
#import "UserCommentTableViewCell.h"

@interface UserCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    NSMutableArray *userCommentContent;//用户评论

}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation UserCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    //
    /**
     在这里初始化参数
     */
    
    userCommentContent = [NSMutableArray arrayWithObjects:@"这是用户评论1，这里的菜还是不错的,不过佐料放得有点猛啊！辣椒太辣了！受不了，基本来说可以给个3星半吧",@"这是用户评论，这里的菜真是烂啊啊 啊啊啊",@"这里的菜还是很好的，啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈",@"这是用户评论,一个简单的测试啊啊啊啊",@"这里的菜好垃圾啊好垃圾啊这里的菜好垃圾啊好垃圾啊这里的菜好垃圾啊好垃圾啊这里的菜好垃圾啊好垃圾啊这里的菜好垃圾啊好垃圾啊这里的菜好垃圾啊好垃圾啊这里的菜好垃圾啊好垃圾啊",@"额。。。菜还是一般般的啦。。。额",@"算了，我写不动了！", nil];
    
    
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"用户评论";
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
     *  @Author frankfan, 14-11-12 16:11:39
     *
     *  tableView创建
     *
     *  @return
     */
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [userCommentContent count];
}

#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat contentHeight;
    if([userCommentContent count]){
    
     contentHeight = [self caculateTheTextHeight:userCommentContent[indexPath.row] andFontSize:14]+35;
        
    }else{
    
        contentHeight = 10+35;
    }
    
    return contentHeight;
}


#pragma mark -创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserCommentTableViewCell *cell =[UserCommentTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = NO;
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    line.backgroundColor =customGrayColor;
    [cell.contentView addSubview:line];
    
    
    cell.commentContent.text = userCommentContent[indexPath.row];
    
    CGFloat contentHeight;
    if([cell.commentContent.text length]){
        
        contentHeight = [self caculateTheTextHeight:cell.commentContent.text andFontSize:14];
    }else{
        
        contentHeight = 0;
    }

    
    cell.commentContent.frame = CGRectMake(10, 36, self.view.bounds.size.width-40, contentHeight);
    //用户评论内容
    cell.commentContent.text = userCommentContent[indexPath.row];
    //来自某人
    cell.theCommenter.text = @"frankfan";
    //来自某天
    cell.theDay.text = @"2014-9-25";
    //来自某刻
    cell.theTime.text = @"20:33";
    
    return cell;

}






/**
 *  @Author frankfan, 14-11-12 16:11:29
 *
 *  动态计算文字的高度
 *
 *  @param string   输入文字
 *  @param fontSize 文字font大小
 *
 *  @return 所占高度
 */

- (CGFloat)caculateTheTextHeight:(NSString *)string andFontSize:(int)fontSize{
    
    /*非彻底性封装,这里给定固定的宽度*/
    CGSize constraint = CGSizeMake(self.view.bounds.size.width-100, CGFLOAT_MAX);
    
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
