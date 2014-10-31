//
//  MyUbinTableViewCell.m
//  youmi
//
//  Created by H.DX on 14-10-31.
//  Copyright (c) 2014年 ruizhou. All rights reserved.
//

#import "MyUbinTableViewCell.h"

@implementation MyUbinTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelOfDate = [[UILabel alloc] init];
        _labelOfTime = [[UILabel alloc] init];
        _labelOfDetails = [[UILabel alloc] init];
        _labelOfMoney = [[UILabel alloc] init];
        
        _labelOfDetails.textAlignment = NSTextAlignmentCenter;
        _labelOfMoney.textAlignment = NSTextAlignmentRight;
        
        _labelOfDate.font = [UIFont systemFontOfSize:14];
        _labelOfMoney.font = [UIFont systemFontOfSize:14];
        _labelOfTime.font = [UIFont systemFontOfSize:14];
        _labelOfDetails.font = [UIFont systemFontOfSize:14];
        
        _labelOfMoney.textColor = [UIColor colorWithRed:40/255.0 green:127/255.0 blue:178/255.0 alpha:1];
        
        [self.contentView addSubview:_labelOfDetails];
        [self.contentView addSubview:_labelOfTime];
        [self.contentView addSubview:_labelOfDate];
        [self.contentView addSubview:_labelOfMoney];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _labelOfDate.frame = CGRectMake(5, 5, 80, 20);
    _labelOfTime.frame = CGRectMake(5, self.frame.size.height-20, 40, 20);
    _labelOfMoney.frame = CGRectMake(self.frame.size.width-100, 18, 90, 20);
    _labelOfDetails.frame = CGRectMake(self.frame.size.width/2-50, 0, 100, 55);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
