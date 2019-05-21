//
//  LCBalanceViewController.m
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "LCBalanceViewController.h"
#import "LCBalanceHeadView.h"
#import "LCBalanceTableCell.h"
#import "LCIncomeViewController.h"
#import "LCExtractListViewController.h"
#import "LCBindAccountViewController.h"
#import "LCWithdrawViewController.h"
#import "BalanceRechargeViewController.h"
#import "WalletListViewController.h"

@interface LCBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)LCBalanceHeadView *headView;
@property (nonatomic,strong)BGTableView *tableView;

@property (nonatomic,strong)NSDictionary *infoDic;
@property (nonatomic,strong)NSArray *reConfigArray;

@end

@implementation LCBalanceViewController

- (LCBalanceHeadView *)headView{
    if (!_headView) {
        _headView = [[LCBalanceHeadView alloc]initWithFrame:CGRectMake(0, 0, win_width, 180)];
    }
    return _headView;
}

- (BGTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BGTableView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-NavHeight) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的积分钱包";
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestUserInfoNetwork];
}

- (void)setupViews{
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LCBalanceTableCell getMyPurseInfoCell:tableView andIndex:indexPath andIdentifier:@"balanceCell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WalletListViewController *vc = [[WalletListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            LCExtractListViewController *vc = [[LCExtractListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            if ([NSString stringIsNull:[UserInfoManager currentUser].alipay_account]) {
                [self.view makeToast:@"请先绑定账户" duration:1.2 position:CSToastPositionCenter];
//                return;
            }
            LCWithdrawViewController *vc = [[LCWithdrawViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            [self requestRechargeConfigNet];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0){
            LCBindAccountViewController *vc = [[LCBindAccountViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 10)];
    [view setBackgroundColor:[UIColor colorWithHexString:@"F4F5F4"]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

// 去掉UItableview sectionHeaderView黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark 网络请求
//TODO:获取用户信息
- (void)requestUserInfoNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    [self postInbackground:GETINFO withParam:para success:^(id resultObject) {
        NSDictionary *dic = resultObject;
        if ([dic[@"code"] intValue] == 1) {
            UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues:dic[@"data"]];
            userInfo.token = TOKEN;
            [[UserInfoManager manager] saveUserInfo:userInfo];
            [self.headView reloadHeadView];
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
