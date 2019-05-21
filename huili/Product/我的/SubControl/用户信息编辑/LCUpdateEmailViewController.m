//
//  LCUpdateEmailViewController.m
//  huili
//
//  Created by zhongweike on 2018/1/16.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "LCUpdateEmailViewController.h"

@interface LCUpdateEmailViewController ()

@property (nonatomic,strong)UITextField *infoTextField;  //要修改的信息

@property (nonatomic,strong)UIButton *confirmButton;  ///< 确认修改button

@property (nonatomic,strong)UIBarButtonItem *rightItem;

@end

@implementation LCUpdateEmailViewController

- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem:)];
    }
    return _rightItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改邮箱";
    [self setUpControls];
}

- (void)setUpControls{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"F4F5F4"]];
    
//    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 25, win_width, 60)];
    [bg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bg];
    
    _infoTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 15, bg.width-20*2, 30)];
    _infoTextField.borderStyle = UITextBorderStyleNone;
    _infoTextField.font = [UIFont systemFontOfSize:15];
    _infoTextField.placeholder = @"请输入要修改的邮箱";
    _infoTextField.textColor = [UIColor colorWithHexString:@"565756"];
    _infoTextField.clearButtonMode = UITextFieldViewModeAlways;
    [bg addSubview:_infoTextField];
    
    //初始值
    _infoTextField.text = [UserInfoManager currentUser].email;
    
    //确认button
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setFrame:CGRectMake(20, bg.maxY+20, win_width-2*20, 44)];
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmButton setBackgroundColor:STYLECOLOR];
    _confirmButton.layer.cornerRadius = 2;
    _confirmButton.layer.masksToBounds = YES;
    [_confirmButton addTarget:self action:@selector(clickRightItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:点击保存
- (void)clickRightItem:(UIBarButtonItem *)rightItem{
    NSLog(@"保存");
    [self.view endEditing:YES];
    if([NSString stringIsNull:_infoTextField.text]){
        [self.view makeToast:@"邮箱不能为空" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    [self requestUpdateNetwork];
}


//TODO:更改用户信息
- (void)requestUpdateNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"email"] = _infoTextField.text;
    [SVProgressHUD showWithStatus:@"修改中..."];
    [self postInbackground:XYUpdate withParam:para success:^(id resultObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = resultObject;
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *dataDic = dic[@"data"];
            UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues:dataDic];
            
            [[UserInfoManager manager] saveUserInfo:userInfo];
            [self.view makeToast:@"保存成功" duration:1.2 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
}

@end
