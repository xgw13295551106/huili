//
//  MyAllyHeadView.m
//  huili
//
//  Created by zhongweike on 2018/1/16.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "MyAllyHeadView.h"

@interface MyAllyHeadView (){
    UILabel *totalLabel;  //盟友总数
    UILabel *amountLabel;  ///< 累计收益
    
    CGFloat self_width;
    CGFloat self_height;
}


@end

@implementation MyAllyHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self_width = frame.size.width;
        self_height = frame.size.height;
        [self setBackgroundColor:STYLECOLOR];
        [self setUpControls:frame];
    }
    return self;
}

- (void)setUpControls:(CGRect)frame{
    //金额label
    CGFloat totalLabel_x = 0;
    CGFloat totalLabel_y = 30;
    CGFloat totalLabel_w = self_width/2;
    CGFloat totalLabel_h = 40;
    totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(totalLabel_x, totalLabel_y, totalLabel_w, totalLabel_h)];
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.font = [UIFont systemFontOfSize:30];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.text = @"--";
    [self addSubview:totalLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(totalLabel.minX, totalLabel.maxY+10, totalLabel.width, 25)];
    titleLabel1.text = @"盟友总数";
    titleLabel1.textColor = [UIColor whiteColor];
    titleLabel1.font = [UIFont systemFontOfSize:15];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel1];
    
    //当前积分
    amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(totalLabel.maxX, totalLabel.minY, self_width/2, totalLabel.height)];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.font = [UIFont systemFontOfSize:30];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.text = @"--";
    [self addSubview:amountLabel];
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(amountLabel.minX, titleLabel1.minY, amountLabel.width, titleLabel1.height)];
    titleLabel2.textColor = [UIColor colorWithHexString:@"ffffff"];
    titleLabel2.font = [UIFont systemFontOfSize:15];
    titleLabel2.text = @"累计收益(积分)";
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel2];
    
    
    self.height = titleLabel1.maxY + 25;
}


/**
 刷新headview
 
 @param dic  dic
 */
- (void)reloadHeadViewWith:(NSDictionary *)dic{
    
    totalLabel.text = [dic stringForKey:@"total"];
    amountLabel.text = [dic stringForKey:@"money"];
}

@end
