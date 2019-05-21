//
//  HomeSelectType.h
//  YeFu
//
//  Created by Carl on 2017/12/13.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeSelectTypeDelegate <NSObject>

-(void)selectType1:(int)tag;

@end

@interface HomeSelectType : UIView

@property(nonatomic)int selectType;

@property (nonatomic,weak) id<HomeSelectTypeDelegate>delegate;

@end
