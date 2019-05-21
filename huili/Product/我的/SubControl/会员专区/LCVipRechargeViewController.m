//
//  LCVipRechargeViewController.m
//  huili
//
//  Created by zhongweike on 2018/1/16.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "LCVipRechargeViewController.h"
#import "CustormPayView.h"
#import "CustomVipAlertView.h"

#define selectImage      [UIImage imageNamed:@"user_vip_recharge_red"]
#define unSelectImage   [UIImage imageNamed:@"user_vip_recharge_gray"]

@interface LCVipRechargeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIButton *confirmButton;
@property (nonatomic,strong)UIBarButtonItem *rightItem;

@property (nonatomic,copy)NSString *top_id;     ///< 要充值的会员配置id
@property (nonatomic,assign)int rechargeType;   ///< 充值类型 1,2,3,4

@property (nonatomic,strong)NSArray *timeArray;  ///< 选择开通时长的数组

@end

static int base_typeButton_tag  = 133;
static int base_selectImgView_tag = 233;

@implementation LCVipRechargeViewController

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-NavHeight-BottomHeight-50)];
        [_scrollView setBackgroundColor:[UIColor colorWithHexString:@"F6F7F6"]];
        _scrollView.delegate= self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *image = [UIImage imageNamed:@"user_vip_question"];
        [button setImage:image forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [button addTarget:self action:@selector(clickVipQuestion:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
    }
    return _rightItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"会员充值";
    [self setupControls];
    [self requestVipRechargeConfig];
}

- (void)setupControls{
    [self.view addSubview:self.scrollView];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 150)];
    [_topView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_topView];
    //集成topview上的控件
    [self setupTopView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.maxY+10, win_width, 180)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_bottomView];
    
    
    //确定
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setFrame:CGRectMake(0, win_height-BottomHeight-50-NavHeight, win_width, 50)];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmButton setBackgroundColor:STYLECOLOR];
    [_confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
}

- (void)setupTopView{
    UIImage *selectImg = [UIImage imageNamed:@"user_vip_leve1_nor"];
    CGFloat button_y = 15;
    CGFloat button_w = selectImg.size.width;
    CGFloat button_h = selectImg.size.height;
    CGFloat item_space = (_topView.width -2*button_w)/3;
    for (int i =0; i<4; i++) {
        int row = i/2; //排
        int col = i%2; //列
        UIButton *button = [self getTypeButton:CGRectMake(item_space+col*(item_space+button_w), button_y+row*(button_h+15), button_w, button_h) andTag:i];
        [_topView addSubview:button];
        _topView.height = button.maxY+15;
        button.selected = i == 0?YES:NO;
    }
    _rechargeType = 1;
}

- (void)setupBottomView:(NSArray *)array{
    [_bottomView removeAllSubviews];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5,150, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"858685"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"选择开通时长";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:titleLabel];
    
    for (int i = 0; i<array.count; i++) {
        NSDictionary *dic = array[i];
        UIImageView *imageView = [self getSelectImgView:CGRectMake(15, titleLabel.maxY+10+i*(40+10), _bottomView.width-2*15, 40) andTag:i andMonth:[dic intForKey:@"num"] andMoney:[dic stringForKey:@"money"]];
        [_bottomView addSubview:imageView];
        _bottomView.height = imageView.maxY+20;
        if (i == 0) {
            [imageView setImage:selectImage];
            _top_id = [dic stringForKey:@"id"];
        }
    }
    
    _scrollView.contentSize = CGSizeMake(-1, _bottomView.maxY+20);
}

//选择充值会员类型button
- (UIButton *)getTypeButton:(CGRect)frame andTag:(int)index
{
    NSString *unSelectImgName = [NSString stringWithFormat:@"user_vip_leve%i_nor",index+1];
    NSString *selectImgName = [NSString stringWithFormat:@"user_vip_leve%i_pre",index+1];
    UIImage *unSelectImg = [UIImage imageNamed:unSelectImgName];
    UIImage *selectImg = [UIImage imageNamed:selectImgName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:unSelectImg forState:UIControlStateNormal];
    [button setImage:selectImg forState:UIControlStateSelected];
    button.tag = base_typeButton_tag + index;
    [button addTarget:self action:@selector(clickTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

//选择开通时长的imageView
- (UIImageView *)getSelectImgView:(CGRect)frame andTag:(int)index andMonth:(int)num andMoney:(NSString *)money{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.tag = base_selectImgView_tag + index;
    [imageView setImage:unSelectImage];
    imageView.userInteractionEnabled = YES;
    
    //开通时长
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, imageView.height)];
    monthLabel.textColor = [UIColor colorWithHexString:@"343534"];
    monthLabel.font = [UIFont systemFontOfSize:14];
    monthLabel.text = [NSString stringWithFormat:@"%i个月",num];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:monthLabel];
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(monthLabel.maxX, 4, 0.8, imageView.height-2*4)];
    [lineView setBackgroundColor:LineColor];
    [imageView addSubview:lineView];
    
    //价格
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineView.maxX+8, 0, imageView.width-15-(lineView.maxX+8), imageView.height)];
    priceLabel.textColor = [UIColor colorWithHexString:@"343534"];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",money];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [imageView addSubview:priceLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelectImgView:)];
    [imageView addGestureRecognizer:tap];
    
    return imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 控件的点击事件
