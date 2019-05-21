//
//  HLKillViewController.m
//  huili
//
//  Created by zhongweike on 2018/1/9.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "HLKillViewController.h"
#import "HLKillGoodsCell.h"
#import "HLKillGoodsModel.h"
#import "GoodsDetailViewController.h"
#import "GoodsModel.h"

@interface HLKillViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int pageNum;
    NSTimer *timer;
}

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)BGTableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation HLKillViewController

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BGTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BGTableView alloc]initWithFrame:CGRectMake(0, _topView.maxY, win_width, win_height-NavHeight-BottomHeight-_topView.maxY) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 22)];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"424342"]];
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, _topView.height)];
        leftLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.text = @"抢购中";
        [_topView addSubview:leftLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_topView.width-10-200, 2, 200, 18)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [_topView addSubview:_timeLabel];
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"秒杀专场";
    [self setupControls];
    
}

- (void)setupControls{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self pull];
    [self push];
    if (!timer) {
        timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startCountTime:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络请求
- (void)requestListNetworking{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"page"] = [NSString stringWithFormat:@"%i",pageNum];
    para[@"is_recomm"] = @"1";
    [self postInbackground:GoodsList withParam:para success:^(id responseObject) {
        [self endRefresh];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            if (pageNum==1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *array=[responseObject objectForKey:@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                GoodsModel *model=[GoodsModel model];
                [model initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            [self startCountTime:timer];
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
    GoodsModel *model = self.dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    return [HLKillGoodsCell getKillGoodsCell:tableView andIndex:indexPath andIdentifer:@"killListCell" andModel:model andBlock:^(GoodsModel *goodsModel) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.end.integerValue];
        if ([[LCTools timerFireMethod:date] isEqualToString:@"00:00:00"]) {
            [weakSelf.view makeToast:@"秒杀已结束" duration:1.2 position:CSToastPositionCenter];
            return ;
        }
        GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
        [vc setGoods_id:goodsModel.goods_id];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel *goodsModel = self.dataArray[indexPath.row];
    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
    [vc setGoods_id:goodsModel.goods_id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HLKillGoodsCell getKillGoodsCellHeight];
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

//TODO:倒计时计算
- (void)startCountTime:(NSTimer *)oneTimer{
    GoodsModel *model = self.dataArray.count>0?self.dataArray[0]:@{};
    NSString *timeString = @"2018-01-09 20:58:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    date = [NSDate dateWithTimeIntervalSince1970:model.end.integerValue];
    NSString *labelString = [NSString stringWithFormat:@"距离结束 %@",[LCTools timerFireMethod:date]];
    _timeLabel.attributedText = [self setAttributedStringStyleWithTimeStr:labelString];

}

//TODO:获取封装的倒计时富文本
- (NSMutableAttributedString *)setAttributedStringStyleWithTimeStr:(NSString *)timeString {
    NSArray *stringArray = [timeString componentsSeparatedByString:@" "];
    NSArray *timeArray = [stringArray[1] componentsSeparatedByString:@":"];
    NSString *hour = timeArray[0];
    NSRange hour_range = NSMakeRange(5, hour.length);
    NSRange min_range = NSMakeRange(5+hour.length+1, 2);
    NSRange second_range = NSMakeRange(5+hour.length+1+2+1, 2);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:timeString];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, timeString.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, timeString.length)];
    //时
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"424342"] range:hour_range];
    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:hour_range];
    //分
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"424342"] range:min_range];
    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:min_range];
    //秒
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"424342"] range:second_range];
    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:second_range];
    
    
    return str;
}


- (void)dealloc{
    [timer invalidate];
    timer = nil;
}

@end
