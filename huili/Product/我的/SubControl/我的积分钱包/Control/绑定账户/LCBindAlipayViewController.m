//
//  LCBindAlipayViewController.m
//  EduParent
//
//  Created by zhongweike on 2017/9/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCBindAlipayViewController.h"
#import "LCBindSuccessViewController.h"

@interface LCBindAlipayViewController (){
    UILabel *nameLabel;
    UITextField *name;
    UILabel *alipayLabel;
    UITextField *alipay;
    UILabel *phoneLabel;
    UITextField *phone;
    UILabel *codeLabel;
    UITextField *code;
    UIButton *codeButton; //获取验证码
    UIButton *confirmButton;  ///< 确认绑定
}

@end

@implementation LCBindAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定账户";
    [self setUpControls];
}

- (void)setUpControls{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"F7F8F7"]];
    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 8, win_width, 200)];
    [bg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bg];
    //支付宝账号
    alipayLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [alipayLabel setText:@"支付宝账号"];
    [alipayLabel setFont:[UIFont systemFontOfSize:15]];
    [alipayLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    alipay=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, win_width-20, 50)];
    [alipay setFont:[UIFont systemFontOfSize:15]];
    [alipay setPlaceholder:@"请输入支付宝账号"];
    [alipay setKeyboardType:UIKeyboardTypeASCIICapable];
    [alipay setTextColor:[UIColor colorWithHexString:@"333333"]];
    [alipay setLeftView:alipayLabel];
    [alipay setLeftViewMode:UITextFieldViewModeAlways];
    [bg addSubview:alipay];
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 49, win_width, 1)];
    [line1 setBackgroundColor:LineColor];
    [bg addSubview:line1];
    //姓名
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [nameLabel setText:@"姓名"];
    [nameLabel setFont:[UIFont systemFontOfSize:15]];
    [nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    name=[[UITextField alloc]initWithFrame:CGRectMake(10, alipay.maxY, win_width-20, 50)];
    [name setFont:[UIFont systemFontOfSize:15]];
    [name setPlaceholder:@"请输入与支付宝账号对应的姓名"];
    [name setTextColor:[UIColor colorWithHexString:@"333333"]];
    [name setLeftView:nameLabel];
    [name setLeftViewMode:UITextFieldViewModeAlways];
    [bg addSubview:name];
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 99, win_width, 1)];
    [line2 setBackgroundColor:LineColor];
    [bg addSubview:line2];
    
    //手机号
    phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 50)];
    [phoneLabel setText:@"手机号"];
    [phoneLabel setFont:[UIFont systemFontOfSize:15]];
    [phoneLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    phone=[[UITextField alloc]initWithFrame:CGRectMake(10, name.maxY, win_width-20, 50)];
    [phone setFont:[UIFont systemFontOfSize:15]];
    [phone setText:[UserInfoManager currentUser].login];
    [phone setEnabled:NO];
    [phone setKeyboardType:UIKeyboardTypeASCIICapable];
    [phone setTextColor:[UIColor colorWithHexString:@"333333"]];
    [phone setLeftView:phoneLabel];
    [phone setLeftViewMode:UITextFieldViewModeAlways];
    [bg addSubview:phone];
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0, 149, win_width, 1)];
    [line3 setBackgroundColor:LineColor];
    [bg addSubview:line3];
    
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
    
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(0, 199, win_width, 1)];
    [line4 setBackgroundColor:LineColor];
    [bg addSubview:line4];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(15, bg.maxY +20, win_width-15*2, 44)];
    [confirmButton setBackgroundColor:STYLECOLOR];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"立即绑定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    [self.view addSubview:confirmButton];
    
    //警告
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(confirmButton.minX, confirmButton.maxY +3, confirmButton.width, 30)];
    promptLabel.textColor = [UIColor colorWithHexString:@"F00A3A"];
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.text = @"请确认支付宝账户正确无误，绑定错误将无法成功提现!";
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.numberOfLines = 2;
    [self.view addSubview:promptLabel];
    
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

#pragma mark Networking
//获取手机验证码
- (void)requestCodeNetworking{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"type"] = @"5";
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

//完成
-(void)doneClick{
    if ([NSString stringIsNull:name.text]) {
        [self.view makeToast:@"请输入姓名" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    if ([NSString stringIsNull:alipay.text]) {
        [self.view makeToast:@"请输入支付宝账号" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    if ([NSString stringIsNull:code.text]) {
        [self.view makeToast:@"请输入验证码" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    [self.view endEditing:YES];
    NSString *message = [NSString stringWithFormat:@"姓名：%@\n支付宝账号：%@\n手机号：%@",name.text,alipay.text,[UserInfoManager currentUser].login];
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"请确认账户信息" message:message];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        
    }]];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"确认" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        [self requestBindNetwokring];
    }]];
    
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleScaleFade];
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}
//TODO:请求绑定接口
- (void)requestBindNetwokring
{
    NSMutableDictionary *para  = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"name"] = name.text;
    para[@"account"] = alipay.text;
    para[@"mobile"] = [UserInfoManager currentUser].login;
    para[@"code"] = code.text;
    [self post:LCBindAccount withParam:para success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            UserInfoModel * userInfo = [UserInfoModel mj_objectWithKeyValues:dic[@"data"]];
            [[UserInfoManager manager]saveUserInfo:userInfo];
            LCBindSuccessViewController *vc = [[LCBindSuccessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
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
