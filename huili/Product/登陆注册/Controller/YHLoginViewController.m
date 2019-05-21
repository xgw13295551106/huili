//
//  YHLoginViewController.m
//  Edu
//
//  Created by yangH4 on 16/3/5.
//  Copyright © 2016年 yangH4. All rights reserved.
//

#import "YHLoginViewController.h"
#import "AppDelegate.h"
#import "UserInfoManager.h"
#import "RegistViewController.h"
#import "ForgetViewController.h"
#import "LCBindPhoneViewController.h"
#import <AlipaySDK/AlipaySDK.h>

typedef enum {
    QQloginType = 333,  ///< QQ第三方登录
    WechatLoginType,     ///< 微信第三方登录
    AliPayLoginType     ///< 支付宝登录
}LoginType;

@interface YHLoginViewController ()

@property(nonatomic,weak)UITextField *user;

@property(nonatomic,weak)UITextField *password;

@property (nonatomic,strong)UIButton *qqButton; ///< qq第三方登录
@property (nonatomic,strong)UIButton *wechatButton; ///< 微信第三方登录

@end

@implementation YHLoginViewController


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notifi_RegistSuccess object:nil];
}

-(void)regisrSuccess{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(toLogin) userInfo:nil repeats:NO];
    
}
-(void)toLogin{
    _user.text=[UserDefaults stringForKey:@"login"];
    _password.text=[UserDefaults stringForKey:@"pwd"];
    [self login];
}

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regisrSuccess) name:Notifi_RegistSuccess object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitle:@"登录"];
    
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(toRegist)];;
    self.navigationItem.rightBarButtonItem=rightBar;
    
    UIBarButtonItem *backBar=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)];
    self.navigationItem.leftBarButtonItem=backBar;
    
     [self setCreatUI];
    
    // Do any additional setup after loading the view.
}



- (void)setCreatUI{
    UIView *loginBg=[[UIView alloc]initWithFrame:CGRectMake(10, 10, AL_DEVICE_WIDTH-20, 44)];
    [loginBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [self.view addSubview:loginBg];
    UITextField *user=[[UITextField alloc]initWithFrame:CGRectMake(5, 7, loginBg.width-10, 30)];
    [user setTextColor:text1Color];
    _user=user;
    [user setFont:[UIFont systemFontOfSize:15]];
    [loginBg addSubview:user];
    UILabel *loginLeft=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [loginLeft setText:@"  手机号"];
    [loginLeft setTextColor:text1Color];
    [loginLeft setFont:[UIFont systemFontOfSize:15]];
    [user setLeftView:loginLeft];
    [user setLeftViewMode:UITextFieldViewModeAlways];
    [user setPlaceholder:@"请输入手机号"];
    [user setKeyboardType:UIKeyboardTypeNumberPad];
    
    UIView *pwdBg=[[UIView alloc]initWithFrame:CGRectMake(10, 10+loginBg.bottom, AL_DEVICE_WIDTH-20, 44)];
    [pwdBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [self.view addSubview:pwdBg];
    UITextField *password=[[UITextField alloc]initWithFrame:CGRectMake(5, 7, loginBg.width-10, 30)];
    [password setTextColor:text1Color];
    _password=password;
    [password setFont:[UIFont systemFontOfSize:15]];
    [pwdBg addSubview:password];
    UILabel *pwdLeft=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [pwdLeft setText:@"  密码"];
    [pwdLeft setTextColor:text1Color];
    [pwdLeft setFont:[UIFont systemFontOfSize:15]];
    [password setLeftView:pwdLeft];
    [password setLeftViewMode:UITextFieldViewModeAlways];
    [password setPlaceholder:@"请输入密码"];
    [password setSecureTextEntry:YES];
    
    UIButton *sumbitBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, pwdBg.bottom+20, AL_DEVICE_WIDTH-20, 44)];
    [sumbitBtn setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
    [sumbitBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [sumbitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sumbitBtn];
    [sumbitBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forgetBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-120, sumbitBtn.bottom+5, 120, 25)];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [forgetBtn setTitleColor:STYLECOLOR forState:UIControlStateNormal];
    [self.view addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //第三方登录label
    UILabel *third_label = [[UILabel alloc]init];
    third_label.text = @"第三方授权登录";
    third_label.font = [UIFont systemFontOfSize:12];
    third_label.textColor = [UIColor colorWithHexString:@"565756"];
    [third_label sizeToFit];
    third_label.center = CGPointMake(win_width/2,  win_height-100-KIsiPhoneXNavHAndB);
    [self.view addSubview:third_label];
    //第三方登录label两边的横线
    CGFloat space = 12; //两边横线距离第三方登录label的距离
    CGFloat win_space = 30; //两边横线距离边框的距离
    CGFloat thirdView_w = (win_width - third_label.size.width - 2*(space+win_space))/2;
    CGFloat thirdView_y = third_label.centerY - 0.5;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(win_space, thirdView_y, thirdView_w, 1)];
    [view1 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:view1];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(third_label.frame)+space, thirdView_y, thirdView_w, 1)];
    [view2 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:view2];
    
    //qq第三方登录
    UIImage *qqImage = [UIImage imageNamed:@"login_qq"];
    _qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_qqButton setFrame:CGRectMake(win_width/2-30-44, third_label.maxY+15, 44, 44)];
    [_qqButton setImage:qqImage forState:UIControlStateNormal];
    [_qqButton addTarget:self action:@selector(clickQQButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_qqButton];
    
    //微信第三方登录
    UIImage *wxImage = [UIImage imageNamed:@"login_weixin"];
    _wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wechatButton setFrame:CGRectMake(win_width/2+30, third_label.maxY+15, 44, 44)];
    [_wechatButton setImage:wxImage forState:UIControlStateNormal];
    [_wechatButton addTarget:self action:@selector(clickWechatButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wechatButton];
    
    
}


