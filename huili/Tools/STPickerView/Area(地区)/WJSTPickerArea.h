//
//  STPickerArea.h
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class WJSTPickerArea;
@protocol  WJSTPickerAreaDelegate<NSObject>

- (void)pickerArea:(WJSTPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area;

@end
@interface WJSTPickerArea : STPickerView


/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <WJSTPickerAreaDelegate>delegate ;
@end
NS_ASSUME_NONNULL_END
