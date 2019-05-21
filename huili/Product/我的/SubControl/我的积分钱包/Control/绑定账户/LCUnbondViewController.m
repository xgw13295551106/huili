//
//  LCUnbondViewController.m
//  EduParent
//
//  Created by zhongweike on 2017/9/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCUnbondViewController.h"

@interface LCUnbondViewController (){
    UILabel *phoneLabel;
    UITextField *phone;
    UILabel *codeLabel;
    UITextField *code;
    UIButton *codeButton; //获取验证码
    UIButton *confirmButton;  ///< 确认绑定
}

@end

@implementation LCUnbondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"解除绑定";
    [self setUpControls];
}

- (void)setUpControls{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"F7F8F7"]];
    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 8, win_width, 100)];
    [bg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bg];
    //手机号
    phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [phoneLabel setText:@"手机号"];
    [phoneLabel setFont:[UIFont systemFontOfSize:15]];
    [phoneLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    phone=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, win_width-20, 50)];
    [phone setFont:[UIFont systemFontOfSize:15]];
    [phone setText:[UserInfoManager currentUser].login];
    [phone setEnabled:NO];
    [phone setKeyboardType:UIKeyboardTypeASCIICapable];
    [phone setTextColor:[UIColor colorWithHexString:@"333333"]];
    [phone setLeftView:phoneLabel];
    [phone setLeftViewMode:UITextFieldViewModeAlways];
    [bg addSubview:phone];
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 149, win_width, 1)];
    [line1 setBackgroundColor:LineColor];
    [bg addSubview:line1];
    
    //验证码
    CGFloat codeButton_w = 80; //验证码button宽度
    codeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [codeLabel setText:@"验证码"];
    [codeLabel setFont:[UIFont systemFontOfSize:15]];
    [codeLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    code=[[UITextField alloc]initWithFrame:CGRectMake(10, phone.origin.y+phone.size.height, win_width-8 - codeButton_w, 50)];
    [code setFont:[UIFont systemFontOfSize:15]];
    [code setPlaceholder:@"请输入验证码"];
    [code setKeyboardType:UIKeyboardTypeASCIICapable];
    [code setTextColor:[UIColor colorWithHexString:@"333333"]];
    [code setLeftView:codeLabel];
    [code setLeftViewMode:UITextFieldViewModeAlways];
    [bg addSubview:code];
    
    CGFloat codeButton_h = 25;
    CGFloat codeButton_x = win_width - 8 - codeButton_w;
    CGFloat codeButton_y = code.center.y - codeButton_h/2;
    codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
    [codeButton setTintColor:[UIColor whiteColor]];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setFrame:CGRectMake(codeButton_x, codeButton_y, codeButton_w, codeButton_h)];
    [codeButton addTarget:self action:@selector(requestCodeNetworking) forControlEvents:UIControlEventTouchUpInside];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    codeButton.layer.cornerRadius = codeButton_h/2;
    codeButton.layer.masksToBounds = YES;
    [bg addSubview:codeButton];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 199, win_width, 1)];
    [line2 setBackgroundColor:LineColor];
    [bg addSubview:line2];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(15, bg.maxY +20, win_width-15*2, 50)];
    [confirmButton setBackgroundColor:STYLECOLOR];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"解除绑定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmButton addTarget:self action:@selector(clickUnboundButton:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    [self.view addSubview:confirmButton];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//发送验证码倒计时
-(void)countDown{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [codeButton setTitle:NSLocalizedString(@"get_code", @"") forState:UIControlStateNormal];
                codeButton.userInteractionEnabled = YES;
                [codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"53D1FC"]] forState:UIControlStateNormal];
                //                // 完成倒计时，发送消息
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"didcountdown" object:nil];
            });
        }else{
            // int minutes = timeout / 60;
            int seconds = timeout % 90;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置
                [codeButton setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                codeButton.userInteractionEnabled = NO;
                [codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"CBCCCB"]] forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (void)clickUnboundButton:(UIButton *)button{
    [self.view endEditing:YES];
    if ([NSString stringIsNull:code.text]) {
        [self.view makeToast:@"请输入验证码" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    [self requestUnboundNetworking];
    
}

#pragma mark Networking
//TODO:获取手机验证码
- (void)requestCodeNetworking{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"type"] = @"6";
    NSString *mobile = [NSString stringWithFormat:@"%ld",arc4random()%10000000000+10000000000];
    [para setValue:[LCTools rsaEncryptStr:phone.text] forKey:@"guess"];
    [para setObject:[YHHelpper md5:mobile] forKey:@"mobile"];
    [SVProgressHUD showWithStatus:@"正在发送请求"];
    [self postInbackground:YHCODE withParam:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            [self.view makeToast:@"发送成功" duration:1.2 position:CSToastPositionCenter];
            [self countDown];
            
            NSLog(@"%@",responseObject);
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
        
    } failure:nil];
}

- (void)requestUnboundNetworking{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"code"] = code.text;
    [SVProgressHUD show];
    [self postInbackground:LCUnbindAccount withParam:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            [self.view makeToast:@"解除绑定成功" duration:1.2 position:CSToastPositionCenter];
            UserInfoModel * userInfo = [UserInfoModel mj_objectWithKeyValues:dic[@"data"]];
            [[UserInfoManager manager] saveUserInfo:userInfo];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:Network_Error duration:1.2 position:CSToastPositionCenter];
    }];
    
    
}

@end
