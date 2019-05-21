//
//  PayButtonView.h
//  ConvenienceStore
//
//  Created by Carl on 2017/10/17.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayButtonView : UIButton

@property(nonatomic)int way;//1支付宝2微信5余额

@property(nonatomic,weak)UIImageView *selectImg;

@end
