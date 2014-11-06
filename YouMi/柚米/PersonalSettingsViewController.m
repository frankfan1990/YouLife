//
//  PersonalSettingsViewController.m
//  youmi
//
//  Created by frankfan on 14-10-17.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "PersonalSettingsViewController.h"
#import "ProgressHUD/ProgressHUD.h"
#import "Reachability.h"
#import <AFNetworking.h>
#import "ModifyNicknameViewController.h"
#import "ModifyPasswordViewController.h"
#import "ModBindPhoneViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIButton+WebCache.h"
#import <TMCache.h>
#import "UIButton+WebCache.h"

#import "Userinfo.h"



@interface PersonalSettingsViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{

    NSArray *itemArray;
    NSArray *extendItemArray;
    
    NSMutableArray *detailContentArray;//个人详情数据
    BOOL isChangedState;
    Reachability *reachability;

    UIButton *rightbarButton;//导航栏上得rightButton
    UIButton *logOutButton;
    
    /**/
    UITextField *name_input;
    UITextField *qq_input;
    UITextField *emial_input;
    UITextField *address_input;
    UITextField *addressDetail_input;
    UITextField *zipCode_input;
    
    //
    NSData *imageData;//用户头像全局变量
    
    NSDictionary *globalDict;//从网络上拉去的全局数据
    
}

@property (nonatomic,strong)NSArray *outPutData;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIImageView *rightArrow;//cell上的指示标志
@property (nonatomic,strong)UIButton *headerImage;//cell上的头像
@property (nonatomic,strong)TPKeyboardAvoidingScrollView *theLoadView;
@end

