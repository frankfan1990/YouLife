//
//  ActivityDetailViewController.m
//  youmi
//
//  Created by frankfan on 14/11/11.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "CycleScrollView.h"
#import "UserCommentListViewController.h"
#import "UIImageView+WebCache.h"
#import "MoreActivityDetailViewController.h"
#import "UserCommentTableViewCell.h"

@interface ActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{

    /*收藏按钮是否点击*/
    BOOL isCollectioned;
    
     NSArray *itemTitles;//headerView上的文字
    
    CycleScrollView *cyclePlayImage;//轮播控件

    NSString *userComment;//用户评论
    
    UIWebView *webView1;//活动介绍部分的webView
    UIWebView *webView2;//商品详情部分的webView
    UIWebView *webView3;//活动规则部分的webView
}
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *cycleImageArrayURLs;//轮播图片的URL
@property (nonatomic,strong)NSMutableArray *iamgeViewArrays;//轮播图片
@property (nonatomic,strong)NSMutableArray *titlesArray;//餐饮模块的菜品文字
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    /**
     在这里初始化参数
     */
    
    isCollectioned = NO;
    itemTitles = @[@"",@"活动介绍",@"商品详情",@"活动规则",@"用户评论"];
    userComment = @"这里的菜啊真是特特特特别的不好吃，以前来这里的时候感觉还一般，没想到这次这么不行了！！！擦简直就是大垃圾！";
    
    self.cycleImageArrayURLs =[NSMutableArray array];
    self.iamgeViewArrays =[NSMutableArray array];

    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"活动详情";
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
    

#pragma mark - 创建tableView
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = customGrayColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = NO;
    
    
    /**
     *  @Author frankfan, 14-11-13 11:11:40
     *
     *  创建轮播
     *
     *  @param NSInteger
     *
     *  @return
     */
#warning fake data
    self.cycleImageArrayURLs = [@[@"http://vip.biznav.cn/20090615162541/pic/20090701134141962.jpg",@"http://a3.att.hudong.com/10/45/01300001024098130129454552574.jpg",@"http://qic.tw/upload/school/MID_20110503003627550.jpg",@"http://img5.imgtn.bdimg.com/it/u=2127817408,3685587629&fm=23&gp=0.jpg",@"http://image.3607.com/2012/03/31/20120320180128640.jpg"]mutableCopy];
    
    /*保证图片数组里元素不大于5个*/
    NSArray *imageArrays = nil;
    if([self.cycleImageArrayURLs count]){
        
        if([self.cycleImageArrayURLs count]>5){
            
            imageArrays =[self.cycleImageArrayURLs subarrayWithRange:NSMakeRange(0, 5)];
            
        }
        
    }
    
    if(!imageArrays){
        
        for (NSString *urlString in self.cycleImageArrayURLs) {
            
            NSURL *imageURL =[NSURL URLWithString:urlString];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
            [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"defaultBackgroundImage"]];
            [self.iamgeViewArrays addObject:imageView];
            
        }
        
    }else{
        
        
        for (NSString *urlString in imageArrays) {
            
            NSURL *imageURL =[NSURL URLWithString:urlString];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
            [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"defaultBackgroundImage"]];
            [self.iamgeViewArrays addObject:imageView];
            
        }
        
        
    }

    
    /**
     创建轮播控件部分
     */
    cyclePlayImage =[[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)
                                        animationDuration:2.8];
    cyclePlayImage.userInteractionEnabled = YES;
    
    __weak ActivityDetailViewController *_self = self;
    cyclePlayImage.totalPagesCount = ^NSInteger{
        
        return [_self.iamgeViewArrays count];
    };
    
    cyclePlayImage.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        
        return _self.iamgeViewArrays[pageIndex];
    };

    
    
    
    /**
     活动介绍
     */
    webView1 = webView1 =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 84)];
    webView1.tag = 2001;
    webView1.delegate = self;
    webView1.scrollView.scrollEnabled = NO;
    [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://image.baidu.com"]]];

    
    /**
     商品详情
     */
    webView2 =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 99)];
    webView2.tag = 2002;
    webView2.delegate = self;
    webView2.scrollView.scrollEnabled = NO;
    [webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
    
    /**
     活动详情
     */
    webView3 =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 109)];
    webView3.tag = 2003;
    webView3.delegate = self;
    webView3.scrollView.scrollEnabled = NO;
    [webView3 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 创建section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 5;
    
}

