//
//  YHBaseViewController.h
//  Bee
//
//  Created by yangH4 on 17/3/16.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XAClient.h"

typedef void(^PopToLastPage)(id parmers);

@interface YHBaseViewController : UIViewController


/**多例POST*/
-(void)postInbackground:(NSString *)api withParam:(NSMutableDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**单例有loadingPOST*/
-(void)post:(NSString *)api withParam:(NSMutableDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

-(void)toastOnWindow:(NSString *)str;//加在窗口上
-(void)toast:(NSString*)str;//加在当前view上
-(void)toast:(NSString*)str andSubView:(UIView *)subView;

- (void)alertControllerWithMsg:(NSString *)msg Title:(NSString *)title;

-(void)showLoading:(NSString*)text;

-(void)hideLoading;

-(void)setTopTitle:(NSString *)string;

- (void)backAction:(UIButton *)sender;

/**上传图片到阿里oss*/
-(void)JDuploadImages:(NSArray<UIImage *> *)images isAsync:(BOOL)isAsync complete:(void(^)(NSArray<NSString *> *names))complete fail:(void(^)())error;
/**上传文件到阿里oss*/
-(void)uploadVoices:(NSArray<NSData *> *)voices isAsync:(BOOL)isAsync complete:(void(^)(NSArray<NSString *> *names))complete fail:(void(^)())error;

/**
 设置导航栏颜色

 @param color 传入想要设置的颜色
 @param isTranslucent 导航栏是否透明
 */
- (void)p_setNavigationBarColor:(UIColor *)color translucent:(BOOL)isTranslucent;

@end