@implementation PersonalSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    ///
    self.theLoadView =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.theLoadView];
    //
    isChangedState = NO;
    reachability =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"个人设置";
    title.textColor = baseRedColor;
    self.navigationItem.titleView = title;
    
    
    /*leftbarbutton*/
    UIButton *leftbarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    leftbarButton.tag = 401;
    leftbarButton.frame = CGRectMake(0, 0, 25, 25);
    [leftbarButton setImage:[UIImage imageNamed:@"朝左箭头icon"] forState:UIControlStateNormal];
    [leftbarButton addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithCustomView:leftbarButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    /*rightBarbutton*/
    rightbarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rightbarButton.tag = 402;
    rightbarButton.frame = CGRectMake(0, 0, 25, 25);
    [rightbarButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [rightbarButton addTarget:self action:@selector(navi_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem2 =[[UIBarButtonItem alloc]initWithCustomView:rightbarButton];
    self.navigationItem.rightBarButtonItem = barButtonItem2;

    
    itemArray = @[@"头像",@"账号",@"修改昵称",@"修改密码",@"修改绑定手机"];
    extendItemArray = @[@"头像",@"账号",@"修改昵称",@"修改密码",@"修改绑定手机",@"",@"QQ",@"邮箱",@"住址地区",@"住址详细",@"邮编"];
    self.outPutData = itemArray;
    
    
#pragma mark 创建tableView
    /*创建主体结构*/
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = customGrayColor;
    self.tableView.scrollEnabled = NO;
    [self.theLoadView addSubview:self.tableView];
    UIView *footerView =[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
    
    
    
    /*创建退出登录按钮*/
    logOutButton =[UIButton buttonWithType:UIButtonTypeCustom];
    logOutButton.frame = CGRectMake(20, self.view.bounds.size.height*0.8, self.view.bounds.size.width-40, 40);
    logOutButton.backgroundColor =baseRedColor;
    [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    logOutButton.layer.cornerRadius = 3;
    [logOutButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateHighlighted];
    [logOutButton addTarget:self action:@selector(logOutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if(!isChangedState){
    
        [self.view addSubview:logOutButton];
    }
    
    
    NSError *error;
    Userinfo *userinfo =[Userinfo modelWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:&error];
    NSLog(@"personSettingError:%@",[error localizedDescription]);
    
    if([userinfo.memberId length]){
    
        
//        UserInfoModel *userInfo =[[UserInfoModel alloc]initWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
        
        detailContentArray =[NSMutableArray arrayWithObjects:@"",userinfo.telphone,userinfo.nickName,@"",userinfo.telphone, nil];

    }
    
    
    // Do any additional setup after loading the view.
}







#pragma  mark 创建cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.outPutData count];

}


#pragma mark 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger thresord = 0;
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = NO;
    cell.textLabel.text = self.outPutData[indexPath.row];
    cell.textLabel.textColor = baseTextColor;
    
   
    if(indexPath.row==0){
        
        UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
        headerView.backgroundColor = customGrayColor;
        [cell.contentView addSubview:headerView];
        thresord = 10;
        
        //创建头像
        self.headerImage =[UIButton buttonWithType:UIButtonTypeCustom];
        self.headerImage.frame = CGRectMake(self.view.bounds.size.width-80, 10, 60, 60);
        self.headerImage.layer.cornerRadius = 5;
        self.headerImage.layer.masksToBounds = YES;

        if(!self.headerImage.imageView.image){
        
            self.headerImage.backgroundColor = customGrayColor;
        }
        
        [self.headerImage addTarget:self action:@selector(headerImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.headerImage];
        
        if(!isChangedState){
        
            self.headerImage.enabled = YES;
        }else{
        
            self.headerImage.enabled = NO;
        }
    
    }else if (indexPath.row==2){
        
        UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 39, self.view.bounds.size.width, 5)];
        footView.backgroundColor = customGrayColor;
        [cell.contentView addSubview:footView];
        thresord = -4;
        
    }else if (indexPath.row==3){
    
        UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 7)];
        headerView.backgroundColor = customGrayColor;
        [cell.contentView addSubview:headerView];
        thresord = 10;
 

    }else if (indexPath.row==4){
    
        thresord = -5;
    
    }
 
    /*给cell添加箭头*/
    
    if(self.rightArrow.image){
    
        self.rightArrow = nil;
    }
    
    if(!isChangedState){
    
     self.rightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, 15+thresord, 20, 20)];

     self.rightArrow.image =[UIImage imageNamed:@"左箭头"];
    }
    
    
    if(indexPath.row==0 || indexPath.row==1 || indexPath.row> 4){
        
        self.rightArrow = nil;
    }
    [cell.contentView addSubview:self.rightArrow];
    
    
    /*给cell添加detail*/
    if(indexPath.row != 0 && indexPath.row != 3 && indexPath.row < 5){
    
        int adjustPosition = 0;
        if(indexPath.row==1){
            
            adjustPosition = 30;
        }
        UILabel *detailLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-170+adjustPosition, 0, 140, 40)];
        detailLabel.tag = 4000;
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.textColor = baseTextColor;
        detailLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:detailLabel];
        
        detailLabel.text = detailContentArray[indexPath.row];
    
    }
    
    if(indexPath.row==2){
        
        UILabel *detailLabel = (UILabel *)[cell viewWithTag:4000];
        detailLabel.frame = CGRectMake(self.view.bounds.size.width-200, 0, 140, 40);
        detailLabel.textAlignment = NSTextAlignmentRight;
        
    }
    
    if(indexPath.row>4){
    
#pragma mark 这里是index.row大于4的地方
        if(indexPath.row == 5){
            
            UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 14)];
            headerView.backgroundColor = customGrayColor;
            [cell.contentView addSubview:headerView];
            
            UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(14, 20, 100, 50)];
            nameLabel.tag = 3000;
            nameLabel.font =[UIFont systemFontOfSize:17];
            nameLabel.textColor = baseTextColor;
            [cell.contentView addSubview:nameLabel];
            
            
            name_input =[[UITextField alloc]initWithFrame:CGRectMake(60, 25, self.view.bounds.size.width-100, 40)];
            name_input.backgroundColor = customGrayColor;
            name_input.layer.cornerRadius = 2;
            name_input.delegate = self;
            name_input.tag = 2001;
            name_input.returnKeyType = UIReturnKeyDone;
            
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"k_name"]){
            
                name_input.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"k_name"];
            }
            
            [cell.contentView addSubview:name_input];
            
        }else if (indexPath.row==6){
            
            qq_input = [[UITextField alloc]initWithFrame:CGRectMake(60, 5, self.view.bounds.size.width-100, 35)];
            qq_input.backgroundColor = customGrayColor;
            qq_input.layer.cornerRadius = 2;
            qq_input.delegate = self;
            qq_input.tag = 2002;
            qq_input.returnKeyType = UIReturnKeyDone;
            
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"k_qq"]){
            
                qq_input.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"k_qq"];
            }
            
            
            [cell.contentView addSubview:qq_input];
        }else if (indexPath.row==7){
           
            emial_input = [[UITextField alloc]initWithFrame:CGRectMake(60, 5, self.view.bounds.size.width-100, 35)];
            emial_input.backgroundColor = customGrayColor;
            emial_input.layer.cornerRadius = 2;
            emial_input.delegate = self;
            emial_input.tag = 2003;
            emial_input.returnKeyType = UIReturnKeyDone;
            
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"k_email"]){
            
                emial_input.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"k_email"];
            }
            
            [cell.contentView addSubview:emial_input];
        
        
        }else if (indexPath.row==8){
           
            address_input = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, self.view.bounds.size.width-130, 35)];
            address_input.backgroundColor = customGrayColor;
            address_input.layer.cornerRadius = 2;
            address_input.delegate = self;
            address_input.tag = 2004;
            address_input.returnKeyType = UIReturnKeyDone;
            
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"k_address"]){
            
            
                address_input.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"k_address"];
            }
            
            [cell.contentView addSubview:address_input];
            
        }else if (indexPath.row==9){
            addressDetail_input = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, self.view.bounds.size.width-130, 35)];
            addressDetail_input.backgroundColor = customGrayColor;
            addressDetail_input.layer.cornerRadius = 2;
            addressDetail_input.delegate = self;
            addressDetail_input.tag = 2005;
            addressDetail_input.returnKeyType = UIReturnKeyDone;
            
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"k_addressDetail"]){
            
                addressDetail_input.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"k_addressDetail"];
            }
            
            [cell.contentView addSubview:addressDetail_input];
            
            
        }else{
            
            
            zipCode_input = [[UITextField alloc]initWithFrame:CGRectMake(60, 5, self.view.bounds.size.width-100, 35)];
            zipCode_input.backgroundColor = customGrayColor;
            zipCode_input.layer.cornerRadius = 2;
            zipCode_input.delegate = self;
            zipCode_input.tag = 2006;
            zipCode_input.returnKeyType = UIReturnKeyDone;
            
            Userinfo *userInfo =[Userinfo modelWithDictionary:globalDict error:nil];
            
            zipCode_input.text =userInfo.postalCode;

            
            [cell.contentView addSubview:zipCode_input];
        
        }
        
    }
  
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3000];
    nameLabel.text = @"姓名";

    return cell;
}



