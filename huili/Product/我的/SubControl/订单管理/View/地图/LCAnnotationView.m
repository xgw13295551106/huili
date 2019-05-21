//
//  LCAnnotationView.m
//  ConsumerProject
//
//  Created by zhongweike on 2017/9/12.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import "LCAnnotationView.h"

@interface LCAnnotationView ()

@property (nonatomic,strong)UIImageView *annotationImgView;

@property (nonatomic,strong)UIImageView *subImgView;

@end

@implementation LCAnnotationView




+ (instancetype)getAnnotationView:(MAMapView *)mapView andAnnotation:(id<MAAnnotation>)annotation andIdentifier:(NSString *)identifier{
    LCAnnotationView *annotationView = (LCAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView == nil) {
        annotationView = [[LCAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:identifier];
    }
    
    return annotationView;
}


- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        
        UIImage *bgImage = [UIImage imageNamed:@"order_icon_location"];
        self.image = bgImage;  //此处不加会莫名不响应
        self.annotationImgView = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
        [self.annotationImgView setImage:bgImage];
        [self addSubview:self.annotationImgView];
        
        CGFloat subImgView_x = 1;
        CGFloat subImgView_y = 1;
        CGFloat subImgView_w = bgImage.size.width - 2;
        CGFloat subImgView_h = subImgView_w;
        
        _subImgView = [[UIImageView alloc]initWithFrame:CGRectMake(subImgView_x, subImgView_y, subImgView_w, subImgView_h)];
        _subImgView.layer.cornerRadius = subImgView_w/2;
        _subImgView.layer.masksToBounds = YES;
        [self.annotationImgView addSubview:_subImgView];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchSelfAction:)];
//        [self addGestureRecognizer:tap];
//        [_annotationImgView addGestureRecognizer:tap];
//        [_subImgView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)touchSelfAction:(UIGestureRecognizer *)gesture{
    if (self.selectBlock) {
        self.selectBlock(self);
    }
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [_subImgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end
