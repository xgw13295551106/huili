//
//  WKBaseViewController.m
//  Bee
//
//  Created by zxy on 2017/3/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "WKBaseViewController.h"
#import <WebKit/WebKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import "ShareView.h"

@interface WKBaseViewController ()<WKNavigationDelegate,WKUIDelegate>
// The web views
// Depending on the version of iOS, one of these will be set
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation WKBaseViewController
- (void)dealloc{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView removeObserver:self forKeyPath:@"title"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
    
    if (_model) {
        UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"common_button_share_def"] style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
        self.navigationItem.rightBarButtonItem=rightBar;
    }
    
    
    self.wkWebView = [[WKWebView alloc] init];
    
    [self.wkWebView setFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT)];
    [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.wkWebView setNavigationDelegate:self];
    [self.wkWebView setUIDelegate:self];
    [self.wkWebView setMultipleTouchEnabled:YES];
    [self.wkWebView setAutoresizesSubviews:YES];
    [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:self.wkWebView];
    self.wkWebView.scrollView.bounces = NO;
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.progressView setFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, self.progressView.frame.size.height)];
    
    //设置进度条颜色
    [self setTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
    [self.view addSubview:self.progressView];
    
    NSURL *url = [NSURL URLWithString:@""];
    if (_url.length) {
        url = [NSURL URLWithString:self.url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_wkWebView loadRequest:request];
    
    // Do any additional setup after loading the view.
}
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.progressView setTintColor:tintColor];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == _wkWebView) {
            [_progressView setAlpha:1.0f];
            [_progressView setProgress:_wkWebView.estimatedProgress animated:YES];
            
            if (_wkWebView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [_progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [_progressView setProgress:0.0f animated:NO];
                }];
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"title"]){
        if (object == _wkWebView) {
            [self setTitle:_wkWebView.title];
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setModel:(YeFuListModel *)model{
    _model=model;
    [self setUrl:[NSString stringWithFormat:@"%@&token=%@",model.url,TOKEN]];
    [self setTitle:model.title];
}
-(void)shareClick{
    [[ShareView ShareViewClient] shareClick:_model.url setTitle:_model.title setContent:_model.cat_name setIcon:_model.img];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
