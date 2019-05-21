
//
//  SelcetMapViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "SelcetMapViewController.h"
#import "BaseNavViewController.h"
#import "MapAddressTableViewCell.h"

@interface SelcetMapViewController ()<MAMapViewDelegate,PYSearchViewControllerDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;
@property(nonatomic,strong)AMapSearchAPI *search;

//@property(nonatomic,strong)AMapLocationManager *locationManager;

@property(nonatomic,weak)PYSearchViewController *searchViewController;

//@property(nonatomic)NSString *currentCity;

@property(nonatomic)NSMutableArray *searchArray;

@property(nonatomic)MAMapView *mapView;

@end

@implementation SelcetMapViewController

-(NSMutableArray*)searchArray{
    if (_searchArray==nil) {
        _searchArray=[[NSMutableArray alloc]init];
    }
    return _searchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(10, 7, AL_DEVICE_WIDTH-20, 30)];
    [searchBar setPlaceholder:@"查找小区／大厦／学校等"];
    searchBar.backgroundImage = [NSBundle py_imageNamed:@"clearImage"];
    [self.navigationItem setTitleView:searchBar];
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, searchBar.height)];
//    [searchBtn setEnabled:NO];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [searchBar addSubview:searchBtn];
    
    [self creatMap];
    
    [self creatAddressList];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    
//    self.locationManager=[[AMapLocationManager alloc]init];
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//    //   定位超时时间，最低2s，此处设置为2s
//    self.locationManager.locationTimeout =2;
//    //   逆地理请求超时时间，最低2s，此处设置为2s
//    self.locationManager.reGeocodeTimeout = 2;
//
//    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
//    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//
//            if (error.code == AMapLocationErrorLocateFailed)
//            {
//                return;
//            }
//        }
//
//        NSLog(@"location:%@", location);
//
//        if (regeocode)
//        {
//            NSLog(@"reGeocode:%@", regeocode);
//            self.currentCity=regeocode.city;
//        }
//    }];
    
    // Do any additional setup after loading the view.
}
/*****************************创建地图*************************************/
-(void)creatMap{
    [AMapServices sharedServices].enableHTTPS = YES;
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-300+64)];
    [_mapView setZoomLevel:15];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setDelegate:self];
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    
    
    UIImageView *centerPoint=[[UIImageView alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH-30)/2, (_mapView.height-30)/2-40, 30, 30)];
    [centerPoint setImage:[UIImage imageNamed:@"user_address_icon_orientation"]];
    [_mapView addSubview:centerPoint];
    [centerPoint setContentMode:UIViewContentModeCenter];
    
}
/*****************************创建地图*************************************/
/*****************************创建地址列表*************************************/
-(void)creatAddressList{
    UIView *bottom=[[UIView alloc]initWithFrame:CGRectMake(0, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-300, AL_DEVICE_WIDTH, 300)];
    [bottom setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottom];
    
    [bottom addSubview:self.myTableView];
}
/*****************************创建地址列表*************************************/
/*****************************地图移动结束后调用此接口*************************************/
/**
 * @brief 地图移动结束后调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    NSLog(@"mapFinishLoading");
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        //解析response获取地址描述，具体解析见 Demo
    }
    [self.dataArray removeAllObjects];
//    AmapAddressModel *model=[AmapAddressModel new];
//    model.city=response.regeocode.addressComponent.city;
//    model.province=response.regeocode.addressComponent.province;
////     model.name=response.regeocode.addressComponent.;
//    model.formattedAddress=response.regeocode.formattedAddress;
//    model.lat=[NSString stringWithFormat:@"%f",_mapView.centerCoordinate.latitude];
//    model.lng=[NSString stringWithFormat:@"%f",_mapView.centerCoordinate.longitude];
//    [self.dataArray addObject:model];
    for (int i=0; i<response.regeocode.pois.count; i++) {
        AMapPOI *poi=[response.regeocode.pois objectAtIndex:i];
        AmapAddressModel *model=[AmapAddressModel new];
        model.city=response.regeocode.addressComponent.city;
        model.province=response.regeocode.addressComponent.province;
        model.district=response.regeocode.addressComponent.district;
        model.name=poi.name;
        model.formattedAddress=poi.address;
        model.lat=[NSString stringWithFormat:@"%f",poi.location.latitude];
        model.lng=[NSString stringWithFormat:@"%f",poi.location.longitude];
        [self.dataArray addObject:model];
    }
    [self.myTableView reloadData];
}

/*****************************地图移动结束后调用此接口*************************************/