#pragma mark - 创建cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0 ||section==2 ||section==4){
    
        return 1;
    }
    
    if(section==1){
    
        return 5;
    }
    
    if(section==3){
    
        return 2;
    }
    
    
    return 0;

}

#pragma mark - 创建tabkeView headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section!=0){
    
        return 25;
    }

    return 0;
}


#pragma mark - 创建HeaderView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    if(section!=0){
    
        UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, 53)];
        backView.backgroundColor = customGrayColor;
        
        UIImageView *widget =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        widget.image = [UIImage imageNamed:@"竖标签"];
        [backView addSubview:widget];
        
        UILabel *itemTitle =[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 123, 30)];
        [backView addSubview:itemTitle];
        itemTitle.font =[UIFont systemFontOfSize:14];
        itemTitle.textColor = baseTextColor;
        itemTitle.text = itemTitles[section];

        if(section==4){
        
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(255, 0, 45, 30);
            [button setTitleColor:[UIColor colorWithWhite:0.55 alpha:1] forState:UIControlStateNormal];
            button.titleLabel.font =[UIFont systemFontOfSize:14];
            //在这里显示一共有多少条评论
            [button setTitle:[NSString stringWithFormat:@"%@条",@111] forState:UIControlStateNormal];
            [backView addSubview:button];
            [button addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        
        }
        
        
        
        return backView;
    
    }

    return nil;
}


#pragma mark - 跳转到评论
- (void)commentButtonClicked{
    
    UserCommentListViewController *userCommentList =[UserCommentListViewController new];
    userCommentList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userCommentList animated:YES];
}


#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0){
    
        return 180;
    }
    
    if(indexPath.section==1){
        
        if(indexPath.row==0){
        
            return 70;
        }
        
        if(indexPath.row==1){
        
            
            return 85;
        }
        
        if(indexPath.row==2 || indexPath.row==3 ||indexPath.row==4){
        
        
            return 44;
        }
     
    }

    if(indexPath.section==2){
    
        
        return 100;
    }
    
    if(indexPath.section==3){
    
        if(indexPath.row==0){
        
            return 110;
        }else{
        
            return 50;
        }
    
        
    }

    
    if(indexPath.section==4){//评论
    
        
        if([userComment length]){
            
            CGFloat commentContentHeight = [self caculateTheTextHeight:userComment andFontSize:14];
            return commentContentHeight+35;
        }else{
            
            return 10+35;
        }

    
    }
    
    return 0;
    
}





