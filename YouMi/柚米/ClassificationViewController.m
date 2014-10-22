//
//  ClassificationViewController.m
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//分类模块

#import "ClassificationViewController.h"
#import "ClassificationTableViewCell.h"
#import "DataAboutTitle.h"
#import "POP.h"

@interface ClassificationViewController ()
{

    CGFloat arrowPosiotonY;/**/
    CGFloat arrowCurrentPositionY;
    CGFloat arrowCurrentPosiotionY3;
    CGFloat arrowPositionY3;
}

@property (nonatomic,strong)DataAboutTitle *aboutTitles;
@property (nonatomic,strong)NSArray *images;

@property (nonatomic,strong)UIImageView *arrowImageView;/*指示小箭头*/
@property (nonatomic,strong)UIImageView *arrowImageView3;/*指示小箭头3*/
@end

@implementation ClassificationViewController

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
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"分类";
    title.textColor = baseRedColor;
    self.navigationItem.titleView = title;
    
    /*rightBarButton*/
    UIButton *rightbutton =[UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 30, 30);
    [rightbutton setImage:[UIImage imageNamed:@"搜索icon@2x.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    ////////////////////////////////////////////////////////
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50)];
    self.tableView.tag = 3001;
    self.tableView.rowHeight = 57;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor =[UIColor colorWithWhite:0.95 alpha:0.9];
//    self.tableView.scrollEnabled  = NO;
    [self.view addSubview:self.tableView];
    
    //////////////////////////////////////////////////////////
    
#pragma mark 2级次级菜单
    self.tableView2 =[[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 64, 320, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView2.backgroundColor =[UIColor colorWithWhite:0.92 alpha:1];
    self.tableView2.tag = 3002;
    self.tableView2.rowHeight = 57;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.view addSubview:self.tableView2];
    
#pragma mark 3级次级菜单
    self.tableView3 =[[UITableView alloc]initWithFrame:CGRectMake(320, 64, 200, self.view.bounds.size.height-49) style:UITableViewStylePlain];
    self.tableView3.tag = 3003;
    self.tableView3.rowHeight = 57;
    self.tableView3.backgroundColor =[UIColor colorWithWhite:0.88 alpha:1];
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    [self.view addSubview:self.tableView3];
    
    
    /**/
    self.aboutTitles = [DataAboutTitle shareWithInstance];
    
    self.images = @[@"美食.png",@"娱乐.png",@"教育.png",@"社区.png",@"健身.png",@"医疗.png",@"美容.png",@"酒店.png"];

    /*添加pan 手势 用以滑动隐藏次级菜单*/
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureBeingEX:)];
    pan.delegate = self;
    [self.tableView2 addGestureRecognizer:pan];
    
    /**/
    UIPanGestureRecognizer *pan3 =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureEX3:)];
    pan3.delegate = self;
    [self.tableView3 addGestureRecognizer:pan3];
    
    /*指示小箭头*/
    self.arrowImageView =[[UIImageView alloc]initWithFrame:CGRectMake(51, 0, 25, 25)];
    self.arrowImageView.image = [UIImage imageNamed:@"2级分类箭头"];
    [self.view addSubview:self.arrowImageView];
//    self.arrowImageView.backgroundColor =[UIColor blackColor];
 
    /*指示小箭头3*/
    self.arrowImageView3 =[[UIImageView alloc]initWithFrame:CGRectMake(155, 0, 25, 25)];
    self.arrowImageView3.image =[UIImage imageNamed:@"三级分类箭头"];
    [self.view addSubview:self.arrowImageView3];
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark 搜索按钮点击
- (void)searchButtonClicked{



}

#pragma mark 处理tableView滚动事件【箭头指示位置】
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    

    if(scrollView.tag==3001){
        
        CGPoint offset = scrollView.contentOffset;
        arrowCurrentPositionY = arrowPosiotonY-57-offset.y;
        self.arrowImageView.frame = CGRectMake(51, arrowCurrentPositionY-5, 25, 25);
        
        if(offset.y<-90 && self.arrowImageView.frame.origin.y<40){
            NSLog(@"%f",offset.y);
            self.arrowImageView.image = nil;
        }
        
    }if(scrollView.tag==3002){
        
        CGPoint offset = scrollView.contentOffset;
        arrowCurrentPosiotionY3 = arrowPositionY3-offset.y;
        self.arrowImageView3.frame = CGRectMake(155, arrowCurrentPosiotionY3, 25, 25);

        
        NSLog(@"~~~");
    }
    
    
    
}



