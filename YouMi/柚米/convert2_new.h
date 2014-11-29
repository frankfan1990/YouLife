//
//  convert2_new.h
//  youmi
//
//  Created by frankfan on 14/11/29.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#ifndef __youmi__convert2_new__
#define __youmi__convert2_new__

#include <stdio.h>
#include <math.h>


//火星转百度
void bd_encrypt_new(double gg_lat, double gg_lon,double *bd_lon_2,double *bd_lat_2);


//百度转火星
void bd_decrypt_new(double bd_lat, double bd_lon, double *gg_lat, double *gg_lon);

#endif /* defined(__youmi__convert2_new__) */
