//
//  DataAboutTitle.m
//  youmi
//
//  Created by frankfan on 14-8-28.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "DataAboutTitle.h"

@implementation DataAboutTitle

+(instancetype)shareWithInstance{

    static DataAboutTitle *titles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        titles =[[[self class]alloc]init];
        titles.titles = @[@"美食饮茶",@"休闲娱乐",@"文化教育",@"社区便利",@"运动健身",@"医疗保健",@"丽人美容",@"旅游酒店"];
    });

    return titles;
}

@end
