//
//  FoodDetailViewController.h
//  youmi
//
//  Created by frankfan on 14-9-10.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADTransitionController/ADTransitionController.h"


@interface FoodDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger index;//接受传进来的index，用以区别不同数据的加载
@property (nonatomic,assign)NSInteger whichMode;//作用同上

@property (nonatomic,copy)NSString *shopTypeID;//商铺类型标识
@end
