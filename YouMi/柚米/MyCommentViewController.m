//
//  MyCommentViewController.m
//  youmi
//
//  Created by frankfan on 14/10/30.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MyCommentViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "EDStarRating.h"
#import "POP.h"


@interface MyCommentViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,EDStarRatingProtocol,UITextViewDelegate,UIActionSheetDelegate>
{
    
    NSArray *commitTitleArray;
    NSMutableArray *recodeImageButton;//记录点击图片获取按钮
}
@property (nonatomic,strong)TPKeyboardAvoidingScrollView *theLoadView;
@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *introducelabel;

@property (nonatomic,strong)UILabel *tasteCommentLabel;
@property (nonatomic,strong)UILabel *serviceCommentLabel;
@property (nonatomic,strong)UILabel *environmentalCommentLabel;

@property (nonatomic,strong)UITextView *commentInput;
@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    
    recodeImageButton =[NSMutableArray array];
    //
    commitTitleArray = @[@"非常不满意",@"不满意",@"满意",@"比较满意",@"非常满意"];
    
    /*创建loadView*/
    self.theLoadView =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.theLoadView];
    
    if(self.view.bounds.size.height<=480){
    
        self.theLoadView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2);
        
    }
    self.theLoadView.scrollEnabled = YES;
    
    /*title*/
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    title.text = @"我的点评";
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
    

    NSArray *itemname = @[@"已点评",@"未点评"];
    UISegmentedControl *segements =[[UISegmentedControl alloc]initWithItems:itemname];
    segements.frame = CGRectMake(10, 5, self.view.bounds.size.width-20, 40);
    segements.tintColor = baseRedColor;
    segements.backgroundColor = [UIColor whiteColor];
    segements.selectedSegmentIndex = 0;
    [self.theLoadView addSubview:segements];
    segements.layer.masksToBounds = YES;
    segements.layer.cornerRadius = 3;
    
    
    /**
     *  @Author frankfan, 14-11-06 10:11:05
     *
     *  开始创建主体
     *
     *  @return nil
     */
    
    self.headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 60, 60)];
    self.headerImageView.layer.cornerRadius = 2;
    self.headerImageView.layer.masksToBounds = YES;
    [self.theLoadView addSubview:self.headerImageView];
    self.headerImageView.backgroundColor =[UIColor blackColor];
    
  
    self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(75, 42, 200, 35)];
    self.titleLabel.font =[UIFont systemFontOfSize:16];
    self.titleLabel.textColor = baseTextColor;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.text = @"这里是标题";
    [self.theLoadView addSubview:self.titleLabel];
    
    
    self.introducelabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 85, 250, 35)];
    self.introducelabel.font = [UIFont systemFontOfSize:14];
    self.introducelabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.introducelabel.adjustsFontSizeToFitWidth = YES;
    self.introducelabel.textAlignment = NSTextAlignmentLeft;
    [self.theLoadView addSubview:self.introducelabel];
    self.introducelabel.text = @"这里是介绍";
    
    /**
     口味
     */
    UILabel *tasteLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 110, 70, 40)];
    tasteLabel.font =[UIFont systemFontOfSize:15];
    tasteLabel.textColor = baseTextColor;
    tasteLabel.text = @"口味:";
    [self.theLoadView addSubview:tasteLabel];
    
    EDStarRating *star1 =[[EDStarRating alloc]initWithFrame:CGRectMake(55, 115, 123, 30)];
    star1.tag = 3000;
    star1.delegate = self;
    star1.maxRating = 5;
    star1.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    star1.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    star1.horizontalMargin = 15.0;
    star1.displayMode=EDStarRatingDisplayFull;
    star1.tintColor = baseRedColor;
    star1.editable = YES;
    [star1 setNeedsDisplay];
    [self.theLoadView addSubview:star1];
    
    
    self.tasteCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 110, 111, 35)];
    self.tasteCommentLabel.font =[UIFont systemFontOfSize:14];
    self.tasteCommentLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.tasteCommentLabel.textAlignment = NSTextAlignmentLeft;
    [self.theLoadView addSubview:self.tasteCommentLabel];
  
    
    /**
     服务
     */
    UILabel *serviceLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 140, 70, 40)];
    serviceLabel.font =[UIFont systemFontOfSize:15];
    serviceLabel.textColor = baseTextColor;
    serviceLabel.text = @"服务:";
    [self.theLoadView addSubview:serviceLabel];

    
    EDStarRating *star2 =[[EDStarRating alloc]initWithFrame:CGRectMake(55, 145, 123, 30)];
    star2.tag = 3001;
    star2.delegate = self;
    star2.maxRating = 5;
    star2.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    star2.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    star2.horizontalMargin = 15.0;
    star2.displayMode=EDStarRatingDisplayFull;
    star2.tintColor = baseRedColor;
    star2.editable = YES;
    [star2 setNeedsDisplay];
    [self.theLoadView addSubview:star2];
    
    
    self.serviceCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 145, 111, 35)];
    self.serviceCommentLabel.font =[UIFont systemFontOfSize:14];
    self.serviceCommentLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.serviceCommentLabel.textAlignment = NSTextAlignmentLeft;
    [self.theLoadView addSubview:self.serviceCommentLabel];

    
    
    /**
     环境
     */
    UILabel *environmentalLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 170, 70, 40)];
    environmentalLabel.font =[UIFont systemFontOfSize:15];
    environmentalLabel.textColor = baseTextColor;
    environmentalLabel.text = @"环境:";
    [self.theLoadView addSubview:environmentalLabel];

    
    EDStarRating *star3 =[[EDStarRating alloc]initWithFrame:CGRectMake(55, 175, 123, 30)];
    star3.tag = 3002;
    star3.delegate = self;
    star3.maxRating = 5;
    star3.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    star3.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    star3.horizontalMargin = 15.0;
    star3.displayMode=EDStarRatingDisplayFull;
    star3.tintColor = baseRedColor;
    star3.editable = YES;
    [star3 setNeedsDisplay];
    [self.theLoadView addSubview:star3];
    

    self.environmentalCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 175, 111, 35)];
    self.environmentalCommentLabel.font =[UIFont systemFontOfSize:14];
    self.environmentalCommentLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.environmentalCommentLabel.textAlignment = NSTextAlignmentLeft;
    [self.theLoadView addSubview:self.environmentalCommentLabel];
    

    
    /**
     *  @Author frankfan, 14-11-06 14:11:51
     *
     *  评论输入框
     *
     *  @return nil
     */
    
    self.commentInput =[[UITextView alloc]initWithFrame:CGRectMake(10, 215, self.view.bounds.size.width-20, 125)];
    self.commentInput.backgroundColor =[UIColor whiteColor];
    self.commentInput.delegate = self;
    self.commentInput.layer.cornerRadius = 3;
    self.commentInput.layer.masksToBounds = YES;
    [self.theLoadView addSubview:self.commentInput];
    self.commentInput.font =[UIFont systemFontOfSize:14];
    self.commentInput.textColor = baseTextColor;
    self.commentInput.text = @"输入评论";
    self.commentInput.layer.borderWidth = 1;
    self.commentInput.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    
    
    /**
     *  @Author frankfan, 14-11-06 15:11:11
     *
     *  创建拍照框
     *
     *  @return nil
     */
    
    UIButton *imageButton1 = [self create4BuutonWithFrame:CGRectMake(10, 355, 70, 70) andTag:4000];
    [self.theLoadView addSubview:imageButton1];
