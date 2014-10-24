//
//  UserInfoModel.h
//  youmi
//
//  Created by frankfan on 14/10/23.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "JSONModel.h"

@interface UserInfoModel : JSONModel

@property (nonatomic,copy)NSString *memberId;//会员编号

//!!!:jsonModel这个框架要注意的是，自定义类的属性里面属性个数可以比接受到的实体类字段属性要少，但不能多
//@property (nonatomic,copy)NSString *memberAccount;//会员查询号
@property (nonatomic,copy)NSString *nickName;//昵称
@property (nonatomic,copy)NSString *memberName;//会员姓名
@property (nonatomic,copy)NSString *telphone;//手机号码
@property (nonatomic,copy)NSString *email;//电子邮箱
@property (nonatomic,copy)NSString *passWord;//密码
@property (nonatomic,copy)NSString *avatar;//头像
@property (nonatomic,copy)NSString *qq;//qq号码
@property (nonatomic,copy)NSString *postalCode; //邮政编码

@property (nonatomic,copy)NSString *provinceName;//省
@property (nonatomic,copy)NSString *cityName;
@property (nonatomic,copy)NSString *regionName;
@property (nonatomic,copy)NSString *address; //详细地址
@property (nonatomic,copy)NSString *createTime;//备注时间
@property (nonatomic,copy)NSString *remark; //注册
@property (nonatomic,copy)NSString *gradeName;
@property (nonatomic,assign)int provinceId;
@property (nonatomic,assign)int cityId; //市
@property (nonatomic,assign)int regionId;//区
@property (nonatomic,assign)int gradeId;//会员等级
@property (nonatomic,assign)double score;//会员积分
@property (nonatomic,assign)double ucoin;//U币余额


//- (instancetype)initWithDict:(NSDictionary *)dict;

@end
