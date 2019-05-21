//
//  LCTextCardView.h
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/29.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TopPosition = 10, ///< 顶部位置
    CenterPosition,   ///< 中间位置
    BottomPosition,   ///< 底部位置
    
}TitlePosition;

@interface LCTextCardView : UIView

/**是否显示顶部线 默认为NO*/
@property (nonatomic,assign)BOOL showTopLine;

/**是否显示底部线 默认为NO*/
@property (nonatomic,assign) BOOL showBottomLine;
/**是否显示右侧箭头 默认为NO */
@property (nonatomic,assign) BOOL showRightImage;

/** 标题 */
@property (nonatomic,copy)NSString *titleString;


/**
 获取一个LCTextCardView

 @param frame frame
 @param text 左侧标题的text
 @param titlePosition  若position传nil，则默认为中间布局
 @return 返回LCTextCardView
 */
+ (instancetype)getViewWith:(CGRect)frame
                    andText:(NSString *)text
                andPosition:(TitlePosition)titlePosition;



@end
