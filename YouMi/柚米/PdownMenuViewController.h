//
//  PdownMenuViewController.h
//  youmi
//
//  Created by frankfan on 14-9-29.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullDownMenuCallBack <NSObject>

@optional
- (void)pullDownMenuCallBack:(NSInteger)whichModel andDetailInfo:(NSString *)detailInfo andTheDataSource:(NSArray *)dataSource;

@end

@interface PdownMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *theLoadView;/*承载tableView的superView*/
@property (nonatomic,strong)UITableView *tableView_left;
@property (nonatomic,strong)UITableView *tableView_right;
@property (nonatomic,strong)UITableView *tableView_single;//当theLoadView上只有一个tableView

@property (nonatomic,assign)NSInteger selectedTag;/*这个值用来判断当前选择的模块，从而相应改变view的结构*/

@property (nonatomic,strong)NSMutableArray *metes_dataSource;/*1000米*/

@property (nonatomic,assign)id<PullDownMenuCallBack>delegate;


@end
