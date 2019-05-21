//
//  LCBindAccountViewController.m
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "LCBindAccountViewController.h"
#import "LCBindAlipayViewController.h"
#import "LCUnbondViewController.h"

@interface LCBindAccountViewController (){
    UIView *unBindView; ///< 未绑定账户的view
    UIView *bindView; ///< 已绑定账户的view
    UILabel *nameLabel; ///< 已绑定账户的姓名label
    UILabel *accountLabel; ///< 已绑定账户的支付宝账号
}

@end

@implementation LCBindAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"绑定账户";
    [self setUpControls];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([NSString stringIsNull:[UserInfoManager currentUser].alipay_account]) {
        bindView.hidden = YES;
        unBindView.hidden = NO;
    }else{
        bindView.hidden = NO;
        unBindView.hidden = YES;
        nameLabel.text = [UserInfoManager currentUser].alipay_realname;
        accountLabel.text = [UserInfoManager currentUser].alipay_account;
    }
}

- (void)setUpControls{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"F7F8F7"]];
    
    //未绑定的bg
    unBindView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, win_width - 15*2, 80)];
    [unBindView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:unBindView];
    unBindView.layer.cornerRadius = 3;
    unBindView.layer.masksToBounds = YES;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, unBindView.width, unBindView.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(unBindView.bounds), CGRectGetMidY(unBindView.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:3].CGPath;
    borderLayer.lineWidth = 1;
    //虚线边框
    borderLayer.lineDashPattern = @[@4, @4];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor grayColor].CGColor;
    [unBindView.layer addSublayer:borderLayer];
    
    //支付宝图片
    UIImage *alipayImage = [UIImage imageNamed:@"user_wallet_account_alipay"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(unBindView.width/2-alipayImage.size.width/2, 12, alipayImage.size.width, alipayImage.size.height)];
    [imageView setImage:alipayImage];
    imageView.userInteractionEnabled = YES;
    [unBindView addSubview:imageView];
    
    //支付宝文字
    UILabel *alipayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.maxY+8, unBindView.width, 20)];
    alipayLabel.textColor = STYLECOLOR;
    alipayLabel.font = [UIFont systemFontOfSize:14];
    alipayLabel.text = @"点击绑定支付宝账号";
    alipayLabel.textAlignment = NSTextAlignmentCenter;
    alipayLabel.userInteractionEnabled = YES;
    [unBindView addSubview:alipayLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBindAlipayView:)];
    [unBindView addGestureRecognizer:tap];
    
    //已绑定账户的view
    bindView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, win_width, 80)];
    [bindView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bindView];
    
    UIImageView *bindImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, bindView.height/2-alipayImage.size.height/2, alipayImage.size.width, alipayImage.size.height)];
    [bindImageView setImage:alipayImage];
    [bindView addSubview:bindImageView];
    
    //支付宝姓名
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(bindImageView.maxX+10, bindImageView.minY - 5, 220, 20)];
    nameLabel.textColor = [UIColor colorWithHexString:@"5D5E5D"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = @"";
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [bindView addSubview:nameLabel];
    
    
    //支付宝账号
    accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.minX, nameLabel.maxY+5, 220, 20)];
    accountLabel.textColor = [UIColor colorWithHexString:@"129FF0"];
    accountLabel.font = [UIFont systemFontOfSize:14];
    accountLabel.text = @"";
    accountLabel.textAlignment = NSTextAlignmentLeft;
    [bindView addSubview:accountLabel];
    
    //解除绑定
    UIButton *unboundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unboundButton setFrame:CGRectMake(win_width-10-60, 10, 60, 60)];
    [unboundButton setImage:[UIImage imageNamed:@"user_wallet_account_delete"] forState:UIControlStateNormal];
    [unboundButton setTitle:@"解除绑定" forState:UIControlStateNormal];
    [unboundButton setTitleColor:[UIColor colorWithHexString:@"EF0032"] forState:UIControlStateNormal];
    unboundButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [unboundButton addTarget:self action:@selector(clickUnboundButton:) forControlEvents:UIControlEventTouchUpInside];
    [bindView addSubview:unboundButton];
    CGFloat offset = 10.0f;  //设置图片和文字的距离
    unboundButton.titleEdgeInsets = UIEdgeInsetsMake(0, -unboundButton.imageView.frame.size.width, -unboundButton.imageView.frame.size.height-offset/2, 0);
    unboundButton.imageEdgeInsets = UIEdgeInsetsMake(-unboundButton.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -unboundButton.titleLabel.intrinsicContentSize.width);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击绑定
- (void)clickBindAlipayView:(UIGestureRecognizer *)gesture
{
    if ([NSString stringIsNull:[UserInfoManager currentUser].alipay_account]) {
        LCBindAlipayViewController *vc = [[LCBindAlipayViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        __weak typeof(self) weakSelf = self;
        [weakSelf addUIAlertControlWithString:@"您已绑定过账号，是否重新绑定？" withActionBlock:^{
            LCBindAlipayViewController *vc = [[LCBindAlipayViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        } andCancel:nil];
    }
    
}


//解除绑定
- (void)clickUnboundButton:(UIButton *)button{
    LCUnbondViewController *vc = [[LCUnbondViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (actionBlock) {
            actionBlock();
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
