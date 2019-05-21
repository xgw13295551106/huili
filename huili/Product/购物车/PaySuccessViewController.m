//
//  PaySuccessViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "LCMyOrderDetailViewController.h"

@interface PaySuccessViewController ()

@property(nonatomic,weak)UILabel *payAmount;
@property(nonatomic,weak)UILabel *jiefen;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的订单"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    
    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 290)];
    [bg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bg];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH-80)/2, 10, 80, 90)];
    [img setImage:[UIImage imageNamed:@"user_pic_pay_succeed"]];
    [img setContentMode:UIViewContentModeCenter];
    [bg addSubview:img];
    
    UILabel *paySuccess=[[UILabel alloc]initWithFrame:CGRectMake(10, img.bottom, AL_DEVICE_WIDTH-20, 30)];
    [paySuccess setText:@"订单支付成功！"];
    [paySuccess setTextColor:STYLECOLOR];
    [paySuccess setTextAlignment:NSTextAlignmentCenter];
    [bg addSubview:paySuccess];
    [paySuccess setFont:[UIFont boldSystemFontOfSize:18]];
    
    UILabel *payWay=[[UILabel alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH-140)/2, paySuccess.bottom, 140, 20)];
    [payWay setText:@"支付方式：在线支付"];
    [payWay setFont:[UIFont systemFontOfSize:15]];
    [payWay setTextColor:text1Color];
    [bg addSubview:payWay];
    
    UILabel *payAmount=[[UILabel alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH-140)/2, payWay.bottom, 140, 20)];
    _payAmount=payAmount;
    [payAmount setFont:[UIFont systemFontOfSize:15]];
    [payAmount setTextColor:text1Color];
    [bg addSubview:payAmount];
    
    UIImageView *jifenIcon=[[UIImageView alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH-140)/2, payAmount.bottom, 20, 20)];
    [jifenIcon setImage:[UIImage imageNamed:@"order_icon_integral"]];
    [jifenIcon setContentMode:UIViewContentModeCenter];
    [bg addSubview:jifenIcon];
    
    UILabel *jiefen=[[UILabel alloc]initWithFrame:CGRectMake(jifenIcon.right+5, jifenIcon.y, 120, 20)];
    _jiefen=jiefen;
    [jiefen setFont:[UIFont systemFontOfSize:14]];
    [jiefen setTextColor:text1Color];
    [bg addSubview:jiefen];
    jiefen.hidden = YES;
    
    UIButton *backHome=[[UIButton alloc]initWithFrame:CGRectMake(((AL_DEVICE_WIDTH-30)-260)/2, jiefen.bottom+20, 130, 44)];
    [backHome.layer setCornerRadius:5];
    [backHome.layer setMasksToBounds:YES];
    [backHome setTitle:@"返回首页" forState:UIControlStateNormal];
    [backHome setBackgroundColor:STYLECOLOR];
    [backHome.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bg addSubview:backHome];
    [backHome addTarget:self action:@selector(backHomeClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *orderLook=[[UIButton alloc]initWithFrame:CGRectMake(backHome.right+30, jiefen.bottom+20, 130, 44)];
    [orderLook.layer setCornerRadius:5];
    [orderLook.layer setMasksToBounds:YES];
    [orderLook setTitle:@"查看订单" forState:UIControlStateNormal];
    [orderLook setBackgroundColor:STYLECOLOR];
    [orderLook.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bg addSubview:orderLook];
    [orderLook addTarget:self action:@selector(orderLookClick) forControlEvents:UIControlEventTouchUpInside];

    [_payAmount setText:[NSString stringWithFormat:@"支付总额：¥%@",[_dic stringForKey:@"pay_amount"]]];
//    [_jiefen setText:[NSString stringWithFormat:@"成功获取%@积分",[_dic stringForKey:@"integral"]]];
    // Do any additional setup after loading the view.
}

-(void)setDic:(NSDictionary *)dic{
    _dic=dic;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backHomeClick{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)backAction:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)orderLookClick{
    LCMyOrderDetailViewController *vc = [[LCMyOrderDetailViewController alloc]init];
    vc.order_id = [_dic stringForKey:@"order_id"];
    [self.navigationController pushViewController:vc animated:YES];
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
