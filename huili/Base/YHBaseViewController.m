//
//  YHBaseViewController.m
//  Bee
//
//  Created by yangH4 on 17/3/16.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"
#import "MBProgressHUD.h"
#import <AliyunOSSiOS/OSSService.h>
#import "AppDelegate.h"
#import "BaseNavViewController.h"
#import "YHLoginViewController.h"

@interface YHBaseViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *_HUD;
    MBProgressHUD *toastHUD;
}

@property(nonatomic,weak)UIView *topView;

@end

@implementation YHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.navigationController.viewControllers count]>1) {
        [self addBackButtonWithText:nil];
    }
    
}

- (void)addBackButtonWithText:(NSString *)text
{
    CGFloat length = text.length * 20;
    if (text.length >= 4) {
        length = text.length*18;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, length > 0 ? 20 + length : 44, 44)];
    UIButton *dismiss =[ UIButton buttonWithType:UIButtonTypeCustom];
    [dismiss addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [dismiss setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [dismiss setTitle:text forState:UIControlStateNormal];
    dismiss.titleLabel.font = [UIFont systemFontOfSize:16];
    [dismiss setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    dismiss.imageView.contentMode = UIViewContentModeBottomLeft;
    dismiss.frame = CGRectMake(-20, 0, 64 + length, 44);
    if (text.length) {
        dismiss.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        dismiss.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    }
    else {
        dismiss.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
    }
    [view addSubview:dismiss];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
}

- (void)backAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (self.navigationController) {
        if([self.navigationController.viewControllers objectAtIndex:0] == self){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}

-(void)setTopTitle:(NSString *)string{
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 44)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:string];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:18*PROPORTION]];
    [title sizeToFit];
    [title setAdjustsFontSizeToFitWidth:YES];
    [self.navigationItem setTitleView:title];
}

- (void)backLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-Http请求

//多例POST
-(void)postInbackground:(NSString *)api withParam:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    NSString *urlString = [YH_REQUEST_DOMAIN stringByAppendingString:api];
    [[XAClient sharedClient] postInBackground:urlString withParam:params success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (success != nil) {
                success(responseObject);
                if ([[responseObject stringForKey:@"code"] isEqualToString:@"2"]) {
                    [self needLogin];
                }
            }
        }
    } failure:^(NSError *error) {
        if (error.code == NSURLErrorCancelled) {
            NSLog(@"请求被取消");
        }else {
            NSLog(@"请求失败---%@",error);
            if (failure != nil) {
                failure(error);
            }
        }
    }];
}

//单例有loadingPOST
-(void)post:(NSString *)api withParam:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [self showLoading:@"正在加载..."];
    NSString *urlString = [YH_REQUEST_DOMAIN stringByAppendingString:api];
    [[XAClient sharedClient] POST:urlString withParam:params success:^(id responseObject) {
        
        [self hideLoading];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (success != nil) {
                success(responseObject);
                if ([[responseObject stringForKey:@"code"] isEqualToString:@"2"]) {
                    [self needLogin];
                }
            }
        }else {
            
        }
    } failure:^(NSError *error) {
        [self hideLoading];
        if (error.code == NSURLErrorCancelled) {
            NSLog(@"请求被取消");
        }else {
            NSLog(@"请求失败---%@",error);
            [self handdleRequestError:error];
            if (failure != nil) {
                failure(error);
            }
        }
    }];
}

-(void)toastOnWindow:(NSString *)str{
    toastHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    toastHUD.mode = MBProgressHUDModeText;
    toastHUD.labelText = str;
    toastHUD.margin = 10.f;
    toastHUD.removeFromSuperViewOnHide = YES;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    toastHUD.yOffset = 0.0f*PROPORTION;
    
    [toastHUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [toastHUD removeFromSuperview];
        toastHUD = nil;
    }];
}
-(void)toast:(NSString*)str{
    toastHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    toastHUD.mode = MBProgressHUDModeText;
    toastHUD.labelText = str;
    toastHUD.margin = 10.f;
    toastHUD.removeFromSuperViewOnHide = YES;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    toastHUD.yOffset = 0.0f*PROPORTION;
    
    //    HUD.xOffset = 100.0f;
    
    [toastHUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [toastHUD removeFromSuperview];
        toastHUD = nil;
    }];
}
-(void)toast:(NSString*)str andSubView:(UIView *)subView{
    toastHUD = [MBProgressHUD showHUDAddedTo:subView animated:YES];
    
    // Configure for text only and offset down
    toastHUD.mode = MBProgressHUDModeText;
    toastHUD.labelText = str;
    toastHUD.margin = 10.f;
    toastHUD.removeFromSuperViewOnHide = YES;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    toastHUD.yOffset = 0.0f*PROPORTION;
    
    //    HUD.xOffset = 100.0f;
    
    [toastHUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [toastHUD removeFromSuperview];
        toastHUD = nil;
    }];
}