/*****************************地图加载成功*************************************/
/**
 * @brief 地图加载成功
 * @param mapView 地图View
 */
/*****************************地图加载成功*************************************/

/*****************************点击搜索按钮*************************************/
-(void)searchClick{
    YHWeakSelf
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"查找小区／大厦／学校等" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        
        for (int i=0; i<self.searchArray.count; i++) {
            AMapPOI *poi=[self.searchArray objectAtIndex:i];
            if ([poi.name isEqualToString:searchText]) {
                NSLog(@"%@",poi.name);
                [searchViewController dismissViewControllerAnimated:NO completion:nil];
                NSDictionary *dic=[[NSMutableDictionary alloc]init];
                [dic setValue:poi.name forKey:@"name"];
                [dic setValue:poi.address forKey:@"address"];
                [dic setValue:[NSString stringWithFormat:@"%@%@%@",poi.province,poi.city,poi.district] forKey:@"area"];
                [dic setValue:[NSString stringWithFormat:@"%f",poi.location.latitude] forKey:@"lat"];
                [dic setValue:[NSString stringWithFormat:@"%f",poi.location.longitude] forKey:@"lng"];
                [dic setValue:poi.province forKey:@"province"];
                [dic setValue:poi.city forKey:@"city"];
                [dic setValue:poi.district forKey:@"district"];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_SelectArressSuccess object:nil userInfo:dic];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
        
    }];
    [searchViewController setHotSearchStyle:PYHotSearchStyleColorfulTag];
    [searchViewController.searchBar setTintColor:STYLECOLOR];
    [searchViewController setShowSearchHistory:NO];
    _searchViewController=searchViewController;
    // 5. Present a navigation controller
    [searchViewController setDelegate:self];
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

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
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        
        request.keywords            = searchText;
        request.city                = @"";
        
        /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
        request.cityLimit           = NO;
        request.requireSubPOIs      = YES;
        
        [self.search AMapPOIKeywordsSearch:request];
    }
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    NSMutableArray *searchSuggestionsM = [NSMutableArray array];
    [self.searchArray removeAllObjects];
    for (int i = 0; i < response.pois.count; i++) {
        AMapPOI *poi=[response.pois objectAtIndex:i];
        NSLog(@"%@",poi);
        NSString *searchSuggestion = poi.name;
        [self.searchArray addObject:poi];
        [searchSuggestionsM addObject:searchSuggestion];
    }
    // Refresh and display the search suggustions
    _searchViewController.searchSuggestions = searchSuggestionsM;
    
    //解析response获取POI信息，具体解析见 Demo
}

/*****************************点击搜索按钮*************************************/

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 300) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView=[UIView new];
        _myTableView.tableHeaderView=[UIView new];
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[MapAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.model = self.dataArray[indexPath.row];
    if (indexPath.row==0) {
        [cell setCurrent];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AmapAddressModel *model=[self.dataArray objectAtIndex:indexPath.row];
    NSDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:model.name forKey:@"name"];
    [dic setValue:model.formattedAddress forKey:@"address"];
    [dic setValue:[NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.district] forKey:@"area"];
    [dic setValue:model.province forKey:@"province"];
    [dic setValue:model.city forKey:@"city"];
    [dic setValue:model.district forKey:@"district"];
    [dic setValue:model.lat forKey:@"lat"];
    [dic setValue:model.lng forKey:@"lng"];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_SelectArressSuccess object:nil userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
    
}
/******************************UITableView代理结束**************************************/

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
