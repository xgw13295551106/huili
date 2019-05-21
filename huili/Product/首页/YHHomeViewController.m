//
//  YHHomeViewController.m
//  yihuo
//
//  Created by zhongweike on 2017/12/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHHomeViewController.h"
#import "YHHomeHeadView.h"

#import "BaseNavViewController.h"
#import "SearchListViewController.h"
#import "GoodsDetailViewController.h"
#import "GoodsListViewController.h"
#import "ClassifyModel.h"
#import "WKBaseViewController.h"
#import "SLCityListViewController.h"
#import "LCHomeTableViewCell.h"
#import "HLKillViewController.h"

#define BannerH 3*AL_DEVICE_WIDTH/5

#define HOME_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeSearch.plist"] // the path of search record cached

@interface YHHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SLCityListViewControllerDelegate>

@property (nonatomic,strong)YHHomeHeadView *headView;
@property (nonatomic,strong)BGTableView *tableView;

@property (nonatomic,strong)UIButton *leftNavButton;

@property(nonatomic)AMapLocationManager *locationManager;

@property (nonatomic,strong)NSDictionary *infoDic;

@property (nonatomic,strong)NSArray *hotArray; ///< 今日特价

@end

@implementation YHHomeViewController


#pragma mark --getter懒加载
- (YHHomeHeadView *)headView{
    if (!_headView) {
        _headView = [YHHomeHeadView getHomeHeadView:CGRectMake(0, 0, win_width, BannerH+200) andBlock:^(NSDictionary *infoDic, ClickHeadType clickType) {
            if (clickType == clickClassify) { //点击分类{id,name,img}
                if ([[infoDic stringForKey:@"id"] isEqualToString:@"9999"]) {
                    [self.tabBarController setSelectedIndex:1];
                    return ;
                }
                ClassifyModel *currentModel=[ClassifyModel model];
                NSMutableArray *listArray=[[NSMutableArray alloc]init];
                NSArray *array=[UserDefaults objectForKey:@"catList"];
                NSLog(@"%@",array);
                if (array) {
                    for (int i=0; i<array.count; i++) {
                        NSDictionary *dic=[array objectAtIndex:i];
                        if ([[dic stringForKey:@"id"] isEqualToString:[infoDic stringForKey:@"id"]]) {
                            NSArray *arrayC=[dic objectForKey:@"child"];
                            currentModel.name=[dic stringForKey:@"name"];
                            currentModel.cat_id=[dic stringForKey:@"id"];
                            for (int j=0; j<arrayC.count; j++) {
                                NSDictionary *dict=[arrayC objectAtIndex:j];
                                ClassifyModel *model=[ClassifyModel model];
                                [model initWithDictionary:dict];
                                [listArray addObject:model];
                            }
                        }
                    }
                }
                GoodsListViewController *vc=[[GoodsListViewController alloc]init];
                [vc setModel:currentModel];
                [vc setListArray:listArray];
                [self.navigationController pushViewController:vc animated:YES];
            }else if(clickType == clickBanner){ //点击广告{id,img,link_url,link_type}
                if ([infoDic intForKey:@"link_type"]==1) {
                    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
                    [vc setGoods_id:[infoDic stringForKey:@"id"]];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([infoDic intForKey:@"link_type"]==2){
                    WKBaseViewController *vc=[[WKBaseViewController alloc]init];
                    [vc setUrl:[infoDic stringForKey:@"link_url"]];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if (clickType == clickKill){ //点击秒杀专场
                HLKillViewController *vc = [[HLKillViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if (clickType == clickGoods){ //点击秒杀商品
                GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
                [vc setGoods_id:[infoDic stringForKey:@"id"]];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _headView;
}

- (BGTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BGTableView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-BottomHeight-50) style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf reloadeTable];
        }];
    }
    return _tableView;
}

- (UIButton *)leftNavButton{
    if (!_leftNavButton) {
        _leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftNavButton setImage:[UIImage imageNamed:@"home_button_location"] forState:UIControlStateNormal];
        [_leftNavButton setTitle:@"定位中" forState:UIControlStateNormal];
        [_leftNavButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftNavButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftNavButton setFrame:CGRectMake(0, 0, 80, 30)];
        [_leftNavButton addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftNavButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupControls];
    [self getClassFy];
}


- (void)setupControls{
    [self setNavgation];
    [self.view addSubview:self.tableView];
    self.locationManager=[[AMapLocationManager alloc]init];
    [self reloadeTable];
}


//TODO:设置nav的界面
- (void)setNavgation{
    BaseNavViewController *nav = (BaseNavViewController *)self.navigationController;
    [nav setNavigationBarColorWith:[UIColor clearColor] andClear:YES];
    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftNavButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.3]];
    [titleButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [titleButton setTitle:@"  输入关键字搜索商品" forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [titleButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [titleButton setFrame:CGRectMake(15, 0, win_width-30, 30)];
    titleButton.layer.cornerRadius = titleButton.height/2;
    titleButton.layer.masksToBounds = YES;
    self.navigationItem.titleView = titleButton;
    [titleButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 定位处理
/*******************************刷新页面***********************************/
-(void)reloadeTable{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [self requestHomeNetwork:param];
}
/*******************************刷新页面***********************************/

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *hotArray = _infoDic[@"hot"];
    return hotArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    return [LCHomeTableViewCell getHomeCell:tableView andIdentifier:@"homeCell" andIndex:indexPath andDic:_hotArray[indexPath.row] andBlock:^(NSDictionary *goodsDic) {
        //goodsDic的key:id,img,name,price,super_price
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
        vc.goods_id = [goodsDic stringForKey:@"id"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *hotArray = _infoDic[@"hot"];
    NSDictionary *goodsDic = hotArray[indexPath.row];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
    vc.goods_id = [goodsDic stringForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 25)];
    [view setBackgroundColor:[UIColor colorWithHexString:@"F4F5F4"]];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    [imgView setImage:[UIImage imageNamed:@"home_discount"]];
    imgView.contentMode = UIViewContentModeCenter;
    [view addSubview:imgView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [LCHomeTableViewCell getHomeCellHeight];
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
    UIEdgeInsets insets = scrollView.contentInset;
    CGFloat banner_h = BannerH;
    BaseNavViewController *nav = (BaseNavViewController *)self.navigationController;
    if (scrollView.contentOffset.y <=0) {
        [nav setNavigationBarColorWith:[UIColor colorWithHexString:@"e1302a" alpha:0] andClear:YES];
        insets.bottom = 0;
    }else if (scrollView.contentOffset.y < banner_h && scrollView.contentOffset.y >0) {
        CGFloat alpha = scrollView.contentOffset.y/banner_h;
        [nav setNavigationBarColorWith:[UIColor colorWithHexString:@"e1302a" alpha:alpha] andClear:YES];
        insets.bottom = 0;
    }else{
        [nav setNavigationBarColorWith:[UIColor colorWithHexString:@"e1302a" alpha:1.0] andClear:YES];
        insets.bottom = NavHeight;
    }
    scrollView.contentInset = insets;
//    if (scrollView.contentOffset.y < 0) {
//        self.navigationController.navigationBar.hidden = YES;
//    }else {
//        self.navigationController.navigationBar.hidden = NO;
//    }
}


#pragma mark 网络请求
//TODO:请求首页接口
- (void)requestHomeNetwork:(NSMutableDictionary *)para{
    para[@"token"] = TOKEN;
    [self postInbackground:YHMain withParam:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            [self handleDataWith:dic[@"data"]];
        }else{
            [self.view makeToast:[dic stringForKey:@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}
//TODO:分析接口返回数据并处理
- (void)handleDataWith:(NSDictionary *)dic{
    self.infoDic = dic;
    [self.leftNavButton setTitle:[dic stringForKey:@"city"] forState:UIControlStateNormal];
    //先本地缓存地区id
    [UserDefaults setValue:dic[@"supplier_id"] forKey:@"supplier_id"];
    //获取banner的list
    [self.headView reloadHeadViewWith:dic];
    _hotArray = dic[@"hot"];
    //刷新tableView
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YHHelpper getHotKey];
    self.navigationController.navigationBar.translucent = YES;
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forBarMetrics:UIBarMetricsDefault];
    [self p_setNavigationBarColor:STYLECOLOR translucent:NO];
}

/******************************获取分类************************************/
-(void)getClassFy{
    [[XAClient sharedClient] postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,CATLIST] withParam:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSArray *array=[responseObject objectForKey:@"data"];
            [UserDefaults setValue:array forKey:@"catList"];
            NSLog(@"%@",responseObject);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
/******************************获取分类************************************/

/****************************搜索**************************************/
-(void)searchClick{
//    if (TOKEN.length==0||(!TOKEN)) {
//        [YHHelpper alertLogin];
//        return;
//    }
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

/*********************************选择位置*********************************/
-(void)locationClick{
    SLCityListViewController *cityListVC = [SLCityListViewController new];
    
    cityListVC.delegate = self;
    cityListVC.cityModel.selectedCity = @"合肥";
    cityListVC.cityModel.selectedCityId = 1;
    
    BaseNavViewController *nv = [[BaseNavViewController alloc] initWithRootViewController:cityListVC];
    
    [self presentViewController:nv animated:YES completion:nil];
}

- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id {
    //    [UserDefaults stringForKey:@"supplier_id"]
//    [UserDefaults setValue:[NSString stringWithFormat:@"%ld",Id] forKey:@"supplier_id"];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:@"region" forKey:@"region"];
    [self requestHomeNetwork:param];
    
}
-(void)sl_currentCityLat:(NSString *)lat Lng:(NSString *)lng{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:lat forKey:@"lat"];
    [param setValue:lng forKey:@"lng"];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [self requestHomeNetwork:param];
    
}

/*********************************选择位置*********************************/

@end
