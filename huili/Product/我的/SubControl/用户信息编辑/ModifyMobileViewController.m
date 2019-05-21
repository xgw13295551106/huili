//
//  ModifyMobileViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/11.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "ModifyMobileViewController.h"
#import "YHLoginViewController.h"
#import "BaseNavViewController.h"
#import "KefuViewController.h"

@interface ModifyMobileViewController ()

@property(nonatomic,weak)UITextField *user;

@property(nonatomic,weak)UITextField *code;

@property(nonatomic,weak)UITextField *codeOld;

@property(nonatomic,weak)UIButton *codeBtn;

@property(nonatomic,weak)UIButton *codeOldBtn;

@property(nonatomic)NSTimer *timer;//定时器

@property(nonatomic)int timeInt;//定时60秒

@property(nonatomic)NSTimer *timerOld;//定时器

@property(nonatomic)int timeIntOld;//定时60秒

@end

@implementation ModifyMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"修改手机号"];
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

/****************************创建UI**************************************/
-(void)creatUI{
    
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB)];
    [scroll setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scroll];
    

    UILabel *newPhone=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, AL_DEVICE_WIDTH-40, 30)];
    [newPhone setText:[NSString stringWithFormat:@"旧手机号：%@",CurrUserInfo.hidlogin]];
    [newPhone setTextColor:text1Color];
    [newPhone setFont:[UIFont systemFontOfSize:14]];
    [scroll addSubview:newPhone];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"手机不可用？请联系客服"];
    
    [str addAttribute:NSForegroundColorAttributeName
                value:text1Color
                range:NSMakeRange(0,7)];
    [str addAttribute:NSForegroundColorAttributeName
                value:STYLECOLOR
                range:NSMakeRange(7,4)];
    
    UILabel *xiyi=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-180, newPhone.y, 170, 30)];
    [xiyi setAttributedText:str];
    [xiyi setFont:[UIFont systemFontOfSize:12]];
    [xiyi setTextAlignment:NSTextAlignmentRight];
    [scroll addSubview:xiyi];
    xiyi.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [xiyi addGestureRecognizer:labelTapGestureRecognizer];
    
    
    UIView *codeOldBg=[[UIView alloc]initWithFrame:CGRectMake(10, newPhone.bottom+10, AL_DEVICE_WIDTH-140, 44)];
    [codeOldBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [scroll addSubview:codeOldBg];
    UITextField *codeOld=[[UITextField alloc]initWithFrame:CGRectMake(5, 7, codeOldBg.width-10, 30)];
    [codeOld setTextColor:text1Color];
    _codeOld=codeOld;
    [codeOld setFont:[UIFont systemFontOfSize:14]];
    [codeOldBg addSubview:codeOld];
    UILabel *codeOldLeft=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [codeOldLeft setText:@"  验证码"];
    [codeOldLeft setTextColor:text1Color];
    [codeOldLeft setFont:[UIFont systemFontOfSize:14]];
    [codeOld setLeftView:codeOldLeft];
    [codeOld setLeftViewMode:UITextFieldViewModeAlways];
    [codeOld setPlaceholder:@"请输入验证码"];
    
    UIButton *codeOldBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [codeOldBtn setFrame:CGRectMake(codeOldBg.right+10, codeOldBg.y, 110, 44)];
    [codeOldBtn setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
    [codeOldBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cccccc"]] forState:UIControlStateDisabled];
    [codeOldBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeOldBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [codeOldBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeOldBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [scroll addSubview:codeOldBtn];
    [codeOldBtn setEnabled:YES];
    [codeOldBtn addTarget:self action:@selector(getCodeOld) forControlEvents:UIControlEventTouchUpInside];
    _codeOldBtn=codeOldBtn;
    
    
    
    UIView *loginBg=[[UIView alloc]initWithFrame:CGRectMake(10, codeOldBg.bottom+10, AL_DEVICE_WIDTH-20, 44)];
    [loginBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [scroll addSubview:loginBg];
    UITextField *user=[[UITextField alloc]initWithFrame:CGRectMake(5, 7, loginBg.width-10, 30)];
    [user setTextColor:text1Color];
    _user=user;
    [user setFont:[UIFont systemFontOfSize:14]];
    [loginBg addSubview:user];
    UILabel *loginLeft=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [loginLeft setText:@"  新手机号"];
    [loginLeft setTextColor:text1Color];
    [loginLeft setFont:[UIFont systemFontOfSize:14]];
    [user setLeftView:loginLeft];
    [user setLeftViewMode:UITextFieldViewModeAlways];
    [user setPlaceholder:@"请输入新手机号"];
    [user setKeyboardType:UIKeyboardTypeNumberPad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:user];
    
    
    UIView *codeBg=[[UIView alloc]initWithFrame:CGRectMake(10, loginBg.bottom+10, AL_DEVICE_WIDTH-140, 44)];
    [codeBg setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
    [scroll addSubview:codeBg];
    UITextField *code=[[UITextField alloc]initWithFrame:CGRectMake(5, 7, codeBg.width-10, 30)];
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
    
    

    
    
    UIButton *registBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, scroll.height-60, AL_DEVICE_WIDTH-20, 44)];
    [registBtn setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
    [registBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scroll addSubview:registBtn];
    [registBtn addTarget:self action:@selector(changeMobileClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *changeStr=@"更换手机号请先输入旧手机号验证吗\n再输入新手机号的验证码，完成手机号更换";
    UILabel *changeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, registBtn.top-50, AL_DEVICE_WIDTH-20, 50)];
    [changeLabel setText:changeStr];
    [changeLabel setNumberOfLines:2];
    [changeLabel setTextColor:text2Color];
    [changeLabel setFont:[UIFont systemFontOfSize:12]];
    [changeLabel setTextAlignment:NSTextAlignmentCenter];
    [scroll addSubview:changeLabel];
}
/****************************创建UI**************************************/

/****************************验证码按钮的变化**************************************/

//定时器新
-(NSTimer*)timer{
    if (_timer==nil) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
//定时器旧
-(NSTimer*)timerOld{
    if (_timerOld==nil) {
        _timerOld=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChangeOld) userInfo:nil repeats:YES];
    }
    return _timerOld;
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

#pragma mark--获取新验证码
-(void)getCode{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:@"4" forKey:@"type"];
    [param setValue:TOKEN forKey:@"token"];
    NSString *mobile = [NSString stringWithFormat:@"%ld",arc4random()%10000000000+10000000000];
    [param setValue:[LCTools rsaEncryptStr:_user.text] forKey:@"guess"];
    [param setObject:[YHHelpper md5:mobile] forKey:@"mobile"];
    [self postInbackground:YHCODE withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [SVProgressHUDHelp SVProgressHUDSuccess:@"验证码发送成功"];
            [_codeBtn setEnabled:NO];
            self.timeInt=60;
            [_codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.timeInt] forState:UIControlStateNormal];
            [self.timer fire];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
    
}
#pragma mark--获取旧验证码
-(void)getCodeOld{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:@"3" forKey:@"type"];
    [param setValue:TOKEN forKey:@"token"];
    NSString *mobile = [NSString stringWithFormat:@"%ld",arc4random()%10000000000+10000000000];
    [param setValue:[LCTools rsaEncryptStr:CurrUserInfo.login] forKey:@"guess"];
    [param setObject:[YHHelpper md5:mobile] forKey:@"mobile"];
    [self postInbackground:YHCODE withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [SVProgressHUDHelp SVProgressHUDSuccess:@"验证码发送成功"];
            [_codeOldBtn setEnabled:NO];
            self.timeIntOld=60;
            [_codeOldBtn setTitle:[NSString stringWithFormat:@"%ds",self.timeIntOld] forState:UIControlStateNormal];
            [self.timerOld fire];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
    
}

#pragma mark--倒计时旧
-(void)timerChangeOld{
    self.timeIntOld--;
    if (self.timeIntOld==0) {
        [_codeOldBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeOldBtn setEnabled:YES];
        [self.timerOld invalidate];
        self.timerOld=nil;
    }else{
        [_codeOldBtn setTitle:[NSString stringWithFormat:@"%ds",self.timeIntOld] forState:UIControlStateNormal];
        [_codeOldBtn setEnabled:NO];
    }
    
}
#pragma mark--倒计时新
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

/****************************更换手机号**************************************/
-(void)changeMobileClick{
    
    if (_codeOld.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入原手机号验证码"];
        return;
    }
    if (_user.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入新手机号"];
        return;
    }
    if (_code.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请输入新手机号验证码"];
        return;
    }
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:_user.text forKey:@"mobile"];
    [param setValue:_codeOld.text forKey:@"og_code"];
    [param setValue:_code.text forKey:@"code"];
    [self post:ChangeMobile withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [UserInfoManager logout];
            YHLoginViewController *vc=[[YHLoginViewController alloc]init];
            BaseNavViewController *nav=[[BaseNavViewController alloc]initWithRootViewController:vc];
            [[YHHelpper getCurrentVC] presentViewController:nav animated:YES completion:^{
                [SVProgressHUDHelp SVProgressHUDSuccess:@"更换手机号成功，请重新登录"];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
}
/****************************更换手机号**************************************/


/******************************点击联系客服************************************/
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
//    KefuViewController *vc=[[KefuViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    [YHHelpper callPhoneAlert:[CommonConfig shared].mobileSer setTitle:@"客服热线"];
    
//    [YHHelpper callPhoneAlert:[CommonConfig shared].mobileSer setTitle:@"客服热线"];
    
    
}
/******************************点击联系客服************************************/

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
