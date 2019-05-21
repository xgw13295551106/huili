//
//  YHHomeHeadView.m
//  yihuo
//
//  Created by zhongweike on 2017/12/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHHomeHeadView.h"

@interface YHHomeHeadView ()<SDCycleScrollViewDelegate>{
    CGFloat self_width;
    CGFloat self_height;
    NSTimer *timer;
}

@property (nonatomic,strong)SDCycleScrollView *bannerView;//顶部轮播图
@property (nonatomic,strong)UIView *seckillView;       ///< 秒杀价部分view

@property (nonatomic,strong)UIView *subKillView1;      ///< 左侧秒杀view
@property (nonatomic,strong)UIView *subKillView2;      ///< 右侧上部分秒杀view
@property (nonatomic,strong)UIView *subKillView3;      ///< 右侧下部分秒杀view

@property (nonatomic,strong)UIImageView *killButton;      ///< 秒杀button

@property (nonatomic,strong)UIImageView *goodsImgView1;
@property (nonatomic,strong)UIImageView *goodsImgView2;
@property (nonatomic,strong)UIImageView *goodsImgView3;
//商品图片
@property (nonatomic,strong)UILabel *goodsNameLabel1;
@property (nonatomic,strong)UILabel *goodsNameLabel2;
@property (nonatomic,strong)UILabel *goodsNameLabel3;
//原价
@property (nonatomic,strong)UILabel *oldLabel1;
@property (nonatomic,strong)UILabel *oldLabel2;
@property (nonatomic,strong)UILabel *oldLabel3;
//倒计时
@property (nonatomic,strong)UILabel *timeLabel1;
@property (nonatomic,strong)UILabel *timeLabel2;
@property (nonatomic,strong)UILabel *timeLabel3;
//秒杀价
@property (nonatomic,strong)UILabel *priceLabel1;
@property (nonatomic,strong)UILabel *priceLabel2;
@property (nonatomic,strong)UILabel *priceLabel3;

@property (nonatomic,strong)UIView *circleView1;
@property (nonatomic,strong)UIView *circleView2;
@property (nonatomic,strong)UIView *circleView3;

@property (nonatomic,strong)HomeHeadBlock headBlock;
@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)NSArray *adArray;
@property (nonatomic,strong)NSArray *catArray;

@property (nonatomic,copy)NSString *endTime;

@property (nonatomic,strong)NSDictionary *infoDic;

@end

static int baseTag = 100;

@implementation YHHomeHeadView

-(SDCycleScrollView*)bannerView{
    if (_bannerView==nil) {
        _bannerView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 3*AL_DEVICE_WIDTH/5) shouldInfiniteLoop:YES imageNamesGroup:nil];
        _bannerView.delegate = self;
        [_bannerView setBannerImageViewContentMode:UIViewContentModeScaleAspectFill];
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _bannerView;
}

+ (instancetype)getHomeHeadView:(CGRect)frame andBlock:(HomeHeadBlock)headBlock{
    YHHomeHeadView *view = [[YHHomeHeadView alloc]initWithFrame:frame];
    view.headBlock = headBlock;
    return view;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self_width = frame.size.width;
        self_height = frame.size.height;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setupUI];
        if (!timer) {
            timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startCountTime:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.bannerView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bannerView.maxY, self_width, self_height-self.bannerView.maxY)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.bottomView];
    
    //分割view
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _bottomView.maxY, self_width, 10)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"F7F8F7"]];
    lineView.tag = 22;
    [self addSubview:lineView];
    
    //秒杀专场view
    _seckillView = [[UIView alloc]initWithFrame:CGRectMake(0, lineView.maxY, self_width, 260)];
    [_seckillView setBackgroundColor:[UIColor colorWithHexString:@"F1F2F1"]];
    [self addSubview:_seckillView];
    
    //秒杀子view1
    _subKillView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3*(_seckillView.width-1)/7, _seckillView.height)];
    _subKillView1.backgroundColor = [UIColor whiteColor];
    [_seckillView addSubview:_subKillView1];
    //秒杀子view2
    _subKillView2 = [[UIView alloc]initWithFrame:CGRectMake(_subKillView1.maxX+1, 0, 4*(_seckillView.width-1)/7, (_seckillView.height-1)/2)];
    _subKillView2.backgroundColor = [UIColor whiteColor];
    [_seckillView addSubview:_subKillView2];
    //秒杀子view3
    _subKillView3 = [[UIView alloc]initWithFrame:CGRectMake(_subKillView2.minX, _subKillView2.maxY+1, _subKillView2.width, _subKillView2.height)];
    _subKillView3.backgroundColor = [UIColor whiteColor];
    [_seckillView addSubview:_subKillView3];
    
    //秒杀部分1
    [self setupSubkillView1];
    //秒杀部分2
    [self setupSubKillView2];
    //秒杀部分3
    [self setupSubKillView3];
    
    //添加点击事件
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickKillView1)];
    [_subKillView1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickKillView2)];
    [_subKillView2 addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickKillView3)];
    [_subKillView3 addGestureRecognizer:tap3];
    
