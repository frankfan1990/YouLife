//
//  RuleDetail.h
//  youmi
//
//  Created by frankfan on 14/11/28.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MTLModel.h"

@interface RuleDetail : MTLModel

@property (nonatomic,copy)NSString *ruleId;
@property (nonatomic,copy)NSString *goodsId;
@property (nonatomic,copy)NSString *rules;
@property (nonatomic,copy)NSString *notes;
@property (nonatomic,copy)NSString *tips;
@property (nonatomic,copy)NSString *details;
@end
