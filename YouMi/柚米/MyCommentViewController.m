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
#import "FBShimmering.h"
#import "FBShimmeringView.h"


@interface MyCommentViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,EDStarRatingProtocol,UITextViewDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    
    NSArray *commitTitleArray;
    
    NSMutableArray *cellArray;
    
    NSMutableArray *placeHolderCellArray;//占位cell
    NSMutableArray *recodeDeletedCell;//记录可能要删除的cell
    
    int stateFlag;//记录actionSheet的模式

}
@property (nonatomic,strong)TPKeyboardAvoidingScrollView *theLoadView;
@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *introducelabel;

@property (nonatomic,strong)UILabel *tasteCommentLabel;
@property (nonatomic,strong)UILabel *serviceCommentLabel;
@property (nonatomic,strong)UILabel *environmentalCommentLabel;

@property (nonatomic,strong)UITextView *commentInput;

@property (nonatomic,strong)UICollectionView *collectionView;//图片按钮
@property (nonatomic,strong)UIImageView *imageView;//cell上得图片

@property (nonatomic,strong)UILabel *headerTitleLabel;//显示店铺名
@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    cellArray = [NSMutableArray array];
    placeHolderCellArray =[NSMutableArray array];
    recodeDeletedCell =[NSMutableArray array];
     //
    commitTitleArray = @[@"非常不满意",@"不满意",@"满意",@"比较满意",@"非常满意"];
    
    /*创建loadView*/
    self.theLoadView =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.theLoadView];
    self.theLoadView.showsVerticalScrollIndicator = NO;
    
    if(self.view.bounds.size.height<=480){
    
        self.theLoadView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*1.2);
        
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
     *  @Author frankfan, 14-11-07 10:11:43
     *
     *  创建collectionView
     *
     *  @return nil
     */
    
    UICollectionViewFlowLayout *flowlayout =[[UICollectionViewFlowLayout alloc]init];
    flowlayout.itemSize = CGSizeMake(60, 60);
    

    
    self.collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(10, 360, self.view.bounds.size.width-20, 80) collectionViewLayout:flowlayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.theLoadView addSubview:self.collectionView];
    self.collectionView.backgroundColor =[UIColor whiteColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    
    
    //staticView fix bug
    /**
     用来挡住多出的那个cellItem
     */
    UIView *staticView =[[UIView alloc]initWithFrame:CGRectMake(10, 430, 100, 20)];
    staticView.backgroundColor =[UIColor whiteColor];
    [self.theLoadView addSubview:staticView];
    
    
#pragma mark - 提交按钮
    UIButton *commitButton =[UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(10, 450, self.view.bounds.size.width-20, 40);
    commitButton.backgroundColor = baseRedColor;
    [commitButton setTitle:@"提交评论" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 3;
    commitButton.layer.masksToBounds = YES;
    [commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.theLoadView addSubview:commitButton];
    
    
    
    
    /**
     *  @Author frankfan, 14-11-10 10:11:20
     *
     *  显示店铺名
     *
     *  @return nil
     */
    
    self.headerTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width-20, 35)];
    self.headerTitleLabel.backgroundColor = baseRedColor;
    self.headerTitleLabel.font = [UIFont systemFontOfSize:16];
    self.headerTitleLabel.textColor = [UIColor whiteColor];
    self.headerTitleLabel.layer.cornerRadius = 3;
    self.headerTitleLabel.layer.masksToBounds = YES;
    self.headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.theLoadView addSubview:self.headerTitleLabel];
    self.headerTitleLabel.adjustsFontSizeToFitWidth = YES;
    
#warning fake data
    self.headerTitleLabel.text = @"这里是标题";
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 提交按钮触发
- (void)commitButtonClicked:(UIButton *)sender{


    NSLog(@"button clicked");
}





#pragma mark - 拍照按钮触发
/**
 *  @Author frankfan, 14-11-06 16:11:28
 *
 *  拍照按钮触发
 *
 *  @return nil
 */
- (void)photoingButtonClicked:(UICollectionViewCell *)sender{
    
    UIActionSheet *actionSheet = nil;
    if([sender.backgroundView isKindOfClass:[UIImageView class]]){
    
        actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"照相机",@"删除", nil];
        [recodeDeletedCell addObject:sender];
        stateFlag = 1;
        
    }else{
    
        actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"照相机", nil];
        stateFlag = 2;
    
    }
    
    
    [actionSheet showInView:self.view];
   
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
        
    }
    
    if(stateFlag ==1){
    
        if(buttonIndex==2){
        
            
            UICollectionViewCell *tempCell =[recodeDeletedCell lastObject];
            NSIndexPath *indexPath =[self.collectionView indexPathForCell:tempCell];
            
           
            
            if([placeHolderCellArray count]){
            
                 [placeHolderCellArray removeLastObject];
                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            }
            
            
            
            
            NSLog(@"删除");

        }else if (buttonIndex ==3){
        
            NSLog(@"取消");
        }
    
    }else if (stateFlag==2){
    
        if(buttonIndex==2){
        
            NSLog(@"取消");
        }
    
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
    
        if([cellArray count]){
        
            UICollectionViewCell *cell = [cellArray lastObject];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
            imageView.image = resizeImage;
         
            if([placeHolderCellArray count]<4){
            
                

                if([cell.backgroundView isKindOfClass:[FBShimmeringView class]]){
                    
                    NSIndexPath *preIndexPath =[self.collectionView indexPathForCell:cell];
                    NSIndexPath *nowIndexPath =[NSIndexPath indexPathForItem:preIndexPath.row+1 inSection:0];
                    [placeHolderCellArray addObject:@""];
                    [self.collectionView insertItemsAtIndexPaths:@[nowIndexPath]];
                    
                    
                   
                }
                            
            }
            cell.backgroundView = imageView;
            
        }
        
    
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];//fix bug 否则状态栏会恢复到黑色文字

}



#pragma mark -取消获取照片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{



    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];//fix bug 否则状态栏会恢复到黑色文字


}

#pragma mark - 处理collectionView代理
/**
 *  @Author frankfan, 14-11-07 10:11:11
 *
 *  处理collectionView
 *
 *  @return nil
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [placeHolderCellArray count]+1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor =customGrayColor;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    
    
    FBShimmeringView *shimeView =[[FBShimmeringView alloc]initWithFrame:cell.bounds];
    cell.backgroundView = shimeView;
    
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:cell.bounds];
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"上传照片";
//     cell.backgroundView = title;
    shimeView.contentView = title;
    shimeView.shimmering = YES;
    shimeView.shimmeringSpeed = 50;
       
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    [self photoingButtonClicked:[collectionView cellForItemAtIndexPath:indexPath]];
    
    UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
    [cellArray addObject:cell];
    
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
