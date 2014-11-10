//
//  SystemConfig.h
//  柚米
//
//  Created by frankfan on 14-8-27.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//
/*
 
 规则说明：
 以k开头的字段为用户偏好配置标识，即用于NSUserdefault的key
 接口字段均为非k开头，以驼峰命名规则命名
 */


#pragma mark - 全局常量
/*全局常量*/
#define kThreePartData_0 @"threePartData"//“三大模块”的缓存key
#define kPassLeftData_0 @"leftData_0" //用作通知的key
#define kShowPicOnlyInWifi @"showPicOnlyInWifi"//用作是否wifi条件下显示图片的判断

#define kUser_ID @"user_id" //userdefault-key用户ID  用做配置本地文件
#define kUser_phoneNum @"user_photoNum" //userdefault-key用户手机号
#define kUser_headerImage @"user_headerImage" //userdefault-key用户头像的URL

#define kCheckNetWork_flag @"www.baidu.com" //这个链接用来检测网络是否能正常访问

#define kUserInfo @"userInfo"//用户账户基本信息

#define kUserCity @"city"//用户当前城市
#define kUserLocationCity @"currentCity"//定位到当前城市



/*系统相关*/
#ifndef ___SystemConfig_h
#define ___SystemConfig_h

/// Dlog
/*
#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif
*/

#warning 切换为发布版的时候要将注释放开
/////debug模式下打印，release模式下不打印
/*
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif
*/


/*userdefault*/
////////////////////////////用作userDefault的key
#define kUserName @"username"
#define kPassword @"password"
///////////////////////////


//-------------------------------------------------------------------------------------------------------------->

#define commomCellHeight 100




#pragma mark - 注册接口
/*注册部分接口*/
/*
    字段-----------意义--------------方法--post
    telphone     电话号码
 */
#define API_RegisterPhoneNum @"http://120.24.71.104:8080/youmi/member/validator"//提交电话号码
//#define API_RegisterPhoneNum @"http://88.88.3.109/youmi/member/validator"//提交电话号码








/*接口字段*/
#define phoneNum @"telphone" //用户手机号码
#define api_passWord @"passWord" //用户密码


//测试接口-测试接口地址每天会有变更
//#define API_RegisterCommit @"http://88.88.3.109/youmi/member/register"//注册提交_测试接口
//正式接口
#define API_RegisterCommit @"http://120.24.71.104:8080/youmi/member/register"//注册提交



#pragma mark - 用户头像上传接口
/*
 *图片上传，用于上传用户头像等
 */

//测试模式
//#define API_AploadImage @"http://88.88.3.109/youmi/member/upload/avatar"
//发布模式
#define API_AploadImage @"http://120.24.71.104:8080/youmi/member/upload/avatar"


#pragma mark - 登陆接口

/*
 *登陆接口
 */
/*接口字段*/
#define userAcount @"userAccount"
#define userPassWord @"passWord"
 //测试模式
//#define API_UserLogin @"http://88.88.3.138:8080/youmi/member/login"
//发布模式
#define API_UserLogin @"http://120.24.71.104:8080/youmi/member/login"

#pragma mark - 修改昵称接口
/*
 *修改昵称
 */
//发布模式
#define API_ModifyNickname @"http://120.24.71.104:8080/youmi/member"
//#define API_ModifyNickname @"http://88.88.3.109/youmi/member"
#define api_nickName @"nickName"//会员昵称字段

#pragma mark - 修改密码接口

/*
 *修改密码
 */
//发布模式
#define API_ModifyPassword @"http://120.24.71.104:8080/youmi/member"



#pragma mark - 获取验证码接口
/*
 *获取验证码
 */
//发布模式
#define API_GetSecurityCode @"http://120.24.71.104:8080/youmi/member/validator"


#pragma mark - 修改绑定手机接口
/*
 *修改手机绑定
 */
//发布模式
#define API_ModiftPhoneBind @"http://120.24.71.104:8080/youmi/member"
#define memberID @"memberId"//用户id 字段



/*网络操作成功与否的key*/
#define isSuccess @"success"


#pragma mark - 完善个人信息接口
/*
 *用户个人信息完善
 */
//发布模式
#define API_ModifyPersonalInfo @"http://120.24.71.104:8080/youmi/member"
#define api_memberName @"memberName"//用户姓名
#define QQ @"qq"//用户QQ号码
#define memberEmail @"email"//用户邮箱
#define memberRegion @"regionName"//用户所在区
#define memberAddress @"address"//用户详细住所
#define memberZipCode @"postalCode"//用户所在地邮编


#pragma mark - 关于优米接口
/**
 *  @Author frankfan, 14-11-10 16:11:13
 *
 *  关于优米
 */
//接口
#define API_AboutYouMi @"http://88.88.3.102:8080/youmi/about"
//发布模式
//#define API_AboutYouMi @"http://120.24.71.104:8080/youmi/about"



#endif
