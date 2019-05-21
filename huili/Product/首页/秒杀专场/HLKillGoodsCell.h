//
//  HLKillGoodsCell.h
//  huili
//
//  Created by zhongweike on 2018/1/9.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;

typedef void(^KillGoodsBlock)(GoodsModel *goodsModel);

@interface HLKillGoodsCell : UITableViewCell


+ (instancetype)getKillGoodsCell:(UITableView *)tableView
                        andIndex:(NSIndexPath *)indexPath
                    andIdentifer:(NSString *)identifier
                        andModel:(GoodsModel *)model
                        andBlock:(KillGoodsBlock)killBlock;


+ (CGFloat)getKillGoodsCellHeight;




@end
