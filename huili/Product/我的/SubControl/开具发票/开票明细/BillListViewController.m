//
//  BillListViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BillListViewController.h"
#import "BillTableViewCell.h"
#import "BillDetailViewController.h"

@interface BillListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic)UIView *noData;

@property(nonatomic)int page;

@end

@implementation BillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"开票明细"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
    
//    [self.view addSubview:self.noData];
    
    [self.view addSubview:self.myTableView];
    
    // Do any additional setup after loading the view.
}

-(UIView*)noData{
    if (_noData==nil) {
        _noData=[[UIView alloc]initWithFrame:CGRectMake(0, 100, AL_DEVICE_WIDTH, 220)];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 200)];
        [img setImage:[UIImage imageNamed:@"common_pic_search_default"]];
        [img setContentMode:UIViewContentModeCenter];
        [_noData addSubview:img];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom, AL_DEVICE_WIDTH, 20)];
        [label setText:@"暂时没有消息"];
        [label setTextColor:text3Color];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [_noData addSubview:label];
    }
    return _noData;
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView=[UIView new];
        __weak typeof(self) weakSelf = self;
        _myTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            weakSelf.page=1;
            [weakSelf reloadeTable];
        }];
        _myTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            [weakSelf reloadeTable];
        }];
        [_myTableView.mj_header beginRefreshing];
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];

    }
    return _dataArray;
}
/******************************UITableView初始化结束**************************************/

#pragma mark UITableView代理
/******************************UITableView代理开始**************************************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[BillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DrawBillModel *model = self.dataArray[indexPath.row];
    BillDetailViewController *vc = [[BillDetailViewController alloc]init];
    vc.in_id = model.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}
/******************************UITableView代理结束**************************************/

-(void)reloadeTable{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"page"] = [NSString stringWithFormat:@"%i",_page];
    [self postInbackground:InList withParam:para success:^(id responseObject) {
        [self endRefresh];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            if (_page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *tmpArray = dic[@"data"];
            for (NSDictionary *one in tmpArray) {
                DrawBillModel *model = [[DrawBillModel model]initWithDictionary:one];
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
    }];
}

- (void)endRefresh{
    [self.myTableView.mj_header endRefreshing];
    [self.myTableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
