//
//  LCBillDetailOrdersViewController.m
//  YeFu
//
//  Created by zhongweike on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCBillDetailOrdersViewController.h"
#import "BillModel.h"
#import "DrawBillTableViewCell.h"

@interface LCBillDetailOrdersViewController ()<UITableViewDelegate,UITableViewDataSource,DrawBillTableViewCellDelegate>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation LCBillDetailOrdersViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-KIsiPhoneXNavHAndB) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"F4F5F4"]];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"所含订单";
    [self.view addSubview:self.tableView];
}

- (void)setupControls{
    [self.view addSubview:self.tableView];
}

- (void)setDataArray:(NSArray *)dataArray{
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *one in dataArray) {
        BillModel *model = [BillModel model];
        [model initWithDictionary:one];
        [tmpArray addObject:model];
    }
    _dataArray = [tmpArray copy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DrawBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[DrawBillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BillModel *model=[self.dataArray objectAtIndex:indexPath.section];
    [cell setDelegate:self];
    cell.noSelect = YES;
    cell.model = model;
    return cell;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
