//
//  MallViewController.h
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//店铺详情

#import <UIKit/UIKit.h>
#import "ShopObjectModel.h"

@interface ItemDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@end
