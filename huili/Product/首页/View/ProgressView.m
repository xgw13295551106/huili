//
//  ProgressView.m
//  yihuo
//
//  Created by Carl on 2017/12/28.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()

@property(nonatomic,weak)UIView *progressValue;
@property(nonatomic,weak)UILabel *progressLabel;

@end

@implementation ProgressView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIView *progress=[[UIView alloc]initWithFrame:CGRectMake(self.width-65, 6, 65, 6)];
        [progress setBackgroundColor:[UIColor whiteColor]];
        [progress.layer setCornerRadius:3];
        [progress.layer setMasksToBounds:YES];
        [progress.layer setBorderWidth:0.8];
        [progress.layer setBorderColor:STYLECOLOR.CGColor];
        [self addSubview:progress];
        UIView *progressValue=[[UIView alloc]initWithFrame:CGRectMake(0, 0, progress.width, 6)];
        [progressValue.layer setMasksToBounds:YES];
        [progressValue setFrame:CGRectMake(0, 0, progress.width*0.5, 6)];
        [progressValue setBackgroundColor:STYLECOLOR];
        [progress addSubview:progressValue];
        _progressValue=progressValue;
        
        UILabel *progressLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        [progressLabel setText:@"已售100%"];
        [progressLabel setFont:[UIFont systemFontOfSize:10]];
        [progressLabel setTextColor:text2Color];
        [self addSubview:progressLabel];
        _progressLabel=progressLabel;
    }
    return self;
}

-(void)setPresent:(CGFloat)present{
    [_progressValue setFrame:CGRectMake(0, 0, 65*present, 6)];
    [_progressLabel setText:[NSString stringWithFormat:@"已售%d%@",(int)present*100,@"%"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
