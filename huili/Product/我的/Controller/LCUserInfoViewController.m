//
//  LCUserInfoViewController.m
//  zhuaWaWa
//
//  Created by zhongweike on 2017/11/24.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCUserInfoViewController.h"
#import "LCUserInfoHeadView.h"
#import "LCEditUserInfoViewController.h"
#import "LCUserInfoCell.h"
#import "ShareView.h"
#import "InfoListModel.h"
#import "LCTools.h"

#import "LCBalanceViewController.h"
#import "MessageViewController.h"
#import "MyCollectionViewController.h"
#import "AddressListViewController.h"
#import "DrawBillViewController.h"
#import "LCMyOrderListViewController.h"
#import "UserGuidViewController.h"
#import "AboutViewController.h"
#import "KefuViewController.h"
#import "OrderServiceViewController.h"
#import "MyAllyViewController.h"
#import "LCVipViewController.h"
#import "LCVipRechargeViewController.h"



@interface LCUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,LCUserInfoHeadViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LCUserInfoHeadView *headView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UIView *footView;

@end

@implementation LCUserInfoViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"InfoList" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        for (int i=0; i<array.count; i++) {
            NSArray *midArr=[array objectAtIndex:i];
            NSMutableArray *mideValueArr=[[NSMutableArray alloc]init];
            for (int j=0; j<midArr.count; j++) {
                InfoListModel *model=[InfoListModel model];
                NSDictionary *dic=[midArr objectAtIndex:j];
                [model initWithDictionary:dic];
                [mideValueArr addObject:model];
            }
            [_dataArray addObject:mideValueArr];
        }
    }
    return _dataArray;
}

- (LCUserInfoHeadView *)headView{
    if (!_headView) {
        _headView = [[LCUserInfoHeadView alloc]initWithFrame:CGRectMake(0, 0, win_width, 240)];
        [_headView setDelegate:self];
    }
    return _headView;
}
-(UIView*)footView{
    if (_footView==nil) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 60)];
        UIButton *quit=[[UIButton alloc]initWithFrame:CGRectMake(20, 10, AL_DEVICE_WIDTH-40, 40)];
        [quit setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [quit setTitle:@"退出登录" forState:UIControlStateNormal];
        [quit addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
        [quit.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [quit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footView addSubview:quit];
    }
    return _footView;
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-NavHeight-50) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = self.footView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setShowsVerticalScrollIndicator:NO];
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpControls];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f8f8f8"]];
}

- (void)setUpControls{
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:点击消息
- (void)clickRightItem:(UIBarButtonItem *)rightItem{
    
}



#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%d",(int)indexPath.row]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"cell%d",(int)indexPath.row]];
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSArray *array=[self.dataArray objectAtIndex:indexPath.section];
    InfoListModel *model=[array objectAtIndex:indexPath.row];
    
    [cell.imageView setImage:[UIImage imageNamed:model.img]];
    [cell.textLabel setText:model.name];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:text3Color];
