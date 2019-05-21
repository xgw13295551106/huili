//
//  GoodsTableViewCell.h
//  YeFu
//
//  Created by Carl on 2017/12/4.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol GoodsTableViewCellDelegate <NSObject>

-(void)checkPrice;

-(void)delectCell:(GoodsModel*)model;

-(void)addGoods;;

@end

@interface GoodsTableViewCell : UITableViewCell

@property(nonatomic)GoodsModel *model;

@property(nonatomic)NSString *is_new;//限购 1是 0否

@property(nonatomic)NSString *is_special;//特价 1是 0否

@property(nonatomic,assign)BOOL is_collect; ///< 是否是收藏的

@property (nonatomic,weak) id<GoodsTableViewCellDelegate>delegate;

@end
