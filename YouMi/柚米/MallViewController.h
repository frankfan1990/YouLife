//
//  MallViewController.h
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger index;//接受传进来的index，用以区别不同数据的加载
@end
