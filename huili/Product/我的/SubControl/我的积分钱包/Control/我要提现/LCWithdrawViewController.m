//
//  LCWithdrawViewController.m
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "LCWithdrawViewController.h"

@interface LCWithdrawViewController (){
    UITextField *moneyTextField;
    UIButton *confirmButton; //确认提现按钮
}

@end

@implementation LCWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"积分提现";
    [self setupControlls];
}

- (void)backAction:(UIButton *)sender{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

//集成UI
- (void)setupControlls{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"F2F3F2"]];
    UserInfoModel *userModel = [UserInfoManager currentUser];
    
    UIView *bg1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, win_width, 120)];
    [bg1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bg1];
    UILabel *tixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    tixianLabel.text = @"提现金额";
    tixianLabel.textColor = [UIColor colorWithHexString:@"707170"];
    tixianLabel.font = [UIFont systemFontOfSize:14];
    [tixianLabel sizeToFit];
    [bg1 addSubview:tixianLabel];
    
    //输入提现金额的textField
    CGFloat moneyTextField_h = 40;
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, moneyTextField_h)];
    leftLabel.text = @"￥";
    leftLabel.font = [UIFont systemFontOfSize:20];
    moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(tixianLabel.frame)+15, win_width-20, moneyTextField_h)];
    moneyTextField.font = [UIFont systemFontOfSize:20];
    [moneyTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [moneyTextField setLeftView:leftLabel];
    moneyTextField.placeholder = @"请输入提现金额";
    [moneyTextField setLeftViewMode:UITextFieldViewModeAlways];
    [bg1 addSubview:moneyTextField];
    
    //分割线
    UIView *devideView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyTextField.frame)+2, win_width, 1)];
    [devideView1 setBackgroundColor:[UIColor colorWithHexString:@"E7E8E7"]];
    [bg1 addSubview:devideView1];
    
    //显示下方介绍信息
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(devideView1.frame)+10, 200, 20)];
    balanceLabel.text = [@"可提现余额" stringByAppendingString:[NSString stringWithFormat:@"  ￥%@ (积分 %@)",userModel.money,userModel.ints]];
    balanceLabel.textColor = [UIColor colorWithHexString:@"A0A1A0"];
    balanceLabel.font = [UIFont systemFontOfSize:14];
    [balanceLabel sizeToFit];
    [bg1 addSubview:balanceLabel];
    
    //全部提现
    UIButton *allExtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allExtractButton setFrame:CGRectMake(bg1.width-10-65, balanceLabel.centerY-20/2, 65, 20)];
    [allExtractButton setTitle:@"全部提现" forState:UIControlStateNormal];
    [allExtractButton setTitleColor:STYLECOLOR forState:UIControlStateNormal];
    allExtractButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [allExtractButton addTarget:self action:@selector(clickAllExtractButton:) forControlEvents:UIControlEventTouchUpInside];
    [bg1 addSubview:allExtractButton];
    
    //----------下个部分 ---------
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bg1.frame)+10, 100, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"666766"];
    label.text = @"请选择提现账户";
    [label sizeToFit];
    [self.view addSubview:label];
    
    UIView *bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+10, win_width, 80)];
    [bg2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bg2];
    
    //支付宝
    UIImage *alipayImage = [UIImage imageNamed:@"user_wallet_account_alipay"];
    UIImageView *bindImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, bg2.height/2-alipayImage.size.height/2, alipayImage.size.width, alipayImage.size.height)];
    [bindImageView setImage:alipayImage];
    [bg2 addSubview:bindImageView];
    
    //支付宝姓名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(bindImageView.maxX+10, bindImageView.minY - 5, 220, 20)];
    nameLabel.textColor = [UIColor colorWithHexString:@"5D5E5D"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = userModel.alipay_realname;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [bg2 addSubview:nameLabel];
    
    
    //支付宝账号
    UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.minX, nameLabel.maxY+5, 220, 20)];
    accountLabel.textColor = STYLECOLOR;
    accountLabel.font = [UIFont systemFontOfSize:14];
    accountLabel.text = userModel.alipay_account;
    accountLabel.textAlignment = NSTextAlignmentLeft;
    [bg2 addSubview:accountLabel];
    //选择支付宝的按钮（taget未加，需要的时候再加）
    UIImage *aliButton_image = [UIImage imageNamed:@"common_product_select"];
    CGFloat aliButton_x = win_width - 10 - aliButton_image.size.width;
    CGFloat aliButton_y = bg2.size.height/2 - aliButton_image.size.height/2;
    UIButton *alipayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alipayButton setFrame:CGRectMake(aliButton_x, aliButton_y, aliButton_image.size.width, aliButton_image.size.height)];
    [alipayButton setImage:aliButton_image forState:UIControlStateNormal];
    [bg2 addSubview:alipayButton];
    
    CGFloat confirmB_h = 44;
    confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton setFrame:CGRectMake(20, bg2.maxY +20, win_width-20*2, confirmB_h)];
    [confirmButton setBackgroundColor:STYLECOLOR];
    [confirmButton setTintColor:[UIColor whiteColor]];
    [confirmButton setTitle:@"确认提现" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmAction:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    
    
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, confirmButton.maxY+8, win_width, 18)];
    promptLabel.textColor = [UIColor colorWithHexString:@"A8A9A8"];
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.text = @"预计1-7个工作日内到账";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptLabel];
}

#pragma mark button点击事件
//TODO:点击全部提现
- (void)clickAllExtractButton:(UIButton *)button{
    moneyTextField.text = [UserInfoManager currentUser].money;
}

//TODO:确认提现
- (void)confirmAction:(UIButton *)button{
    [self.view endEditing:YES];
    if ([NSString stringIsNull:moneyTextField.text]) {
        [self.view makeToast:@"请输入提现金额" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    
    if ([moneyTextField.text floatValue] ==  0) {
        [self.view makeToast:@"提现金额不能为0" duration:1.2 position:CSToastPositionCenter];;
        return;
    }
    if (moneyTextField.text.length > 9) {
        [self.view makeToast:@"提现金额过大" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    if (moneyTextField.text.floatValue > [UserInfoManager currentUser].money.floatValue) {
        [self.view makeToast:@"提现金额大于可提现金额" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"money"] = moneyTextField.text;
    para[@"integral"] = [UserInfoManager currentUser].ints;
    [self post:LCWithdraw withParam:para success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            __weak typeof(self) weakSelf = self;
            [weakSelf addUIAlertControlWithString:@"您的提现申请已成功提交!\n提现金额预计在1-7个工作日内\n到您的提现账户。" withActionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
