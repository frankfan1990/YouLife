//
//  ShopBusiniessInfoObjcModel.h
//  
//
//  Created by frankfan on 14/11/27.
//
//
/**
 *  @author frankfan, 14-11-26 10:11:55
 *
 *  Shop对象里面的子对象，商铺营业信息对象
 */

#import "MTLModel.h"

@interface ShopBusiniessInfoObjcModel : MTLModel

@property (nonatomic,copy)NSString *amendDate;
@property (nonatomic,copy)NSString *amstartDate;//中餐
@property (nonatomic,copy)NSString *bus;//公交信息
@property (nonatomic,copy)NSString *businessDescription;//餐厅特色
@property (nonatomic,copy)NSString *pmendDate;//晚餐
@property (nonatomic,copy)NSString *pmstartDate;
@property (nonatomic,copy)NSString *shopId;
@end
