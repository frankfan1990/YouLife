//
//  UserCommentTableViewCell.h
//  youmi
//
//  Created by frankfan on 14/11/12.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCommentTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *theCommenter;//来自某用户
@property (nonatomic,strong)UILabel *theDay;//某天
@property (nonatomic,strong)UILabel *theTime;//某时
@property (nonatomic,strong)UILabel *commentContent;//评论内容

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
