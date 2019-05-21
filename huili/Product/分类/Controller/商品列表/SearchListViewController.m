//
//  SearchListViewController.m
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "SearchListViewController.h"
#import "SGEasyButton.h"
#import "GoodsDetailViewController.h"
#import "GoodsTableViewCell.h"

@interface SearchListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *myTableView;
@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic)int page;

@property(nonatomic)UIView *noData;

@property(nonatomic,weak)UIButton *sellBtn;
@property(nonatomic,weak)UIButton *priceBtn;

@property(nonatomic)int orderby;

@end

@implementation SearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.noData];
    [self.myTableView.mj_header beginRefreshing];
    [self creatTop];
    // Do any additional setup after loading the view.
}

-(void)setKey:(NSString *)key{
    _key=key;
    [self setTitle:key];
}
-(void)setModel:(ClassifyModel *)model{
    _model=model;
}

-(UIView*)noData{
    if (_noData==nil) {
        _noData=[[UIView alloc]initWithFrame:CGRectMake(0, 100, AL_DEVICE_WIDTH, 220)];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 200)];
        [img setImage:[UIImage imageNamed:@"home_pic_search_default"]];
        [img setContentMode:UIViewContentModeCenter];
        [_noData addSubview:img];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom, AL_DEVICE_WIDTH, 30)];
        [label setText:@"未搜索到任何结果"];
        [label setTextColor:text3Color];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [_noData addSubview:label];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, label.bottom, AL_DEVICE_WIDTH, 20)];
        [label2 setText:[CommonConfig shared].pageAd];
        [label2 setTextColor:STYLECOLOR];
        [label2 setFont:[UIFont boldSystemFontOfSize:16]];
        [label2 setTextAlignment:NSTextAlignmentCenter];
        [_noData addSubview:label2];
        [_noData setHidden:YES];
    }
    return _noData;
}

#pragma mark--创建头部
-(void)creatTop{
    UIView *topBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 50)];
    [topBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topBg];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 49, AL_DEVICE_WIDTH, 1)];
    [line setBackgroundColor:LineColor];
    [self.view addSubview:line];
    
    UIButton *sellBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH/2, 50)];
    [sellBtn setTitle:@"销量" forState:UIControlStateNormal];
    _sellBtn=sellBtn;
    [sellBtn setSelected:YES];
    self.orderby=1;
    [sellBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sellBtn setTitleColor:text1Color forState:UIControlStateNormal];
    [sellBtn setTitleColor:STYLECOLOR forState:UIControlStateSelected];
    [topBg addSubview:sellBtn];
    [sellBtn addTarget:self action:@selector(sellCilck:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *priceBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH/2, 0, AL_DEVICE_WIDTH/2, 50)];
    [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    _priceBtn=priceBtn;
    [priceBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:10];
    [priceBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [priceBtn setImage:[UIImage imageNamed:@"common_icon_screen"] forState:UIControlStateNormal];
    [priceBtn setTitleColor:text1Color forState:UIControlStateNormal];
    [priceBtn setTitleColor:STYLECOLOR forState:UIControlStateSelected];
    [topBg addSubview:priceBtn];
    [priceBtn addTarget:self action:@selector(priceCilck) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark--销量选择
-(void)sellCilck:(UIButton*)sender{
    sender.selected=YES;
    self.orderby=1;
    [_priceBtn setImage:[UIImage imageNamed:@"common_icon_screen"] forState:UIControlStateNormal];
    
    [self.myTableView.mj_header beginRefreshing];
}
#pragma mark--价格
-(void)priceCilck{
    if (self.orderby==1) {
        self.orderby=2;
        [_priceBtn setImage:[UIImage imageNamed:@"common_icon_screen_down"] forState:UIControlStateNormal];
    }else if (self.orderby==2){
        self.orderby=3;
        [_priceBtn setImage:[UIImage imageNamed:@"common_icon_screen_up"] forState:UIControlStateNormal];
    }else{
        self.orderby=2;
        [_priceBtn setImage:[UIImage imageNamed:@"common_icon_screen_down"] forState:UIControlStateNormal];
    }
    [_sellBtn setSelected:NO];
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-50) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView=[UIView new];
        __weak typeof(self) weakSelf = self;
        _myTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            self.page=1;
            [weakSelf getGoodsList];
        }];
        _myTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            self.page++;
            [weakSelf getGoodsList];
        }];
        
        _myTableView.showsVerticalScrollIndicator = NO;
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
//    [cell setIs_new:self.is_new];
    cell.model = self.dataArray[indexPath.row];
//    [cell setIs_special:self.is_special];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
    GoodsModel *model=self.dataArray[indexPath.row];
    [vc setGoods_id:model.goods_id];
    [self.navigationController pushViewController:vc animated:YES];
}

/******************************UITableView代理结束**************************************/

/******************************请求数据************************************/
-(void)getGoodsList{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:[NSString stringWithInt:self.page] forKey:@"page"];
    [param setValue:self.model.cat_id forKey:@"cat_id"];
    [param setValue:self.is_new forKey:@"is_new"];
    [param setValue:@"0" forKey:@"is_special"];
    [param setValue:@"0" forKey:@"is_recomm"];
    [param setValue:self.is_selling forKey:@"is_selling"];
    [param setValue:self.model.sub_id forKey:@"sub_id"];
    [param setValue:self.key forKey:@"key"];
    [param setValue:[NSString stringWithInt:self.orderby] forKey:@"orderby"];
    
    [self postInbackground:GoodsList withParam:param success:^(id responseObject) {
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
                [model initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            if (self.dataArray.count==0) {
                [self.noData setHidden:NO];
            }else{
                [self.noData setHidden:YES];
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
