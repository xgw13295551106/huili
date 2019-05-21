//
//  WalletListViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "WalletListViewController.h"
#import "WalletListTableViewCell.h"
#import "WalletListModel.h"

@interface WalletListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)BGTableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic)int page;

@property(nonatomic)UIView *noData;

@end

@implementation WalletListViewController


- (void)viewDidLoad {
    [self setTitle:@"钱包明细"];
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    [self.view addSubview:self.myTableView];
    [self.myTableView insertSubview:self.noData atIndex:0];
    // Do any additional setup after loading the view.
}

-(UIView*)noData{
    if (_noData==nil) {
        _noData=[[UIView alloc]initWithFrame:CGRectMake(0, 100, AL_DEVICE_WIDTH, 220)];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 200)];
        [img setImage:[UIImage imageNamed:@"user_wallet_details_default"]];
        [img setContentMode:UIViewContentModeCenter];
        [_noData addSubview:img];
        [_noData setHidden:YES];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom, AL_DEVICE_WIDTH, 20)];
        [label setText:@"暂时没有钱包明细"];
        [label setTextColor:text3Color];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [_noData addSubview:label];
    }
    return _noData;
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (BGTableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[BGTableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64) style:UITableViewStylePlain];
        [_myTableView setBackgroundColor:[UIColor colorWithHexString:@"f7f7f8"]];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page=1;
            [weakSelf reloadeTable];
        }];
        _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[WalletListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/******************************UITableView代理结束**************************************/

-(void)reloadeTable{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"page"] = [NSString stringWithFormat:@"%i",_page];
    [self postInbackground:Blist withParam:para success:^(id responseObject) {
        [self endRefresh];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            if (_page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *tmpArray = [WalletListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            for (WalletListModel *model in tmpArray) {
                [self.dataArray addObject:model];
            }
            
            if (self.dataArray.count==0) {
                [self.noData setHidden:NO];
            }else{
                [self.noData setHidden:YES];
            }
            
            [self.myTableView reloadData];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endRefresh{
    [self.myTableView.mj_header endRefreshing];
    [self.myTableView.mj_footer endRefreshing];
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