#pragma mark pan手势回调方法 隐藏次级菜单(二级)
- (void)panGestureBeingEX:(UIPanGestureRecognizer *)gesture{

//    CGPoint beginPoint;
    CGPoint transitioPoint;
    CGPoint endPoint;
    
    transitioPoint =[gesture translationInView:self.tableView2];
    CGFloat positionX = transitioPoint.x;
    if(!self.tableView2.dragging && transitioPoint.x>5){/*这里的逻辑是：此时必须是左右滑动，并且滑动的距离超过5才会触发事件*/
    
        
        self.tableView2.frame = CGRectMake(65+positionX, 64, 320, self.view.bounds.size.height-49);
        if(self.arrowImageView.frame.origin.y !=0){
            
            /*这里面的参数-2，为magic number 我也不知道为什么是这个值，but it work!/arrowCurrentPositionY+*/
            self.arrowImageView.frame = CGRectMake(51+positionX-1, arrowPosiotonY, 25, 25);
        }

        if(self.tableView3.frame.origin.x != 320){
        
            self.tableView3.frame = CGRectMake(169+positionX, 64, 200, self.view.bounds.size.height-49);
        }
        
        if(self.arrowImageView3.frame.origin.y != 0){
            
            self.arrowImageView3.frame = CGRectMake(155+positionX, self.arrowImageView3.frame.origin.y, 25, 25);
        }

        

    }
    if(gesture.state==UIGestureRecognizerStateEnded){
    
        endPoint = [gesture locationInView:self.view];
        if(self.tableView2.frame.origin.x<150){
        
            POPSpringAnimation *springAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            springAnimation.springSpeed = 16;
            springAnimation.springBounciness = 1;
            springAnimation.toValue =[NSValue valueWithCGRect:CGRectMake(65, 64, 320, self.view.bounds.size.height-49)];
            [self.tableView2 pop_addAnimation:springAnimation forKey:@"springAnimation1"];
            
            /*箭头标志回弹*arrowCurrentPositionY+*/
            POPSpringAnimation *arrowSpring =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            arrowSpring.springSpeed = 16;
            arrowSpring.springBounciness = 1;
            arrowSpring.toValue =[NSValue valueWithCGRect:CGRectMake(51, arrowPosiotonY, 25, 25)];
            [self.arrowImageView pop_addAnimation:arrowSpring forKey:@"arrowSpring"];
            
            /*3级标志回弹*/
            POPSpringAnimation *arrowSpring3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            arrowSpring3.springSpeed = 16;
            arrowSpring3.springBounciness = 1;
            arrowSpring3.toValue =[NSValue valueWithCGRect:CGRectMake(155, self.arrowImageView3.frame.origin.y, 25, 25)];
            [self.arrowImageView3 pop_addAnimation:arrowSpring3 forKey:@"arrowSpring3"];
            
            
            /*3级菜单联动2级菜单*/
            POPSpringAnimation *springAnimation3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            springAnimation3.springSpeed = 16;
            springAnimation3.springBounciness = 1;
            springAnimation3.toValue =[NSValue valueWithCGRect:CGRectMake(169, 64, 200, self.view.bounds.size.height-49)];
            [self.tableView3 pop_addAnimation:springAnimation3 forKey:@"springAnimation3"];
        
        }else{
        
            POPSpringAnimation *springAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            springAnimation.springSpeed = 16;
            springAnimation.springBounciness = 1;
            springAnimation.toValue =[NSValue valueWithCGRect:CGRectMake(self.view.bounds.size.width, 64, 320, self.view.bounds.size.height-49)];
            [self.tableView2 pop_addAnimation:springAnimation forKey:@"springAnimation2"];
            
            /*箭头标志隐藏*/
            /*箭头标志*arrowCurrentPositionY+*/
            POPSpringAnimation *arrowSpring =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            arrowSpring.springSpeed = 16;
            arrowSpring.springBounciness = 1;
            arrowSpring.toValue =[NSValue valueWithCGRect:CGRectMake(self.view.bounds.size.width, arrowPosiotonY, 25, 25)];
            [self.arrowImageView pop_addAnimation:arrowSpring forKey:@"arrowSpring"];
//            self.arrowImageView.frame = CGRectMake(55, 0, 25, 25);
            
            
            /*3箭头标志隐藏*/
            /*3箭头标志*arrowCurrentPositionY+*/
         
            POPSpringAnimation *arrowSpring3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            arrowSpring3.springSpeed = 16;
            arrowSpring3.springBounciness = 1;
            arrowSpring3.toValue =[NSValue valueWithCGRect:CGRectMake(self.view.bounds.size.width, self.arrowImageView3.frame.origin.y, 25, 25)];
            [self.arrowImageView3 pop_addAnimation:arrowSpring3 forKey:@"arrowSpring4"];
//            self.arrowImageView3.frame = CGRectMake(159, 0, 19, 19);
            
            
            /*3级菜单联动2级菜单*/
            POPSpringAnimation *springAnimation3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            springAnimation3.springSpeed = 16;
            springAnimation3.springBounciness = 1;
            springAnimation3.toValue =[NSValue valueWithCGRect:CGRectMake(self.view.bounds.size.width, 64, 200, self.view.bounds.size.height-49)];
            [self.tableView3 pop_addAnimation:springAnimation3 forKey:@"springAnimation3"];


        }
        
        
    }
    
}



