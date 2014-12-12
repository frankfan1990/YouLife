//
//  convert2_new.c
//  youmi
//
//  Created by frankfan on 14/11/29.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#include "convert2_new.h"



static const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;


//火星转百度
void bd_encrypt_new(double gg_lat, double gg_lon,double *bd_lon_2,double *bd_lat_2)
{
    
    
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    *bd_lon_2 = z * cos(theta) + 0.0065;
    *bd_lat_2 = z * sin(theta) + 0.006;
    
}


//百度转火星

void bd_decrypt_new(double bd_lat, double bd_lon, double *gg_lat, double *gg_lon)
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    *gg_lon = z * cos(theta);
    *gg_lat = z * sin(theta);
}

