//
//  ZYColumnViewController.h
//  西藏自治区
//
//  Created by TRS on 16/5/27.
//  Copyright © 2016年 成都拓尔思. All rights reserved.
//

/**
 *  注意事项:
 *          1.在此默认导航条的高度为64，ZYDefinition.h 内已经写死
 *          2.使用指定初始化方法，传递需要的参数
 *          3.分类控制器的一些可自定义DIY参数，包括高度 等请参阅ZYDefinition.h 文件说明
 *          4.为了避免在展开过程中，导致遮盖导航条，在添加的时候需要将本控制器的view插入到最底层
 *            [self.view insertSubview:columnVC.view atIndex:0]
 *          5.如果需要修改下拉备选按钮样式，请直接在ZYSparesButton.m文件中修改自定义样式
 */

#import <UIKit/UIKit.h>
@class ZYColumnViewController;

@protocol ZYColumnViewControllerDelegate <NSObject>

@optional
/** 此代理方法回传的数组是最新的分类栏目按钮排序的数组，有可能与初始化传入的数组相同，代理需要判断，相同的时候做出处理 */
- (void)columnViewDidChanged:(NSMutableArray *)columnNames SpareColumnNamesArray:(NSMutableArray *)spareColumnNames;
/** 次代理方法回传被点击的分类栏目按钮，以及该按钮所在的索引位置 */
- (void)columnViewColumnTitleButton:(UIButton *)button DidClickAtIndex:(NSInteger)index;
/** 传递当前分类栏目 选中的最新index */
- (void)columnViewDidSelected:(ZYColumnViewController *)columnViewVC AtIndex:(NSInteger)index;

@end

@interface ZYColumnViewController : UIViewController
/** 初始化方法 (参数1: 需要展示的分类数组(NSString), 参数2: 备选的分类数组(NSSting)) */
- (instancetype)initWithColumnNames:(NSArray *)columnNames SpareColumnNames:(NSArray *)spareNames;
/**
 *  按钮是否是等宽，还是根据文字长度决定宽度(默认YES)
 *  等宽按钮默认排布4个
 *  如果按照文字长度决定按钮宽度，2字 60 3字 70 4字 80
 */
@property (nonatomic, assign) BOOL                 isEqualWith;
/** 是否有下面横条指示器，默认YES */
@property (nonatomic, assign) BOOL                 hasIndicator;
/** 横条指示器的颜色(默认 红色) */
@property (nonatomic, weak  ) UIColor              *indicatorColor;
/** 分类栏目按钮普通状态下的颜色(默认黑色) */
@property (nonatomic, weak  ) UIColor              *norColor;
/** 分类栏目按钮选中状态下的颜色(默认红色) */
@property (nonatomic, weak  ) UIColor              *selColor;
/** 固定分类栏目按钮个数(默认只固定第一个) */
@property (nonatomic, assign) NSUInteger           fixedCount;

@property (nonatomic, weak  ) id<ZYColumnViewControllerDelegate>  delegate;

/** 设置当前选中第几个 */
- (void)setCurrentSelectedTitle:(NSInteger)index;
@end
