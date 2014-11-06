//
//  MyAttentionViewController.m
//  youmi
//
//  Created by frankfan on 14/10/30.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "UIImageView+WebCache.h"


@interface MyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    BOOL isEdit;//标志
    UIView *checkBoxView;//选择框背
    
    BOOL isShowCheckBox;
    BOOL checkBoxIsClicked;
    
    UIButton *rightbarButton;//编辑按钮
    
    NSMutableArray *recodeClickedArray;//记录点击的按钮
    
}
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *brandNameArray;
@end

@implementation MyAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = customGrayColor;
    //
    isEdit = NO;
    checkBoxIsClicked = NO;
    recodeClickedArray = [NSMutableArray array];
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"我的关注";
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

    
    
    /*rightbarButton*/
    rightbarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rightbarButton.tag = 402;
    rightbarButton.frame = CGRectMake(0, 0, 25, 25);
    [rightbarButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
  
    [rightbarButton addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightbarButton];
    self.navigationItem.rightBarButtonItem = rightbarButtonItem;

    
    /*创建segmentControl*/
    UIFont *font =[UIFont systemFontOfSize:18];
    NSAttributedString *product = [[NSAttributedString alloc]initWithString:@"商品" attributes:@{NSFontAttributeName:font}];
    
    NSAttributedString *shopper = [[NSAttributedString alloc]initWithString:@"店铺" attributes:@{NSFontAttributeName:font}];
    NSArray *segementItem =@[product,shopper];
    UISegmentedControl *segements =[[UISegmentedControl alloc]initWithItems:segementItem];
    segements.selectedSegmentIndex = 0;
    segements.tintColor = baseRedColor;
    segements.frame = CGRectMake(10, 64+5, self.view.bounds.size.width-20, 40);
    [self.view addSubview:segements];
    segements.backgroundColor =[UIColor whiteColor];
    
    
    
    /**
     *  @Author frankfan, 14-11-05 10:11:06
     *
     *  我的关注 tableView主体骨架创建
     *
     *  @return nil
     */
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 64+5+45, self.view.bounds.size.width-20, self.view.bounds.size.height-64-55-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = customGrayColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    
    /**
     *  @Author frankfan, 14-11-06 09:11:47
     *
     *  初始化基本dataSource
     *
     *  @param NSInteger nil
     *
     *  @return nil
     */
    
    self.brandNameArray =[NSMutableArray arrayWithObjects:@"商品一",@"商品二",@"商品三",@"商品四",@"商品五",@"商品六",@"商品七",@"商品八", nil];
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - cell个数
/**
 *  @Author frankfan, 14-11-05 10:11:13
 *
 *  返回cell个数
 *
 *  @param tableView tableView
 *  @param section   cell的section
 *
 *  @return 返回cell个数
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
#warning fake data
    return [self.brandNameArray count];
}


#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;

}

#pragma mark - tableView的编辑模式

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
    
    
        [self.brandNameArray removeObject:self.brandNameArray[indexPath.row]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    }

}


#pragma mark - cell将要出现 这里处理button的显示逻辑
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    UIButton *checkBox = (UIButton *)[cell viewWithTag:2000];
    if(![recodeClickedArray containsObject:indexPath]){
    
        checkBox.backgroundColor = customGrayColor;
    }else{
    
        checkBox.backgroundColor = baseRedColor;
    }
    

}




#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITableViewCell *cell =nil;
    static NSString *cellName = @"cell";
    cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.layer.cornerRadius = 2;
        cell.layer.masksToBounds = YES;
        cell.selectionStyle = NO;
        
        
        /**
         *  @Author frankfan, 14-11-05 11:11:32
         *
         *  开始创建cell里面的控件
         */
        cell.backgroundColor =customGrayColor;
        UILabel *backLoad =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 75)];
        backLoad.backgroundColor =[UIColor whiteColor];
        backLoad.layer.cornerRadius = 2;
        backLoad.layer.masksToBounds = YES;
        backLoad.userInteractionEnabled = YES;
        [cell.contentView addSubview:backLoad];
        
    
        /*商品照片*/
        UIImageView *headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 123, 75)];
        headerImageView.tag = 1001;
        headerImageView.layer.cornerRadius = 2;
        headerImageView.layer.masksToBounds = YES;

        UIImageView *arrowImageView =[[UIImageView alloc]initWithFrame:CGRectMake(headerImageView.bounds.size.width-12, headerImageView.bounds.size.height/2.0-8, 20, 20)];
        arrowImageView.image =[UIImage imageNamed:@"我的系列白色图标"];
        [cell.contentView addSubview:headerImageView];
        [cell.contentView addSubview:arrowImageView];
        
        
        /*商品名*/
        UILabel *productName = [[UILabel alloc]initWithFrame:CGRectMake(125,-5, 200, 40)];
        productName.tag = 1002;
        productName.textAlignment = NSTextAlignmentLeft;
        productName.font =[UIFont boldSystemFontOfSize:17];
        productName.textColor = baseTextColor;
        [backLoad addSubview:productName];
        
        /*价格*/
        UILabel *price =[[UILabel alloc]initWithFrame:CGRectMake(125, 42, 100, 40)];
        price.tag = 1003;
        price.textAlignment = NSTextAlignmentLeft;
        price.font =[UIFont systemFontOfSize:14];
        price.textColor = baseTextColor;
        [backLoad addSubview:price];
        
        
        /*创建选择框*/
        UIButton *checkBox =[UIButton buttonWithType:UIButtonTypeCustom];
        checkBox.tag = 2000;
        checkBox.frame = CGRectMake(260, 25, 20, 20);
        checkBox.backgroundColor = customGrayColor;
        checkBox.alpha = 0;
        [backLoad addSubview:checkBox];
        [checkBox addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
      
        
        
    }
    
    UIButton *checkBox = (UIButton *)[cell viewWithTag:2000];
    checkBox.userInteractionEnabled = YES;
    
    
    if(isShowCheckBox){
    
        [UIView animateWithDuration:0.3 animations:^{
            
       
            checkBox.alpha = 1;
        }];
        
    }else if (!isShowCheckBox){
    
        [UIView animateWithDuration:0.2 animations:^{
            
        
            checkBox.alpha = 0;
        }];
    }

    
    
    UIImageView *imageViewDelegate = (UIImageView *)[cell viewWithTag:1001];
    UILabel *productNameDelegate = (UILabel *)[cell viewWithTag:1002];
    UILabel *prideDelegate =(UILabel *)[cell viewWithTag:1003];
    
