//
//  ShopPicsObjcModel.h
//  youmi
//
//  Created by frankfan on 14/11/26.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//
/**
 *  @author frankfan, 14-11-26 10:11:55
 *
 *  Shop对象里面的子对象，轮播图片对象
 */

#import "MTLModel.h"

@interface ShopPicsObjcModel : MTLModel

@property (nonatomic,copy)NSString *pictureId;
@property (nonatomic,copy)NSString *fileCopy;//图片路径
@property (nonatomic,copy)NSString *pictureName;//图片名字
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *fileName;
@property (nonatomic,copy)NSString *shopId;
@property (nonatomic,copy)NSString *goodsId;
@end
