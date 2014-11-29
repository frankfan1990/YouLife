//
//  ValueKeyConfig.m
//  MyMoon
//
//  Created by kklink on 14-9-17.
//  Copyright (c) 2014年 kklink. All rights reserved.
//

#import "ValueKeyConfig.h"

#define allTimeOut 60
#define LocationTime 2*60

@implementation ValueKeyConfig

+ (void)saveWithKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[self getNowDataStr] forKey:key];
    [ud synchronize];
}

+ (double)readWithKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    double time = [[ud objectForKey:key] doubleValue];
    return time;
}

+ (BOOL)isTimeOut:(double)time andKey:(NSString *)key
{
    float maxTime = allTimeOut;
    if([key isEqualToString:@"LocationTime"]){
        maxTime = LocationTime;
    }
    
    if ([self compareTime:time atMaxTime:maxTime]) {
        return YES;
    }else{
        return NO;
    }
}

//获取当前时间
+(NSString *)getNowDataStr{
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    return timeSp;
}

//对比时间
+ (BOOL)compareTime:(NSInteger)timeInterver atMaxTime:(int)maxTime
{
    //前的时间
    NSInteger minDistance=[[self getNowDataStr] integerValue]-timeInterver;
    if (minDistance>maxTime) {
        return YES;
    }
    return NO;
}

+ (void)saveValue:(id)value andKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:key];
    [ud synchronize];
}

+ (id)readValueWithKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id value = [ud objectForKey:key];
    return value;
}

@end
