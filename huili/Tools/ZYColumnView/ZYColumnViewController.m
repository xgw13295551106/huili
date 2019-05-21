//
//  ZYColumnViewController.m
//  西藏自治区
//
//  Created by TRS on 16/5/27.
//  Copyright © 2016年 成都拓尔思. All rights reserved.
//

#import "ZYColumnViewController.h"
#import "ZYSparesButton.h"
#import "UIView+Extentions.h"
#import "ZYDefinition.h"

@interface ZYColumnViewController ()

/** 控制展开或者收起的spreadBtn */
@property (nonatomic, weak  ) UIButton                  *spreadBtn;
/** 导航栏透明遮盖 */
//@property (nonatomic, strong) UIButton                  *navCover;
/** 此数组中存放的是 "正在显示"的分类栏目的 栏目名称 (NSString) */
@property (nonatomic, strong) NSMutableArray            *columnNames;
/** 此数组中存放的是 "备用"的分类栏目的 栏目名称 (NSString) */
@property (nonatomic, strong) NSMutableArray            *spareColumnNames;
/** 存放分类栏目滚动的(UIButton)按钮数组 */
@property (nonatomic, strong) NSMutableArray            *columnButtons;
/** 当前选中分类栏目的标题 */
@property (nonatomic, copy  ) NSString                  *columnSelTitle;
/** 存放需要显示的 ZYSparesButton 按钮的数组 */
@property (nonatomic, strong) NSMutableArray            *sortButtons;
/** sort按钮部分 占据的view的高度 */
@property (nonatomic, assign) CGFloat                   sortH;
/** 存放备选的 ZYSparesButton 按钮的数组 */
@property (nonatomic, strong) NSMutableArray            *listButtons;
/** list按钮部分 占据的view的高度 */
@property (nonatomic, assign) CGFloat                   listH;
/** 标识spread按钮是否是展开的 */
@property (nonatomic, assign) BOOL                      isSpread;
/** 横向滚动的scrollView */
@property (nonatomic, weak  ) UIScrollView              *scrollView;
/** 线条指示器 */
@property (nonatomic, strong) UIView                    *indicator;
/** 当前选中的分类栏目按钮 */
@property (nonatomic, weak  ) UIButton                  *selButton;
/** 遮盖view (切换栏目 删除排序) */
@property (nonatomic, strong) UIView                    *promptViewUp;
/** 遮盖view (点击添加更多栏目) */
@property (nonatomic, strong) UIView                    *promptViewDown;
/** 下拉展开的scrollView */
@property (nonatomic, strong) UIScrollView              *spreadView;
/** 编辑按钮 */
@property (nonatomic, weak  ) UIButton                  *edtingBtn;

// 开始拖动的view的下一个view的CGPoint（如果开始位置是0 结束位置是4 nextPoint值逐个往下算）
@property (nonatomic, assign) CGPoint   valuePoint;
// 用于赋值CGPoint
@property (nonatomic, assign) CGPoint   nextPoint;

@end

@implementation ZYColumnViewController

#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"请使用.h中指定方法初始化");
    }
    return self;
}

