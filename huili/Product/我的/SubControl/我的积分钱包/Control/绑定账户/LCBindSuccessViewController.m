//
//  LCBindSuccessViewController.m
//  EduParent
//
//  Created by zhongweike on 2017/9/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCBindSuccessViewController.h"
#import "LCWithdrawViewController.h"

@interface LCBindSuccessViewController ()

@end

@implementation LCBindSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定账户";
    [self setUpControls];
}

- (void)setUpControls{
    UIImage *image = [UIImage imageNamed:@"user_wallet_account_success"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(win_width/2-image.size.width/2, 30, image.size.width, image.size.height)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    
    //绑定成功label
    UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.maxY+20, win_width, 25)];
    successLabel.font = [UIFont systemFontOfSize:22];
    successLabel.text = @"绑定成功";
    successLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:successLabel];
    
    //提示label
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, successLabel.maxY, win_width, 40)];
    promptLabel.textColor = [UIColor colorWithHexString:@"575857"];
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.text = @"您可以将钱包的账户可提余额\n提现至所绑定的账户中";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 2;
    [self.view addSubview:promptLabel];
    
    //返回button
    UIButton *backButton  = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setFrame:CGRectMake(15, promptLabel.maxY+30, win_width-2*15, 44)];
    [backButton setBackgroundColor:STYLECOLOR];
    [backButton setTitle:@"返回绑定账户" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    backButton.layer.cornerRadius = 5;
    backButton.layer.masksToBounds = YES;
    [backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //立即提现
    UIButton *expendButton  = [UIButton buttonWithType:UIButtonTypeSystem];
    [expendButton setFrame:CGRectMake(15, backButton.maxY+10, win_width-2*15, 44)];
    [expendButton setBackgroundColor:STYLECOLOR];
    [expendButton setTitle:@"立即提现" forState:UIControlStateNormal];
    [expendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:expendButton];
    expendButton.layer.cornerRadius = 5;
    expendButton.layer.masksToBounds = YES;
    [expendButton addTarget:self action:@selector(clickExpendButton:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)backAction:(UIButton *)sender{
    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
}

//点击返回我的钱包
- (void)clickBackButton:(UIButton *)button{
    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
    
}

//点击进入立即提现
- (void)clickExpendButton:(UIButton *)button{
    LCWithdrawViewController *vc = [[LCWithdrawViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
