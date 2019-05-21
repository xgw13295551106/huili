//
//  LCBindPhoneViewController.m
//  StudioRecognition
//
//  Created by zhongweike on 2017/10/13.
//  Copyright © 2017年 zhongweike. All rights reserved.
//

#import "LCBindPhoneViewController.h"


@interface LCBindPhoneViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *phoneTF; //手机号
@property (nonatomic,strong)UITextField *codeTF;  //验证码
@property (nonatomic,strong)UIButton *codeButton; //验证码button
@property (nonatomic,strong)UIButton *agreeButton; //同意button
@property (nonatomic,strong)UIButton *protocolButton; //用户协议
@property (nonatomic,strong)UIButton *registerButton; //完成注册button

@end

@implementation LCBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"完善手机号";
    [self setUpControls];
}


- (void)setUpControls{
    CGFloat bg_x = 40;
    CGFloat bg_w = win_width-2*bg_x;
    CGFloat bg_h = 44;
    
    CGFloat textField_x = 15;
    CGFloat textField_w = bg_w - 2*textField_x;
    CGFloat textField_h = 30;
    CGFloat textField_y = 7;
    CGRect textField_rect = CGRectMake(textField_x, textField_y, textField_w, textField_h);
    //手机号
    UIView *bg1 = [self getTextFieldBgView:CGRectMake(bg_x, 20, bg_w, bg_h)];
    [self.view addSubview:bg1];
    _phoneTF = [self getTextFieldWith:textField_rect andPlaceholder:@"请输入手机号"];
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    [bg1 addSubview:_phoneTF];
    
    //验证码
    UIView *bg2 = [self getTextFieldBgView:CGRectMake(bg_x, bg1.maxY+15, bg_w, bg_h)];
    [self.view addSubview:bg2];
    _codeTF = [self getTextFieldWith:textField_rect andPlaceholder:@"请输入验证码"];
    [bg2 addSubview:_codeTF];
    _codeTF.rightView = [self getCodeRightView];
    _codeTF.keyboardType = UIKeyboardTypeEmailAddress;
    _codeTF.rightViewMode = UITextFieldViewModeAlways;
    
    
    //注册
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setFrame:CGRectMake(bg_x, bg2.maxY+20, bg_w, bg_h)];
    [_registerButton setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton setTitle:@"完成注册" forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_registerButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    _registerButton.layer.cornerRadius = _registerButton.height/2;
    _registerButton.layer.masksToBounds = YES;
    [self.view addSubview:_registerButton];
    
    //点击同意用户协议
    _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeButton setFrame:CGRectMake(_registerButton.minX, _registerButton.maxY+10, 20, 20)];
    [_agreeButton setImage:[UIImage imageNamed:@"login_yixuan"] forState:UIControlStateSelected];
    [_agreeButton setImage:[UIImage imageNamed:@"login_weixuan"] forState:UIControlStateNormal];
    [_agreeButton addTarget:self action:@selector(clickAgreeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreeButton];
    _agreeButton.hidden = YES;
    
    //同意label
    UILabel *agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agreeButton.maxX+2, _agreeButton.minY, 30, _agreeButton.height)];
    agreeLabel.textColor = [UIColor colorWithHexString:@"616261"];
    agreeLabel.font = [UIFont systemFontOfSize:14];
    agreeLabel.text = @"同意";
    [self.view addSubview:agreeLabel];
    agreeLabel.hidden = YES;
    
    //用户协议button
    _protocolButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_protocolButton setFrame:CGRectMake(agreeLabel.maxX, _agreeButton.minY, 110, _agreeButton.height)];
    [_protocolButton setTitleColor:STYLECOLOR forState:UIControlStateNormal];
    [_protocolButton setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [_protocolButton addTarget:self action:@selector(clickProtocolButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_protocolButton];
    _protocolButton.hidden = YES;
}

- (UIView *)getCodeRightView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, _codeTF.height)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, view.height)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"989998"]];
    [view addSubview:lineView];
    
    _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeButton setFrame:CGRectMake(1, 0, view.width-1, view.height)];
    [_codeButton setTitleColor:[UIColor colorWithHexString:@"CCCDCC"] forState:UIControlStateNormal];
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_codeButton addTarget:self action:@selector(clickCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_codeButton];
    return view;
}