/** 初始化方法 */
- (instancetype)initWithColumnNames:(NSArray *)columnNames SpareColumnNames:(NSArray *)spareNames
{
    if (self = [super init]){
        _columnNames      = [NSMutableArray arrayWithArray:columnNames];
        _spareColumnNames = [NSMutableArray arrayWithArray:spareNames];
        _columnButtons    = [NSMutableArray array];
        _hasIndicator     = YES;
        _indicatorColor   = [UIColor redColor];
        _norColor         = [UIColor darkGrayColor];
        _selColor         = [UIColor redColor];
        _isEqualWith      = YES;
        _fixedCount       = 1;
        // 这句要写最后，要不上面初始化属性，有可能被跳过
        self.view.frame = CGRectMake(0, kAppNavHeight, kScreenWidth, kColumn_ViewH);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 展开收起按钮
    [self setupSpreadBtn];
    // 初始化scrollView
    [self setupScrollView];
    // 初始化scrollView里面的columnButton
    [self setupColumnTitleButtons];
    
    self.view.backgroundColor = kSpreadViewColor;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 修正外部push回来后，造成的frame不正确的问题
    if (!self.isSpread) {
        self.view.frame = CGRectMake(0, kAppNavHeight, kScreenWidth, kColumn_ViewH);
    }
}

/** 初始化展开收起按钮 */
- (void)setupSpreadBtn
{
    // 控制展开和收起的按钮(下面添加一个父控件view,添加为了配合按钮旋转)
    UIView   *spreadView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - kColumn_ViewH, 0, kColumn_ViewH, kColumn_ViewH)];
    spreadView.backgroundColor = [UIColor whiteColor];
    UIButton *spreadBtn  = [[UIButton alloc] initWithFrame:spreadView.bounds];
    self.spreadBtn = spreadBtn;
    spreadBtn.backgroundColor = [UIColor clearColor];
    [spreadBtn setImage:[UIImage imageNamed:@"ZYColumnResource.bundle/spreadButton.png"] forState:UIControlStateNormal];
    [spreadBtn addTarget:self action:@selector(spreadButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [spreadView addSubview:spreadBtn];
    [self.view addSubview:spreadView];
}

/** 初始化横向滚动的scrollView容器 */
- (void)setupScrollView
{
    if (self.columnNames.count == 0) {  // 容错处理
        return;
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-kColumn_ViewH, kColumn_ViewH)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
}

/** 添加分类栏目上面的按钮(包含等宽 不等宽) */
- (void)setupColumnTitleButtons
{
    [self.columnButtons removeAllObjects];  // 先移除已经存放的 然后重新创建
    for (UIView *child in self.scrollView.subviews) {
        if ([child isKindOfClass:[UIButton class]]) {
            [child removeFromSuperview];
        }
    }
    CGFloat buttonH = self.hasIndicator ? kColumn_ViewH - kColumn_IndicatorH : kColumn_ViewH;
    CGFloat buttonW = 0;
    // 添加columnTitle按钮
    for (int i = 0; i < self.columnNames.count; i++) {
        NSString *title = self.columnNames[i];
        if (!self.isEqualWith) {
            switch (title.length) {
                case 2: {buttonW = kColumn_TitleLength2;}
                    break;
                case 3: {buttonW = kColumn_TitleLength3;}
                    break;
                case 4: {buttonW = kColumn_TitleLength4;}
                    break;
                case 5: {buttonW = kColumn_TitleLength5up;}
                    break;
                default:
                    break;
            }
        } else {
            buttonW = (kScreenWidth - kColumn_ViewH)/kColumn_LayoutCount;
        }
        CGFloat buttonX = 0;
        if (i != 0) {
            UIButton *lastButton = self.columnButtons[i-1];
            buttonX = lastButton.x + lastButton.width;
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 0, buttonW, buttonH)];
        button.tag = i;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.norColor forState:UIControlStateNormal];
        [button setTitleColor:self.selColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:kColumn_TitleNorFont];
        [self.scrollView addSubview:button];
        [button addTarget:self action:@selector(columnTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 添加按钮到分类栏目数组中
        [self.columnButtons addObject:button];
    }
    if (self.columnSelTitle == nil && self.columnButtons.count > 0) {
        UIButton *firstButton = self.columnButtons[0];
        self.columnSelTitle = firstButton.titleLabel.text;
        self.selButton = firstButton;
        [self changeColumnTitlesStatus:firstButton];
    } else {
        for (UIButton *btn in self.columnButtons) {
            if ([btn.titleLabel.text isEqualToString:self.columnSelTitle]) {
                [self changeColumnTitlesStatus:btn];
                break;
            }
        }
    }
    // 设置分类按钮父控件scrollView的contentSize
    [self caculateContentSizeOfTitles];
}

#pragma mark - 点击事件处理
/** 栏目分类条按钮点击事件 */
- (void)columnTitleButtonClick:(UIButton *)button
{
    // 切换选中状态
    [self changeColumnTitlesStatus:button];
    // 匹配按钮位置
    [self autoSuitItemsPosition];
    // 传递点击按钮位置信息
    if ([self.delegate respondsToSelector:@selector(columnViewColumnTitleButton:DidClickAtIndex:)]) {
        [self.delegate columnViewColumnTitleButton:button DidClickAtIndex:button.tag];
    }
}

/** 展开收回按钮点击事件 */
- (void)spreadButtonDidClick:(UIButton *)button
{
    [self spreadOrHide];
}

/** 透明导航遮盖点击事件 */
- (void)coverDidClick:(UIButton *)cover
{
    [self spreadOrHide];
}

/** 删除排序按钮点击事件 */
- (void)edtingButtonClick:(UIButton *)button
{
    // 控制promptViewDown 和 listButtons的隐藏或者显示
    self.promptViewDown.hidden = !button.selected;
    for (ZYSparesButton *btn in self.listButtons) {
        btn.hidden = !button.selected;
    }
    // sortButtons按钮状态切换
    for (ZYSparesButton *btn in self.sortButtons) {
        btn.selected = !button.selected;
    }
    button.selected = !button.selected;
}

/** sortButtons点击事件 */
- (void)sortButtonClick:(ZYSparesButton *)button
{
    if (button.selected) {      // 需要移除这个button并且添加到listButtons数组中 并且排序
        if (button.tag < self.fixedCount) {     // 固定的按钮不能删除 移动
            return;
        }
        if ([self.columnSelTitle isEqualToString:button.titleLabel.text]) {     // 说明用户把当前选中的分类栏目给移除了
            self.columnSelTitle = nil;
        }
        [self.sortButtons removeObject:button];
        [self.listButtons insertObject:button atIndex:0];
        // 更换监听事件
        [button removeTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden   = YES;
        button.selected = NO;
        // 重新排序 赋值新tag
        [self reLayoutButtons:self.sortButtons];
        // 判断是否需要修正promptViewDown的位置
        ZYSparesButton *lastBtn = [self.sortButtons lastObject];
        if (CGRectGetMaxY(lastBtn.frame)+kSparesMarginH != self.sortH) {
            [self layoutListUpOneRow];
        }
        [self reLayoutButtons:self.listButtons];
    } else {
        self.columnSelTitle = button.titleLabel.text;
        [self spreadOrHide];
    }
}

/** listButtons点击事件 */
- (void)listButtonClick:(ZYSparesButton *)button
{
    // 上移点击的button
    [self layoutSortButtons:button];
    // 重新排布listButtons
    [self.listButtons removeObject:button];
    [self reLayoutButtons:self.listButtons];
}

#pragma makr - 移动排布算法
- (void)longPress:(UIGestureRecognizer *)recognizer
{
    ZYSparesButton *item = (ZYSparesButton *)recognizer.view;
    if (![self.sortButtons containsObject:item] || item.tag < self.fixedCount) {return;}  // 不在sortButtons数组中的都不执行长按手势 固定的按钮不允许移动
    // 隐藏下面的listButtons
    if (!self.edtingBtn.selected) {
        [self edtingButtonClick:self.edtingBtn];
    }
    // 禁用其他按钮的拖拽手势
    for (ZYSparesButton *bt in self.sortButtons) {
        if (bt!=item) {
            bt.userInteractionEnabled = NO;
        }
    }
    [self.spreadView bringSubviewToFront:item];
    // 长按视图在父视图中的位置（触摸点的位置）
    CGPoint recognizerPoint = [recognizer locationInView:self.spreadView];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // 开始的时候改变拖动view的外观（放大，改变颜色等）
        /*
        [UIView animateWithDuration:0.2 animations:^{
            item.transform = CGAffineTransformMakeScale(1.3, 1.3);
            item.alpha = 0.7;
            item.backgroundColor = [UIColor redColor];
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }];
        */
        
        // valuePoint保存最新的移动位置
        _valuePoint = item.center;
        item.backgroundColor = [UIColor redColor];
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [item setTitleColor:ZYRGBColor(128, 128, 128) forState:UIControlStateNormal];
    } else if(recognizer.state == UIGestureRecognizerStateChanged){
        
        // 更新pan.view的center
        item.center = recognizerPoint;
        /**
         * 可以创建一个继承UIButton的类(MyButton)，这样便于扩展，增加一些属性来绑定数据
         * 如果在self.view上加其他控件拖拽会奔溃，可以在下面方法里面加判断MyButton，也可以把所有按钮放到一个全局变量的UIView上来替换self.view
         */
        for (ZYSparesButton * bt in self.sortButtons) {
            // 判断是否移动到另一个view区域
            // CGRectContainsPoint(rect,point) 判断某个点是否被某个frame包含
            if (CGRectContainsPoint(bt.frame, item.center)&&bt!=item && bt.tag >= self.fixedCount)
            {
                // 开始位置
                NSInteger fromIndex = item.tag;
                // 需要移动到的位置
                NSInteger toIndex = bt.tag;
                
                // 往后移动
                if ((toIndex-fromIndex)>0) {
                    // 从开始位置移动到结束位置
                    // 把移动view的下一个view移动到记录的view的位置(valuePoint)，并把下一view的位置记为新的nextPoint，并把view的tag值-1,依次类推
                    [UIView animateWithDuration:kColumn_AnimationDuration animations:^{
                        for (NSInteger i = fromIndex+1; i<=toIndex; i++) {
                            UIButton * nextBt = (UIButton*)[self.view viewWithTag:i];
                            _nextPoint = nextBt.center;
                            nextBt.center = _valuePoint;
                            _valuePoint = _nextPoint;
                            nextBt.tag--;
                        }
                        item.tag = toIndex;
                    }];
                }
                // 往前移动
                else {
                    // 从开始位置移动到结束位置
                    // 把移动view的上一个view移动到记录的view的位置(valuePoint)，并把上一view的位置记为新的nextPoint，并把view的tag值+1,依次类推
                    [UIView animateWithDuration:0.2 animations:^{
                        for (NSInteger i = fromIndex-1; i>=toIndex; i--) {
                            UIButton * nextBt = (UIButton*)[self.view viewWithTag:i];
                            _nextPoint = nextBt.center;
                            nextBt.center = _valuePoint;
                            _valuePoint = _nextPoint;
                            nextBt.tag++;
                        }
                        item.tag = toIndex;
                    }];
                }
            }
        }
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        
        // 恢复其他按钮的拖拽手势
        for (ZYSparesButton * bt in self.sortButtons) {
            if (bt!=item) {
                bt.userInteractionEnabled = YES;
            }
        }
        // 结束时候恢复view的外观（放大，改变颜色等）
        [UIView animateWithDuration:kColumn_AnimationDuration animations:^{
            //            item.transform = CGAffineTransformMakeScale(1.0, 1.0);
            //            item.alpha = 1;
            item.center = _valuePoint;
            [self.spreadView insertSubview:item atIndex:1];     // 不用0 是因为保持promptViewDown 在最下，避免拖动后，item从下到上，又变成从promptViewDown 下钻过的效果
            item.backgroundColor = [UIColor whiteColor];
            [item setTitleColor:ZYRGBColor(128, 128, 128) forState:UIControlStateSelected];
            [item setTitleColor:ZYRGBColor(128, 128, 128) forState:UIControlStateNormal];
        }];
        // 同步数组
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < self.sortButtons.count; i++) {
            for (ZYSparesButton *button in self.sortButtons) {
                if (button.tag == i) {
                    [temp addObject:button];
                    break;
                }
            }
        }
        // 同步数组
        self.sortButtons = temp;
        [self updateColumnNames];
    }
}