//    UIButton *imageButton2 = [self create4BuutonWithFrame:CGRectMake(87, 355, 70, 70) andTag:4001];
//    imageButton2.alpha = YES;
//    UIButton *imageButton3 = [self create4BuutonWithFrame:CGRectMake(165, 355, 70, 70) andTag:4002];
//
//    UIButton *imageButtin4 = [self create4BuutonWithFrame:CGRectMake(242, 355, 70, 70) andTag:4003];
    
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 创建拍照按钮
- (UIButton *)create4BuutonWithFrame:(CGRect)frame andTag:(NSInteger)tag{

    UIButton *imageButton1 =[UIButton buttonWithType:UIButtonTypeCustom];
    imageButton1.tag = tag;
    imageButton1.backgroundColor = customGrayColor;
    imageButton1.frame = frame;
    imageButton1.layer.borderWidth = 1;
    imageButton1.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    [self.theLoadView addSubview:imageButton1];
    [imageButton1 setTitle:@"图片上传" forState:UIControlStateNormal];
    [imageButton1 setTitleColor:baseTextColor forState:UIControlStateNormal];
    imageButton1.titleLabel.font =[UIFont systemFontOfSize:14];
    [imageButton1 addTarget:self action:@selector(photoingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
   
    return imageButton1;
}




#pragma mark - 拍照按钮触发
/**
 *  @Author frankfan, 14-11-06 16:11:28
 *
 *  拍照按钮触发
 *
 *  @return nil
 */
- (void)photoingButtonClicked:(UIButton *)sender{
    
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"照相机", nil];
    
    [actionSheet showInView:self.view];
    
    
    NSNumber *buttonTag = [NSNumber numberWithInteger:sender.tag];
    [recodeImageButton addObject:buttonTag];
    

}


#pragma mark - actionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex==0){//相册
    
        UIImagePickerController *imagePicker =[[UIImagePickerController alloc]init];
        [self presentViewController:imagePicker animated:YES completion:^{
            
            
        }];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
       
        
    }else if(buttonIndex==1){//照相机
    

        
        UIImagePickerController *imagePicker2 =[[UIImagePickerController alloc]init];
        imagePicker2.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
            imagePicker2.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker2 animated:YES completion:^{
                
                
            }];
        }else{
        
            NSLog(@"设备不支持相机");
        
        }
        
    
    }else{

        if([recodeImageButton count]){
        
            [recodeImageButton removeLastObject];
        }
        NSLog(@"取消");
    }

}


