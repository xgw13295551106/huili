//
//  LCMyOrderDetailViewController.m
//  YeFu
//
//  Created by zhongweike on 2017/12/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCMyOrderDetailViewController.h"
#import "LCMyOrderDetailModel.h"
#import "CustormPayView.h"
#import "GoPayViewController.h"
#import "LCOrderDetailFootView.h"
#import "LCOrderDetailGoodsCell.h"
#import "OrderAddressHeadView.h"
#import "LCRefundGoodsViewController.h"
#import "LCWuliuViewController.h"

@interface LCMyOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *topView;       ///< 顶部状态view
@property (nonatomic,strong)UILabel *statusLabel;  ///< 订单状态label
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LCOrderDetailFootView *tableFootView;
@property (nonatomic,strong)OrderAddressHeadView *tableHeadView;

@property (nonatomic,strong)LCMyOrderDetailModel *detailModel;

@end

@implementation LCMyOrderDetailViewController
//TODO:获取一个简易封装的button
- (UIButton *)getOneButtonWith:(CGRect)frame andTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    return button;
}
#pragma mark --getter 懒加载

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _topView.maxY, win_width, win_height-NavHeight-_topView.maxY) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"F6F7F6"]];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 30)];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"FE9E31"]];
        
        //状态label
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 20)];
        _statusLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _statusLabel.font = [UIFont systemFontOfSize:15];
        [_topView addSubview:_statusLabel];
    }
    return _topView;
}

- (LCOrderDetailFootView *)tableFootView{
    if (!_tableFootView) {
        __weak typeof(self) weakSelf = self;
        _tableFootView = [LCOrderDetailFootView getOrderDetailFootView:CGRectMake(0, 0, win_width, 300) andModel:self.detailModel andBlock:^(LCMyOrderDetailModel *detailModel, OrderButtonEvent orderEvent) {
            if (orderEvent == cancelEvent){ //取消订单
                [weakSelf addUIAlertControlWithString:@"确认取消订单?" withActionBlock:^{
                    [self requestOrderActionNetWith:detailModel.id andType:@"1"];
                } andCancel:nil];
            }else if (orderEvent == payEvent){//支付
                [weakSelf clickPayButtonAction:nil];
            }else if (orderEvent == buyAgentEvent){
                [weakSelf requestBuyAgainNetwork:detailModel.id];
            }else if (orderEvent == acceptEvent){//确认收货
                [weakSelf addUIAlertControlWithString:@"是否确认收货？" withActionBlock:^{
                    [weakSelf requestOrderActionNetWith:detailModel.id andType:@"2"];
                } andCancel:nil];
            }else if (orderEvent == cancelRefundEvent){
                [weakSelf requestOrderActionNetWith:detailModel.id andType:@"3"];
            }else if (orderEvent == wuliuEvent){
                LCMyOrderGoodsModel *model = [LCMyOrderGoodsModel mj_objectWithKeyValues:detailModel.goods[0]];
                LCWuliuViewController *vc = [[LCWuliuViewController alloc]init];
                vc.order_id = detailModel.id;
                vc.order_goods_img = model.goods_img;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _tableFootView;
}

- (OrderAddressHeadView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[OrderAddressHeadView alloc]initWithFrame:CGRectMake(0, 0, win_width, 100)];
    }
    return _tableHeadView;
}

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"订单详情";
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDetailNetworking];
}

- (void)setupControls{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.tableHeadView;
    self.tableView.tableFooterView = self.tableFootView;
    
    self.tableHeadView.hideRightImg = YES;
    
    [self refreshView];
}
//刷新界面
- (void)refreshView{
    if (!self.detailModel) {
        return;
    }
    self.statusLabel.text =[self getOrderStatusDecInfo:_detailModel];
    [self.tableHeadView setAddressInfo:self.detailModel];
    [self.tableFootView setInfoWith:self.detailModel];
    [self.tableView reloadData];
    
}

//TODO:获取订单状态内容 订单状态 0为待支付 1为已支付待发货 2为已发货待收货 3为确认收货已完成 5为售后  9为取消
- (NSString *)getOrderStatusDecInfo:(LCMyOrderDetailModel *)model{
    [_topView setBackgroundColor:[UIColor colorWithHexString:@"FE9E31"]];
    NSString *statusString = @"";
    int orderStatus = model.order_status.intValue;
    if (orderStatus == 1) {
        statusString = @"等待发货";
    }else if (orderStatus == 2){
        statusString = @"等待收货";
    }else if (orderStatus == 3){
        statusString = @"交易完成";
    }else if (orderStatus == 5){
        //0为待处理 1为等地商家收货 2为等待重新发货 3已完成
        if (model.back_status.intValue == 0) {
            statusString = @"待处理";
        }else if (model.back_status.intValue == 1){
            statusString = @"等待商家收货";
        }else if (model.back_status.intValue == 2){
            statusString = model.back_type.intValue ==1?@"等待退款":@"等待重新发货";
        }else if (model.back_status.intValue == 3){
            statusString = @"已完成";
        }else{
            statusString = @"处理中";
        }
    }else if(orderStatus == 8){
        statusString = @"已取消";
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"C2C3C2"]];
    }else if (orderStatus == 0){
        statusString = @"等待付款";
    }
    
    return statusString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络请求