/** listButtons上移一个选中button上移到 sortButtons区域 */
- (void)layoutSortButtons:(ZYSparesButton *)button
{
    // 拿到sortButtons的最后一个ZYSparesButton 得到前面的位置
    ZYSparesButton *lastButton = [self.sortButtons lastObject];
    CGFloat centerX = 0;
    CGFloat centerY = 0;
    // 判断是否需要换行 计算出移动的按钮的位置
    if (self.sortButtons.count%kColumn_LayoutCount == 0) {      // 要换行
        [self layoutListDownOneRow];    // 下移一行
        // 移动添加的按钮
        ZYSparesButton *firstButton = self.sortButtons[0];
        centerX = firstButton.centerX;
        centerY = self.sortH - (kSparesMarginH + kSparesBtnH*0.5);
    } else {
        centerX = lastButton.centerX + (kSparesMarginW + lastButton.width);
        centerY = lastButton.centerY;
    }
    [UIView animateWithDuration:kColumn_AnimationDuration animations:^{
        button.centerX = centerX;
        button.centerY = centerY;
    }];
    // 更换监听事件
    [button removeTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // 添加按钮到sortButtons
    button.tag = self.sortButtons.count;
    [self.sortButtons addObject:button];
}

/** 让promptViewDown 和所有listButtons整体下移一行 */
- (void)layoutListDownOneRow
{
    [UIView animateWithDuration:kColumn_AnimationDuration * 0.5 animations:^{
        self.promptViewDown.y += kSparesBtnH + kSparesMarginH;
        for (ZYSparesButton *button in self.listButtons) {
            button.y += kSparesBtnH + kSparesMarginH;
        }
    }];
    // 刷新sortButtons占据的总高度
    self.sortH = self.promptViewDown.y;
}

/** 让promptViewDown 和所有的listButton 整体上移一行 */
- (void)layoutListUpOneRow
{
    [UIView animateWithDuration:kColumn_AnimationDuration * 0.5 animations:^{
        self.promptViewDown.y -= (kSparesBtnH + kSparesMarginH);
        for (ZYSparesButton *button in self.listButtons) {
            button.y += kSparesBtnH + kSparesMarginH;
        }
    }];
    self.sortH = self.promptViewDown.y;
}

/** 重新排列listButtons 或者 sortButtons 赋值最新的tag值 */
- (void)reLayoutButtons:(NSMutableArray *)array
{
    CGFloat buttonW = (kScreenWidth-(kColumn_LayoutCount+1)*kSparesMarginW)/kColumn_LayoutCount;
    CGFloat extraH = ([array isEqualToArray:self.listButtons]) ? CGRectGetMaxY(self.promptViewDown.frame):0;
    for (int i = 0; i<array.count; i++) {
        ZYSparesButton *button = array[i];
        button.tag = i;
        // 计算第i个位置的center点
        NSInteger row = i/kColumn_LayoutCount;
        NSInteger col = i%kColumn_LayoutCount;
        CGFloat centerX = col*(kSparesMarginW + buttonW)+kSparesMarginW + 0.5*buttonW;
        CGFloat centerY = row*(kSparesMarginH + kSparesBtnH) + kSparesMarginH+ 0.5*kSparesBtnH + extraH;
        [UIView animateWithDuration:kColumn_AnimationDuration animations:^{
            button.centerX = centerX;
            button.centerY = centerY;
        }];
    }
}

#pragma mark - 公共方法
/** 设置分类栏目按钮选中之间的切换 */
- (void)changeColumnTitlesStatus:(UIButton *)selButton
{
    if (self.hasIndicator) {
        [UIView animateWithDuration:kColumn_AnimationDuration * 0.5 animations:^{
            self.indicator.x     = selButton.x;
            self.indicator.width = selButton.width;
        }];
    }
    if (self.selButton == nil) {    // 第一次进来的时候，selButton可能为空
        self.selButton = selButton;
        self.selButton.titleLabel.font = [UIFont systemFontOfSize:kColumn_TitleSelFont];
        self.selButton.selected = YES;
        return;
    }
    [self.selButton setTitleColor:self.norColor forState:UIControlStateNormal];
    self.selButton.titleLabel.font = [UIFont systemFontOfSize:kColumn_TitleNorFont];
    self.selButton.selected = NO;
    selButton.titleLabel.font = [UIFont systemFontOfSize:kColumn_TitleSelFont];
    selButton.selected = YES;
    self.selButton = selButton;
    // 赋值最新选中的分类栏目名称
    self.columnSelTitle = self.selButton.titleLabel.text;
}

/** 计算分类栏目按钮父控件scrollView的contentSize */
- (void)caculateContentSizeOfTitles
{
    if (self.isEqualWith) {
        self.scrollView.contentSize = CGSizeMake(self.columnNames.count * (kScreenWidth - kColumn_ViewH)/kColumn_LayoutCount, 0);
    } else {
        CGFloat contentSize = 0;
        for (int i = 0; i < self.columnButtons.count; i++) {
            UIButton *button = self.columnButtons[i];
            contentSize += button.width;
        }
        self.scrollView.contentSize = CGSizeMake(contentSize, 0);
    }
}

/** 自动匹配分类栏目按钮的contentOffset */
- (void)autoSuitItemsPosition
{
    [UIView animateWithDuration:0.3 animations:^{
        if(_scrollView.contentSize.width > _scrollView.frame.size.width) {
            CGFloat desiredX = self.selButton.center.x - (_scrollView.bounds.size.width/2);
            if(desiredX < 0.0) desiredX = 0.0;
            if (desiredX > (_scrollView.contentSize.width - _scrollView.bounds.size.width)) {
                desiredX = (_scrollView.contentSize.width - _scrollView.bounds.size.width);
            }
            if (!(_scrollView.bounds.size.width > _scrollView.contentSize.width)) {
                [_scrollView setContentOffset:CGPointMake(desiredX, 0) animated:YES];
            }
        }
    }];
}

/** 收起或者展开spreadView */
- (void)spreadOrHide
{
    if (!self.isSpread) {
        // 展开
        [UIView animateWithDuration:kColumn_AnimationDuration animations:^{
            self.promptViewUp.alpha = 1.0;
            self.view.height        = kColumn_SpreadH;
            self.spreadView.y       = kColumn_ViewH;
        }];
    } else {
        // 收起
        [UIView animateWithDuration:kColumn_AnimationDuration animations:^{
            self.view.height        = kColumn_ViewH;
            self.spreadView.y       = -kColumn_SpreadH;
        }completion:^(BOOL finished) {
            self.promptViewUp.alpha = 0.0;
        }];
        // 编辑排序按钮状态复位
        if (self.edtingBtn.selected) {
            [self edtingButtonClick:self.edtingBtn];
        }
        // 更改分类栏目的顺序 增删分类栏目按钮
        [self updateColumnNames];
        [self setupColumnTitleButtons];
        [self autoSuitItemsPosition];
        // 传递数据
        if ([self.delegate respondsToSelector:@selector(columnViewDidSelected:AtIndex:)]) {
            [self.delegate columnViewDidSelected:self AtIndex:self.selButton.tag];
        }
        if ([self.delegate respondsToSelector:@selector(columnViewDidChanged:SpareColumnNamesArray:)]) {
            [self.delegate columnViewDidChanged:self.columnNames SpareColumnNamesArray:self.spareColumnNames];
        }
    }
    // 旋转图标
    [self animationRotate:self.spreadBtn ToAngle:self.isSpread ? 180 : -180];
//    self.navCover.hidden = self.isSpread;
    self.isSpread        = !self.isSpread;
}

/** 更新同步 coumnNames 和 spareColumnNames */
- (void)updateColumnNames
{
    [self.columnNames removeAllObjects];
    [self.spareColumnNames removeAllObjects];
    for (ZYSparesButton *btn in self.sortButtons) {
        [self.columnNames addObject:btn.titleLabel.text];
    }
    for (ZYSparesButton *btn in self.listButtons) {
        [self.spareColumnNames addObject:btn.titleLabel.text];
    }
}

/** 设置当前选中第几个 */
- (void)setCurrentSelectedTitle:(NSInteger)index
{
    UIButton *selButton = self.columnButtons[index];
    self.columnSelTitle = selButton.titleLabel.text;
    [self changeColumnTitlesStatus:selButton];
    [self autoSuitItemsPosition];
}

#pragma mark spread旋转
/** 顺时针旋转一个view angle 代表需要传入的角度 需要逆时针，请传入负数 */
- (void)animationRotate:(UIView *)view ToAngle:(CGFloat)angle
{
    [UIView animateWithDuration:0.5 animations:^{
        view.transform = CGAffineTransformRotate(view.transform, angle/180.0*M_PI);
    }];
}

#pragma mark - 懒加载
/** 横向滚动的选中指示条 */
- (UIView *)indicator
{
    if (_indicator == nil) {
        // 注意: 默认宽度是按照等宽来计算的
        _indicator = [[UIView alloc] initWithFrame:CGRectMake(0, kColumn_ViewH - kColumn_IndicatorH, (kScreenWidth-kColumn_ViewH)/kColumn_LayoutCount, kColumn_IndicatorH)];
        _indicator.backgroundColor = self.indicatorColor;
        _indicator.hidden = !self.hasIndicator;
        [self.scrollView addSubview:_indicator];
    }
    return _indicator;
}

/** 用于遮盖住横向滚动的分类栏目按钮的遮盖view */
- (UIView *)promptViewUp
{
    if (_promptViewUp == nil) {
        _promptViewUp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - kColumn_ViewH, kColumn_ViewH)];
        _promptViewUp.alpha = 0.0;     // 默认隐藏
        _promptViewUp.backgroundColor = kSparesPromptColor;
        UIButton *subscrib = [[UIButton alloc] initWithFrame:CGRectMake(kSparesMarginW, 0, (kScreenWidth-kColumn_LayoutCount*(kSparesMarginW+1))/kColumn_LayoutCount, kColumn_ViewH)];
        [subscrib setTitle:@"选择频道" forState:UIControlStateNormal];
        [subscrib setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        subscrib.userInteractionEnabled = NO;
        [_promptViewUp addSubview:subscrib];
        // 后期增加的提示文字
//        UIButton *promptBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subscrib.frame)/*+kSparesMarginW*/, 0, 120, kColumn_ViewH)];
//        [promptBtn setTitle:@"长按编辑,拖拽排序" forState:UIControlStateNormal];
//        promptBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        [promptBtn setTitleColor:ZYRGBColor(152, 152, 152) forState:UIControlStateNormal];
//        promptBtn.userInteractionEnabled = YES;
//        [_promptViewUp addSubview:promptBtn];
        
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_promptViewUp.width- 55 -kSparesMarginW, 8, 55, kColumn_ViewH-16)];
//        self.edtingBtn = button;
//        [_promptViewUp addSubview:button];
//        [button setTitle:@"编辑" forState:UIControlStateNormal];
//        [button setTitle:@"完成" forState:UIControlStateSelected];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [button setCornerWithRadius:2.0f];
//        [button setBorderWithColor:[UIColor redColor] borderWidth:1.0f];
//        [button addTarget:self action:@selector(edtingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//
//        button.titleLabel.font = subscrib.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.view insertSubview:_promptViewUp aboveSubview:_scrollView];
    }
    return _promptViewUp;
}

