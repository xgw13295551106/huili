//
//  LCWuliuViewController.m
//  huili
//
//  Created by zhongweike on 2018/1/12.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "LCWuliuViewController.h"
#import "LCWuliuHeadView.h"
#import "LCWuliuCell.h"

@interface LCWuliuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)LCWuliuHeadView *headView;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSDictionary *infoDic;

@end

@implementation LCWuliuViewController

- (LCWuliuHeadView *)headView{
    if (!_headView) {
        _headView = [LCWuliuHeadView getWuliuHeadView:CGRectMake(0, 0, win_width, 100) andDic:_infoDic];
    }
    return _headView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-NavHeight-BottomHeight) style:UITableViewStylePlain];
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
    self.navigationItem.title = @"查看物流";
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self requestWuliuNetwork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络请求
- (void)requestWuliuNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"order_id"] = self.order_id;
    
    [self post:LCSearchWuliu withParam:para success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            //expTextName承运来源 mailNo物流编号 tel客服电话 data<NSArray，time,context>信息数组
            _infoDic = dic[@"data"];
            self.tableView.tableHeaderView = self.headView;
            self.headView.order_goods_img = self.order_goods_img;
            [self.tableView reloadData];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tmpArray = _infoDic[@"data"];
    return tmpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tmpArray = _infoDic[@"data"];
    return [LCWuliuCell getWuliuCell:tableView andIndex:indexPath andIdentifier:@"wuliuCell" andDic:tmpArray[indexPath.row]];
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
    NSArray *tmpArray = _infoDic[@"data"];
    if (tmpArray.count == 0) {
        return 0;
    }
    return [LCWuliuCell getWuliuCellHeightWith:tmpArray[indexPath.row]];
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

@end
