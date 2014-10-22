//
//  ClassificationViewController.h
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIScrollViewDelegate>


@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITableView *tableView2;/*2级菜单*/
@property (nonatomic,strong)UITableView *tableView3;/*3级菜单*/
@end
