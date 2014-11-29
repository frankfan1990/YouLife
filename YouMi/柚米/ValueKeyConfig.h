//
//  ValueKeyConfig.h
//  MyMoon
//
//  Created by kklink on 14-9-17.
//  Copyright (c) 2014年 kklink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValueKeyConfig : NSObject

//是否需要刷新数据
+ (void)saveWithKey:(NSString *)key;
+ (double)readWithKey:(NSString *)key;
+ (BOOL)isTimeOut:(double)time andKey:(NSString *)key;

+ (void)saveValue:(id)value andKey:(NSString *)key;
+ (id)readValueWithKey:(NSString *)key;

@end