//    _goodsImgView1.contentMode = UIViewContentModeScaleAspectFit;
}

//TODO:集成subKillView1
- (void)setupSubkillView1{
    CGFloat circleView_w = 62;
    CGFloat circleView_h = circleView_w;
    //秒杀button
    UIImage *killImage = [UIImage imageNamed:@"home_pic_miaosha@2x"];
    _killButton = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, _subKillView1.width, 40)];
    _killButton.contentMode = UIViewContentModeScaleAspectFit;
    [_killButton setImage:killImage];
    _killButton.userInteractionEnabled = YES;
    [_subKillView1 addSubview:_killButton];
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickKillAction)];
    [_killButton addGestureRecognizer:tap];
    
    _goodsImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, _killButton.maxY+10, _killButton.width-2*10, _killButton.width/2)];
    [_subKillView1 addSubview:_goodsImgView1];
    
    _goodsNameLabel1 = [self getGoodsNameLabelWith:CGRectMake(_goodsImgView1.minX, _goodsImgView1.maxY+2, _goodsImgView1.width, 30)];
    [_subKillView1 addSubview:_goodsNameLabel1];
    //放秒杀价的view
    _circleView1 = [self getCircleKillView:CGRectMake(_subKillView1.width-circleView_w-8, _subKillView1.height-10-circleView_h, circleView_w, circleView_h)];
    [_subKillView1 addSubview:_circleView1];
    _circleView1.hidden = YES;
    
    _priceLabel1 = [self getKillPriceLabel:CGRectMake(0, _circleView1.height/2-2, _circleView1.width, _circleView1.height/2-10)];
    [_circleView1 addSubview:_priceLabel1];
    
    _oldLabel1 = [self getOldPriceLabel:CGRectMake(_goodsImgView1.minX, _circleView1.minY-3, _circleView1.minX-2-_goodsImgView1.minX, 22)];
    [_subKillView1 addSubview:_oldLabel1];
    
    _timeLabel1 = [self getTimeLabel:CGRectMake(_goodsImgView1.minX, _circleView1.maxY-18, _oldLabel1.width, 18)];
    [_subKillView1 addSubview:_timeLabel1];
    
    UILabel *surplusLabel1 = [self getSurplusLabel:CGRectMake(_timeLabel1.minX, _timeLabel1.minY-14, _priceLabel1.width, 14)];
    [_subKillView1 addSubview:surplusLabel1];
}

