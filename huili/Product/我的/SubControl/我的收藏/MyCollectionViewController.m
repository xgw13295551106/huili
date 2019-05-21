//
//  MyCollectionViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "GoodsTableViewCell.h"
#import "GoodsDetailViewController.h"

@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic)int page;

@property(nonatomic)int type;//0为不选择 1为选择

@property(nonatomic)UIBarButtonItem *right1;

@property(nonatomic)UIBarButtonItem *right2;

@property(nonatomic)UIButton *cancelCollect;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"收藏列表"];

    
//    self.navigationItem.rightBarButtonItem=self.right1;
    
    [self.view addSubview:self.myTableView];
    
    [self.myTableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}

-(UIButton*)cancelCollect{
    if (_cancelCollect==nil) {
        _cancelCollect=[[UIButton alloc]initWithFrame:CGRectMake(0, AL_DEVICE_HEIGHT-64-50, AL_DEVICE_WIDTH, 50)];
        [_cancelCollect setBackgroundColor:STYLECOLOR];
        [_cancelCollect setTitle:@"取消收藏" forState:UIControlStateNormal];
        [_cancelCollect addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelCollect.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_cancelCollect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_cancelCollect];
        [_cancelCollect setHidden:YES];
    }
    return _cancelCollect;
}

-(UIBarButtonItem*)right1{
    if (_right1==nil) {
        _right1=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick1)];
    }
    return _right1;
}
-(UIBarButtonItem*)right2{
    if (_right2==nil) {
        _right2=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick2)];
    }
    return _right2;
}

-(void)rightClick1{
    self.navigationItem.rightBarButtonItem=self.right2;
    self.type=1;
    [self.myTableView reloadData];
    [self.myTableView setFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64-50)];
    [self.cancelCollect setHidden:NO];
}
-(void)rightClick2{
    self.navigationItem.rightBarButtonItem=self.right1;
    self.type=0;
    [self.myTableView setFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64)];
    [self.myTableView reloadData];
    [self.cancelCollect setHidden:YES];
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView=[UIView new];
        _myTableView.showsVerticalScrollIndicator = NO;
        __weak typeof(self) weakSelf = self;
        _myTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            weakSelf.page=1;
            [weakSelf getCollectList];
        }];
        _myTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            [weakSelf getCollectList];
        }];
    }
    return _myTableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
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
    return 130*PROPORTION;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[GoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.model = self.dataArray[indexPath.row];
    cell.is_collect = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel *model=[self.dataArray objectAtIndex:indexPath.row];
    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
    [vc setGoods_id:model.goods_id];
    [self.navigationController pushViewController:vc animated:YES];
}


//删除
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView setEditing:NO animated:YES];
        GoodsModel *model=[self.dataArray objectAtIndex:indexPath.row];
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setValue:TOKEN forKey:@"token"];
        [param setValue:model.co_id forKey:@"co_id"];
        [self post:GoodsCancelCollect withParam:param success:^(id responseObject) {
            int code=[responseObject intForKey:@"code"];
            if (code==1) {
                [SVProgressHUDHelp SVProgressHUDSuccess:@"取消收藏成功"];
                [self.dataArray removeObject:model];
                [self.myTableView reloadData];
            }else{
                [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
            }
        } failure:nil];
        NSLog(@"删除");
    }];
    return @[deleteRowAction];//左划出现几个就返回几个
}
/******************************UITableView代理结束**************************************/

/*******************************取消关注***********************************/
-(void)cancelClick{
    NSMutableArray *delectArray=[[NSMutableArray alloc]init];
    NSMutableArray *co_idArr=[[NSMutableArray alloc]init];
    for (int i=0; i<self.dataArray.count; i++) {
        GoodsModel *model=[self.dataArray objectAtIndex:i];
        if (model.isSelect) {
            [delectArray addObject:model];
            [co_idArr addObject:model.co_id];
        }
    }
    if (delectArray.count==0) {
        return;
    }
    NSString *co_id = [co_idArr componentsJoinedByString:@","];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:co_id forKey:@"co_id"];
    [self post:GoodsCancelCollect withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [SVProgressHUDHelp SVProgressHUDSuccess:@"删除成功"];
            [self.dataArray removeObjectsInArray:delectArray];
            [self.myTableView reloadData];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
}
/*******************************取消关注***********************************/

/*******************************获取收藏列表***********************************/
-(void)getCollectList{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:[NSString stringWithInt:self.page] forKey:@"page"];
    [self postInbackground:GoodsCollectList withParam:param success:^(id responseObject) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSArray *array=[responseObject objectForKey:@"data"];
            if (self.page==1) {
                [self.dataArray removeAllObjects];
            }
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                GoodsModel *model=[GoodsModel model];
                [model initWithDictionary3:dic];
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
}
/*******************************获取收藏列表***********************************/

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