#warning fake data
    /*图像*/
    [imageViewDelegate sd_setImageWithURL:[NSURL URLWithString:@"http://www.seelii.cn/userdata/products/1267952446446_2.jpg"] placeholderImage:[UIImage imageNamed:@"defaultBackgroundImage"]];
    /*商品/店铺名*/
    productNameDelegate.text = self.brandNameArray[indexPath.row];
    /*价格*/
    prideDelegate.text = @"￥88.8";

    return cell;
    
    
}


#pragma mark - checkBox触发
- (void)checkBoxClicked:(UIButton *)sender{
    
    //检测点击按钮对应的indexPath
    CGPoint buttonPosition =[sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath =[self.tableView indexPathForRowAtPoint:buttonPosition];

    
    
    if(!checkBoxIsClicked){
        
        sender.backgroundColor = baseRedColor;
        checkBoxIsClicked = YES;
        [recodeClickedArray addObject:indexPath];
        
    }else{
        
        sender.backgroundColor = customGrayColor;
        checkBoxIsClicked = NO;
        [recodeClickedArray removeObject:indexPath];
        
    }
    

    
    NSLog(@"..%ld",(long)indexPath.row);
    

    
}



/**
 *  @Author frankfan, 14-10-30 13:10:26
 *
 *  导航栏按钮触发
 *
 *  @return nil
 */
#pragma mark - 导航栏按钮触发
- (void)navi_buttonClicked:(UIButton *)sender{
    
    if(sender.tag==401){
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        if(!isEdit){//打开编辑
            
            [rightbarButton setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateNormal];
            isEdit = YES;
            isShowCheckBox = YES;
            [self.tableView reloadData];

            
        }else{//关闭编辑
        
            [rightbarButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
            isEdit = NO;
            isShowCheckBox = NO;
            [self.tableView reloadData];
        }
        
   
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
