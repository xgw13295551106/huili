//
//  UIImageView+UIImageViewExt.m
//  WisdomTCM
//
//  Created by AaronLee on 14-11-21.
//  Copyright (c) 2014年 newzone. All rights reserved.
//

#import "UIImageViewExt.h"
#import "NSString+NSStringExt.h"

@implementation UIImageView (UIImageViewExt)

- (void)rotationByAngle:(CGFloat)angle Duation:(CGFloat)duation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: angle * (M_PI / 180.0f) ];
    rotationAnimation.duration = duation;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)rotationByAngle:(CGFloat)angle Duation:(CGFloat)duation Delay:(CGFloat)delay
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView animateWithDuration:duation delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = endAngle;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setimageWithUrl:(NSString *)url CacheToNative:(BOOL)cache Dic:(NSMutableDictionary *)dic
{
    if (url.length) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (data) {
                UIImage* image = [UIImage imageWithData:data];
                if (image) {
                    if (cache) {
                        NSString* filePath = [NSTemporaryDirectory() stringByAppendingString:@"imageCache/"];
                        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
                        }
                        filePath = [filePath stringByAppendingString:[url md5String]];
                        [data writeToFile:filePath atomically:YES];
                    }
                    [dic setObject:image forKey:[url md5String]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = image;
                    });
                }
            }
        });
    }
}

@end
