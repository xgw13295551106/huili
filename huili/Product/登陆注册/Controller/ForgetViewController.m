//
//  ForgetViewController.m
//  ConvenienceStore
//
//  Created by Carl on 2017/10/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()

@property(nonatomic,weak)UITextField *user;

@property(nonatomic,weak)UITextField *code;

@property(nonatomic,weak)UIButton *codeBtn;

@property(nonatomic,weak)UITextField *password;

@property(nonatomic,weak)UITextField *password2;

@property(nonatomic)NSTimer *timer;//定时器

@property(nonatomic)int timeInt;//定时60秒

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"忘记密码"];
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

/****************************创建UI**************************************/
-(void)creatUI{
    
    UIView *loginBg=[[UIView alloc]initWithFrame:CGRectMake(10, 10, AL_DEVICE_WIDTH-20, 44)];
    [loginBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [self.view addSubview:loginBg];
    UITextField *user=[[UITextField alloc]initWithFrame:CGRectMake(5, 7, loginBg.width-10, 30)];
    [user setTextColor:text1Color];
    _user=user;
    [user setFont:[UIFont systemFontOfSize:14]];
    [loginBg addSubview:user];
    UILabel *loginLeft=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [loginLeft setText:@"  手机号"];
    [loginLeft setTextColor:text1Color];
    [loginLeft setFont:[UIFont systemFontOfSize:14]];
    [user setLeftView:loginLeft];
    [user setLeftViewMode:UITextFieldViewModeAlways];
    [user setPlaceholder:@"请输入手机号"];
    [user setKeyboardType:UIKeyboardTypeNumberPad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:user];
    
    
    UIView *codeBg=[[UIView alloc]initWithFrame:CGRectMake(10, loginBg.bottom+10, AL_DEVICE_WIDTH-140, 44)];
    [codeBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [self.view addSubview:codeBg];
    UITextField *code=[[UITextField alloc]initWithFrame:CGRectMake(5, 7, loginBg.width-10, 30)];
    [code setTextColor:text1Color];
    _code=code;
    [code setFont:[UIFont systemFontOfSize:14]];
    [codeBg addSubview:code];
    UILabel *codeLeft=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [codeLeft setText:@"  验证码"];
    [codeLeft setTextColor:text1Color];
    [codeLeft setFont:[UIFont systemFontOfSize:14]];
    [code setLeftView:codeLeft];
    [code setLeftViewMode:UITextFieldViewModeAlways];
    [code setPlaceholder:@"请输入验证码"];
    
    UIButton *codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setFrame:CGRectMake(codeBg.right+10, codeBg.y, 110, 44)];
    [codeBtn setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
    [codeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cccccc"]] forState:UIControlStateDisabled];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:codeBtn];
    [codeBtn setEnabled:NO];
    [codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    _codeBtn=codeBtn;
    
    
    UIView *pwdBg=[[UIView alloc]initWithFrame:CGRectMake(10, 10+codeBtn.bottom, AL_DEVICE_WIDTH-20, 44)];
    [pwdBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [self.view addSubview:pwdBg];
    UITextField *password=[[UITextField alloc]initWithFrame:CGRectMake(5, 7, loginBg.width-10, 30)];
    [password setTextColor:text1Color];
    _password=password;
    [password setFont:[UIFont systemFontOfSize:14]];
    [pwdBg addSubview:password];
    UILabel *pwdLeft=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [pwdLeft setText:@"  密码"];
    [pwdLeft setTextColor:text1Color];
    [pwdLeft setFont:[UIFont systemFontOfSize:14]];
    [password setLeftView:pwdLeft];
    [password setLeftViewMode:UITextFieldViewModeAlways];
    [password setPlaceholder:@"请输入登录密码"];
    [password setSecureTextEntry:YES];
    
    
    UIView *pwdBg2=[[UIView alloc]initWithFrame:CGRectMake(10, 10+pwdBg.bottom, AL_DEVICE_WIDTH-20, 44)];
    [pwdBg2 setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [self.view addSubview:pwdBg2];
    UITextField *password2=[[UITextField alloc]initWithFrame:CGRectMake(5, 7, loginBg.width-10, 30)];
    [password2 setTextColor:text1Color];
    _password2=password2;
    [password2 setFont:[UIFont systemFontOfSize:14]];
    [pwdBg2 addSubview:password2];
    UILabel *pwd2Left=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [pwd2Left setText:@"  确认密码"];
    [pwd2Left setTextColor:text1Color];
    [pwd2Left setFont:[UIFont systemFontOfSize:14]];
    [password2 setLeftView:pwd2Left];
    [password2 setLeftViewMode:UITextFieldViewModeAlways];
    [password2 setPlaceholder:@"请输入登录密码"];
    [password2 setSecureTextEntry:YES];
    
    
    UIButton *sumbitBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, pwdBg2.bottom+20, AL_DEVICE_WIDTH-20, 44)];
    [sumbitBtn setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
    [sumbitBtn setTitle:@"确认修改密码" forState:UIControlStateNormal];
    [sumbitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sumbitBtn];
    [sumbitBtn addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    
}
/****************************创建UI**************************************/

/****************************验证码按钮的变化**************************************/

//定时器
-(NSTimer*)timer{
    if (_timer==nil) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)userDidChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    if (sender.text.length==11) {
        [_codeBtn setEnabled:YES];
    }else{
        [_codeBtn setEnabled:NO];
    }
}

#pragma mark--获取验证码
-(void)getCode{
    if (![_user.text isEqualToString:@""]) {
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setValue:@"2" forKey:@"type"];
        NSString *mobile = [NSString stringWithFormat:@"%ld",arc4random()%10000000000+10000000000];
        [param setValue:[LCTools rsaEncryptStr:_user.text] forKey:@"guess"];
        [param setObject:[YHHelpper md5:mobile] forKey:@"mobile"];
        [self post:YHCODE withParam:param success:^(id responseObject) {
            int code=[responseObject intForKey:@"code"];
            if (code == 1) {
                [_codeBtn setEnabled:NO];
                self.timeInt=60;
                [_codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.timeInt] forState:UIControlStateNormal];
                [self.timer fire];
                [SVProgressHUDHelp SVProgressHUDSuccess:@"获取验证码成功"];
            }
            else
            {
                [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
            }
        } failure:nil];
    }
    else
    {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入手机号"];
    }
}

#pragma mark--倒计时
-(void)timerChange{
    self.timeInt--;
    if (self.timeInt==0) {
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setEnabled:YES];
        [self.timer invalidate];
        self.timer=nil;
    }else{
        [_codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.timeInt] forState:UIControlStateNormal];
        [_codeBtn setEnabled:NO];
    }
    
}

/****************************验证码按钮的变化**************************************/

/****************************立即修改**************************************/
-(void)sumbitClick{
    
    if ([_user.text isEqualToString:@""]) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入手机号"];
        return;
    }
    
    if ([_code.text isEqualToString:@""]) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入验证码"];
        return;
    }
    if (_password.text.length<6 ||_password.text.length>18) {
        [_password becomeFirstResponder];
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入6位以上密码"];
        return;
    }
    
    if ([_password.text isEqualToString:_password2.text]) {
        if (_password.text.length>=6) {
            
            NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
            [param setObject:_password.text forKey:@"pwd"];
            [param setValue:_code.text forKey:@"code"];
            [param setValue:_user.text forKey:@"mobile"];
            [self post:WJDUPDATEPWD withParam:param success:^(id responseObject) {
                int code=[responseObject intForKey:@"code"];
                if (code == 1) {
                    [UserDefaults setValue:_user.text forKey:@"login"];
                    [UserDefaults setValue:_password.text forKey:@"pwd"];
                    [SVProgressHUDHelp SVProgressHUDSuccess:@"重置成功，请登录"];
                    
                    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(back) userInfo:nil repeats:NO];
                    
                }
                else
                {
                    [SVProgressHUDHelp SVProgressHUDFail:responseObject[@"msg"]];
                }
                
            } failure:^(NSError *error) {
                [SVProgressHUDHelp SVProgressHUDFail:@"修改失败"];
            }];
        }
        else
        {
            [SVProgressHUDHelp SVProgressHUDFail:@"密码不少于6位数"];
        }
    }else
    {
        [SVProgressHUDHelp SVProgressHUDFail:@"密码不一致"];
    }
}

-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/****************************立即修改**************************************/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
