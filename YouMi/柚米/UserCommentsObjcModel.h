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

@property (nonatomic,copy)NSString *commentId;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *ipAddress;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,copy)NSString *shopId;
@property (nonatomic,copy)NSString *goodsId;
@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,assign)NSInteger tasteStars;
@property (nonatomic,assign)NSInteger serviceStars;
@property (nonatomic,assign)NSInteger environmentStars;
@property (nonatomic,copy)NSString *pictures;
@property (nonatomic,assign)NSInteger isComment;
@property (nonatomic,copy)NSString *shopName;
@property (nonatomic,copy)NSString *goodsName;
@property (nonatomic,assign)NSInteger commentType;
@property (nonatomic,assign)double price;
@property (nonatomic,copy)NSString *header;
@property (nonatomic,copy)NSString *goodsPicture;
@property (nonatomic,copy)NSString *nickName;
@end
