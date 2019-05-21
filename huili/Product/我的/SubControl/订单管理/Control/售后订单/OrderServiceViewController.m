//
//  OrderServiceViewController.m
//  huili
//
//  Created by zhongweike on 2018/1/15.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "OrderServiceViewController.h"
#import "LCMyOrderDetailModel.h"
#import "OrderServiceCell.h"
#import "ServiceDetailViewController.h"

@interface OrderServiceViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int pageNum;
}

@property (nonatomic,strong)BGTableView *tableView;
@property (nonatomic,strong)UIView *nullView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation OrderServiceViewController

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

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

- (BGTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BGTableView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-NavHeight-BottomHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"售后订单";
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
- (void)requestListNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"status"] = @"6";
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

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OrderServiceCell getOrderServiceCell:tableView andIdentifier:@"orderServiceCell" andIndex:indexPath andModel:self.dataArray[indexPath.section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCMyOrderDetailModel *model = self.dataArray[indexPath.section];
    ServiceDetailViewController *vc = [[ServiceDetailViewController alloc]init];
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
    return [OrderServiceCell getOrderServiceCellHeight];
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
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
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
    [self requestListNetwork];
}

//上拉加载更多数据
- (void)loadMoreData
{
    pageNum ++;
    [self requestListNetwork];
}

//结束刷新
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (actionBlock) {
            actionBlock();
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