-(void)rightBtn
{//忘记密码
    ForgetViewController *vc=[[ForgetViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)toRegist
{//立即注册
    RegistViewController *vc=[[RegistViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//TODO:点击QQ第三方登录button
- (void)clickQQButton:(UIButton *)button{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqapi://"]]) {
        //QQ
        __weak typeof(self) weakSelf = self;
        [weakSelf addUIAlertControlWithString:@"未安装腾讯QQ" withActionBlock:nil];
        return;
    }
    [SVProgressHUD show];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        if (error == nil) {
            UMSocialUserInfoResponse *snsAccount = result;
            [self requestThirdLoginNetworkingWith:QQloginType andOpenId:snsAccount.openid andImg:snsAccount.iconurl andName:snsAccount.name];
        }else{
            [SVProgressHUD dismiss];
            [self.view makeToast:@"失败" duration:1.2 position:CSToastPositionCenter];
        }
    }];
}

//TODO:点击微信第三方登录button
- (void)clickWechatButton:(UIButton *)button{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        __weak typeof(self) weakSelf = self;
        [weakSelf addUIAlertControlWithString:@"未安装微信软件" withActionBlock:nil];
        return;
    }
    [SVProgressHUD show];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (error == nil) {
            UMSocialUserInfoResponse *snsAccount = result;
            [self requestThirdLoginNetworkingWith:WechatLoginType andOpenId:snsAccount.openid andImg:snsAccount.iconurl andName:snsAccount.name];
        }else{
            [SVProgressHUD dismiss];
            [self.view makeToast:@"失败" duration:1.2 position:CSToastPositionCenter];
        }
    }];
    
    
}



-(void)login{
    [_password resignFirstResponder];
    [_user resignFirstResponder];
    if (_password.text.length<6 ||_password.text.length>18) {
        [_password becomeFirstResponder];
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入6-18位密码"];
        return;
    }
    
    if (![_user.text isEqualToString:@""]) {
        if (![_password.text isEqualToString:@""]) {
            NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
            [param setObject:_user.text forKey:@"mobile"];
            [param setObject:_password.text forKey:@"pwd"];
            [self post:YHLogin withParam:param success:^(id responseObject) {
                int code=[responseObject intForKey:@"code"];
                if (code==1) {
                    
                    [SVProgressHUDHelp SVProgressHUDSuccess:@"登录成功"];
                    
                    [UserDefaults setValue:_user.text forKey:@"login"];
                    [UserDefaults setValue:_password.text forKey:@"pwd"];
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    NSLog(@"%@",data);
                    UserInfoManager *manage = [UserInfoManager manager];
                    [manage saveUserInfo:[UserInfoModel getUserModel:data]];
                    
                    NSLog(@"%@",manage.currUserInfo.token);
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_LoginSuccess object:nil userInfo:nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_CartChange object:nil userInfo:nil];
                    }];
                    
                }else{
                    [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
                }
            } failure:nil];
            
        }
        else
        {
            [SVProgressHUDHelp SVProgressHUDFail:@"请输入密码"];
        }
    }
    else
    {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入用户名／手机号"];
    }
    
    
    
    
    
}


//第三方登录
- (void)requestThirdLoginNetworkingWith:(LoginType)loginType
                              andOpenId:(NSString *)openId
                                 andImg:(NSString *)img
                                andName:(NSString *)name{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"open_id"] = openId;
    para[@"img"] = img;
    para[@"name"] = name;
    if (loginType == QQloginType) {
        para[@"type"] = @"1";
    }else if (loginType == WechatLoginType){
        para[@"type"] = @"2";
    }
    
    [self postInbackground:LCThirdLogin withParam:para success:^(id resultObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = resultObject;
        if ([dic[@"code"] intValue] == 1) {
            UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues:dic[@"data"]];
            if ([NSString stringIsNull:userInfo.login]) {
                LCBindPhoneViewController *vc  = [[LCBindPhoneViewController alloc]init];
                vc.thirdDic = @{@"open_id":openId,@"type":para[@"type"]};
                vc.bindBlock = ^(BOOL isSuccessed) {
                    if (isSuccessed) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [[UserInfoManager manager]saveUserInfo:[UserInfoModel getUserModel:dic[@"data"]]];
                userInfo = [UserInfoManager currentUser];
                [self.view makeToast:@"登录成功" duration:1.2 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //登陆成功，跳转主页面
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:Network_Error duration:1.2 position:CSToastPositionCenter];
    }];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _user.text=[UserDefaults stringForKey:@"login"];
    _password.text=[UserDefaults stringForKey:@"pwd"];
}


-(void)clickBack{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//添加提示（只有一个框的）
-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (actionBlock) {
            actionBlock();
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
