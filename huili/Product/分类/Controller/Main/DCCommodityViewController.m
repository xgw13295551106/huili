//
//  DCCommodityViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//
#define tableViewH  100

#import "DCCommodityViewController.h"
#import "BaseNavViewController.h"
#import "HomeSearchViewController.h"
#import "GoodsListViewController.h"
#import "SearchListViewController.h"

#import "CatModel.h"
// Views
#import "DCClassCategoryCell.h"
#import "DCGoodsSortCell.h"
#import "DCBrandSortCell.h"
// Vendors
#import "MJExtension.h"
// Categories

// Others
#define HOME_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HomeSearch.plist"] // the path of search record cached

@interface DCCommodityViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* collectionViw */
@property (strong , nonatomic)UICollectionView *collectionView;

/* 左边数据 */
@property (strong , nonatomic)NSMutableArray<CatModel *> *titleItem;
/* 右边数据 */
@property (strong , nonatomic)NSMutableArray<ClassifyModel *> *mainItem;

@property(nonatomic)UISearchBar *searchBar;

@property(nonatomic)NSString *key;

@end

static NSString *const DCClassCategoryCellID = @"DCClassCategoryCell";
static NSString *const DCBrandsSortHeadViewID = @"DCBrandsSortHeadView";
static NSString *const DCGoodsSortCellID = @"DCGoodsSortCell";
static NSString *const DCBrandSortCellID = @"DCBrandSortCell";

@implementation DCCommodityViewController

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, 0, tableViewH, AL_DEVICE_HEIGHT-NavHeight-50);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCClassCategoryCell class] forCellReuseIdentifier:DCClassCategoryCellID];
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 3; //X
        layout.minimumLineSpacing = 5;  //Y
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.frame = CGRectMake(tableViewH, 0, kScreenW - tableViewH, AL_DEVICE_HEIGHT-64-50);
        //注册Cell
        [_collectionView registerClass:[DCGoodsSortCell class] forCellWithReuseIdentifier:DCGoodsSortCellID];
        [_collectionView registerClass:[DCBrandSortCell class] forCellWithReuseIdentifier:DCBrandSortCellID];
    }
    return _collectionView;
}


#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YHHelpper getHotKey];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    NSArray *array=[UserDefaults objectForKey:@"catList"];
    if (array) {
        [self.titleItem removeAllObjects];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic=[array objectAtIndex:i];
            CatModel *model=[CatModel model];
            [model initWithDictionary:dic];
            [self.titleItem addObject:model];
        }
        [self.mainItem removeAllObjects];
        CatModel *model=[self.titleItem objectAtIndex:0];
        [self.mainItem addObjectsFromArray:model.classifyArr];
        [self.tableView reloadData];
        [self.collectionView reloadData];
        [self setUpData];
        
    }
    
    [self setUpNav];
    
    [self setUpTab];
    
    //获取分类
    [self getClassFy];
    
}

#pragma mark - initizlize
- (void)setUpTab
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(NSMutableArray*)titleItem{
    if (_titleItem==nil) {
        _titleItem=[[NSMutableArray alloc]init];
    }
    return _titleItem;
}
-(NSMutableArray*)mainItem{
    if (_mainItem==nil) {
        _mainItem=[[NSMutableArray alloc]init];
    }
    return _mainItem;
}

#pragma mark - 加载数据
- (void)setUpData
{
    //默认选择第一行（注意一定要在加载完数据之后）
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}


#pragma mark - 设置导航条
- (void)setUpNav
{
    

    //搜索框
    UITextField *searchText = [[UITextField alloc]initWithFrame:CGRectMake(20, 7, AL_DEVICE_WIDTH-40, 30)];
    searchText.placeholder = @"输入关键字搜索商品";
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


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCClassCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:DCClassCategoryCellID forIndexPath:indexPath];
    cell.titleItem = _titleItem[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatModel *model=[self.titleItem objectAtIndex:indexPath.row];
    NSLog(@"%@",model.cat_id);
    [self.mainItem removeAllObjects];
    [self.mainItem addObjectsFromArray:model.classifyArr];
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mainItem.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    DCGoodsSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsSortCellID forIndexPath:indexPath];
    cell.subItem = [self.mainItem objectAtIndex:indexPath.row];
    gridcell = cell;

    return gridcell;
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - tableViewH - 6)/3, (kScreenW - tableViewH - 6)/3+20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (TOKEN.length==0||(!TOKEN)) {
//        [YHHelpper alertLogin];
//        return;
//    }
    ClassifyModel *model=[self.mainItem objectAtIndex:indexPath.row];
    GoodsListViewController *vc=[[GoodsListViewController alloc]init];
    [vc setModel:model];
    [vc setListArray:self.mainItem];
    [self.navigationController pushViewController:vc animated:YES];
//    NSLog(@"点击了个第%zd分组第%zd几个Item",indexPath.section,indexPath.row);
//    DCGoodsSetViewController *goodSetVc = [[DCGoodsSetViewController alloc] init];
//    goodSetVc.goodPlisName = @"ClasiftyGoods.plist";
//    [self.navigationController pushViewController:goodSetVc animated:YES];
}

#pragma 设置StatusBar为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
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
        //        [vc setModel:self.model];
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
/****************************搜索**************************************/


/******************************获取分类************************************/
-(void)getClassFy{
    [[XAClient sharedClient] postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,CATLIST] withParam:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSArray *array=[responseObject objectForKey:@"data"];
            [UserDefaults setValue:array forKey:@"catList"];
            [self.titleItem removeAllObjects];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                CatModel *model=[CatModel model];
                [model initWithDictionary:dic];
                [self.titleItem addObject:model];
            }
            [self.mainItem removeAllObjects];
            CatModel *model=[self.titleItem objectAtIndex:0];
            [self.mainItem addObjectsFromArray:model.classifyArr];
            [self.tableView reloadData];
            [self.collectionView reloadData];
            [self setUpData];
            NSLog(@"%@",responseObject);
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
/******************************获取分类************************************/


@end