#pragma mark cell被选中触发
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(isChangedState){
        return;
    }
    
    
    if(indexPath.row==2){
        
        ModifyNicknameViewController *modifyNickname = nil;
        if(!modifyNickname){
        
            modifyNickname =[ModifyNicknameViewController new];
            [self.navigationController pushViewController:modifyNickname animated:YES];
        }
        
    }else if (indexPath.row==3){
        
        ModifyPasswordViewController *modifyPassword = nil;
        if (!modifyPassword) {
            
            modifyPassword =[ModifyPasswordViewController new];
            [self.navigationController pushViewController:modifyPassword animated:YES];
        }
    
    
    }else if (indexPath.row==4){
    
        ModBindPhoneViewController *modBindPhone = nil;
        if(!modBindPhone){
            
            modBindPhone = [ModBindPhoneViewController new];
            [self.navigationController pushViewController:modBindPhone animated:YES];
        }
    
    }


}


#pragma mark done按钮点击触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}


#pragma mark cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==0){
    
            return 75;
    }else if (indexPath.row==3){
    
        return 65;
    }else{
        
        if(indexPath.row==5){
        
            return 75;
        }
        
        
        return 44;

    }
}




#pragma mark 退出登录触发
- (void)logOutButtonClicked:(UIButton *)sender{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[TMCache sharedCache]removeObjectForKey:kUserInfo];
        [self.navigationController popViewControllerAnimated:YES];

    });
    
    }



#pragma mark 头像点击触发
- (void)headerImageButtonClicked:(UIButton *)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"照相机", nil];

    [actionSheet showInView:self.view];
    NSLog(@"头像被点击");

}



#pragma mark 触发相册/照相机
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){//相册
        
        UIImagePickerController *imagePicker =[[UIImagePickerController alloc]init];
        [self.navigationController presentViewController:imagePicker animated:YES completion:^{
            
        }];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        
    }else if (buttonIndex==1){//摄像头
    
        UIImagePickerController *imagePicker2 =[[UIImagePickerController alloc]init];
        imagePicker2.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
            imagePicker2.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:imagePicker2 animated:YES completion:^{
                
                
            }];
            
        }else{
        
            [ProgressHUD showError:@"该设备不支持相机" Interaction:NO];
        
        }
        
    }
    
}


