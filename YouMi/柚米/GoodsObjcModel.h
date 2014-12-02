//
//  GoodsObjcModel.h
//  youmi
//
//  Created by frankfan on 14/11/28.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//
/**
 *  @author frankfan, 14-11-28 14:11:12
 *
 *  Shop对象里的子对象 特惠活动/商品详情
 */

#import "MTLModel.h"
#import "RuleDetail.h"

@interface GoodsObjcModel : MTLModel

@property (nonatomic,copy)NSString *goodsId;    //商品编号
@property (nonatomic,copy)NSString *goodsName;  //商品名称
@property (nonatomic,copy)NSString *shopId;     //商铺编号
@property (nonatomic,copy)NSString *shopName;   //商铺名称
@property (nonatomic,assign)double price;//价格
@property (nonatomic,copy)NSString *typeId;//所属商铺
@property (nonatomic,copy)NSString *typeName;
@property (nonatomic,copy)NSString *startDate;
@property (nonatomic,copy)NSString *endDate;
@property (nonatomic,copy)NSString *goodsPicture;
@property (nonatomic,assign)NSInteger stock;
@property (nonatomic,copy)NSString *brandId;
@property (nonatomic,copy)NSString *brandName;
@property (nonatomic,assign)NSInteger stockWarning;
@property (nonatomic,copy)NSString *recommended;
@property (nonatomic,assign)NSInteger shelves;
@property (nonatomic,assign)NSInteger freePost;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,assign)NSInteger readyToRetire;
@property (nonatomic,assign)NSInteger expiredRetreat;
@property (nonatomic,assign)NSInteger noAppoinment;
@property (nonatomic,copy)NSString *introduction;
@property (nonatomic,strong)RuleDetail *activityRules;
@property (nonatomic,assign)NSInteger sortOrder;
@property (nonatomic,assign)NSInteger isPromote;  //是否促销产品
@property (nonatomic,assign)NSInteger promotePrice;
@property (nonatomic,copy)NSString *detailContent;
@property (nonatomic,copy)NSString *rules;
@property (nonatomic,copy)NSString *notes;
@property (nonatomic,copy)NSString *tips;
@property (nonatomic,copy)NSString *details;
@property (nonatomic,strong)NSArray *pictures;//轮播
@end












































































