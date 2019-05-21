//
//  SLCityListViewController.m
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import "SLCityListViewController.h"

#import "SLCityHeadView.h"
#import "SLCityListCell.h"
#import "SLHotCityCell.h"
#import "CityMacros.h"
#import "SLCityLocationView.h"
#import "SLLocationHelp.h"
#import "BaseNavViewController.h"
#import "SelectAreaViewController.h"


#define City_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CitySearch.plist"] // the path of search record cached

@interface SLCityListViewController ()<UITableViewDelegate, UITableViewDataSource,PYSearchViewControllerDelegate,SelectAreaViewControllerDelegate>


/** 列表视图 */
@property (strong, nonatomic) UITableView *tableView;
/** 定位视图 */
@property (strong, nonatomic) SLCityLocationView *cityLocationView;
/** 区头视图 */
@property (strong, nonatomic) SLCityHeadView *cityHeadView;
/** 是否开始拖拽 */
@property (assign, nonatomic, getter=isBegainDrag) BOOL begainDrag;
/** 区头数组 */
@property (strong, nonatomic) NSMutableArray *sectionArray;
/** 分区中心动画label */
@property (strong, nonatomic) UILabel *sectionTitle;
/** 定位城市ID */
@property (assign, nonatomic) NSInteger Id;



@property(nonatomic)AMapLocationManager *locationManager;

@property(nonatomic)NSString *lat;

@property(nonatomic)NSString *lng;

@end


#define kSectionTitleWidth 50
#define kTimeInterval 1



@implementation SLCityListViewController

#pragma mark -- 懒加载
// 区头数组
- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray new];
    }
    return _sectionArray;
}

// 分区动画标题
- (UILabel *)sectionTitle {
    if (!_sectionTitle) {
        _sectionTitle = [UILabel new];
        _sectionTitle.backgroundColor = [UIColor redColor];
        _sectionTitle.textColor = [UIColor whiteColor];
        _sectionTitle.layer.cornerRadius = kSectionTitleWidth / 2.0;
        _sectionTitle.layer.masksToBounds = YES;
        _sectionTitle.alpha = 0;
        _sectionTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _sectionTitle;
}

- (SLCityModel *)cityModel {
    if (!_cityModel) {
        _cityModel=[SLCityModel new];
//        NSString *path = [[NSBundle mainBundle] pathForResource:kCityData ofType:nil];
//        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
//        _cityModel = [SLCityModel mj_objectWithKeyValues:data];
    }
    return _cityModel;
}

// 定位视图
- (SLCityLocationView *)cityLocationView {
    if (!_cityLocationView) {
        _cityLocationView = [[SLCityLocationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    }
    return _cityLocationView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionIndexBackgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        _tableView.sectionIndexColor = STYLECOLOR;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SLCityHeadView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:cityHeadView];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SLHotCityCell class]) bundle:nil] forCellReuseIdentifier:hotCityCell];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SLCityListCell class]) bundle:nil] forCellReuseIdentifier:cityListCell];
    }
    return _tableView;
}

-(AMapLocationManager*)locationManager{
    if (_locationManager==nil) {
        _locationManager=[[AMapLocationManager alloc]init];
    }
    return _locationManager;
}

#pragma mark -- 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 设置navigationBar
    [self setupNavigationBar];
    
    // 添加视图
    [self.view addSubview:self.cityLocationView];
    // 定位方法
    [self locationAction:self.cityLocationView];
    
    
    
    
    [self.cityLocationView.cityButton addTarget:self action:@selector(locationCitySelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cityLocationView.locationButton addTarget:self action:@selector(againLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self getCityList];

    // 定位索引图片
    UIImageView *locationImageView = [UIImageView new];
    locationImageView.image = [UIImage imageNamed:@"location"];
    [self.view addSubview:locationImageView];
    CGFloat centerOffset = self.sectionArray.count * 13 / 2.5;
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-3.5);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.view.mas_centerY).offset(-centerOffset);
    }];
    // 动画

}

#pragma mark -- 设置navigationBar
- (void)setupNavigationBar {
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem=back;
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH-20, 44)];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(10, 7, AL_DEVICE_WIDTH-20, 30)];
    [searchBar setPlaceholder:@"搜索"];
    searchBar.backgroundImage = [NSBundle py_imageNamed:@"clearImage"];
    [searchBar addSubview:searchBtn];
    self.navigationItem.titleView=searchBar;
    
    
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    // 设置标题
//    self.navigationItem.title = self.cityModel.selectedCityId? [NSString stringWithFormat:@"当前选择-%@", self.cityModel.selectedCity]: @"选择城市";
    [self selectdeCity];
}
- (void)selectdeCity {
    
    // 遍历选择
    for (SLCityList *cityList in self.cityModel.list) {
        for (SLCity *city in cityList.citys) {
            
            if (city.Id == self.cityModel.selectedCityId) {
                city.selected = YES;
            } else {
                city.selected = NO;
            }
        }
    }
    
    
}

