//
//  LCLocationTool.m
//  ios_app
//
//  Created by 刘翀 on 16/8/18.
//  Copyright © 2016年 xinhuo. All rights reserved.
//

#import "LCLocationTool.h"
LCLocationTool *locationTool = nil;
@implementation LCLocationTool

+ (instancetype)sharedLocation{
    if (!locationTool) {
        locationTool = [[LCLocationTool alloc]init];
    }
    return locationTool;
}

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (instancetype)init{
    if (self = [super init]) {
        //1.创建定位管理器
        self.locationManager = [[CLLocationManager alloc]init];
        //2.设置代理 用于返回位置信息
        self.locationManager.delegate = self;
        //3.请求授权(ios8以后)
        /*
         获取设备系统
         [[[UIDevice currentDevice]systemVersion]doubleValue];
         */
        if ([[[UIDevice currentDevice]systemVersion]doubleValue]>8.0) {
            [self.locationManager requestAlwaysAuthorization];//一直请求
            //[self.locationManager requestWhenInUseAuthorization];//在前台时请求
        }
        //一下两个属性 会影响设备的耗能
        //定位频率，多少米定位一次
        self.locationManager.distanceFilter = 80;
        //定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //开始更新位置
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

/**
 测试两个CLLocation之间的距离
 */
+(NSString *)testDistanceUserForLatitude:(NSString *)latitude Longitude:(NSString *)longitude{
    if(![LCLocationTool judgeLocation]){
        return @"请前往设置开启定位";
    }
    LCLocationTool *localTool = [LCLocationTool sharedLocation];
    //本地位置
    CLLocation *location1 = [[CLLocation alloc]initWithLatitude:[localTool.latitude doubleValue] longitude:[localTool.longitude doubleValue]];
    //目标位置
    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    //117.238596,31.827714
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    //NSLog(@"%f",distance);
    NSString *distanceStr = [NSString stringWithFormat:@"%.2fkm",distance/1000];
    return distanceStr;
}

+ (BOOL)judgeLocation{
    LCLocationTool *locationTool = [LCLocationTool sharedLocation];
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
            //定位功能可用，开始定位
            [locationTool.locationManager startUpdatingLocation];
            return YES;
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        return NO;
    }else{
        return NO;
    }
}

//定位到用户的位置时调用 可能会调用多次
/**
 locations:存放的是用户的位置信息
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"find you");
    //获取用户最后的位置
    CLLocation *location = [locations lastObject];//位置信息
    CLLocationCoordinate2D coordinate = location.coordinate;//经纬度
    locationTool.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    locationTool.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    locationTool.location = location;
    //打印出经纬度
    NSLog(@"定位:lon:%f,lat:%f",coordinate.longitude,coordinate.latitude);

    //有时候用户位置找到后就不需要更新了
    //[self.locationManager stopUpdatingLocation];//停止更新
}



- (void)geoCoderWithAddress:(NSString *)address{
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // CLPlacemark : 地标
        // location : 位置对象
        // addressDictionary : 地址字典
        // name : 地址详情
        // locality : 城市
        
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            CLLocation *location = pl.location;
        }else
        {
            NSLog(@"错误");
        }
    }];
}



- (void)geoReverseCoderWithLocation:(CLLocation *)location{
    // 反地理编码(经纬度---地址)
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            NSString *string = pl.locality;
        }else
        {
            NSLog(@"错误");
        }
    }];

}

@end