#pragma mark - 创建tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *headerViewCell =nil;
    UITableViewCell *cell1_0 = nil;
    UITableViewCell *cell1_1 = nil;
    UITableViewCell *cell1_2 = nil;
    UITableViewCell *cell1_3_4 = nil;
    
    UITableViewCell *cell2 = nil;
    UITableViewCell *cell3 = nil;
    UITableViewCell *cell3_1 = nil;
    
    if(indexPath.section==0){//轮播图
    
        headerViewCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        headerViewCell.selectionStyle = NO;
        [headerViewCell.contentView addSubview:cyclePlayImage];
        
        return headerViewCell;
    }
    
    if(indexPath.section==1){
    
        if(indexPath.row==0){
        
            cell1_0 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell1_0.selectionStyle = NO;
            
            UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 69, cell1_0.bounds.size.width, 1)];
            line.backgroundColor =customGrayColor;
            [cell1_0.contentView addSubview:line];
            
            //info1_0_0
            UILabel *info1_0 =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
            info1_0.tag = 1001;
            info1_0.font =[UIFont systemFontOfSize:14];
            info1_0.textColor = [UIColor colorWithWhite:0.75 alpha:1];
            [cell1_0.contentView addSubview:info1_0];
            
            //info1_0_1
            UILabel *info1_0_1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 200, 55)];
            info1_0_1.tag = 1002;
            info1_0_1.font =[UIFont systemFontOfSize:22];
            info1_0_1.textColor = baseRedColor;
            [cell1_0.contentView addSubview:info1_0_1];

            
            
            //cell1_0上得信息
            info1_0.text = @"今天打折扣哦！";
            
            //cell1_0_1上得信息
            info1_0_1.text = @"￥35";
            
            return cell1_0;
            
        }
        
        if(indexPath.row==1){//这里放uiwebview
            
            cell1_1 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell1_1.selectionStyle = NO;
            
            UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 84, cell1_1.bounds.size.width, 1)];
            line.backgroundColor =customGrayColor;
            [cell1_1.contentView addSubview:line];
            
            //webView显示内容
            [cell1_1.contentView addSubview:webView1];
           
            return cell1_1;
        }
        
        if(indexPath.row==2){//三个选项
        
            cell1_2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell1_2.selectionStyle = NO;
            
            UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 43, cell1_2.bounds.size.width, 1)];
            line.backgroundColor =customGrayColor;
            [cell1_2.contentView addSubview:line];
            
            
            UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(100, 0, 1, 44)];
            line1.backgroundColor = customGrayColor;
            [cell1_2.contentView addSubview:line1];
            
            UIView *line3 =[[UIView alloc]initWithFrame:CGRectMake(205, 0, 1, 44)];
            line3.backgroundColor =customGrayColor;
            [cell1_2 addSubview:line3];
            
            
            //支持随时退
            UILabel *supportPayback =[[UILabel alloc]initWithFrame:CGRectMake(25, 0, 80, 43)];
            supportPayback.font =[UIFont systemFontOfSize:13];
            supportPayback.textColor = baseTextColor;
            supportPayback.text = @"支持随时退";
            [cell1_2.contentView addSubview:supportPayback];
            
            //支持过期退
            UILabel *supportDelay =[[UILabel alloc]initWithFrame:CGRectMake(130, 0, 80, 43)];
            supportDelay.font =[UIFont systemFontOfSize:13];
            supportDelay.textColor = baseTextColor;
            supportDelay.text = @"支持过期退";
            [cell1_2.contentView addSubview:supportDelay];
            
            
            //无需预约
            UILabel *noAppointment =[[UILabel alloc]initWithFrame:CGRectMake(235, 0, 80, 43)];
            noAppointment.font =[UIFont systemFontOfSize:13];
            noAppointment.textColor = baseTextColor;
            noAppointment.text = @"无需预约";
            [cell1_2.contentView addSubview:noAppointment];

            
            //对勾1
            UIImageView *mark1 =[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 15, 15)];
            mark1.image =[UIImage imageNamed:@"绿色勾"];
            [cell1_2.contentView addSubview:mark1];
            
            //对勾2
            UIImageView *mark2 =[[UIImageView alloc]initWithFrame:CGRectMake(115, 15, 15, 15)];
            mark2.image =[UIImage imageNamed:@"绿色勾"];
            [cell1_2.contentView addSubview:mark2];
            
            
            //对勾3
            UIImageView *mark3 =[[UIImageView alloc]initWithFrame:CGRectMake(220, 15, 15, 15)];
            mark3.image =[UIImage imageNamed:@"绿色勾"];
            [cell1_2.contentView addSubview:mark3];

            
            return cell1_2;
        }
        
        if(indexPath.row==3 || indexPath.row==4){
      
            cell1_3_4 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell1_3_4.selectionStyle = NO;
            
            UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 43, cell1_3_4.bounds.size.width, 1)];
            line.backgroundColor =customGrayColor;
            [cell1_3_4.contentView addSubview:line];

            UIImageView *view =[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 15, 17)];
            
            UILabel *infoLabel =[[UILabel alloc]initWithFrame:CGRectMake(25, 5, 200, 35)];
            infoLabel.font =[UIFont systemFontOfSize:14];
            infoLabel.textColor =baseTextColor;
            infoLabel.adjustsFontSizeToFitWidth = YES;
            
            [cell1_3_4.contentView addSubview:view];
            [cell1_3_4.contentView addSubview:infoLabel];
            
            if(indexPath.row==3){//店铺地址
            
                view.image =[UIImage imageNamed:@"地标"];
                infoLabel.text = @"长沙岳麓区天马小区";
            }else{//电话号码
            
                view.image =[UIImage imageNamed:@"电话"];
                infoLabel.text = @"15575829007";
            }
            
            return cell1_3_4;
        }
        
    }
    
    if(indexPath.section==2){//商品详情
        
        cell2 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell2.selectionStyle = NO;
        
        [cell2.contentView addSubview:webView2];
        
        return cell2;
    
    }
    
    if(indexPath.section==3){//活动规则
        
        if(indexPath.row==0){
        
            cell3 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell3.selectionStyle = NO;
            
            [cell3.contentView addSubview:webView3];
            
            return cell3;

        }else{
        
            cell3_1 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell3_1.userInteractionEnabled = YES;
            
            UIButton *moreDetail =[UIButton buttonWithType:UIButtonTypeCustom];
            moreDetail.userInteractionEnabled = YES;
            moreDetail.frame = CGRectMake(3, 8, cell3_1.bounds.size.width-25, 40);
            [moreDetail setTitle:@"更多详情" forState:UIControlStateNormal];
            [moreDetail setTitleColor:baseTextColor forState:UIControlStateNormal];
            moreDetail.layer.borderWidth = 1;
            moreDetail.layer.borderColor = customGrayColor.CGColor;
            moreDetail.backgroundColor =[UIColor whiteColor];
            [cell3_1.contentView addSubview:moreDetail];
            moreDetail.titleLabel.font =[UIFont systemFontOfSize:14];
            [moreDetail addTarget:self action:@selector(showMoreThing) forControlEvents:UIControlEventTouchUpInside];
            
            return cell3_1;

        
        }
        
        
    }
    


    cell1_3_4 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    return cell1_3_4;
}


