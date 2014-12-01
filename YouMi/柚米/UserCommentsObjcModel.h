//
//  UserCommentsObjcModel.h
//  youmi
//
//  Created by frankfan on 14/12/1.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//
//
/**
 *  @author frankfan, 14-11-26 10:11:55
 *
 *  Shop对象里面的子对象，用户评论
 */

#import "MTLModel.h"

@interface UserCommentsObjcModel : MTLModel

@property (nonatomic,copy)NSString *userName;// 用户名
@property (nonatomic,copy)NSString *createTime;// 时间
@property (nonatomic,copy)NSString *content;// 评论内容
@end
