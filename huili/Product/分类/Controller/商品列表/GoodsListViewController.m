//
//  GoodsListViewController.m
//  yihuo
//
//  Created by Carl on 2017/12/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsTableViewCell.h"
#import "SGEasyButton.h"
#import "GoodsDetailViewController.h"
#import "LeftViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "BaseNavViewController.h"
#import "SearchListViewController.h"


//#import "CWScrollView.h"
#define HOME_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeSearch.plist"] // the path of search record cached

@interface GoodsListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *myTableView;
@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic)int page;

@property(nonatomic)UIView *noData;

@property(nonatomic,weak)UIButton *sellBtn;
@property(nonatomic,weak)UIButton *priceBtn;

@property(nonatomic)int orderby;

@property(nonatomic,weak)UITextField *searchText;
@property(nonatomic)NSString *key;

@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.noData];
    [self.myTableView.mj_header beginRefreshing];
    [self creatTop];
    // Do any additional setup after loading the view.
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

#pragma mark - 设置导航条
- (void)setUpNav
{
    //搜索框
    UITextField *searchText = [[UITextField alloc]initWithFrame:CGRectMake(20, 7, AL_DEVICE_WIDTH-40, 30)];
    searchText.placeholder = @"输入关键字搜索商品";
    _searchText=searchText;
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.layer.cornerRadius = 8;
    searchText.layer.masksToBounds = YES;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
    UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 15, 15)];
    searchImage.contentMode = UIViewContentModeCenter;
    [searchImage setImage:[UIImage imageNamed:@"home_icon_search"]];
    [searchView addSubview:searchImage];
    searchText.leftView = searchView;
    searchText.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *searchBg=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 30)];
    [searchBg setBackgroundColor:[UIColor clearColor]];
    [searchBg.layer setCornerRadius:8];
    [searchBg addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [searchText addSubview:searchBg];
    self.navigationItem.titleView = searchText;
}

#pragma mark--创建头部
-(void)creatTop{
    UIView *topBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 50)];
    [topBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topBg];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 49, AL_DEVICE_WIDTH, 1)];
    [line setBackgroundColor:LineColor];
    [self.view addSubview:line];
    
    UIButton *sellBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH/3, 50)];
    [sellBtn setTitle:@"销量" forState:UIControlStateNormal];
    _sellBtn=sellBtn;
    [sellBtn setSelected:YES];
    self.orderby=1;
    [sellBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sellBtn setTitleColor:text1Color forState:UIControlStateNormal];
    [sellBtn setTitleColor:STYLECOLOR forState:UIControlStateSelected];
    [topBg addSubview:sellBtn];
    [sellBtn addTarget:self action:@selector(sellCilck:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *priceBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH/3, 0, AL_DEVICE_WIDTH/3, 50)];
    [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    _priceBtn=priceBtn;
    [priceBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:10];
    [priceBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [priceBtn setImage:[UIImage imageNamed:@"common_icon_screen"] forState:UIControlStateNormal];
    [priceBtn setTitleColor:text1Color forState:UIControlStateNormal];
    [priceBtn setTitleColor:STYLECOLOR forState:UIControlStateSelected];
    [topBg addSubview:priceBtn];
    [priceBtn addTarget:self action:@selector(priceCilck) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(2*AL_DEVICE_WIDTH/3, 0, AL_DEVICE_WIDTH/3, 50)];
    [leftBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftBtn setTitleColor:text1Color forState:UIControlStateNormal];
    [leftBtn setTitleColor:STYLECOLOR forState:UIControlStateSelected];
    [topBg addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(drawerMaskAnimationRight) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark--销量选择
-(void)sellCilck:(UIButton*)sender{
    sender.selected=YES;
    self.orderby=1;
    [_priceBtn setImage:[UIImage imageNamed:@"common_icon_screen"] forState:UIControlStateNormal];
    
    [self.myTableView.mj_header beginRefreshing];
    [_sellBtn setSelected:YES];
    [_priceBtn setSelected:NO];
}
#pragma mark--价格
-(void)priceCilck{
    if (self.orderby==1) {
        self.orderby=2;
        [_priceBtn setImage:[UIImage imageNamed:@"common_icon_screen_up"] forState:UIControlStateNormal];
    }else if (self.orderby==2){
        self.orderby=3;
        [_priceBtn setImage:[UIImage imageNamed:@"common_icon_screen_down"] forState:UIControlStateNormal];
    }else{
        self.orderby=2;
        [_priceBtn setImage:[UIImage imageNamed:@"common_icon_screen_up"] forState:UIControlStateNormal];
    }
    [_sellBtn setSelected:NO];
    [_priceBtn setSelected:YES];
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
            weakSelf.page=1;
            [weakSelf getGoodsList];
        }];
        _myTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
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
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsListCell"];
    if (!cell) {
        cell = [[GoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsListCell"];
    }
    cell.model = self.dataArray[indexPath.row];
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
    [param setValue:self.model.sub_id forKey:@"sub_id"];
    [param setValue:[NSString stringWithInt:self.orderby] forKey:@"orderby"];
    [param setValue:[self.model.filterArray componentsJoinedByString:@","] forKey:@"name"];
    [param setValue:@"0" forKey:@"is_special"];
    [param setValue:@"0" forKey:@"is_recomm"];
    
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
/******************************请求数据************************************/

- (void)drawerMaskAnimationRight{
    
    LeftViewController *vc = [[LeftViewController alloc] init];
    [vc setDataArray:self.listArray];
    [vc setCurrentModel:self.model];
    
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0 direction:CWDrawerTransitionDirectionRight backImage:nil];
    YHWeakSelf
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:conf];
    [vc setSelectClassBlock:^(ClassifyModel *model) {
        weakSelf.model=model;
        [weakSelf.myTableView.mj_header beginRefreshing];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

/****************************搜索**************************************/
-(void)searchClick{
    if (TOKEN.length==0||(!TOKEN)) {
        [YHHelpper alertLogin];
        return;
    }
    // 1. Create an Array of popular search
    NSArray *array=[UserDefaults objectForKey:@"hotKey"];
    NSMutableArray *hotSeaches=[[NSMutableArray alloc]init];
    if (array) {
        for (NSDictionary *dic in array) {
            [hotSeaches addObject:[dic stringForKey:@"name"]];
        }
    }
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索商品" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        SearchListViewController *vc=[[SearchListViewController alloc]init];
        [vc setModel:self.model];
        vc.key=searchText;
        [searchViewController.navigationController pushViewController:vc animated:YES];
        
    }];
    [searchViewController setHotSearchStyle:PYHotSearchStyleColorfulTag];
    [searchViewController.searchBar setTintColor:STYLECOLOR];
    searchViewController.searchHistoriesCachePath = HOME_CACHE_PATH;
    // 5. Present a navigation controller
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YHHelpper getHotKey];
}

-(void)setListArray:(NSArray *)listArray{
    _listArray=listArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@被释放了",NSStringFromClass([self class]));
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