//TODO:请求订单详情信息
- (void)requestDetailNetworking{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"order_id"] = self.order_id;
    [self post:LCOrderDetail withParam:para success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            self.detailModel = [LCMyOrderDetailModel mj_objectWithKeyValues:dic[@"data"]];
            if (!_tableView) {
                [self setupControls];
            }else{
                [self refreshView];
            }
            
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self addUIAlertControlWithString:Network_Error withActionBlock:^{
            
        }];
    }];
}


//TODO:订单支付
- (void)requestPayOrderNet:(NSMutableDictionary *)para{
    para[@"token"] = TOKEN;
    para[@"order_id"] = self.detailModel.id;
    [SVProgressHUD showWithStatus:@"正在发起支付..."];
    [self postInbackground:LCOrderPay withParam:para success:^(id responseObject) {
        [CustormPayView dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            if ([para[@"pay_type"] isEqualToString:@"3"]) {
                [SVProgressHUD dismiss];
                [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
                [self requestDetailNetworking];
            }else if ([para[@"pay_type"] isEqualToString:@"1"]){
                //支付宝支付
                [[LCAlipayManager manager]AliPayWithOrderString:dic[@"data"] andBlock:^(NSDictionary *resultDic) {
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
                        [self requestDetailNetworking];
                    }
                    [self addUIAlertControlWithString:resultString withActionBlock:nil];
                }];
               
            }else{
                //微信支付
                LCWeChatModel *weChatModel = [LCWeChatModel mj_objectWithKeyValues:dic[@"data"]];
                [[LCWeChatManager manager] weChatPayWithModel:weChatModel andBlock:^(BOOL success) {
                    [SVProgressHUD dismiss];
                    if (success) {
                        //支付成功
                        [self requestDetailNetworking];
                    }
                    NSString *resultString = success?@"支付成功":@"支付失败";
                    [self addUIAlertControlWithString:resultString withActionBlock:nil];
                }];
            }
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [CustormPayView dismiss];
        [self addUIAlertControlWithString:Network_Error withActionBlock:nil];
    }];
}

//TODO:订单操作接口 1为取消2为确认收货3取消退款
- (void)requestOrderActionNetWith:(NSString *)order_id andType:(NSString *)type{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"order_id"] = order_id;
    para[@"type"] = type;
    [self postInbackground:LCOrderAction withParam:para success:^(id responseObject)
     {
         NSDictionary *dic = responseObject;
         if ([dic[@"code"] intValue] == 1) {
             [self requestDetailNetworking];
         }else{
             [SVProgressHUD dismiss];
             NSString *msg = [NSString stringWithFormat:@"%@",dic[@"msg"]];
             [self.view makeToast:msg duration:1.2 position:CSToastPositionCenter];
         }
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];
}

//TODO:请求再次购买
- (void)requestBuyAgainNetwork:(NSString *)orderId{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    [para setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    para[@"ids"] = orderId;
    [SVProgressHUD show];
    [self postInbackground:GoOrderInfo withParam:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *dataDic = dic[@"data"];
            GoPayViewController *vc = [[GoPayViewController alloc]init];
            vc.push_type = 3;
            vc.order_id = orderId;
            vc.dicData = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.detailModel) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailModel.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    BOOL allowRefund = self.detailModel.order_status.intValue == 3?YES:NO;
    LCMyOrderGoodsModel *model = [LCMyOrderGoodsModel mj_objectWithKeyValues:self.detailModel.goods[indexPath.row]];
    return [LCOrderDetailGoodsCell getOrderDetailGoodsCell:tableView andIndex:indexPath andIdentifier:@"orderDetailGoodsCell" andModel:model andBlock:^(LCMyOrderGoodsModel *goodsModel) {
        //点击申请售后
        LCRefundGoodsViewController *vc = [[LCRefundGoodsViewController alloc]init];
        vc.order_id = self.detailModel.id;
        vc.goodsModel = goodsModel;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } andType:allowRefund];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *titleString;
    if (section == 1) {
        titleString = @"商品清单";
    }else if (section == 2){
        titleString = @"配送信息";
    }else {
        titleString = @"订单信息";
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 30)];
    [view setBackgroundColor:[UIColor colorWithHexString:@"F4F5F4"]];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = titleString;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [LCOrderDetailGoodsCell getOrderDetailGoodsCellHeight];
}

// 去掉UItableview sectionHeaderView黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark button点击事件
//TODO:点击支付button
- (void)clickPayButtonAction:(UIButton *)button{
    [CustormPayView shareCustormPayView:^(CustormPayType payType, UIButton *payButton)
    {
        //支付类型1 支付宝 2微信 3余额
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        if (payType == PursePayType) {  //余额支付
            para[@"pay_type"] = @"3";
        }else if (payType == AlipayType){  //支付宝支付
            para[@"pay_type"] = @"1";
        }else if (payType == WechatPayType){ //微信支付
            para[@"pay_type"] = @"2";
        }
        [self requestPayOrderNet:para];
    }];
}

//TODO:点击取消button
- (void)clickCancelButtonAction:(UIButton *)button{
    if (self.detailModel) {
        __weak typeof(self) weakSelf = self;
        [weakSelf addUIAlertControlWithString:@"确认取消订单?" withActionBlock:^{
            [self requestOrderActionNetWith:self.detailModel.id andType:@"1"];
        } andCancel:nil];
        
    }
}

//TODO:点击再次购买
- (void)clickBuyAaginButtonAction:(UIButton *)button{
    [self requestBuyAgainNetwork:self.detailModel.id];
}

#pragma mark UIAlert 弹出框
-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (actionBlock) {
            actionBlock();
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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

- (void)dealloc{
    NSLog(@"订单详情已释放");
}

@end
