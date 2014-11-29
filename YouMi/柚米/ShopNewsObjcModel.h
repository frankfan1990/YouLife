//
//  ShopNewsObjcModel.h
//  youmi
//
//  Created by frankfan on 14/11/27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//
/**
 *  @author frankfan, 14-11-26 10:11:55
 *
 *  Shop对象里面的子对象，商家资讯
 */


#import "MTLModel.h"

@interface ShopNewsObjcModel : MTLModel

@property (nonatomic,copy)NSString *createTime;//时间
@property (nonatomic,copy)NSString *newsId;
@property (nonatomic,copy)NSString *newsName;
@property (nonatomic,copy)NSString *shopId;
@property (nonatomic,copy)NSString *title;//标头
@end
