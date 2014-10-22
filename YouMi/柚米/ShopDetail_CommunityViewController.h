//
//  ShopDetail_CommunityViewController.h
//  youmi
//
//  Created by frankfan on 14-9-23.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//首页->社区便利->小区列表->附近优惠活动列表->店铺详情

#import <UIKit/UIKit.h>

@interface ShopDetail_CommunityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSString *headerTitle;/*头部标题*/
@property (nonatomic,strong)NSString *imageUrl;/*接受从上层传过来的链接*/

@property (nonatomic,strong)UILabel *shopName;
@property (nonatomic,strong)NSString *shopName_string;//店铺名文本
@property (nonatomic,strong)UILabel *shopTag;
@property (nonatomic,strong)UILabel *workingTime;
@property (nonatomic,strong)UILabel *shopAddress;
@property (nonatomic,strong)UIButton *phoneNumber;
@property (nonatomic,strong)NSString *phoneNumber_string;//电话文本
@property (nonatomic,strong)NSString *content_string;//详情


@property (nonatomic,strong)UITableView *tableView;
@end
