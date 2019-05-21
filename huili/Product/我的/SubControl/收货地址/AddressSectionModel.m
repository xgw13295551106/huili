//
//  AddressSectionModel.m
//  YeFu
//
//  Created by Carl on 2017/12/16.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AddressSectionModel.h"

@implementation AddressSectionModel

-(NSMutableArray*)addressArray{
    if (_addressArray==nil) {
        _addressArray=[[NSMutableArray alloc]init];
    }
    return _addressArray;
}

@end