#pragma mark - 显示更多详情按钮触发
- (void)showMoreThing{

    MoreActivityDetailViewController *moreActivityDetail =[MoreActivityDetailViewController new];
    moreActivityDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreActivityDetail animated:YES];
    
}


#pragma mark 调试用 webView
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    NSLog(@"error:%@",[error localizedDescription]);
}



#pragma mark - 导航栏按钮触发
- (void)buttonClicked:(UIButton *)sender{

    if(sender.tag==10006){//回退按钮
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(sender.tag==1000){//收藏
        
        if(!isCollectioned){
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
            
            isCollectioned = YES;
        }else{
            
            UIButton *button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            isCollectioned = NO;
        }
        
        
        
    }
    
    if(sender.tag==1002){//分享
        
        
        NSLog(@"分享");
        
    }



}


/**
 *  @Author frankfan, 14-11-13 11:11:30
 *
 *  根据文字动态计算高度
 *
 *  @param string   输入文字
 *  @param fontSize 文字font大小
 *
 *  @return 返回文字所占的高度
 */
- (CGFloat)caculateTheTextHeight:(NSString *)string andFontSize:(int)fontSize{
    
    /*非彻底性封装,这里给定固定的宽度,后面的被减掉的阀值与高度成正比*/
    CGSize constraint = CGSizeMake(self.view.bounds.size.width-60, CGFLOAT_MAX);
    
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