#pragma mark pan手势回调 隐藏次级菜单(三级)

- (void)panGestureEX3:(UIPanGestureRecognizer *)gesture{

//    CGPoint beginPoint;
    CGPoint transitioPoint;
    CGPoint endPoint;
    
    transitioPoint =[gesture translationInView:self.tableView2];
    if(!self.tableView3.dragging && transitioPoint.x>5 && self.tableView3.frame.origin.x != 320){/*这里的逻辑是：此时必须是左右滑动，并且滑动的距离超过5才会触发事件*/
        
        CGFloat positionX = transitioPoint.x;
     
        self.tableView3.frame = CGRectMake(169+positionX, 64, 200, self.view.bounds.size.height-49);
        if(self.arrowImageView3.frame.origin.y != 0){
        
            self.arrowImageView3.frame = CGRectMake(155+positionX, self.arrowImageView3.frame.origin.y, 25, 25);
        }
        
    }
    if(gesture.state==UIGestureRecognizerStateEnded){
        
        endPoint = [gesture locationInView:self.view];
        if(self.tableView3.frame.origin.x<250){
            
            POPSpringAnimation *springAnimation3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            springAnimation3.springSpeed = 16;
            springAnimation3.springBounciness = 1;
            springAnimation3.toValue =[NSValue valueWithCGRect:CGRectMake(169, 64, 200, self.view.bounds.size.height-49)];
            [self.tableView3 pop_addAnimation:springAnimation3 forKey:@"springAnimation3"];
            
            /*指示标回弹*/
            /*3级标志回弹*/
            POPSpringAnimation *arrowSpring3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            arrowSpring3.springSpeed = 16;
            arrowSpring3.springBounciness = 1;
            arrowSpring3.toValue =[NSValue valueWithCGRect:CGRectMake(155, self.arrowImageView3.frame.origin.y, 25, 25)];
            [self.arrowImageView3 pop_addAnimation:arrowSpring3 forKey:@"arrowSpring3"];

            
            
        }else{
            
            POPSpringAnimation *springAnimation3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            springAnimation3.springSpeed = 16;
            springAnimation3.springBounciness = 1;
            springAnimation3.toValue =[NSValue valueWithCGRect:CGRectMake(320, 64, 200, self.view.bounds.size.height-49)];
            [self.tableView3 pop_addAnimation:springAnimation3 forKey:@"springAnimation3"];
            
            /*3箭头标志隐藏*/
            /*3箭头标志*arrowCurrentPositionY+*/
            
            POPSpringAnimation *arrowSpring3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            arrowSpring3.springSpeed = 16;
            arrowSpring3.springBounciness = 1;
            arrowSpring3.toValue =[NSValue valueWithCGRect:CGRectMake(self.view.bounds.size.width, self.arrowImageView3.frame.origin.y, 25, 25)];
            [self.arrowImageView3 pop_addAnimation:arrowSpring3 forKey:@"arrowSpring3"];

            
            
        }
        
        
    }

    
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if(tableView.tag==3001){
    
    
        return [self.aboutTitles.titles count];
    }else if (tableView.tag==3002){
    
#warning fake data 这个数字根据dataArray返回，待改
        return 13;/*这个10为fake data，需要根据需求修改为真实分类个数*/
    }else{
    
        return 13;
    }
    
    return 0;
}


