//
//  AboutMoreViewController.m
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "AboutMoreViewController.h"

@interface AboutMoreViewController ()
{

    NSArray *itemNames1;
    NSArray *itemNames2;
    NSArray *itemNames3;

    UISwitch *switchCV;
    NSInteger switchCVIsSelected;
}
@end

@implementation AboutMoreViewController

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
    //
    switchCVIsSelected = 0;
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"更多";
    title.textColor = baseRedColor;
    self.navigationItem.titleView = title;

    /**/
    int height = 0;
    if(self.view.bounds.size.height==480){
        
        height = 60;
    }else{
    
        height = 0;
    }
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height-height) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 39;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorStyle = NO;
    self.tableView.separatorColor =[UIColor clearColor];
    if(self.view.frame.size.height==480){
    
          self.tableView.scrollEnabled = YES;
    }else{
    
    
          self.tableView.scrollEnabled = NO;
    }
    
    
    [self.view addSubview:self.tableView];
    
    
    /**/
    itemNames1 = @[@"仅wifi下显示图片",@"分享设置",@"新手帮助"];
    itemNames2 = @[@"意见反馈",@"版本更新",@"关于优生活",@"告诉朋友"];
    itemNames3 = @[@"评分",@"清空缓存"];
    
    ///
    if([[NSUserDefaults standardUserDefaults]boolForKey:kShowPicOnlyInWifi]){
    
        switchCVIsSelected = 1;
        
    }else{
    
        switchCVIsSelected = 0;
    }
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark tableView代理-cell的生成个数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(section==0){
    
        return 3;
    }else if (section==1){
    
        return 4;
    }else{
    
        return 2;
    }

}


#pragma mark cell的创建
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellName = @"cellName";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if(indexPath.row ==0 && indexPath.section==0){
    
        cell.accessoryType = NO;
    }
    
    /**/
    if(indexPath.row==0 && indexPath.section==0){
    
        switchCV =[[UISwitch alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-70, 4, 0, 0)];
        switchCV.onTintColor = baseRedColor;
        [cell.contentView addSubview:switchCV];
        [switchCV addTarget:self action:@selector(TheSwitchControlCalled:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = NO;
        
        if(switchCVIsSelected){
        
            switchCV.on = YES;
        }else{
        
        
            switchCV.on = NO;
        }
    
    }
    
    if(indexPath.section==0){
    
        cell.textLabel.text = itemNames1[indexPath.row];
        cell.textLabel.font =[UIFont systemFontOfSize:15];
        cell.textLabel.textColor = baseTextColor;
    }else if (indexPath.section==1){
    
        cell.textLabel.text = itemNames2[indexPath.row];
        cell.textLabel.font =[UIFont systemFontOfSize:15];
        cell.textLabel.textColor = baseTextColor;
    
    }else{
    
        cell.textLabel.text = itemNames3[indexPath.row];
        cell.textLabel.font =[UIFont systemFontOfSize:15];
        cell.textLabel.textColor = baseTextColor;
        
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    }
    
    return cell;

}

#pragma mark 开关控件的触发
- (void)TheSwitchControlCalled:(UISwitch *)sender{

 
    if(sender.on){
    
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showPicOnlyInWifi"];
        
    }else{
    
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showPicOnlyInWifi"];
    
    }

}





#pragma mark 自定义tableView group style
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 5.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
                
                lineLayer.borderWidth = 2;
                lineLayer.borderColor =[UIColor colorWithWhite:0.85 alpha:0.9].CGColor;
                
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
            
            layer.strokeColor =[UIColor colorWithWhite:0.85 alpha:0.9].CGColor;

            
        }
    }





}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if(section==0){
    
        return 0.1;
    }else{
    
    
        return 20;
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
