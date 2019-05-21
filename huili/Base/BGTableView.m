//
//  BGTableView.m
//  shop_send
//
//  Created by zhongweike on 2017/12/19.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "BGTableView.h"

@interface BGTableView ()


@end

@implementation BGTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.tableFooterView = [UIView new];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    return self;
}

@end
