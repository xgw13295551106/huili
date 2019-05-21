//
//  LCLocationTool.h
//  ios_app
//
//  Created by 刘翀 on 16/8/18.
//  Copyright © 2016年 xinhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//定位
@interface LCLocationTool : NSObject<CLLocationManagerDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;

/** 省份 */
@property (nonatomic,copy) NSString *province;

/** 城市 */
@property (nonatomic,copy) NSString *city;

@property (nonatomic, strong) CLGeocoder *geocoder;


@property (nonatomic,strong)CLLocation *location;

/**
 *  经度
 */
@property(nonatomic,strong)NSString *longitude;
/**
 *  纬度
 */
@property (nonatomic,copy)NSString *latitude;
/**
 *  判断目标位置与当前用户位置的距离
 *
 *  @param latitude  目标地址纬度
 *  @param longitude 目标地址经度
 *
 *  @return 返回距离长度
 */
+(NSString *)testDistanceUserForLatitude:(NSString *)latitude Longitude:(NSString *)longitude;
/**
 *  获取用户当前位置信息
 *
 *  @return 返回一个单例
 */
+ (instancetype)sharedLocation;
/**
 *  判断用户是否开启定位
 *
 *  @return 返回yes or no
 */
+(BOOL)judgeLocation;

@end
