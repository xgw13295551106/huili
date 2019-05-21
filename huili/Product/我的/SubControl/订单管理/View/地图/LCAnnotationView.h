//
//  LCAnnotationView.h
//  ConsumerProject
//
//  Created by zhongweike on 2017/9/12.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>



@interface LCAnnotationView : MAAnnotationView

typedef void(^SelectBlock)(LCAnnotationView *annotationView);

+ (instancetype)getAnnotationView:(MAMapView *)mapView
                    andAnnotation:(id<MAAnnotation>)annotation
                    andIdentifier:(NSString *)identifier;


@property (nonatomic,strong)NSString *imageUrl;

@property (nonatomic,strong)SelectBlock selectBlock;

@end
