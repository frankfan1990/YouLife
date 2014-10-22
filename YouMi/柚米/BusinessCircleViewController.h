//
//  BusinessCircleViewController.h
//  youmi
//
//  Created by frankfan on 14-9-11.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCircleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *static_tableView;
@property (nonatomic,strong)UITableView *flex_tableView;

@property (nonatomic,strong)NSMutableArray *BusinessCirArray;
@end
