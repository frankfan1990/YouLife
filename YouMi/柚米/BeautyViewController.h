//
//  BeautyViewController.h
//  youmi
//
//  Created by frankfan on 14/10/28.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeautyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger index;//接受传进来的index，用以区别不同数据的加载
@end
