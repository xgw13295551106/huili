//
//  AddressSectionModel.h
//  YeFu
//
//  Created by Carl on 2017/12/16.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface AddressSectionModel : BaseModel

@property (nonatomic ) int type;//1为show 2位hidden

@property (nonatomic ) NSMutableArray *addressArray;

@end
