//
//  UserCommentTableViewCell.m
//  youmi
//
//  Created by frankfan on 14/11/12.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

/**
 *  @Author frankfan, 14-11-12 10:11:39
 *
 *  用户评论cell
 *
 *  @return
 */


#import "UserCommentTableViewCell.h"

@interface UserCommentTableViewCell ()
{

}


@end
@implementation UserCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    
        UILabel *label_from =[[UILabel alloc]initWithFrame:CGRectMake(6, 0, 35, 35)];
        label_from.font =[UIFont systemFontOfSize:14];
        label_from.textColor = baseTextColor;
        label_from.text = @"来自:";
        [self.contentView addSubview:label_from];
        
    
        //来自某用户
        self.theCommenter =[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 123, 35)];
        self.theCommenter.font =[UIFont systemFontOfSize:14];
        self.theCommenter.textColor = [UIColor colorWithWhite:0.55 alpha:1];
        self.theCommenter.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.theCommenter];
   
        //某天
        self.theDay =[[UILabel alloc]initWithFrame:CGRectMake(177, 0, 65, 35)];
        self.theDay.font =[UIFont systemFontOfSize:14];
        self.theDay.textColor = [UIColor colorWithWhite:0.55 alpha:1];
        self.theDay.adjustsFontSizeToFitWidth = YES;
        self.theDay.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.theDay];
        
        //某时刻
        self.theTime =[[UILabel alloc]initWithFrame:CGRectMake(245, 0, 50, 35)];
        self.theTime.font =[UIFont systemFontOfSize:13];
        self.theTime.textColor = [UIColor colorWithWhite:0.55 alpha:1];
        self.theTime.adjustsFontSizeToFitWidth = YES;
        self.theTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.theTime];

        
        
        UIView *staticLine =[[UIView alloc]initWithFrame:CGRectMake(0, 35, self.bounds.size.width-20, 1)];
        staticLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
        [self.contentView addSubview:staticLine];
    
        UIView *staticLine2 =[[UIView alloc]initWithFrame:CGRectMake(175, 0, 1, 35)];
        staticLine2.backgroundColor = customGrayColor;
        [self.contentView addSubview:staticLine2];
        
        UIView *staticLine3 =[[UIView alloc]initWithFrame:CGRectMake(245, 0, 1, 35)];
        staticLine3.backgroundColor = customGrayColor;
        [self.contentView addSubview:staticLine3];

        
        
        //用户评论内容
        _commentContent =[[UILabel alloc]initWithFrame:CGRectMake(0, 36, self.bounds.size.width-20, 0)];
        _commentContent.font =[UIFont systemFontOfSize:14];
        _commentContent.textColor = baseTextColor;
        _commentContent.numberOfLines = 0;
        _commentContent.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_commentContent];
        
    
    }

    return self;

}


+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString *cellName = @"cell";
    UserCommentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
    
        cell =[[UserCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    return cell;

}


/**
 *  @Author frankfan, 14-11-12 10:11:30
 *
 *  动态根据文字多少计算高度
 *
 *  @param string   输入的文字
 *  @param fontSize 文字的font
 *
 *  @return 返回高度
 */

- (CGFloat)caculateTheTextHeight:(NSString *)string andFontSize:(int)fontSize{
    
    /*非彻底性封装,这里给定固定的宽度*/
    CGSize constraint = CGSizeMake(self.bounds.size.width-20, CGFLOAT_MAX);
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:string
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    
    return size.height+10;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
