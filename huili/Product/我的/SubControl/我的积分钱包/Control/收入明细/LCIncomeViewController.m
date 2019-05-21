//
//  LCIncomeViewController.m
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "LCIncomeViewController.h"
#import "LCIncomeListCell.h"

@interface LCIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int pageNum;
}

@property (nonatomic,strong)UILabel *totalIncomeLabel;    ///< 累计收入
@property (nonatomic,strong)UILabel *moneyLabel;          ///< 本月佣金

@property (nonatomic,strong)BGTableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LCIncomeViewController

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BGTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BGTableView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-NavHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"收入明细";
    [self setupViews];
    [self pull];
    [self push];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)setupViews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,70*PROPORTION)];
    [view setBackgroundColor:[UIColor colorWithHexString:@"F4F5F4"]];
    [self.view addSubview:view];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width,70*PROPORTION)];
    view1.backgroundColor = [UIColor whiteColor];
    [view addSubview:view1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0,40*PROPORTION,self.view.width/2,20*PROPORTION)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor darkGrayColor];
    label1.font = [UIFont systemFontOfSize:14*PROPORTION];
    label1.text = @"累计收入(元)";
    [view1 addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2,40*PROPORTION,self.view.width/2,20*PROPORTION)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor darkGrayColor];
    label2.font = [UIFont systemFontOfSize:14*PROPORTION];
    label2.text = @"本月佣金(元)";
    [view1 addSubview:label2];
    
    _totalIncomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,15*PROPORTION,self.view.width/2,20*PROPORTION)];
    _totalIncomeLabel.textAlignment = NSTextAlignmentCenter;
    _totalIncomeLabel.textColor = [UIColor colorWithHexString:@"DE3133"];
    _totalIncomeLabel.font = [UIFont systemFontOfSize:17*PROPORTION];
    _totalIncomeLabel.text = @"0";
    [view1 addSubview:_totalIncomeLabel];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2,15*PROPORTION,self.view.width/2,20*PROPORTION)];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.textColor = [UIColor colorWithHexString:@"DE3133"];
    _moneyLabel.font = [UIFont systemFontOfSize:17*PROPORTION];
    _moneyLabel.text = @"0.0";
    [view1 addSubview:_moneyLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(view1.centerX-0.5,2,1,view1.height-2*2)];
    line1.backgroundColor = LineColor;
    [view1 addSubview:line1];
    [self.view addSubview:self.tableView];
    [self.tableView setFrame:CGRectMake(0, view.maxY, win_width, win_height-NavHeight-view.maxY)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络请求
- (void)requestIncomeNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"page"] = [NSString stringWithFormat:@"%i",pageNum];
    [self postInbackground:LCIncomeList withParam:para success:^(id resultObject) {
        [self endRefresh];
        NSDictionary *dic = resultObject;
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *dataDic = dic[@"data"];
            _totalIncomeLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"total_income"]];
            _moneyLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"current_income"]];
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *tmpArray = dataDic[@"list"];
            for (NSDictionary *one in tmpArray) {
                [self.dataArray addObject:one];
            }
            [self.tableView reloadData];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
    }];
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LCIncomeListCell getIncomeListCell:tableView andIndex:indexPath andIdentifier:@"incomeListCell" andDic:self.dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [self requestIncomeNetwork];
}

//上拉加载更多数据
- (void)loadMoreData
{
    pageNum ++;
    [self requestIncomeNetwork];
}

//结束刷新
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
