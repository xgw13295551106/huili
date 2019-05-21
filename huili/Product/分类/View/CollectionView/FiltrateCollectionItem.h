//
//  FiltrateCollectionItemCollectionViewCell.h
//  huili
//
//  Created by zhongweike on 2018/1/11.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击选中回调block
typedef void(^ClickSelectFiltrate)(BOOL isSelect,NSDictionary *itemDic);

@interface FiltrateCollectionItem : UICollectionViewCell

@property (nonatomic,strong)NSDictionary *itemDic;

@property (nonatomic,strong)ClickSelectFiltrate selectBlock;

@property (nonatomic,strong)UIButton *contentButton;

@property (nonatomic,assign)BOOL isSelect;

@end
