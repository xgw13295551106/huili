//
//  LCTextCardView.m
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/29.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import "LCTextCardView.h"

@interface LCTextCardView (){
    UIView *topLineView;
    UIView *bottomLineView;
    UIImageView *rightImage; ///< 右侧的箭头>
    UILabel *titleLabel;   //左侧的title文本
    CGFloat self_width;
    CGFloat self_height;
}


@property (nonatomic,assign) TitlePosition titlePosition;

@end

@implementation LCTextCardView

+ (instancetype)getViewWith:(CGRect)frame andText:(NSString *)text andPosition:(TitlePosition)titlePosition{
    LCTextCardView *textCardView = [[LCTextCardView alloc]initWithFrame:frame andText:text andPosition:titlePosition];
    return textCardView;
}

- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text andPosition:(TitlePosition)titlePosition{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self_width = frame.size.width;
        self_height = frame.size.height;
        [self setUpControlWith:frame andText:text andPosition:titlePosition];
    }
    return self;
}

- (void)setUpControlWith:(CGRect)frame andText:(NSString *)text andPosition:(TitlePosition)titlePosition{
    _titlePosition = titlePosition;
    
    topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self_width, 1)];
    [topLineView setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
    [self addSubview:topLineView];
    topLineView.hidden = YES;
    
    //标题title
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"828382"];
    titleLabel.text = text;
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    CGFloat titleLable_x = 15;
    CGFloat titlelabel_w = titleLabel.bounds.size.width;
    CGFloat titleLable_h = titleLabel.bounds.size.height;
    CGFloat titleLabel_y = 0;
    if (titlePosition == TopPosition) {
        titleLabel_y = 10;
    }else if (titlePosition == CenterPosition){
        titleLabel_y = self.bounds.size.height/2 - titleLable_h/2;
    }else if (titlePosition == BottomPosition){
        titleLabel_y = self_height - self.bounds.size.height - 10;
    }else{
        //若position传nil，则默认为中间布局
        titleLabel_y = self.bounds.size.height/2 - titleLable_h/2;
    }
    [titleLabel setFrame:CGRectMake(titleLable_x, titleLabel_y, titlelabel_w, titleLable_h)];
    
    bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self_height-1, self_width, 1)];
    [bottomLineView setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
    [self addSubview:bottomLineView];
    bottomLineView.hidden = YES;
    
    UIImage *image= [UIImage imageNamed:@"btn_list_right"];
    CGFloat imgView_w = image.size.width;
    CGFloat imgView_h = image.size.height;
    CGFloat imgView_x = self_width - 10 - imgView_w;
    CGFloat imgView_y = self_height/2 - imgView_h/2;
    rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(imgView_x, imgView_y, imgView_w, imgView_h)];
    [rightImage setImage:image];
    [self addSubview:rightImage];
    rightImage.hidden = YES;
}


- (void)setFrame:(CGRect)frame{
    //重写父类方法，对界面重布局
    [super setFrame:frame];
    self_width = frame.size.width;
    self_height = frame.size.height;
    CGFloat titleLable_x = 15;
    CGFloat titlelabel_w = titleLabel.bounds.size.width;
    CGFloat titleLable_h = titleLabel.bounds.size.height;
    CGFloat titleLabel_y = 0;
    if (_titlePosition == TopPosition) {
        titleLabel_y = 10;
    }else if (_titlePosition == CenterPosition){
        titleLabel_y = self.bounds.size.height/2 - titleLable_h/2;
    }else if (_titlePosition == BottomPosition){
        titleLabel_y = self_height - self.bounds.size.height - 10;
    }else{
        titleLabel_y = self.bounds.size.height/2 - titleLable_h/2;
    }
    [titleLabel setFrame:CGRectMake(titleLable_x, titleLabel_y, titlelabel_w, titleLable_h)];
    
    [bottomLineView setFrame:CGRectMake(0, self_height-1, self_width, 1)];
    
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    titleLabel.text = titleString;
    [titleLabel sizeToFit];
}

- (void)setShowTopLine:(BOOL)showTopLine{
    _showTopLine = showTopLine;
    topLineView.hidden = !showTopLine;
}

- (void)setShowBottomLine:(BOOL)showBottomLine{
    _showBottomLine = showBottomLine;
    bottomLineView.hidden = !showBottomLine;
}

- (void)setShowRightImage:(BOOL)showRightImage{
    _showRightImage = showRightImage;
    rightImage.hidden = !showRightImage;
}

@end
