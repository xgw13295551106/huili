//
//  HomeSelectType.m
//  YeFu
//
//  Created by Carl on 2017/12/13.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "HomeSelectType.h"

@interface HomeSelectType ()

@property(nonatomic,weak)UIButton *lastBtn;

@property(nonatomic,weak)UIView *line;

@end

@implementation HomeSelectType

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setSelectType:(int)selectType{
    _selectType=selectType;
    for (int i=0; i<4; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*AL_DEVICE_WIDTH/4, 0, AL_DEVICE_WIDTH/4, 44)];
        if (i==0) {
            [btn setTitle:@"今日特价" forState:UIControlStateNormal];
        }else if (i==1){
            [btn setTitle:@"掌柜推荐" forState:UIControlStateNormal];
        }else if (i==2){
            [btn setTitle:@"人气热卖" forState:UIControlStateNormal];
        }else if (i==3){
            [btn setTitle:@"新品上市" forState:UIControlStateNormal];
        }
        
        [btn setTitleColor:text1Color forState:UIControlStateNormal];
        [btn setTitleColor:STYLECOLOR forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:btn];
        btn.tag=i;
        if (i==selectType) {
            _lastBtn=btn;
            [_lastBtn setSelected:YES];
        }
        [btn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(selectType*AL_DEVICE_WIDTH/4, 41, AL_DEVICE_WIDTH/4, 3)];
    [line setBackgroundColor:STYLECOLOR];
    _line=line;
    [self addSubview:line];
}


-(void)selectClick:(UIButton*)sender{
    [_lastBtn setSelected:NO];
    [sender setSelected:YES];
    _lastBtn=sender;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [_line setFrame:CGRectMake((int)sender.tag*AL_DEVICE_WIDTH/4, 41, AL_DEVICE_WIDTH/4, 3)];
        NSLog(@"%f",_line.x);
    }];
    if ([self.delegate respondsToSelector:@selector(selectType1:)]) {
        [self.delegate selectType1:(int)sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