#pragma mark - imagePickerController代理
/*获取照片*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *originImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizeImage = [self scaleImage:originImage toSize:CGSizeMake(originImage.size.width*0.3, originImage.size.height*0.3)];
    
    //留作上传至服务器源数据
    NSData *imagedata = UIImageJPEGRepresentation(resizeImage, 0.8);
    
    
    if(originImage){
    
        if([recodeImageButton count]){
        
            NSNumber *buttonTag = [recodeImageButton lastObject];
            UIButton *button =(UIButton *)[self.view viewWithTag:[buttonTag integerValue]];
            
            
            
            if(![button currentImage]){
                
                
                
                
            }
            
            
            
            
            
            
            
            [button setImage:resizeImage forState:UIControlStateNormal];
            [button setTitle:nil forState:UIControlStateNormal];
            
        

            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                POPSpringAnimation *springAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
                springAnimation.springSpeed = 15;
                springAnimation.springBounciness = 16;
                
                
            });
            
            
        }
        
        
        
    
    
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}


#pragma mark -取消获取照片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{



    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
    if([recodeImageButton count]){
    
        [recodeImageButton removeLastObject];
    }
}




#pragma mark - 开始评论
- (void)textViewDidBeginEditing:(UITextView *)textView{

    if([textView.text isEqualToString:@"输入评论"]){
        
        textView.text = nil;
        
    }

}




#pragma mark - 打分控件代理
- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating{

    NSInteger index = (int)rating-1;
    if(index>=0 && index<=4){
    
        if(control.tag==3000){
            
            self.tasteCommentLabel.text = commitTitleArray[index];
            
        }else if (control.tag==3001){
            
            self.serviceCommentLabel.text = commitTitleArray[index];
        }else{
            
            
            self.environmentalCommentLabel.text = commitTitleArray[index];
        }

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






/**
 *  @Author frankfan, 14-10-30 13:10:26
 *
 *  导航栏按钮触发
 *
 *  @return nil
 */
#pragma mark - 导航栏按钮触发
- (void)navi_buttonClicked:(UIButton *)sender{
    
    if(sender.tag==401){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