#pragma mark -- 定位
/// 定位选择
- (void)locationCitySelected:(UIButton *)button {

    if ([self.delegate respondsToSelector:@selector(sl_currentCityLat:Lng:)]) {
        [self.delegate sl_currentCityLat:self.lat Lng:self.lng];
    }
    
//    if (_delegate && [_delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
//        
//        [_delegate sl_cityListSelectedCity:button.titleLabel.text Id:self.Id];
//        
//    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
/// 重新定位
- (void)againLocation:(UIButton *)button {
    [self locationAction:self.cityLocationView];
}

/// 定位
- (void)locationAction:(SLCityLocationView *)cityLocationView {
    
    YHWeakSelf
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            cityLocationView.cityButton.enabled = YES;
            cityLocationView.locationCity = [NSString stringWithFormat:@"%@%@",regeocode.city,regeocode.district];
            weakSelf.lat=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
            weakSelf.lng=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
        }
    }];
}


#pragma mark -- 分区中心动画视图添加
- (void)sectionAnimationView {
    [self.tableView.superview addSubview:self.sectionTitle];
    [self.sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.tableView.superview);
        make.width.height.mas_equalTo(kSectionTitleWidth);
    }];
}


#pragma mark -- tableView 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section? self.cityModel.list[section - 1].citys.count: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SLHotCityCell *hotCell = [tableView dequeueReusableCellWithIdentifier:hotCityCell forIndexPath:indexPath];
        hotCell.cityModel = self.cityModel;
        __weak typeof(self) weakSelf = self;
        hotCell.selectedCityBlock = ^(NSString *selectedCity, NSInteger Id) {
            [weakSelf sl_currentCity:selectedCity supplier_id:Id];
//            SelectAreaViewController *vc=[[SelectAreaViewController alloc]init];
//            [vc setDelegate:self];
//            [vc setCity:selectedCity];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        };
        
        return hotCell;
    }
    
    SLCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cityListCell forIndexPath:indexPath];
    cell.city = self.cityModel.list[indexPath.section - 1].citys[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section? 33: self.cityModel.hotCellH;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section? 18: 0.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.cityHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cityHeadView];
    
    self.cityHeadView.titleLabel.text = self.sectionArray[section];
    
    return self.cityHeadView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) return;
    
//    if (_delegate && [_delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
//
//        SLCity *city = self.cityModel.list[indexPath.section - 1].citys[indexPath.row];
//        [_delegate sl_cityListSelectedCity:city.name Id:city.Id];
//
//    }
    SLCity *city = self.cityModel.list[indexPath.section - 1].citys[indexPath.row];
//    SelectAreaViewController *vc=[[SelectAreaViewController alloc]init];
//    [vc setDelegate:self];
//    [vc setCity:city.name];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    [self sl_currentCity:city.name supplier_id:city.Id];
    
}




- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    
    // 结束拖拽
    self.begainDrag = NO;
    
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sectionTitle.alpha = 1.0;
        [self.sectionTitle.layer removeAllAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.sectionTitle.alpha = 0.;
        }];
    }];
    
    return index;
    
}



#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    UITableView *tableView = (UITableView *)scrollView;
    NSArray *array = [tableView indexPathsForRowsInRect:CGRectMake(0, tableView.contentOffset.y, kScreenWidth, 20)];
    NSIndexPath *indexPath = [NSIndexPath new];
    indexPath = array.count? array[0]: [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.sectionTitle.text = self.sectionArray[indexPath.section];
    
    // 是否开始拖拽
    if (self.isBegainDrag) {
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.sectionTitle.alpha = 1.0;
        }];
    }
    
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.begainDrag = YES;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sectionTitle.alpha = 0.;
    }];
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    self.begainDrag = NO;
    if (!velocity.y) {
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.sectionTitle.alpha = 0.;
        }];
        
    }
    
    
}


- (void)dealloc {
    
}

