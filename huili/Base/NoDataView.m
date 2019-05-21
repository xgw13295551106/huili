//
//  NoDataView.m
//  Bee
//
//  Created by yangH4 on 17/4/10.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "NoDataView.h"

//@property(nonatomic,weak)UILabel *title;
//
//@property(nonatomic,weak)UILabel *detailLabel;

@implementation NoDataView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH-170)/2, 80, 170, 114)];
        [img setImage:[UIImage imageNamed:@"xiaoxi_default"]];
        [self addSubview:img];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, img.origin.y+img.size.height+10, AL_DEVICE_WIDTH, 40)];
        _title=title;
//        [title setText:@"您还没有行程"];
        [title setTextColor:[UIColor colorWithHexString:@"333333"]];
        [title setFont:[UIFont systemFontOfSize:18]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:title];
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, title.origin.y+title.size.height, AL_DEVICE_WIDTH, 30)];
        _detailLabel=detailLabel;
//        [detailLabel setText:@"快来体验小黄峰吧!"];
        [detailLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [detailLabel setFont:[UIFont systemFontOfSize:15]];
        [detailLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:detailLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
