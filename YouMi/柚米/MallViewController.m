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
#import "MJRefresh.h"
#import "POP.h"
#import "PdownMenuViewController.h"

/*fake data*/
#define arrayCount 10

@interface MallViewController ()
{
    
    NSString *_metereString;
    
    /*modul_begin*///
    NSMutableArray *statuRecode_array;
    /*modul_end*////
    NSMutableArray *storeTheTag;//存储点击的tag

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

@property (nonatomic,strong)PdownMenuViewController *downMenu;
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
    
    self.index = 11;
    
    //
    storeTheTag =[NSMutableArray array];//存放被点击的tag
    statuRecode_array =[NSMutableArray array];
    

    
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
    self.arrow1.tag=2001;
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
    self.arrow2.tag = 2002;
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
    self.arrow3.tag = 2003;
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
    
    self.mainScrillerView =[[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180) animationDuration:3.2];
    __weak MallViewController *_self = self;
    self.mainScrillerView.totalPagesCount = ^NSInteger(void){
    
    
        return [_self.imagesArray count];
    };
    
    self.mainScrillerView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
    
        return _self.imagesArray[pageIndex];
    };
    
    self.mainScrillerView.TapActionBlock = ^(NSInteger pageIndex){
    
    
        NSLog(@"index:%ld",(long)pageIndex);
    };
    
    
    [self.view addSubview:self.mainScrillerView];
    
    
#pragma mark 创建tableView
    
//    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 294, self.view.bounds.size.width, self.view.bounds.size.height-49-294) style:UITableViewStylePlain];
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 114, self.view.bounds.size.width, self.view.bounds.size.height-49-114) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    /**
     *  @Author frankfan, 14-10-28 14:10:38
     *
     *  添加下拉刷新和上拉加载
     *
     *  @return nil
     */
    [self.tableView addHeaderWithTarget:self action:@selector(pullDownToRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(pullUpToReferesh)];
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - 下拉刷新回调方法
- (void)pullDownToRefresh{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView headerEndRefreshing];
    });

}


#pragma mark - 上拉加载
- (void)pullUpToReferesh{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView footerEndRefreshing];
    });

}




#pragma mark 3个按钮触发事件

- (void)buttonClicked:(UIButton *)sender{
    /*动画模块_begin*/
    NSInteger whichTag;
    if(sender.tag==1001){
        
        whichTag = 2001;
    }else if (sender.tag==1002){
        
        whichTag = 2002;
    }else{
        
        whichTag = 2003;
    }
    
    
    if([storeTheTag count]<3){
        
        if([storeTheTag count]==2){
            
            [storeTheTag removeObjectAtIndex:0];
            [storeTheTag addObject:[NSNumber numberWithInteger:whichTag]];
            
        }else{
            
            [storeTheTag addObject:[NSNumber numberWithInteger:whichTag]];
        }
        
    }
    
    if([storeTheTag count]==2){
        
        if([storeTheTag[0]integerValue] == [storeTheTag[1]integerValue]){
            
            UIImageView *arrow = (UIImageView *)[self.view viewWithTag:[storeTheTag[0]integerValue]];
            
            POPSpringAnimation *rotate_animation =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotate_animation.toValue = @(0);
            [arrow.layer pop_addAnimation:rotate_animation forKey:@"1"];
            [storeTheTag removeAllObjects];
            
        }else{
            
            UIImageView *arrow_old = (UIImageView *)[self.view viewWithTag:[storeTheTag[0]integerValue]];
            UIImageView *arrow_new =(UIImageView *)[self.view viewWithTag:[storeTheTag[1]integerValue]];
            
            POPSpringAnimation *arrow_oldAniamtion =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            arrow_oldAniamtion.toValue = @(0);
            [arrow_old.layer pop_addAnimation:arrow_oldAniamtion forKey:@"2"];

            
            POPSpringAnimation *arrow_newAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            arrow_newAnimation.toValue = @(M_PI);
            [arrow_new.layer pop_addAnimation:arrow_newAnimation forKey:@"3"];

           
        }
        
    }else{
        
        UIImageView *arrow =(UIImageView *)[self.view viewWithTag:[storeTheTag[0]integerValue]];
        
        POPSpringAnimation *rorate_animation =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rorate_animation.toValue = @(M_PI);
        [arrow.layer pop_addAnimation:rorate_animation forKey:@"4"];
        
        
    }
    /*动画模块_end*/
    
    
    
    ////////////////////
    /*状态机 begin*/
    if([statuRecode_array count]<3){
        
        if([statuRecode_array count]==2){
            
            [statuRecode_array removeObjectAtIndex:0];
            [statuRecode_array addObject:[NSNumber numberWithInteger:sender.tag]];
            
        }else{
            
            [statuRecode_array addObject:[NSNumber numberWithInteger:sender.tag]];
        }
        
    }
    /*状态机 end*/
    
    
    if([statuRecode_array count]==2){
        
        if([statuRecode_array[0]integerValue]==[statuRecode_array[1]integerValue]){
            
            if(self.downMenu.theLoadView.frame.origin.y>0){
                
                self.downMenu.view = nil;
                self.downMenu = nil;
                [statuRecode_array removeAllObjects];
                
            }else{
                
                [UIView animateWithDuration:0.35 animations:^{
                    
                    self.downMenu.theLoadView.frame = CGRectMake(0, 114, self.view.bounds.size.width, 300);
                }];
            }
            
            
            
        }else{
            
            self.downMenu.view = nil;
            self.downMenu = nil;
            self.downMenu =[[PdownMenuViewController alloc]init];
            self.downMenu.selectedTag = sender.tag;
            
            //            [self.view insertSubview:self.downMenu.view belowSubview:self.tableView];
            [self.view insertSubview:self.downMenu.view aboveSubview:self.tableView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.35 animations:^{
                    
                    self.downMenu.theLoadView.frame = CGRectMake(0, 114, self.view.bounds.size.width, 300);
                }];
                
            });
            
            
        }
    }else{
        
        
        self.downMenu.view = nil;
        self.downMenu = nil;
        self.downMenu =[[PdownMenuViewController alloc]init];
        self.downMenu.selectedTag = sender.tag;
        
        //        [self.view insertSubview:self.downMenu.view belowSubview:self.tableView];
        [self.view insertSubview:self.downMenu.view aboveSubview:self.tableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.35 animations:^{
                
                self.downMenu.theLoadView.frame = CGRectMake(0, 114, self.view.bounds.size.width, 300);
            }];
            
        });
        
        
    }
    
    //if(self.downMenu && sender.tag==1001)
    if(self.downMenu){
        
        
        NSArray *flag = @[[NSNumber numberWithInteger:self.index],[NSNumber numberWithInteger:sender.tag]];//将两个标志[首页按钮,三个按钮]传过去，区别的加载数据
        [[NSNotificationCenter defaultCenter]postNotificationName:kPassLeftData_0 object:flag];
    }
    


}


#pragma mark tableView代理方法——tableView生成cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return arrayCount+1;
}


#pragma mark tableView代理方法-tableView创建cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *headCell = nil;
    MainPageCustomTableViewCell *cell = nil;
    
    if(indexPath.row==0){
    
        headCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [headCell.contentView addSubview:self.mainScrillerView];
        return headCell;
    }
    
    if(indexPath.row != 0){
    
        cell = [MainPageCustomTableViewCell cellWithTableView:tableView];
        return cell;
    }
    

    return nil;

}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        
        return 180;
    }else{
    
        return commomCellHeight;
    }

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
