//
//  MyWalletViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "MyWalletViewController.h"
#import "WalletListViewController.h"
#import "JifenListViewController.h"
#import "BalanceRechargeViewController.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)UIView *headerView;
@property (nonatomic)UILabel *yueValue;
@property (nonatomic)UILabel *jifen;

@property(nonatomic)UIView *footerView;

@property (nonatomic,strong)NSArray *reConfigArray;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的钱包"];
    
    [self.view addSubview:self.myTableView];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f7f7f8"]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestUserInfoNetwork];
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64) style:UITableViewStylePlain];
        [_myTableView setBackgroundColor:[UIColor colorWithHexString:@"f7f7f8"]];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableHeaderView=self.headerView;
        _myTableView.tableFooterView=self.footerView;
        [_myTableView setScrollEnabled:NO];
        
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}
-(UIView*)headerView{
    if (_headerView==nil) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 150)];
        [_headerView setBackgroundColor:STYLECOLOR];
        UILabel *yueLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, AL_DEVICE_WIDTH, 30)];
        [yueLabel setText:@"账户余额（元）"];
        [yueLabel setTextAlignment:NSTextAlignmentCenter];
        [yueLabel setTextColor:[UIColor whiteColor]];
        [yueLabel setFont:[UIFont systemFontOfSize:16]];
        [_headerView addSubview:yueLabel];
        
        _yueValue=[[UILabel alloc]initWithFrame:CGRectMake(0, yueLabel.bottom, AL_DEVICE_WIDTH, 40)];
        [_yueValue setText:[UserInfoManager currentUser].balance];
        [_yueValue setTextAlignment:NSTextAlignmentCenter];
        [_yueValue setTextColor:[UIColor whiteColor]];
        [_yueValue setFont:[UIFont boldSystemFontOfSize:30]];
        [_headerView addSubview:_yueValue];
        
        _jifen=[[UILabel alloc]initWithFrame:CGRectMake(0, _yueValue.bottom, AL_DEVICE_WIDTH, 30)];
        [_jifen setText:[NSString stringWithFormat:@"当前积分：%@",[UserInfoManager currentUser].integral]];
        [_jifen setTextAlignment:NSTextAlignmentCenter];
        [_jifen setTextColor:[UIColor whiteColor]];
        [_jifen setFont:[UIFont systemFontOfSize:16]];
        [_headerView addSubview:_jifen];
        
        
        
    }
    return _headerView;
}

-(UIView*)footerView{
    if (_footerView==nil) {
        _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 60)];
        UIButton *chongzhi=[[UIButton alloc]initWithFrame:CGRectMake(10, 8, AL_DEVICE_WIDTH-20, 44)];
        [chongzhi setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
        [chongzhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chongzhi setTitle:@"余额充值" forState:UIControlStateNormal];
        [chongzhi.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_footerView addSubview:chongzhi];
        [chongzhi addTarget:self action:@selector(clcikChongzhi) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

/******************************UITableView初始化结束**************************************/

#pragma mark UITableView代理
/******************************UITableView代理开始**************************************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,AL_DEVICE_WIDTH, 10)];
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,AL_DEVICE_WIDTH, 10)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (indexPath.row==0) {
        [cell.imageView setImage:[UIImage imageNamed:@"user_wallet_qianbaomx"]];
        [cell.textLabel setText:@"钱包明细"];
    }else{
        [cell.imageView setImage:[UIImage imageNamed:@"user_wallet_jifenmx"]];
        [cell.textLabel setText:@"积分明细"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {//钱包明细
        WalletListViewController *vc=[[WalletListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{//积分明细
        JifenListViewController *vc=[[JifenListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
/******************************UITableView代理结束**************************************/
//{
//    "give_money" = 0;
//    id = 11;
//    "pay_money" = 1;
//},
//{
//    "give_money" = 0;
//    id = 2;
//    "pay_money" = 10;
//},
//{
//    "give_money" = 2;
//    id = 1;
//    "pay_money" = 30;
//},
//{
//    "give_money" = 3;
//    id = 7;
//    "pay_money" = 50;
//},
//{
//    "give_money" = 10;
//    id = 8;
//    "pay_money" = 100;
//}

/******************************余额充值************************************/
-(void)clcikChongzhi{
    [self requestRechargeConfigNet];
    
}
/******************************余额充值************************************/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络请求
//请求用户余额
- (void)requestUserInfoNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    [self post:GETINFO withParam:para success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            [[UserInfoManager manager]saveUserInfo:[UserInfoModel getUserModel:dic[@"data"]]];
            _yueValue.text = [UserInfoManager currentUser].balance;
            _jifen.text = [NSString stringWithFormat:@"当前积分：%@",[UserInfoManager currentUser].integral];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
}

//TODO:请求充值配置
- (void)requestRechargeConfigNet
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    [self postInbackground:Option withParam:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            self.reConfigArray = dic[@"data"];
            BalanceRechargeViewController *detail = [[BalanceRechargeViewController alloc]init];
            detail.array = _reConfigArray;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}




@end