//TODO:集成subKillView2
- (void)setupSubKillView2{
    CGFloat circleView_w = 62;
    CGFloat circleView_h = circleView_w;
    _circleView2 = [self getCircleKillView:CGRectMake(10, 10, circleView_w, circleView_h)];
    [_subKillView2 addSubview:_circleView2];
    _circleView2.hidden = YES;
    
    _priceLabel2 = [self getKillPriceLabel:CGRectMake(0, _circleView2.height/2-2, _circleView2.width, _circleView2.height/2-10)];
    [_circleView2 addSubview:_priceLabel2];
    
    _timeLabel2 = [self getTimeLabel:CGRectMake(_circleView2.minX, _subKillView2.height-18-10, 75, 18)];
    [_subKillView2 addSubview:_timeLabel2];
    
    UILabel *surplusLabel2 = [self getSurplusLabel:CGRectMake(_timeLabel2.minX, _timeLabel2.minY-14, _priceLabel2.width, 14)];
    [_subKillView2 addSubview:surplusLabel2];
    
    CGFloat goodsImgView2_x = _circleView2.maxX+2;
    CGFloat goodsImgView2_w = _subKillView2.width - 8-(goodsImgView2_x);
    _goodsImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(goodsImgView2_x, _circleView2.minY, goodsImgView2_w, 60)];
    [_subKillView2 addSubview:_goodsImgView2];
    
    _goodsNameLabel2 = [self getGoodsNameLabelWith:CGRectMake(_goodsImgView2.minX, _goodsImgView2.maxY+2, _goodsImgView2.width, 30)];
    [_subKillView2 addSubview:_goodsNameLabel2];
    
    _oldLabel2 = [self getOldPriceLabel:CGRectMake(_goodsImgView2.minX, _subKillView2.height-18-10, goodsImgView2_w, 18)];
    _oldLabel2.font = [UIFont systemFontOfSize:16];
    [_subKillView2 addSubview:_oldLabel2];
}

//TODO:集成subKillView3
- (void)setupSubKillView3{
    CGFloat circleView_w = 62;
    CGFloat circleView_h = circleView_w;
    _circleView3 = [self getCircleKillView:CGRectMake(_subKillView3.width-8-circleView_w, 10, circleView_w, circleView_h)];
    [_subKillView3 addSubview:_circleView3];
    _circleView3.hidden = YES;
    
    _priceLabel3 = [self getKillPriceLabel:CGRectMake(0, _circleView3.height/2-2, _circleView3.width, _circleView3.height/2-10)];
    [_circleView3 addSubview:_priceLabel3];
    
    _timeLabel3 = [self getTimeLabel:CGRectMake(_subKillView3.width-8-62, _subKillView3.height-18-10, 68, 18)];
    [_subKillView3 addSubview:_timeLabel3];
    
    UILabel *surplusLabel3 = [self getSurplusLabel:CGRectMake(_timeLabel3.minX, _timeLabel3.minY-14, _priceLabel3.width, 14)];
    [_subKillView3 addSubview:surplusLabel3];
    
    CGFloat goodsImgView3_x = 10;
    CGFloat goodsImgView3_w = _circleView3.minX - 2-goodsImgView3_x;
    _goodsImgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(goodsImgView3_x, _circleView3.minY, goodsImgView3_w, 60)];
    [_subKillView3 addSubview:_goodsImgView3];
    
    _goodsNameLabel3 = [self getGoodsNameLabelWith:CGRectMake(_goodsImgView3.minX, _goodsImgView3.maxY+2, _goodsImgView3.width, 30)];
    [_subKillView3 addSubview:_goodsNameLabel3];
    
    _oldLabel3 = [self getOldPriceLabel:CGRectMake(_goodsImgView3.minX, _subKillView3.height-18-10, goodsImgView3_w, 18)];
    _oldLabel3.font = [UIFont systemFontOfSize:16];
    [_subKillView3 addSubview:_oldLabel3];
    
}

