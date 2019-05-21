//
//  ZYDefinition.h
//  西藏自治区
//
//  Created by TRS on 16/5/27.
//  Copyright © 2016年 成都拓尔思. All rights reserved.
//

#ifndef ZYDefinition_h
#define ZYDefinition_h

// 1.默认认为app的导航条高度为64
#define kAppNavHeight             0            // 默认认为app的导航条高度为64
// 2.获得RGB颜色
#define ZYRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// RGBA
#define ZYRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define ZYRandomColor ZYRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 3.常用尺寸
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

#define inch35          ([UIScreen mainScreen].bounds.size.height == 460.0)
#define inch40          ([UIScreen mainScreen].bounds.size.height == 568.0)
#define inch47          ([UIScreen mainScreen].bounds.size.height == 667.0)
#define inch55          ([UIScreen mainScreen].bounds.size.height == 736.0)

/***************************** 可修改参数 满足你的DIY ***********************************/
// 1.分类栏目的高度
#define kColumn_ViewH                   40
// 2.横条指示器的高度
#define kColumn_IndicatorH              2
// 3.分类栏目按钮在等宽状态下，默认布局按钮的个数
#define kColumn_LayoutCount             4
// 4.分类栏目按钮普通状态下字体 选中状态下字体
#define kColumn_TitleNorFont            ((inch47 || inch55) ? 15 : 12)
#define kColumn_TitleSelFont            ((inch47 || inch55) ? 17 : 15)
// 5.分类栏目按钮 在不等宽条件下title 2 3 4 个字 或者更多字数下分别按钮长度
#define kColumn_TitleLength2            50      // 2个字
#define kColumn_TitleLength3            60      // 3个字
#define kColumn_TitleLength4            70      // 4个字
#define kColumn_TitleLength5up          80      // 5个或者以上
// 6.所有的动画执行时间
#define kColumn_AnimationDuration       0.5
// 7.展开的高度 默认拉到屏幕底部 并且认为columnView贴着导航条下面
#define kColumn_SpreadH                 (kScreenHeight - kAppNavHeight)
// 8.备选排序的ZYSparesButton的高度 字体 字体颜色
#define kSparesBtnH                     40
#define kSparesBtnFont                  14
#define kSparesBtnColorNor              ZYRGBColor((128), (128), (128))
#define kSparesBtnColorSel              ZYRGBColor((128), (128), (128))
#define kSparesBtnColorHig              ZYRGBColor((255), (255), (255))
// 9.展开界面，备选排序的ZYSparesButton的间距
#define kSparesMarginW                  8
#define kSparesMarginH                  12
// 10.promptViewDown的高度 和 颜色
#define kSparesPromptH                  40
#define kSparesPromptColor              ZYRGBColor((255), (255), (255))
// 11.下拉scrollView的背景颜色
#define kSpreadViewColor                ZYRGBColor((238), (238), (238))
/***************************** 可修改参数 满足你的DIY ***********************************/
#endif /* ZYDefinition_h */
