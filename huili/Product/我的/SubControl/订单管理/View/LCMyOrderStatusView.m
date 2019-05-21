
//
//  LCMyOrderStatusView.m
//  YeFu
//
//  Created by zhongweike on 2017/12/11.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCMyOrderStatusView.h"

@interface LCMyOrderStatusView ()<UIScrollViewDelegate>{
    CGFloat self_width;
    CGFloat self_height;
}
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)MyOrderStatusBlock statusBlock;
@property (nonatomic,strong)UIView *bottomView; ///< 底部下划线view

@property (nonatomic,strong)NSArray *statusArray;

@end

static int button_base_tag = 222;

@implementation LCMyOrderStatusView

+ (instancetype)getMyOrderStatusView:(CGRect)frame andBlock:(MyOrderStatusBlock)statusBlock{
    LCMyOrderStatusView *view = [[LCMyOrderStatusView alloc]initWithFrame:frame];
    view.statusBlock = statusBlock;
    return view;
}

- (NSArray *)statusArray{
    if (!_statusArray) {
        _statusArray = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成",@"已取消"];
    }
    return _statusArray;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(0, 0);
        //        _scrollView.alwaysBounceHorizontal = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self_width = frame.size.width;
        self_height = frame.size.height;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpControls];
    }
    return self;
}

- (void)setUpControls{
    [self.scrollView setFrame:CGRectMake(0, 0, self_width, self_height)];
    
    CGFloat item_space = 0.0;
    CGFloat button_y = 5;
    CGFloat button_h = self_height - 2*button_y;
    CGFloat button_w = win_width / 5.0;
    CGFloat button_max_x = 0;
    //动态创建button
    for (int i=0; i<self.statusArray.count; i++) {
        CGRect button_frame = CGRectMake(button_max_x, button_y, button_w, button_h);
        UIButton *button = [self getSelectButton:button_frame andTitle:self.statusArray[i] andTag:button_base_tag+i];
        button_max_x = button_max_x+item_space+button_w;
        
        [self.scrollView addSubview:button];
    }
    
    self.scrollView.contentSize = CGSizeMake(button_max_x - item_space, -10);//禁止上下滚动
    self.selectIndex = 0;
    
    //底部下划线
    CGFloat bottomView_x = 2;
    CGFloat bottomView_y = self_height-1;
    CGFloat bottomView_w = button_w - 2*bottomView_x;
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(bottomView_x, bottomView_y, bottomView_w, 1)];
    [_bottomView setBackgroundColor:STYLECOLOR];
    [self.scrollView addSubview:_bottomView];
}


- (UIButton *)getSelectButton:(CGRect)frame andTitle:(NSString *)title andTag:(int)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setFrame:frame];
    button.tag = tag;
    [button addTarget:self action:@selector(clickSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

//点击选择button
- (void)clickSelectButtonAction:(UIButton *)button{
    self.selectIndex = (int)button.tag-button_base_tag;
    [UIView animateWithDuration:0.2 animations:^{
        _bottomView.centerX = button.centerX;
    }];
    
    if (self.statusBlock) {
        self.statusBlock(_selectIndex);
    }
    if (self.selectIndex >= 2 && self.scrollView.contentOffset.x != self.scrollView.contentSize.width - win_width) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - win_width, 0) animated:YES];
    }else if (self.selectIndex <= 1 && self.scrollView.contentOffset.x != 0)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)setSelectIndex:(int)selectIndex{
    _selectIndex = selectIndex<self.statusArray.count?selectIndex:0;
    UIButton *button = [self viewWithTag:button_base_tag+selectIndex];
    if (button) {
        for (int i=0; i<self.statusArray.count; i++) {
            UIButton *itemButton = [self viewWithTag:button_base_tag+i];
            itemButton.selected = NO;
        }
        button.selected  = YES;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _bottomView.centerX = button.centerX;
    }];
    NSLog(@"%.f",_scrollView.contentOffset.x + self_width);
    if (button.minX < _scrollView.contentOffset.x ) {
        _scrollView.contentOffset = CGPointMake(button.minX-10, 0);
    }else if (button.minX >= (_scrollView.contentOffset.x + self_width)){
        _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x + (button.maxX-_scrollView.contentOffset.x-self_width -10)+10, 0);
    }
}


@end