- (void)reloadHeadViewWith:(NSDictionary *)dic{
    _infoDic = dic;
    self.adArray = [dic objectForKey:@"top"];
    NSMutableArray *adImgList = [NSMutableArray array];
    for (NSDictionary *one in _adArray) {
        [adImgList addObject:[one stringForKey:@"img"]];
    }
    [self.bannerView setImageURLStringsGroup:adImgList];
    
    
    self.catArray = [dic objectForKey:@"cat"];
    [_bottomView removeAllSubviews];
    CGFloat button_w = self_width/5;
    CGFloat button_h = button_w +10;
    for (int i = 0; i<self.catArray.count; i++) {
        int col = i%5;
        int raw = i/5;
        UIButton *button = [self getItemButton:CGRectMake(col*button_w, raw*button_h, button_w, button_h) and:self.catArray[i] andTag:i+baseTag];
        [_bottomView addSubview:button];
    }
    _bottomView.height = 2*button_h;
    
    UIView *lineView = [self viewWithTag:22];
    lineView.minY = _bottomView.maxY;
    _seckillView.minY =  lineView.maxY;
    
    _circleView1.hidden = NO;
    _circleView2.hidden = NO;
    _circleView3.hidden = NO;
    NSArray *killArray = dic[@"recommend"];
    //-------------------秒杀1---------------------//
    NSDictionary *killDic1 = killArray.count>0?killArray[0]:@{};
    _endTime = [killDic1 stringForKey:@"end"];
    [_goodsImgView1 sd_setImageWithURL:[NSURL URLWithString:[killDic1 stringForKey:@"img"]] placeholderImage:DefaultsImg];
    _goodsNameLabel1.text = [killDic1 stringForKey:@"name"];
    _priceLabel1.text = [NSString stringIsNull:[killDic1 stringForKey:@"price"]]?@"--":[killDic1 stringForKey:@"price"];
    NSString *oldPrice1 = [NSString stringIsNull:[killDic1 stringForKey:@"super_price"]]?@"":[killDic1 stringForKey:@"super_price"];
    _oldLabel1.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"￥%@",oldPrice1]];
    _timeLabel1.attributedText = [self setAttributedStringStyleWithTimeStr:@"00:00:00"];
    //-------------------秒杀2--------------------//
    NSDictionary *killDic2 = killArray.count>1?killArray[1]:@{};
    [_goodsImgView2 sd_setImageWithURL:[NSURL URLWithString:[killDic2 stringForKey:@"img"]] placeholderImage:DefaultsImg];
    _goodsNameLabel2.text = [killDic2 stringForKey:@"name"];
    _priceLabel2.text = [NSString stringIsNull:[killDic2 stringForKey:@"price"]]?@"--":[killDic2 stringForKey:@"price"];
    _oldLabel2.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"￥%@",[killDic2 stringForKey:@"super_price"]]];
    _timeLabel2.attributedText = [self setAttributedStringStyleWithTimeStr:@"00:00:00"];
    //-------------------秒杀3--------------------//
    NSDictionary *killDic3 = killArray.count>2?killArray[2]:@{};
    [_goodsImgView3 sd_setImageWithURL:[NSURL URLWithString:[killDic3 stringForKey:@"img"]] placeholderImage:DefaultsImg];
    _goodsNameLabel3.text = [killDic3 stringForKey:@"name"];
    _priceLabel3.text = [NSString stringIsNull:[killDic3 stringForKey:@"price"]]?@"--":[killDic3 stringForKey:@"price"];
    _oldLabel3.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"￥%@",[killDic3 stringForKey:@"super_price"]]];
    _timeLabel3.attributedText = [self setAttributedStringStyleWithTimeStr:@"00:00:00"];
    
    [self startCountTime:timer];
    
    self.height = _seckillView.maxY;
}

- (void)startCountTime:(NSTimer *)oneTimer{
    NSString *timeString = @"2018-01-09 20:58:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    date = [NSDate dateWithTimeIntervalSince1970:_endTime.integerValue];
    _timeLabel1.attributedText = [self setAttributedStringStyleWithTimeStr:[LCTools timerFireMethod:date]];
    _timeLabel2.attributedText = [self setAttributedStringStyleWithTimeStr:[LCTools timerFireMethod:date]];
    _timeLabel3.attributedText = [self setAttributedStringStyleWithTimeStr:[LCTools timerFireMethod:date]];
}

- (UIButton *)getItemButton:(CGRect)frame and:(NSDictionary *)dic andTag:(int)buttonTag
{
    NSString *imageName = [dic stringForKey:@"img"];   //图片链接
    NSString *title = [dic stringForKey:@"name"];   //文字内容
    
    //NSString *color = dic[@"color"];  //文字的颜色
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    
    CGFloat img_x = (button.width - 40)/2;
    CGFloat img_y = (button.height - 40-10-20)/2;//40是图高，10是图文间距，20是文高
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(img_x, img_y, 40, 40)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"home_icon_menu1"]];
    [button addSubview:imageView];

    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.maxY+10, button.width, 20)];
    bottomLabel.textColor = [UIColor colorWithHexString:@"8D8F8D"];
    bottomLabel.font = [UIFont systemFontOfSize:14];
    bottomLabel.text = title;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [button addSubview:bottomLabel];
    
    button.clipsToBounds = YES;
    [button setTag:buttonTag];
    [button addTarget:self action:@selector(clickItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark 点击事件
//TODO:点击banner
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.headBlock) {
        //暂时不要点击banner的效果
        //self.headBlock(self.adArray[index], clickBanner);
    }
}

