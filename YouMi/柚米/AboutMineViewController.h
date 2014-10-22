//
//  AboutMineViewController.h
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutMineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton *headerImage;
@property (nonatomic,strong)UILabel *userID;
@property (nonatomic,strong)UILabel *phoneNumber;

@property (nonatomic,strong)UITableView *tableView;
@end