-(void)hideLoading
{
    [_HUD setHidden:YES];
    [_HUD removeFromSuperview];
    _HUD = nil;
}

-(void)showLoading:(NSString*)text
{
    if (_HUD ==nil) {
        _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_HUD setBackgroundColor:[UIColor clearColor]];
        [_HUD setDimBackground:NO];
        _HUD.delegate = self;
        [_HUD setLabelText:text];
        [_HUD setHidden:NO];
        _HUD.yOffset = -100;
        CGAffineTransform at =CGAffineTransformMakeRotation(2*M_PI);
        [_HUD setTransform:at];
        [self.view bringSubviewToFront:_HUD];
    }
}

- (void)alertControllerWithMsg:(NSString *)msg Title:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", "") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)handdleRequestError:(NSError *)error
{
    if (error.code == 10086) {
        [self alertControllerWithMsg:@"网络不可用！" Title:@"温馨提示"];
    }else {
        NSString *msg = [[error userInfo] objectForKey:@"des"];
        NSString *alart = [[error userInfo] stringForKey:@"NSLocalizedDescription"];
        if (msg) {
            [self alertControllerWithMsg:msg Title:@"温馨提示"];
        }else if(alart.length>0)
        {
            [self alertControllerWithMsg:[[error userInfo] stringForKey:@"NSLocalizedDescription"] Title:@"温馨提示"];
        }else
        {
            [self alertControllerWithMsg:@"服务器忙，请稍后重试" Title:@"温馨提示"];
        }
    }
}


// ------ 图片压缩至100K以内上传
-(NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>2*1024*1024) {//2M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.05);
        }else if (data.length>1024*1024) {//1M-2M
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.2);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.4);
        }
    }
    return data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)JDuploadImages:(NSArray<UIImage *> *)images isAsync:(BOOL)isAsync complete:(void(^)(NSArray<NSString *> *names))complete fail:(void(^)())error
{
    [self showLoading:@"图片上传"];
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc]initWithPlainTextAccessKey:OSS_AccessKey secretKey:OSS_SecretKey];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:OSS_Endpoint credentialProvider:credential];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = OSS_BucketName;
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970]*1000;
#warning
//                NSString *imageName = [NSString stringWithFormat:@"%@%.0f.jpg",[DataManager shared].currentUser.mobile,a];
                NSString *imageName = [NSString stringWithFormat:@"%@%.0f.jpg",@"111",a];
                put.objectKey = imageName;
                [callBackNames addObject:imageName];
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                put.uploadingData = data;
                
                OSSTask * putTask = [client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (!putTask.error) {
                    NSLog(@"upload object success!");
                } else {
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                    if (error) {
                        error();
                    }
                }
                if (isAsync) {
                    if (image == images.lastObject) {
                        NSLog(@"upload object finished!");
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideLoading];
                            if (complete) {
                                complete([NSArray arrayWithArray:callBackNames]);
                            }
                        });
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if (complete) {
                complete([NSArray arrayWithArray:callBackNames]);
            }
        });
    }
}
//上传文件到阿里oss
-(void)uploadVoices:(NSArray<NSData *> *)voices isAsync:(BOOL)isAsync complete:(void(^)(NSArray<NSString *> *names))complete fail:(void(^)())error
{
    [self showLoading:@"文件上传"];
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc]initWithPlainTextAccessKey:OSS_AccessKey secretKey:OSS_SecretKey];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:OSS_Endpoint credentialProvider:credential];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = voices.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (NSData *voiceData in voices) {
        if (voiceData) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970]*1000;
                NSString *voiceName = [NSString stringWithFormat:@"%@%.0f.mp3",[UserInfoManager manager].currUserInfo.login,a];
                put.objectKey = voiceName;
                put.bucketName = OSS_BucketName;
                [callBackNames addObject:voiceName];
                
                put.uploadingData = voiceData;
                
                OSSTask * putTask = [client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (!putTask.error) {
                    NSLog(@"upload object success!");
                } else {
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                    if (error) {
                        error();
                    }
                }
                if (isAsync) {
                    if (voiceData == voices.lastObject) {
                        NSLog(@"upload object finished!");
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideLoading];
                            if (complete) {
                                complete([NSArray arrayWithArray:callBackNames]);
                            }
                        });
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if (complete) {
                complete([NSArray arrayWithArray:callBackNames]);
            }
        });
    }
}

-(void)needLogin{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您还未登录" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YHLoginViewController *vc=[[YHLoginViewController alloc]init];
        BaseNavViewController *nav=[[BaseNavViewController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    [alert addAction:action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)dealloc{
    
}
- (void)p_setNavigationBarColor:(UIColor *)color translucent:(BOOL)isTranslucent
{
    self.navigationController.navigationBar.translucent = isTranslucent;
    UIImage *image = [UIImage imageWithColor:color];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
@end