//获取一个封装好的textfield的bgview
- (UIView *)getTextFieldBgView:(CGRect)rect
{
    UIView *bg = [[UIView alloc]initWithFrame:rect];
    [bg setBackgroundColor:[UIColor whiteColor]];
    bg.layer.cornerRadius = rect.size.height/2;
    bg.layer.masksToBounds = YES;
    bg.layer.borderWidth = 1.5;
    bg.layer.borderColor = [UIColor colorWithHexString:@"989998"].CGColor;
    return bg;
}

//获取一个封装好的UITextField
- (UITextField *)getTextFieldWith:(CGRect)rect andPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    return textField;
}

#pragma mark -UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _phoneTF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
            return NO;
        }
    }else if (textField == _codeTF){
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (textField.text.length >= 8) {
            textField.text = [textField.text substringToIndex:8];
            return NO;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button 事件
//请求验证码
- (void)clickCodeButton:(UIButton *)button {
    if ([NSString stringIsNull:_phoneTF.text]) {
        [self.view makeToast:@"请填写手机号" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (_phoneTF.text.length != 11) {
        [self.view makeToast:@"手机号不合法" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    [self requestCodeNetwork];
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
                [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
                //                // 完成倒计时，发送消息
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"didcountdown" object:nil];
            });
        }else{
            // int minutes = timeout / 60;
            int seconds = timeout % 90;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

//点击同意用户协议
- (void)clickAgreeButton:(UIButton *)button{
    button.selected = !button.selected;
}

//点击查看用户协议
- (void)clickProtocolButton:(UIButton *)button{
//    LCAgreementViewController *vc = [[LCAgreementViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

//点击注册
- (void)clickRegisterButton:(UIButton *)button{
    if ([NSString stringIsNull:_phoneTF.text]) {
        [self.view makeToast:@"请填写手机号" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (_phoneTF.text.length != 11) {
        [self.view makeToast:@"手机号不合法" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    if ([NSString stringIsNull:_codeTF.text]) {
        [self.view makeToast:@"请填写验证码" duration:1.5 position:CSToastPositionCenter];
        return;
    }
//    if (!_agreeButton.selected) {
//        [self.view makeToast:@"请先同意用户协议" duration:1.2 position:CSToastPositionCenter];
//        return;
//    }
    //执行注册网络请求
    [self requestBindNetwork];
}


#pragma mark Network
//TODO:请求验证码
- (void)requestCodeNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"type"] = _thirdDic[@"type"];
    para[@"open_id"] = _thirdDic[@"open_id"];
    NSString *mobile = [NSString stringWithFormat:@"%ld",arc4random()%10000000000+10000000000];
    [para setValue:[LCTools rsaEncryptStr:_phoneTF.text] forKey:@"guess"];
    [para setObject:[YHHelpper md5:mobile] forKey:@"mobile"];
    [SVProgressHUD show];
    [self postInbackground:LCThirdCode withParam:para success:^(id resultObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = resultObject;
        if ([dic[@"code"] intValue] == 1) {
            [self.view makeToast:@"发送成功" duration:1.2 position:CSToastPositionCenter];
            [self countDown];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
}

//TODO:第三方登录绑定手机号注册
- (void)requestBindNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"type"] = _thirdDic[@"type"];
    para[@"open_id"] = _thirdDic[@"open_id"];
    para[@"mobile"] = _phoneTF.text;
    para[@"code"] = _codeTF.text;
    [self post:LCThirdBind withParam:para success:^(id resultObject) {
        NSDictionary *dic = resultObject;
        if ([dic[@"code"] intValue] == 1) {
            [[UserInfoManager manager] saveUserInfo:[UserInfoModel getUserModel:dic[@"data"]]];
            if (self.bindBlock) {
                [self.navigationController popViewControllerAnimated:YES];
                self.bindBlock(YES);
            }
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
    
}




@end