#pragma mark 从该代理方法中取到照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *originImage =info[UIImagePickerControllerOriginalImage];
   
    
    if(originImage){
    
        UIImage *resizeImage =[self scaleImage:originImage toSize:CGSizeMake(originImage.size.width*0.2, originImage.size.height*0.2)];
        imageData =UIImageJPEGRepresentation(resizeImage, 0.7);
        
        if([reachability isReachable]){//网络有链接
            
            [ProgressHUD show:nil Interaction:NO];
            AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
            manager.requestSerializer =[AFHTTPRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
#pragma mark警告
#warning 这里的问题是接口不正确会造成崩溃
            
            NSDictionary *parameters = nil;
            
            
            Userinfo *userinfo = [Userinfo modelWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:nil];
            
            if([userinfo.memberId length]){
            
                parameters = @{memberID:userinfo.memberId};
            }
            
            
            [manager POST:API_AploadImage parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"headerImage.jpeg" mimeType:@"image/jpeg"];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *result = (NSDictionary *)responseObject;
                
                if([result[@"success"]integerValue]==1){//如果头像修改成功，则：

                    [self.headerImage setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                    [[TMCache sharedCache]setObject:result[@"data"] forKey:kUserInfo];
                    
                    [ProgressHUD showSuccess:@"修改成功" Interaction:NO];
                }
                
                NSLog(@"responseObject:%@",responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [ProgressHUD showError:@"修改失败" Interaction:NO];
                NSLog(@"error:%@",[error localizedDescription]);
            }];

    
        
        }else{//网络无链接
        
            [ProgressHUD showError:@"网络链接异常" Interaction:NO];
        
        }
        
        
    }else{
    
        [ProgressHUD showError:@"照片拾取失败" Interaction:NO];
    
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];//fix bug 否则状态栏会恢复到黑色文字
    
}



