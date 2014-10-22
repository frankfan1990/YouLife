//
//  Email_Phone.m
//  tableView刷新测试
//
//  Created by frankfan on 14-8-6.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "Email_Phone.h"

BOOL isValidateEmail(NSString *email){

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];

}

BOOL isValidatePhone(NSString *mobile){

    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *phoneRegex = @"^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
   
    return [phoneTest evaluateWithObject:mobile];


}