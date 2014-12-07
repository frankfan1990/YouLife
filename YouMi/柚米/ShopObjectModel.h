//
//  ShopObjectModel.h
//  youmi
//
//  Created by frankfan on 14/11/20.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

/**
 *  @Author frankfan, 14-11-20 14:11:34
 *
 *  商铺数据层对象
 */


@interface ShopObjectModel : MTLModel

@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,copy)NSString *shopId;//商铺编号
@property (nonatomic,copy)NSString *shopName;//商铺名称
@property (nonatomic,copy)NSString *circleId;//商圈地址
@property (nonatomic,copy)NSString *circleName;
@property (nonatomic,assign)NSInteger provinceId;
@property (nonatomic,copy)NSString *provinceName;//省
@property (nonatomic,copy)NSString *header;//头像
@property (nonatomic,assign)NSInteger cityId;//市
@property (nonatomic,copy)NSString *cityName;
@property (nonatomic,assign)NSInteger regionId;//区
@property (nonatomic,copy)NSString *regionName;
@property (nonatomic,assign)CGFloat lat;
@property (nonatomic,assign)CGFloat lng;
@property (nonatomic,copy)NSString *contact;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,copy)NSString *businessLicense;
@property (nonatomic,copy)NSString *typeId;//商铺类型
@property (nonatomic,copy)NSString *typeName;
@property (nonatomic,assign)NSInteger starsReviews;//商铺评分
@property (nonatomic,assign)CGFloat perCpitaConsumption; // 人均消费
@property (nonatomic,assign)NSInteger sortOrder; // 推荐排序
@property (nonatomic,copy)NSString *tagWords;// 标签
@property (nonatomic,copy)NSString *typeIds;
@property (nonatomic,assign)NSInteger pageViews;
@property (nonatomic,strong)NSArray *pictures;//轮播图片
@property (nonatomic,strong)NSArray *goodses;//商品
@property (nonatomic,strong)NSArray *shopNewses;
@property (nonatomic,strong)NSArray *comments;//评价
@property (nonatomic,copy)NSArray *businesses;
@property (nonatomic,copy)NSString *shopTitle;//满100送50
@property (nonatomic,copy)NSString *attentionId;
@property (nonatomic,assign)BOOL attention;
@end