#pragma mark 导航栏上面的按钮触发
- (void)navi_buttonClicked:(UIButton *)sender{

    if(sender.tag==401){
    
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
        if(!isChangedState){
            
            isChangedState = YES;
            self.outPutData = extendItemArray;
           
            [self.tableView beginUpdates];

            NSMutableArray *indexPaths = [NSMutableArray array];
            for (int i = 5; i<11; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            
            NSArray *indexPath1 = @[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0],[NSIndexPath indexPathForRow:4 inSection:0]];
            [self.tableView reloadRowsAtIndexPaths:indexPath1 withRowAnimation:UITableViewRowAnimationFade];
            
            self.tableView.scrollEnabled = YES;
          
            
            [rightbarButton setImage:[UIImage imageNamed:@"确定"] forState:UIControlStateNormal];
            
            [logOutButton removeFromSuperview];

            
            
            Userinfo *userInfo =[Userinfo modelWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
            if(userInfo){
            
            
                name_input.text = userInfo.memberName;
                
                
                qq_input.text =userInfo.qq;
                
                
                emial_input.text = userInfo.email;
                
                
                if(userInfo.regionId==0){
                    
                    address_input.text = nil;
                }else{
                    
                    address_input.text = [NSString stringWithFormat:@"%d",userInfo.regionId];
                    
                }
                
                
                addressDetail_input.text =userInfo.address;
                
                
                zipCode_input.text =userInfo.postalCode;

            }
                
            
            
            
#pragma mark这里有警告
#warning 这里是处理用户详细信息的修改
        }else{//这里是详细信息的提交
        
            isChangedState = NO;
            self.outPutData = itemArray;
            /*View层逻辑处理*/
            
            [self.tableView beginUpdates];
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (int i = 5; i<11; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            
            [self.tableView endUpdates];
            
            NSArray *indexPath1 = @[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0],[NSIndexPath indexPathForRow:4 inSection:0]];
            [self.tableView reloadRowsAtIndexPaths:indexPath1 withRowAnimation:UITableViewRowAnimationFade];

   
            self.tableView.scrollEnabled = NO;
            [rightbarButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
            
            logOutButton.alpha = 0;
            [self.view addSubview:logOutButton];
            [UIView animateWithDuration:0.8 animations:^{
                
                logOutButton.alpha = 1;
            }];
           
            /*网络层逻辑处理*/
            
            if([name_input.text length]==0 && [qq_input.text length]==0 && [emial_input.text length]==0 && [address_input.text length]==0 && [addressDetail_input.text length]==0 && [zipCode_input.text length]==0){
            
                return;
            }
            
            if([reachability isReachable]){
            
                AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
                
                NSDictionary *parameters = nil;
//                UserInfoModel *userinfo =[[UserInfoModel alloc]initWithDictionary:[[TMCache sharedCache] objectForKey:kUserInfo] error:nil];
                Userinfo *userinfo =[Userinfo modelWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
                if(userinfo.memberId){
                    
                    /**
                     *  @Author frankfan, 14-11-01 18:11:15
                     *
                     *  这里的判断为fix bug 原因还没有找
                     */
                    if([zipCode_input.text length]){
                    
                        parameters = @{memberID:userinfo.memberId,api_memberName:name_input.text,QQ:qq_input.text,memberEmail:emial_input.text,memberRegion:address_input.text,memberAddress:addressDetail_input.text,memberZipCode:zipCode_input.text};
                        

                    }else{
                   
                        parameters = @{memberID:userinfo.memberId,api_memberName:name_input.text,QQ:qq_input.text,memberEmail:emial_input.text,memberRegion:address_input.text,memberAddress:addressDetail_input.text};
                    
                    }
                
                    
                }
          
                [ProgressHUD show:nil Interaction:NO];
                [manager POST:API_ModifyPersonalInfo parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"responseOBJ:%@",responseObject);
                    if([responseObject[isSuccess]integerValue]==1){
                    
                        [ProgressHUD showSuccess:@"修改成功" Interaction:NO];
                        [[TMCache sharedCache]setObject:responseObject[@"data"] forKey:kUserInfo];
                        
                        Userinfo *userinfo =[Userinfo modelWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
                        
                        
                        
                    }else{
                    
                        [ProgressHUD showError:@"修改失败"];
                        [self removeTheUserdefault];
                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [ProgressHUD showError:@"修改失败"];
                    NSLog(@"error:%@",[error localizedDescription]);
                    [self removeTheUserdefault];
                }];
                
                
            }else{
            
            
                [ProgressHUD showError:@"网络异常,修改失败"];
                [self removeTheUserdefault];
                
            }
            
        }
        

        NSLog(@"编辑按钮点击");
    }

}


/*假如提交修改失败，则清空所填信息*/
- (void)removeTheUserdefault{

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"k_zipCode"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"k_addressDetail"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"k_address"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"k_email"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"k_qq"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"k_name"];

}




#pragma mark 处理textField文字
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if(textField.tag){
        
        if([textField.text length]){
        
            textField.text = nil;
        }
    
    }
}



#pragma mark uitextfield停止输入
- (void)textFieldDidEndEditing:(UITextField *)textField{

    if(textField.tag==2006){
    
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"k_zipCode"];
    
    }else if (textField.tag==2005){
    
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"k_addressDetail"];
    }else if (textField.tag==2004){
    
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"k_address"];
    }else if (textField.tag==2003){
    
    
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"k_email"];
    }else if (textField.tag==2002){
    
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"k_qq"];
    }else{
    
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"k_name"];
    }



}


#pragma mark viewDidAppear

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
     NSLog(@"........<:%@",[[TMCache sharedCache]objectForKey:kUserInfo]);
    
    
    NSError *error;
    
    Userinfo *userinfo =[Userinfo modelWithDictionary:[[TMCache sharedCache]objectForKey:kUserInfo] error:nil];
    
    
    NSLog(@"..error:%@",[error localizedDescription]);
    
   
    
    //用户头像显示
    if([userinfo.avatar length]){
        
        [self.headerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:userinfo.avatar] forState:UIControlStateNormal];
        
    }
    
    //用户昵称显示
    
    
    if([userinfo.nickName length]){
        
        if([detailContentArray count]){
            
            [detailContentArray removeObjectAtIndex:2];
            [detailContentArray insertObject:userinfo.nickName atIndex:2];
            [self.tableView reloadData];
        
        }
       }
    
    //用户手机号码显示
    
    if([userinfo.telphone length]){
        
        if([detailContentArray count]){
        
            [detailContentArray removeObjectAtIndex:4];
            [detailContentArray insertObject:userinfo.telphone atIndex:4];
            [self.tableView reloadData];

        }
    }



}




#pragma mark 在这里处理progress的消失
- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    if([ProgressHUD shared]){
    
        [ProgressHUD dismiss];
    }
}


#pragma mark 图片缩放-该方法用来减小图片尺寸优化性能
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark dealloc
- (void)dealloc{

   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