//TODO:点击选择充值会员类型
- (void)clickTypeButton:(UIButton *)button{
    int index = (int)button.tag - base_typeButton_tag;
    for (int i =0; i<4; i++) {
        UIButton *one = [_topView viewWithTag:i+base_typeButton_tag];
        one.selected = NO;
    }
    button.selected = YES;
    _rechargeType = index+1;
    [self requestVipRechargeConfig];
    NSLog(@"%i",_rechargeType);
}

//TODO:点击选择开通时长
- (void)clickSelectImgView:(UIGestureRecognizer *)tap{
    for (int i = 0; i<_timeArray.count; i++) {
        UIImageView *imageView = [_bottomView viewWithTag:base_selectImgView_tag+i];
        [imageView setImage:unSelectImage];
    }
    UIImageView *imageView = (UIImageView *)tap.view;
    [imageView setImage:selectImage];
    
    int selectIndex = (int)imageView.tag - base_selectImgView_tag;
    NSDictionary *dic = _timeArray[selectIndex];
    self.top_id = [dic stringForKey:@"id"];
}

//TODO:请求确定充值
- (void)clickConfirmButton:(UIButton *)button{
    [CustormPayView shareCustormPayView:^(CustormPayType payType, UIButton *payButton) {
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        if (payType == AlipayType) {
            para[@"way"] = @"1";
        }else if (payType == WechatPayType){
            para[@"way"] = @"2";
        }else{
            para[@"way"] = @"3";
        }
        [self requestRechargeNetwork:para];
        
    }];
}

//TODO:点击会员充值疑问
- (void)clickVipQuestion:(UIButton *)button{
    CustomVipAlertView *alertView = [CustomVipAlertView getCustomVipAlertViewWith:CGRectMake(0, 0, win_width-2*30, 250)];
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    alertController.tapBackgroundDismissEnable = NO;
    [self presentViewController:alertController animated:YES completion:nil];
    
    [alertView setCloseBlock:^{
        [alertController dismissViewControllerAnimated:YES];
    }];
}

#pragma mark 网络请求
//TODO:会员配置
- (void)requestVipRechargeConfig{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"type"] = [NSString stringWithFormat:@"%i",_rechargeType];
    [self post:VipRechargeConfig withParam:para success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            _timeArray = [dic objectForKey:@"data"];
            [self setupBottomView:_timeArray];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
}

//TODO:充值会员
- (void)requestRechargeNetwork:(NSMutableDictionary *)para{
    if (!para) {
        para = [NSMutableDictionary dictionary];
    }
    para[@"token"] = TOKEN;
    para[@"type"] = [NSString stringWithFormat:@"%i",_rechargeType];
    para[@"top_id"] = self.top_id;
    [SVProgressHUD showWithStatus:@"正在发起支付..."];
    [CustormPayView dismiss];
    [self postInbackground:RechargeVip withParam:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            if ([para[@"way"] isEqualToString:@"3"]) {
                [self.view makeToast:@"充值成功!" duration:1.2 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else if ([para[@"way"] isEqualToString:@"1"]){
                //支付宝支付
                NSString *string = [dic stringForKey:@"data"];
                [[LCAlipayManager manager]AliPayWithOrderString:string andBlock:^(NSDictionary *resultDic) {
                    [SVProgressHUD dismiss];
                    NSString *resultString = nil;
                    int code = [resultDic[@"resultStatus"] intValue];
                    switch (code) {
                        case 9000:
                            resultString = @"订单支付成功!";
                            break;
                        case 8000:
                            resultString = @"正在处理中，请稍后";
                            break;
                        case 4000:
                            resultString = @"订单支付失败!";
                            break;
                        case 6001:
                            resultString = @"用户中途取消";
                            break;
                        case 6002:
                            resultString = @"网络连接出错";
                            break;
                        default:
                            break;
                    }
                    if (code == 9000) {
                        //支付成功后，刷新页面
                        [self.view makeToast:@"充值成功!" duration:1.2 position:CSToastPositionCenter];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }else{
                        [SVProgressHUDHelp SVProgressHUDFail:@"支付失败"];
                    }
                }];
                
            }else if([para[@"way"] isEqualToString:@"2"]){
                //微信支付
                NSDictionary *wxinfo=[dic objectForKey:@"data"];
                LCWeChatModel *weChatModel = [LCWeChatModel mj_objectWithKeyValues:wxinfo];
                [[LCWeChatManager manager] weChatPayWithModel:weChatModel andBlock:^(BOOL success) {
                    [SVProgressHUD dismiss];
                    if (success) {
                        //支付成功
                        [self.view makeToast:@"充值成功!" duration:1.2 position:CSToastPositionCenter];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }else{
                        [SVProgressHUDHelp SVProgressHUDFail:@"支付失败"];
                    }
                    //                    [self addUIAlertControlWithString:resultString withActionBlock:nil];
                }];
            }
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}

@end
