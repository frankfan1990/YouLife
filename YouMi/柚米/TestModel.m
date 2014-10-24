//
//  TestModel.m
//  youmi
//
//  Created by frankfan on 14/10/24.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "TestModel.h"

@interface TestModel (YouMi)
@end

@implementation TestModel (YouMi)

- (void)setNilValueForKey:(NSString *)key{

    [self setValue:@0 forKey:key];
}

@end


@implementation TestModel

@end
