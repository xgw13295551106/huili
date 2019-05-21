//
//  ClassfyBtn.m
//  YeFu
//
//  Created by Carl on 2017/12/13.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "ClassfyBtn.h"

@implementation ClassfyBtn

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20)];
        [img setImage:DefaultsImg];
        [img setContentMode:UIViewContentModeCenter];
        _img=img;
        [self addSubview:img];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, img.bottom-3, frame.size.width-10, 20)];
        [label setTextColor:text1Color];
        _label=label;
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
        [label setText:@"水果生鲜"];
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