//TODO:点击分类
- (void)clickItemButtonAction:(UIButton *)button{
    int index = (int)button.tag - baseTag;
    if (self.headBlock) {
        self.headBlock(self.catArray[index], clickClassify);
    }
    
}

//TODO:点击秒杀专场
- (void)clickKillAction{
    if (self.headBlock) {
        self.headBlock(nil, clickKill);
    }
}

//TODO:点击秒杀商品1
- (void)clickKillView1{
    NSArray *array = _infoDic[@"recommend"];
    if (array.count>0) {
        if (self.headBlock) {
            self.headBlock(array[0], clickGoods);
        }
    }
}

//TODO:点击秒杀商品2
- (void)clickKillView2{
    NSArray *array = _infoDic[@"recommend"];
    if (array.count>1) {
        if (self.headBlock) {
            self.headBlock(array[1], clickGoods);
        }
    }
}

//TODO:点击秒杀商品3
- (void)clickKillView3{
    NSArray *array = _infoDic[@"recommend"];
    if (array.count>2) {
        if (self.headBlock) {
            self.headBlock(array[2], clickGoods);
        }
    }
}


#pragma mark 封装的一些方法，获取控件、文本
//TODO:获取商品名的label
- (UILabel *)getGoodsNameLabelWith:(CGRect)frame {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor colorWithHexString:@"000000"];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 2;
    return label;
}

//TODO:获取封装的原价label
- (UILabel *)getOldPriceLabel:(CGRect)frame{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor colorWithHexString:@"696A69"];
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

//TODO:获取剩余时间文本label
- (UILabel *)getSurplusLabel:(CGRect)frame{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor colorWithHexString:@"929392"];
    label.font = [UIFont systemFontOfSize:10];
    label.text = @"秒杀剩余时间";
    [label sizeToFit];
    label.size = CGSizeMake(label.width, frame.size.height);
    
    return label;
}

//TODO:获取剩余时间label
- (UILabel *)getTimeLabel:(CGRect)frame{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14];
    
    return label;
}

//TODO:获取秒杀价view
- (UIView *)getCircleKillView:(CGRect)frame{
    UIView *circleView = [[UIView alloc]initWithFrame:frame];
    [circleView setBackgroundColor:STYLECOLOR];
    circleView.layer.cornerRadius = frame.size.height/2;
    circleView.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, circleView.width, circleView.height/2-5)];
    label.textColor = [UIColor colorWithHexString:@"ffffff"];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"秒杀价";
    label.textAlignment = NSTextAlignmentCenter;
    [circleView addSubview:label];
    
    return circleView;
}

//TODO:获取秒杀价label
- (UILabel *)getKillPriceLabel:(CGRect)frame{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor colorWithHexString:@"ffffff"];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    return label;
}

//TODO:获取封装好的中划线富文本
- (NSMutableAttributedString *)getAttributedStr:(NSString *)string{
    
    //中划线
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,string.length)];
    
    [attributeMarket addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
    [attributeMarket addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, string.length-1)];
    
    return attributeMarket;
}

//TODO:获取封装的倒计时富文本
- (NSMutableAttributedString *)setAttributedStringStyleWithTimeStr:(NSString *)timeString {
    NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
    NSString *hour = timeArray[0];
    NSRange hour_range = NSMakeRange(0, hour.length);
    NSRange min_range = NSMakeRange(hour.length+1, 2);
    NSRange second_range = NSMakeRange(hour.length+1+2+1, 2);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:timeString];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, timeString.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, timeString.length)];
    
    //时
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:hour_range];
    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithHexString:@"FB4C7B"] range:hour_range];
    
    //分
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:min_range];
    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithHexString:@"FB4C7B"] range:min_range];
    
    //秒
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:second_range];
    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithHexString:@"FB4C7B"] range:second_range];
    
    
    return str;
}


- (void)dealloc{
    [timer invalidate];
    timer = nil;
}

@end