#pragma mark 次级菜单的生成与布局
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ClassificationTableViewCell *cell =[ClassificationTableViewCell cellWithTableView:tableView];
    if(tableView.tag==3001){
    
        cell.title.text = self.aboutTitles.titles[indexPath.row];
        cell.headerImageView.image =[UIImage imageNamed:self.images[indexPath.row]];
        if(indexPath.row==5 ||indexPath.row==6 || indexPath.row==7){
            
            
            cell.headerImageView.frame = CGRectMake(10, 3.5, 46, 46);
        }
    }else if(tableView.tag==3002){/*2级菜单*/
    
    
        cell.textLabel.text = @"二级菜单";
        cell.backgroundColor =[UIColor colorWithWhite:0.92 alpha:1];
        cell.textLabel.font =[UIFont systemFontOfSize:14];
        cell.textLabel.textColor = baseTextColor;
        [cell.customBackgroundView removeFromSuperview];
        
    }if(tableView.tag==3003){/*3级菜单*/
    
        cell.textLabel.text = @"三级菜单";
        cell.backgroundColor =[UIColor colorWithWhite:0.88 alpha:1];
        cell.textLabel.font =[UIFont systemFontOfSize:12];
        cell.textLabel.textColor = baseTextColor;
        [cell.customBackgroundView removeFromSuperview];
    }
    
    return cell;

}


#pragma mark 次级菜单的触发事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(tableView.tag==3001){/*主菜单栏被点击*/
    
        self.arrowImageView.image = [UIImage imageNamed:@"2级分类箭头"];//fix bug 
        POPSpringAnimation *springAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        springAnimation.springSpeed = 16.0;
        springAnimation.springBounciness = 5.0;
        springAnimation.toValue =[NSValue valueWithCGRect:CGRectMake(65, 64, 320, self.view.bounds.size.height-49)];
        [self.tableView2 pop_addAnimation:springAnimation forKey:@"springAniamtion2"];
        ///
        /*获取箭头动画目的位置*/
        arrowPosiotonY = 54+57*(indexPath.row+1)-57/2.0;
        
        CGRect rectOFcellIntableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfinSuperView = [tableView convertRect:rectOFcellIntableView toView:[tableView superview]];
        
        
        
        /*指示器位置动画*/
        POPSpringAnimation *arrow_springAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        arrow_springAnimation.springSpeed = 16;
        arrow_springAnimation.springBounciness = 1;
        arrow_springAnimation.toValue =[NSValue valueWithCGRect:CGRectMake(51, rectOfinSuperView.origin.y+57.0/2.0-9, 25, 25)];
        [self.arrowImageView pop_addAnimation:arrow_springAnimation forKey:@"arrow_animtion"];
        
#pragma mark 点击隐藏3级菜单
        
        if(self.tableView3.frame.origin.x!=self.view.bounds.size.width && self.arrowImageView3.frame.origin.x!=self.view.bounds.size.width){
        
            POPSpringAnimation *springAnimation3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            springAnimation3.springSpeed = 16;
            springAnimation3.springBounciness = 1;
            springAnimation3.toValue =[NSValue valueWithCGRect:CGRectMake(320, 64, 200, self.view.bounds.size.height-49)];
            [self.tableView3 pop_addAnimation:springAnimation3 forKey:@"springAnimation3"];
            
            /*3箭头标志隐藏*/
            /*3箭头标志*arrowCurrentPositionY+*/
            
            POPSpringAnimation *arrowSpring3 =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            arrowSpring3.springSpeed = 16;
            arrowSpring3.springBounciness = 1;
            arrowSpring3.toValue =[NSValue valueWithCGRect:CGRectMake(self.view.bounds.size.width, self.arrowImageView3.frame.origin.y, 25, 25)];
            [self.arrowImageView3 pop_addAnimation:arrowSpring3 forKey:@"arrowSpring3"];

            
        
        }
        
        
        
    }else if (tableView.tag==3002){/*2级菜单被点击*/
    
        POPSpringAnimation *springAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        springAnimation.springSpeed = 9.0;
        springAnimation.springBounciness = 1;
        springAnimation.toValue =[NSValue valueWithCGRect:CGRectMake(169, 64, 200, self.view.bounds.size.height-49)];
        [self.tableView3 pop_addAnimation:springAnimation forKey:@"springAniamtion3"];
        
   
        /*获取箭头动画目的位置*54+*/
        
            CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
            CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];

            arrowPositionY3 = 54+57*(indexPath.row+1)-57/2.0;
                        /*指示器位置动画*/
            POPSpringAnimation *arrow_springAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            arrow_springAnimation.springSpeed = 16;
            arrow_springAnimation.springBounciness = 1;
            arrow_springAnimation.toValue =[NSValue valueWithCGRect:CGRectMake(155, rectOfCellInSuperview.origin.y+57.0/2.0-9, 25, 25)];
            [self.arrowImageView3 pop_addAnimation:arrow_springAnimation forKey:@"arrow_animtion"];

        
    }



}






- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{


    return YES;
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
