//
//  LCMyOrderListViewController.m
//  YeFu
//
//  Created by zhongweike on 2017/12/11.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCMyOrderListViewController.h"
#import "LCMyOrderStatusView.h"
#import "LCMyOrderListCell.h"
#import "LCMyOrderDetailModel.h"
#import "LCMyOrderDetailViewController.h"
#import "GoPayViewController.h"
#import "LCWuliuViewController.h"

@interface LCMyOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int pageNum;
}

@property (nonatomic,strong)LCMyOrderStatusView *statusView;
@property (nonatomic,strong)BGTableView *tableView;
@property (nonatomic,strong)UIView *nullView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LCMyOrderListViewController

- (UIView *)nullView{
    if (!_nullView) {
        _nullView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        [_nullView setBackgroundColor:[UIColor colorWithHexString:@"F7F8F7"]];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_pic_default"]];
        [imageView sizeToFit];
        imageView.center = CGPointMake(_nullView.width/2, _nullView.height/2-30);
        [_nullView addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.maxY+20, _nullView.width, 25)];
        label.textColor = [UIColor colorWithHexString:@"CDD1D8"];
        label.font = [UIFont systemFontOfSize:20];
        label.text = @"暂时没有相关订单";
        label.textAlignment = NSTextAlignmentCenter;
        [_nullView addSubview:label];
        _nullView.hidden = YES;
        
    }
    return _nullView;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BGTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BGTableView alloc]initWithFrame:CGRectMake(0, _statusView.maxY, win_width, win_height-64-KIsiPhoneXH-_statusView.maxY) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)setSelectStatus:(int)selectStatus{
    _selectStatus = selectStatus;
    pageNum = 1;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的订单";
    [self setUpControls];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self loadNewData];
}

- (void)setUpControls{
    //订单状态选择view
    __weak typeof(self) weakSelf = self;
    _statusView = [LCMyOrderStatusView getMyOrderStatusView:CGRectMake(0, 0, win_width, 41) andBlock:^(int selectIndex) {
        weakSelf.selectStatus = selectIndex;
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    _statusView.selectIndex = self.selectStatus;

    [self.view addSubview:_statusView];
    
    [self.view addSubview:self.tableView];
    [self.tableView insertSubview:self.nullView atIndex:0];
    [self pull];
    [self push];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络请求
//TODO:请求订单列表
- (void)requestListNetworking{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"status"] = [NSString stringWithFormat:@"%i",_statusView.selectIndex];
    para[@"page"] = [NSString stringWithFormat:@"%i",pageNum];
    self.nullView.hidden = YES;
    [self postInbackground:LCOrderList withParam:para success:^(id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *tmpArray = [LCMyOrderDetailModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            if (tmpArray.count > 0) {
                for (LCMyOrderDetailModel *model in tmpArray) {
                    [self.dataArray addObject:model];
                }
            }
            self.nullView.hidden = self.dataArray.count==0?NO:YES;
            [self.tableView reloadData];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
        [self addUIAlertControlWithString:Network_Error withActionBlock:^{
            
        }];
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
            [self loadNewData];
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//获取cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    return [LCMyOrderListCell getMyOrderListCell:tableView andIndex:indexPath andModel:self.dataArray[indexPath.section] andBlock:^(OrderButtonEvent orderEvent, LCMyOrderDetailModel *model) {
        if (orderEvent == cancelEvent){ //取消订单
            [weakSelf addUIAlertControlWithString:@"确认取消订单?" withActionBlock:^{
                [self requestOrderActionNetWith:model.id andType:@"1"];
            } andCancel:nil];
        }else if (orderEvent == payEvent){//支付
            LCMyOrderDetailViewController *vc = [[LCMyOrderDetailViewController alloc]init];
            vc.order_id = model.id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (orderEvent == buyAgentEvent){//再次购买
            [weakSelf requestBuyAgainNetwork:model.id];
        }else if (orderEvent == acceptEvent){//确认收货
            [weakSelf addUIAlertControlWithString:@"是否确认收货？" withActionBlock:^{
                [weakSelf requestOrderActionNetWith:model.id andType:@"2"];
            } andCancel:nil];
        }else if (orderEvent == cancelRefundEvent){//取消退款
            [weakSelf requestOrderActionNetWith:model.id andType:@"3"];
        }else if (orderEvent == wuliuEvent){ //查看物流
            LCMyOrderGoodsModel *goods_model = [LCMyOrderGoodsModel mj_objectWithKeyValues:model.goods[0]];
            LCWuliuViewController *vc = [[LCWuliuViewController alloc]init];
            vc.order_id = model.id;
            vc.order_goods_img = goods_model.goods_img;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCMyOrderDetailModel *model = self.dataArray[indexPath.section];
    LCMyOrderDetailViewController *vc = [[LCMyOrderDetailViewController alloc]init];
    vc.order_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
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
    return [LCMyOrderListCell getMyOrderListCellHeight:tableView andIndex:indexPath andModel:self.dataArray[indexPath.section]];
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
}

#pragma mark 下拉刷新等操作
//下拉刷新
-(void)pull
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:13];
    
    // 设置颜色
    header.stateLabel.textColor = STYLECOLOR;
    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置刷新控件
    self.tableView.mj_header = header;
}
//上拉加载更多
-(void)push
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置文字
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    footer.stateLabel.textColor = STYLECOLOR;
    
    // 设置footer
    self.tableView.mj_footer = footer;
}

//下拉刷新数据
- (void)loadNewData
{
    pageNum = 1;
    [self requestListNetworking];
}

//上拉加载更多数据
- (void)loadMoreData
{
    pageNum ++;
    [self requestListNetworking];
}

//结束刷新
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}



-(void)dealloc{
    NSLog(@"该VC已释放");
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

@end