//    [cell.detailTextLabel setText:model.name];
    if (model.cat_id==8) {
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.detailTextLabel setText:App_Version];
    }
    if (model.cat_id==9) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[LCTools folderSizeAtPath:[LCTools getCachesPath]]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array=[self.dataArray objectAtIndex:indexPath.section];
    InfoListModel *model=[array objectAtIndex:indexPath.row];
    
    switch (model.cat_id) {
        case 0://地址管理
        {
            AddressListViewController *vc=[[AddressListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1://我的收藏
        {
            MyCollectionViewController *vc=[[MyCollectionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2://消息中心
        {
            MessageViewController *vc=[[MessageViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3://会员专区
        {
            if ([UserInfoManager currentUser].type.intValue == 0) {
                ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:App_Name message:@"您还不是会员，是否前往充值？"];
                [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
                    
                }]];
                [alertView addAction:[ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
                    LCVipRechargeViewController *vc = [[LCVipRechargeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }]];
                ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
                alertController.tapBackgroundDismissEnable = NO;
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                LCVipViewController *vc = [[LCVipViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 4://我的盟友
        {
            MyAllyViewController *vc = [[MyAllyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5://我的积分钱包
        {
            LCBalanceViewController *vc = [[LCBalanceViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6://使用指南
        {
            UserGuidViewController *vc=[[UserGuidViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7://关于我们
        {
            AboutViewController *vc=[[AboutViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9://清除缓存
        {
            ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:App_Name message:@"是否清除缓存"];
            
            [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
                
            }]];
            
            [alertView addAction:[ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
                [LCTools clearCache:[LCTools getCachesPath]];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }]];
            
            ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
            alertController.tapBackgroundDismissEnable = NO;
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 10://联系客服
        {
            [YHHelpper callPhoneAlert:[CommonConfig shared].mobileSer setTitle:@"客服热线"];
        }
            break;
        case 11://分享app
        {
            [[ShareView ShareViewClient] shareClick:nil setTitle:nil setContent:nil setIcon:nil];
        }
            break;
        default:
            break;
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
    return 50;
}

// 去掉UItableview sectionHeaderView黏性
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y<0) {
//        scrollView.contentOffset = CGPointZero; //滑动到顶部时，停止滑动
//    }
//    CGFloat sectionHeaderHeight = 10;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}
/*************************点击编辑个人信息*****************************************/
-(void)editUser{
    LCEditUserInfoViewController *vc = [[LCEditUserInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
/*************************点击编辑个人信息*****************************************/

/**************************退出登录****************************************/
-(void)quitClick{
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:App_Name message:@"是否退出登录"];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        
    }]];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        [UserInfoManager logout];
        
        self.tabBarController.selectedIndex=0;
        
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"out", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_CartChange object:nil userInfo:dic];
        
    }]];
    
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
    alertController.tapBackgroundDismissEnable = NO;
    [self presentViewController:alertController animated:YES completion:nil];
    
}
/**************************退出登录****************************************/

/**************************更新用户信息****************************************/
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [[XAClient sharedClient] postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,GETINFO] withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSDictionary *data=[responseObject objectForKey:@"data"];
            UserInfoManager *manage = [UserInfoManager manager];
            [manage saveUserInfo:[UserInfoModel getUserModel:data]];
            [self.headView reloadView];
        }
    } failure:nil];
    [self.headView reloadView];
    
    [[XAClient sharedClient]postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,OrderAmount] withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSDictionary *dic=[responseObject objectForKey:@"data"];
            [self.headView setOrderDic:dic];
        }
    } failure:nil];
}
/**************************更新用户信息****************************************/

/*************************点击编辑个人信息*****************************************/
/**************************点击订单type=0全部 1已下单 2配送中 3待评价 4 已评价****************************************/
-(void)clickOrder:(int)type{
    NSLog(@"%d",type);
    LCMyOrderListViewController *vc = [[LCMyOrderListViewController alloc]init];
    switch (type) {
        case 0:
        {
            vc.selectStatus = 0; //全部
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            vc.selectStatus = 1;  //待付款
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            vc.selectStatus = 2;  //待发货
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            vc.selectStatus = 3;  //待收货
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            vc.selectStatus = 4; //已完成
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            OrderServiceViewController *serviceVC = [[OrderServiceViewController alloc]init];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}
/**************************点击订单****************************************/

/**************************点击会员专区****************************************/
- (void)clickVip{
    if ([UserInfoManager currentUser].type.intValue == 0) {
        ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:App_Name message:@"您还不是会员，是否前往充值？"];
        [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
            
        }]];
        [alertView addAction:[ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
            LCVipRechargeViewController *vc = [[LCVipRechargeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }]];
        ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
        alertController.tapBackgroundDismissEnable = NO;
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        LCVipViewController *vc = [[LCVipViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**************************点击会员专区****************************************/


@end
