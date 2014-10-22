//
//  MainPageData.h
//  youmi
//
//  Created by frankfan on 14-8-28.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainPageData : NSObject

@property (nonatomic,strong)NSMutableArray *dataArray;

- (instancetype)initWithDiction:(NSDictionary *)dict;
@end
