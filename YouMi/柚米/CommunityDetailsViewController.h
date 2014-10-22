//
//  CommunityDetailsViewController.h
//  youmi
//
//  Created by frankfan on 14-9-19.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//社区便利->小区

#import <UIKit/UIKit.h>

@interface CommunityDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *communityName;
@end
