//
//  UserCartObject.h
//  youmi
//
//  Created by frankfan on 14/12/15.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MTLModel.h"

@interface UserCartObject : MTLModel

@property (nonatomic, assign) double goodsPrice;
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *cartId;
@property (nonatomic, assign) double markerPrice;
@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, assign) double goodsNumber;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *goodsPicture;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *goodsId;

@end