/****************************搜索**************************************/
-(void)searchClick{
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索城市" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
//        [searchViewController.navigationController pushViewController:[[SelectAreaViewController alloc] init] animated:YES];
        [self getCityKey:searchText];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [searchViewController setHotSearchStyle:PYHotSearchStyleColorfulTag];
    [searchViewController.searchBar setTintColor:STYLECOLOR];
//    searchViewController.searchHistoriesCachePath = nil;
    searchViewController.showSearchHistory=NO;
    [searchViewController setDelegate:self];
    // 5. Present a navigation controller
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
}
/****************************搜索**************************************/

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
//            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
//                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
//                [searchSuggestionsM addObject:searchSuggestion];
//            }
//            // Refresh and display the search suggustions
//            searchViewController.searchSuggestions = searchSuggestionsM;
//        });
    }
}

-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/****************************获取热门城市和城市**************************************/
-(void)getCityList{
    //获取热门城市
    [[XAClient sharedClient] postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,GetHotCity] withParam:nil success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
//            self.cityModel.hotCity
            NSMutableArray *hotArr=[[NSMutableArray alloc]init];
            NSArray *array=[responseObject objectForKey:@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                SLCity *HotModel=[SLCity new];
                HotModel.Id=[dic intForKey:@"count"];
                HotModel.name=[dic stringForKey:@"city"];
                [hotArr addObject:HotModel];
            }
            self.cityModel.hotCity=hotArr;
            
            //获取城市
            [[XAClient sharedClient] postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,GetCity] withParam:nil success:^(id responseObject) {
                int code=[responseObject intForKey:@"code"];
                if (code==1) {
                    NSMutableArray *cityListArray=[[NSMutableArray alloc]init];
                    NSArray *array=[responseObject objectForKey:@"data"];
                    for (int i=0; i<array.count; i++) {
                        NSDictionary *dic=[array objectAtIndex:i];
                        SLCityList *cityModel=[SLCityList new];
                        cityModel.initial=[dic stringForKey:@"name"];
                        NSMutableArray *cityArray=[[NSMutableArray alloc]init];
                        NSArray *childArray=[dic objectForKey:@"children"];
                        for (int j=0; j<childArray.count; j++) {
                            NSDictionary *dicChlid=[childArray objectAtIndex:j];
                            SLCity *childModel=[SLCity new];
                            childModel.name=[dicChlid stringForKey:@"name"];
                            childModel.Id=[dicChlid integerForKey:@"id"];
                            [cityArray addObject:childModel];
                        }
                        cityModel.citys=cityArray;
                        [cityListArray addObject:cityModel];
                    }
                    self.cityModel.list=cityListArray;
                    [self.sectionArray removeAllObjects];
//                    self.sectionArray=[[NSMutableArray alloc]init];
                    for (SLCityList *cityList in self.cityModel.list) {
                        [self.sectionArray addObject:cityList.initial];
                    }
                    [self.sectionArray insertObject:@"热门" atIndex:0];
                    
                    [self.view addSubview:self.tableView];
                    [self sectionAnimationView];
                }else{
                    [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
                }
            } failure:nil];
            
//            [self.tableView reloadData];
            
            
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
//    [self.view addSubview:self.tableView];
}

-(void)getCityKey:(NSString*)key{
    //获取城市
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:key forKey:@"key"];
    [[XAClient sharedClient] postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,GetCity] withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSMutableArray *cityListArray=[[NSMutableArray alloc]init];
            NSArray *array=[responseObject objectForKey:@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                SLCityList *cityModel=[SLCityList new];
                NSMutableArray *cityArray=[[NSMutableArray alloc]init];
                NSArray *childArray=[dic objectForKey:@"children"];
                cityModel.initial=[dic stringForKey:@"name"];
                for (int j=0; j<childArray.count; j++) {
                    NSDictionary *dicChlid=[childArray objectAtIndex:j];
                    SLCity *childModel=[SLCity new];
                    childModel.name=[dicChlid stringForKey:@"name"];
                    childModel.Id=[dicChlid integerForKey:@"id"];
                    [cityArray addObject:childModel];
                }
                cityModel.citys=cityArray;
                if (cityModel.citys.count>0) {
                    [cityListArray addObject:cityModel];
                }
                
            }
            self.cityModel.list=cityListArray;
//            self.sectionArray=[[NSMutableArray alloc]init];
            [self.sectionArray removeAllObjects];
            [self.sectionArray addObject:@"热门"];
            for (SLCityList *cityList in self.cityModel.list) {
                [self.sectionArray addObject:cityList.initial];
            }
            
            [self.tableView reloadData];
            [self sectionAnimationView];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
}

/****************************获取热门城市和城市**************************************/

/****************************选择区域后代理**************************************/
-(void)sl_currentCity:(NSString *)city supplier_id:(NSInteger)supplier_id{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
        [self.delegate sl_cityListSelectedCity:city Id:supplier_id];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
/****************************选择区域后代理**************************************/

@end
