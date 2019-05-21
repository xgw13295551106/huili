//
//  BillDetailViewController.m
//  YeFu
//
//  Created by zhongweike on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BillDetailViewController.h"
#import "LCIndetailModel.h"
#import "LCBillDetailSecondCell.h"
#import "LCBillDetailThirdCell.h"
#import "LCBillDetailFouthCell.h"
#import "LCBillDetailOrdersViewController.h"

@interface BillDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)BGTableView *tableView;
@property (nonatomic,strong)LCIndetailModel *detailModel;   ///< 开票详情view
@property (nonatomic,strong)NSMutableArray *dataArray;   ///< 决定显示哪些内容的array

@end

@implementation BillDetailViewController

- (NSMutableArray *)dataArray{
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:@"1"];
    if (_detailModel.status.intValue>0) {
        //若显示已开票或已出票，则多显示一个cell
        [_dataArray addObject:@"2"];
    }
    [_dataArray addObject:@"3"];
    [_dataArray addObject:@"4"];
    [_dataArray addObject:@"5"];
    return _dataArray;
}

- (BGTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BGTableView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-KIsiPhoneXNavHAndB) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F4F5F4"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开票详情";
    [self requestInNetwork];
}

- (void)setupControls{
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络请求
- (void)requestInNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"in_id"] = self.in_id;
    [self post:InDetail withParam:para success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            self.detailModel = [LCIndetailModel mj_objectWithKeyValues:dic[@"data"]];
            [self setupControls];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        
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
    NSString *cell_identifier = self.dataArray[indexPath.section];
    if ([cell_identifier isEqualToString:@"1"]) {
        //只用到一个，所以不写复用了
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"inStatusCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, win_width, 40)];
        statusLabel.font = [UIFont systemFontOfSize:16];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.textColor = [UIColor colorWithHexString:@"4CCCC6"];
        [cell addSubview:statusLabel];
        if (_detailModel.status.intValue == 0) {
            statusLabel.text = @"待开票";
            statusLabel.textColor = [UIColor colorWithHexString:@"FE1E1E"];
        }else if (_detailModel.status.intValue == 1){
            statusLabel.text = @"已开票";
        }else if (_detailModel.status.intValue == 2){
            statusLabel.text = @"已发出";
        }
        
        return cell;
    }else if ([cell_identifier isEqualToString:@"2"]){
        LCBillDetailSecondCell *cell = [LCBillDetailSecondCell getBillDetailSecondCell:tableView andIndex:indexPath andIdentifier:@"billDetailSecondCell" andModel:self.detailModel];
        return cell;
    }else if ([cell_identifier isEqualToString:@"3"]){
        LCBillDetailThirdCell *cell = [LCBillDetailThirdCell getBillDetailThirdCell:tableView andIndex:indexPath andIdentifier:@"billDetailThirdCell" andModel:self.detailModel];
        return cell;
    }else if ([cell_identifier isEqualToString:@"4"]){
        LCBillDetailFouthCell *cell = [LCBillDetailFouthCell getBillDetailFouthCell:tableView andIndex:indexPath andIdentifier:@"billDetailFounthCell" andModel:self.detailModel];
        return cell;
    }else if ([cell_identifier isEqualToString:@"5"]){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"billDetailFifthCell"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, win_width-15*2, 30)];
        label.textColor = [UIColor colorWithHexString:@"606160"];
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"%@张发票，含%i个订单",_detailModel.num,(int)_detailModel.order.count];
        label.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:label];
        
        //右侧箭头图片
        UIImage *rightImage = [UIImage imageNamed:@"next"];
        UIImageView *rightImgView = [[UIImageView alloc]initWithImage:rightImage];
        [rightImgView sizeToFit];
        [rightImgView setFrame:CGRectMake(win_width-10-rightImgView.width, 60/2-rightImgView.height/2, rightImgView.width, rightImgView.height)];
        [cell addSubview:rightImgView];
        
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *cell_identifier = self.dataArray[indexPath.section];
    if (cell_identifier.intValue == 5 ){
        LCBillDetailOrdersViewController *vc = [[LCBillDetailOrdersViewController alloc]init];
        vc.dataArray = self.detailModel.order;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 10)];
    [view setBackgroundColor:[UIColor colorWithHexString:@"F4F5F4"]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cell_identifier = self.dataArray[indexPath.section];
    if (cell_identifier.intValue == 1 ) {
        return 40;
    }else if (cell_identifier.intValue == 2){
        return [LCBillDetailSecondCell getBillDetailSecondCellHeight:_detailModel];
    }else if (cell_identifier.intValue == 3){
        return [LCBillDetailThirdCell getBillDetailThirdCellHeight:_detailModel];
    }else if (cell_identifier.intValue == 4){
        return [LCBillDetailFouthCell getBillDetailFouthCellHeight];
    }else if (cell_identifier.intValue == 5){
        return 60;
    }
    return 0;
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
