//
//  EntertainmentDetailViewController.h
//  youmi
//
//  Created by frankfan on 14-9-10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//文化娱乐


#import <UIKit/UIKit.h>

@interface EntertainmentDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger index;//接受传进来的index，用以区别不同数据的加载

@property (nonatomic,assign)NSInteger whichMode_entertainment;//作用同上

@property (nonatomic,copy)NSString *shopTypeID_entertainment;//商铺类型标识
@end