/** 下拉后的scrollView容器 */
- (UIScrollView *)spreadView
{
    if (_spreadView == nil) {
        _spreadView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -kColumn_SpreadH, kScreenWidth, kColumn_SpreadH - kColumn_ViewH)];
        _spreadView.backgroundColor = self.view.backgroundColor;
        [self.view insertSubview:_spreadView atIndex:0];
        // 布局sortButton按钮
        [self sortButtons];
        // 布局"点击添加更多"view
        [self promptViewDown];
        // 布局listButton按钮
        [self listButtons];
    }
    return _spreadView;
}

/** 展开后,用户已经选中的button */
- (NSMutableArray *)sortButtons
{
    if (_sortButtons == nil) {
        _sortButtons = [NSMutableArray array];
        // 按钮的固定的尺寸
        CGFloat buttonW = (kScreenWidth-kColumn_LayoutCount*(kSparesMarginW+1))/kColumn_LayoutCount;
        CGFloat buttonH = kSparesBtnH;
        // 九宫格布局sort按钮
        for (int i = 0; i < self.columnNames.count; i++) {
            NSInteger col     = i % kColumn_LayoutCount;
            NSInteger row     = i / kColumn_LayoutCount;
            CGFloat   buttonX = col*(buttonW + kSparesMarginW) + kSparesMarginW;
            CGFloat   buttonY = row*(buttonH + kSparesMarginH) + kSparesMarginH;
            ZYSparesButton *button = [[ZYSparesButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
            // 手势绑定
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [button addGestureRecognizer:longPress];
            button.tag = i;
            __weak typeof(self)weakSelf = self;
            __weak typeof(button)weakButton = button;
            button.delCallback = ^(UIButton *delButton){    // 点击了删除图标的回调
                [weakSelf sortButtonClick:weakButton];
            };
            button.buttonW = buttonW;   // 保存按钮宽度，以后扩展使用
            if (i < self.fixedCount) {
                button.isFixed = YES;
            }
            [button setTitle:self.columnNames[i] forState:UIControlStateNormal];
            // 计算出sort按钮部分的高度
            self.sortH = (row+1)*(buttonH + kSparesMarginH) + kSparesMarginH;
            [self.spreadView addSubview:button];
            // 装进数组
            [_sortButtons addObject:button];
            [button addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _sortButtons;
}

/** 下面备选用于被添加的sparesButton */
- (NSMutableArray *)listButtons
{
    if (_listButtons == nil) {
        _listButtons = [NSMutableArray array];
        // 按钮的固定的尺寸
        CGFloat buttonW = (kScreenWidth-kColumn_LayoutCount*(kSparesMarginW+1))/kColumn_LayoutCount;
        CGFloat buttonH = kSparesBtnH;
        // 九宫格布局sort按钮
        for (int i = 0; i < self.spareColumnNames.count; i++) {
            NSInteger col     = i % kColumn_LayoutCount;
            NSInteger row     = i / kColumn_LayoutCount;
            CGFloat   buttonX = col*(buttonW + kSparesMarginW) + kSparesMarginW;
            CGFloat   buttonY = row*(buttonH + kSparesMarginH) + kSparesMarginH + CGRectGetMaxY(self.promptViewDown.frame);
            ZYSparesButton *button = [[ZYSparesButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
            button.tag = i;
            // 手势绑定
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [button addGestureRecognizer:longPress];
            button.buttonW = buttonW;   // 保存按钮宽度，以后扩展使用
            __weak typeof(self)weakSelf = self;
            __weak typeof(button)weakButton = button;
            button.delCallback = ^(UIButton *delButton){    // 点击了删除图标的回调
                [weakSelf sortButtonClick:weakButton];
            };
            [button setTitle:self.spareColumnNames[i] forState:UIControlStateNormal];
            // 计算出list按钮部分的高度
            self.listH = (row+1)*(buttonH + kSparesMarginH) + kSparesMarginH;
            [self.spreadView addSubview:button];
            // 装进数组
            [_listButtons addObject:button];
            [button addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        // 设置spreadView的contentSize
        self.spreadView.contentSize = CGSizeMake(0, self.sortH+self.promptViewDown.height+self.listH);
    }
    return _listButtons;
}

/** 点击添加更多的那个view */
- (UIView *)promptViewDown
{
    if (_promptViewDown == nil) {
        _promptViewDown = [[UIView alloc] initWithFrame:CGRectMake(0, self.sortH, kScreenWidth, kSparesPromptH)];
        _promptViewDown.backgroundColor = kSparesPromptColor;
//        UIButton *promptBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSparesMarginW, 0, (kScreenWidth-kColumn_LayoutCount*(kSparesMarginW+1))/kColumn_LayoutCount, kColumn_ViewH)];
//        [promptBtn setTitle:@"其他频道" forState:UIControlStateNormal];
//        [promptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        promptBtn.userInteractionEnabled = NO;
//        promptBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_promptViewDown addSubview:promptBtn];
//        [_spreadView addSubview:_promptViewDown];
        [_spreadView insertSubview:_promptViewDown atIndex:0];
         _promptViewDown.backgroundColor = [UIColor clearColor];
    }
    return _promptViewDown;
}

//- (UIButton *)navCover
//{
//
//    if (_navCover == nil) {
//        _navCover = [[UIButton alloc] init];
//        _navCover.backgroundColor = [UIColor clearColor];
//        _navCover.frame = CGRectMake(0, 0, kScreenWidth, kAppNavHeight);
//        [[UIApplication sharedApplication].keyWindow addSubview:_navCover];
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        NSLog(@"to see %@", window);
//        [_navCover addTarget:self action:@selector(coverDidClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _navCover;
//}


#pragma mark - dealloc
- (void)dealloc
{
    // cover是加到window上的，控制器销毁需要移除，避免内存泄露
//    if (self.navCover) {
//        [self.navCover removeFromSuperview];
//    }
}

@end
