//
//  RegistViewController.m
//  ConvenienceStore
//
//  Created by Carl on 2017/10/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "RegistViewController.h"
#import "WKBaseViewController.h"

@interface RegistViewController ()

@property(nonatomic,weak)UITextField *user;

@property(nonatomic,weak)UITextField *code;

@property(nonatomic,weak)UIButton *codeBtn;

@property(nonatomic,weak)UITextField *password;

@property(nonatomic,weak)UITextField *password2;

@property (nonatomic,strong)UITextField *shareCodeTF;  /// <邀请码

@property(nonatomic,weak)UIButton *readXieYi;

@property(nonatomic)NSTimer *timer;//定时器

@property(nonatomic)int timeInt;//定时60秒

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.fromType==1) {
        UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
        self.navigationItem.rightBarButtonItem=rightBar;
    }else{
        UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginTo)];
        self.navigationItem.rightBarButtonItem=rightBar;
    }
    [self setTitle:@"注册"];
    [self.navigationItem setHidesBackButton:YES];
    
    
    [self creatUI];
    
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)loginTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backTo{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/****************************创建UI**************************************/
-(void)creatUI{
    
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:self.view.frame];
    [scroll setContentSize:CGSizeMake(AL_DEVICE_WIDTH, 400)];
    [scroll setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scroll];
    
    UIView *loginBg=[[UIView alloc]initWithFrame:CGRectMake(10, 10, AL_DEVICE_WIDTH-20, 44)];
    [loginBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [scroll addSubview:loginBg];
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
    [scroll addSubview:codeBg];
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
    [scroll addSubview:codeBtn];
    [codeBtn setEnabled:NO];
    [codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    _codeBtn=codeBtn;
    
    
    UIView *pwdBg=[[UIView alloc]initWithFrame:CGRectMake(10, 10+codeBtn.bottom, AL_DEVICE_WIDTH-20, 44)];
    [pwdBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [scroll addSubview:pwdBg];
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
    [scroll addSubview:pwdBg2];
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
    
    //邀请码
    UIView *shareCodeBg = [[UIView alloc]initWithFrame:CGRectMake(10, 10+pwdBg2.bottom, AL_DEVICE_WIDTH-20, 44)];
    [shareCodeBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [scroll addSubview:shareCodeBg];
    _shareCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(5, 7, shareCodeBg.width-10, 30)];
    [_shareCodeTF setTextColor:text1Color];
    _shareCodeTF.font = [UIFont systemFontOfSize:14];
    [shareCodeBg addSubview:_shareCodeTF];
    UILabel *shareLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [shareLeft setText:@"  邀请码"];
    [shareLeft setTextColor:text1Color];
    [shareLeft setFont:[UIFont systemFontOfSize:14]];
    [_shareCodeTF setLeftView:shareLeft];
    [_shareCodeTF setLeftViewMode:UITextFieldViewModeAlways];
    [_shareCodeTF setPlaceholder:@"请输入邀请码"];

    
    UIButton *registBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, shareCodeBg.bottom+20, AL_DEVICE_WIDTH-20, 44)];
    [registBtn setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scroll addSubview:registBtn];
    [registBtn addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *readXieYi=[UIButton buttonWithType:UIButtonTypeCustom];
    _readXieYi=readXieYi;
    [readXieYi setFrame:CGRectMake(10, registBtn.bottom+5, 30, 30)];
    [readXieYi setImage:[UIImage imageNamed:@"login_weixuan"] forState:UIControlStateNormal];
    [readXieYi setImage:[UIImage imageNamed:@"login_xuanze"] forState:UIControlStateSelected];
    [scroll addSubview:readXieYi];
    [readXieYi addTarget:self action:@selector(readClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *xiyi=[[UILabel alloc]initWithFrame:CGRectMake(readXieYi.right, readXieYi.y, AL_DEVICE_WIDTH-50, 30)];
    [xiyi setText:@"阅读并同意《用户使用协议》"];
    [xiyi setTextColor:STYLECOLOR];
    [xiyi setFont:[UIFont systemFontOfSize:12]];
    [scroll addSubview:xiyi];
    xiyi.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [xiyi addGestureRecognizer:labelTapGestureRecognizer];
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
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:@"1" forKey:@"type"];
    NSString *mobile = [NSString stringWithFormat:@"%ld",arc4random()%10000000000+10000000000];
    [param setValue:[LCTools rsaEncryptStr:_user.text] forKey:@"guess"];
    [param setObject:[YHHelpper md5:mobile] forKey:@"mobile"];
    [self postInbackground:YHCODE withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [_codeBtn setEnabled:NO];
            self.timeInt=60;
            [_codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.timeInt] forState:UIControlStateNormal];
            [self.timer fire];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
    
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

/****************************立即注册**************************************/
-(void)registClick{
    if (_user.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入手机号"];
        return;
    }
    if (_code.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入验证码"];
        return;
    }
    if (_password.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入密码"];
        return;
    }
    
    if (_password.text.length<6 ) {
        [_password becomeFirstResponder];
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入6位以上的密码"];
        return;
    }
    
    if (![_password.text isEqualToString:_password2.text]) {
        [SVProgressHUDHelp SVProgressHUDFail:@"两次输入的密码不一致"];
        return;
    }
    if (!_readXieYi.selected) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请先勾选用户协议"];
        return;
    }
    
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:_user.text forKey:@"mobile"];
    [param setValue:_password.text forKey:@"pwd"];
    [param setValue:_code.text forKey:@"code"];
    [param setValue:_shareCodeTF.text forKey:@"invite_code"];
    [self post:YHRegist withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            
            [UserDefaults setValue:_user.text forKey:@"login"];
            [UserDefaults setValue:_password.text forKey:@"pwd"];
            NSDictionary *data=[responseObject objectForKey:@"data"];
            NSLog(@"%@",data);
            UserInfoManager *manage = [UserInfoManager manager];
            [manage saveUserInfo:[UserInfoModel getUserModel:data]];
            
            ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:App_Name message:@"注册成功"];
            YHWeakSelf
            [alertView addAction:[ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_LoginSuccess object:nil userInfo:nil];
                }];
                
            }]];
            ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
            alertController.tapBackgroundDismissEnable = NO;
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
}
/****************************立即注册**************************************/

/*****************************已阅读协议*************************************/
-(void)readClick:(UIButton*)sender{
    [sender setSelected:!sender.selected];
}
/*****************************已阅读协议*************************************/

/******************************点击协议************************************/
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
//    UILabel *label=(UILabel*)recognizer.view;
    WKBaseViewController *vc=[[WKBaseViewController alloc]init];
    [vc setUrl:[CommonConfig shared].registXieyi];
    [vc setTitle:[NSString stringWithFormat:@"%@用户使用协议",App_Name]];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
/******************************点击协议************************************/

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
