//
//  LCLeadViewController.m
//  ios_demo
//
//  Created by 刘翀 on 16/9/26.
//  Copyright © 2016年 xinhuo. All rights reserved.
//

#import "LCLeadViewController.h"
#import "BaseTabbarViewController.h"
#import "AppDelegate.h"

@interface LCLeadViewController ()<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    UIButton *beginButton;
}

@end

@implementation LCLeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height)];
    scrollView.contentSize = CGSizeMake(win_width*5, win_height);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    [self setScrollImage];
    
    CGFloat button_w = 200;
    CGFloat button_h = 50;
    CGFloat button_x = win_width/2 - button_w/2 + 4*win_width;
    CGFloat button_y = win_height - button_h - 25;
    beginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [beginButton setFrame:CGRectMake(button_x, button_y, button_w, button_h)];
    [beginButton setBackgroundColor:[UIColor clearColor]];
    [beginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [beginButton setTitle:@"   " forState:UIControlStateNormal];
    [beginButton addTarget:self action:@selector(beginAction:) forControlEvents:UIControlEventTouchUpInside];

    [scrollView addSubview:beginButton];
    
}


- (void)setScrollImage{
    for (int i = 0; i<5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*win_width, 0, win_width, win_height)];
        NSString *imageName = [NSString stringWithFormat:@"ydy%i",i+1];
        [imageView setImage:[UIImage imageNamed:imageName]];
        [scrollView addSubview:imageView];
    }
}


- (void)beginAction:(id)sender{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:FirstOpen];
    BaseTabbarViewController *tabBarVC = [[BaseTabbarViewController alloc]init];
    [UIApplication sharedApplication].delegate.window.rootViewController = tabBarVC;;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
