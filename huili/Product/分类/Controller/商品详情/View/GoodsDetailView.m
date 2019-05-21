//
//  GoodsDetailView.m
//  YeFu
//
//  Created by Carl on 2017/12/6.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "GoodsDetailView.h"
#import "LLImagePickerView.h"

@interface GoodsDetailView ()<SDCycleScrollViewDelegate>{
    NSTimer *timer;
}

@property(nonatomic,weak)UILabel *name;
@property(nonatomic,weak)UILabel *goods_price;

@property (nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,weak)UIButton *collectBnt;

@end
@implementation GoodsDetailView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSArray *imagesURLStrings = [_dic objectForKey:@"list_img"];
    if ([self.delegate respondsToSelector:@selector(showImgArray:setIndex:)]) {
        [self.delegate showImgArray:imagesURLStrings setIndex:index];
    }
}


/*****************************收藏*************************************/

-(void)setDic:(NSDictionary *)dic{
    _dic=dic;
    // 商品广告页
    NSArray *imagesURLStrings =[dic objectForKey:@"list_img"];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_WIDTH) shouldInfiniteLoop:YES imageNamesGroup:imagesURLStrings];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //--------------------秒杀价view,先初始化，后面再根据参数设置隐藏或显示----------------//
    UIImage *killImage = [UIImage imageNamed:@"bg_miaosha"];
    UIImageView *killImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, cycleScrollView.maxY, win_width, 35)];
    [killImgView setImage:killImage];
    [self addSubview:killImgView];
    killImgView.hidden = YES;
    
    UILabel *killLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 58, 25)];
    killLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    killLabel.font = [UIFont systemFontOfSize:18];
    killLabel.text = @"秒杀价";
    [killImgView addSubview:killLabel];
    
    UILabel *killPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(killLabel.maxX+2, killLabel.minY, 0, 25)];
    killPriceLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    killPriceLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    killPriceLabel.text = [NSString stringWithFormat:@"¥%@",[dic stringForKey:@"price"]];
    [killImgView addSubview:killPriceLabel];
    [killPriceLabel sizeToFit];
    killPriceLabel.size = CGSizeMake(killPriceLabel.width, 25);
    
    UILabel *oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(killPriceLabel.maxX+2, killPriceLabel.minY+4, 120, 20)];
    oldLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    oldLabel.font = [UIFont systemFontOfSize:14];
    oldLabel.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"￥%@",[dic stringForKey:@"super_price"]]];
    [killImgView addSubview:oldLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(win_width-10-140, killPriceLabel.minY, 140, 25)];
    _timeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [killImgView addSubview:_timeLabel];
    [self startCountTime:timer];
    
    //-------------------------------秒杀价view部分结束--------------------------//
    
    //商品名
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(10, cycleScrollView.bottom+3, AL_DEVICE_WIDTH-20, 50)];
    [name setTextColor:text1Color];
    [name setNumberOfLines:2];
    [name setFont:[UIFont boldSystemFontOfSize:17]];
    [self addSubview:name];
    _name=name;
    
    //商品价格
    UILabel *goods_price=[[UILabel alloc]initWithFrame:CGRectMake(10, name.bottom, AL_DEVICE_WIDTH-20, 25)];
    [goods_price setTextColor:[UIColor colorWithHexString:@"f23030"]];
    [goods_price setFont:[UIFont boldSystemFontOfSize:19]];
    [self addSubview:goods_price];
    _goods_price=goods_price;
    
    
    [_name setText:[dic stringForKey:@"name"]];
    [_goods_price setText:[NSString stringWithFormat:@"¥%@",[dic stringForKey:@"price"]]];
    [_goods_price sizeToFit];
    [_goods_price setFrame:CGRectMake(10, name.bottom, _goods_price.width, 25)];
    
    
    if ([self judgeGoodsType] == 1) {
        UIImage *specialImage = [UIImage imageNamed:@"commodity_button_bargain"];
        UIImageView *specialImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_goods_price.maxX+2, _goods_price.centerY-specialImage.size.height/2, specialImage.size.width, specialImage.size.height)];
        [specialImgView setImage:specialImage];
        [self addSubview:specialImgView];
        
        //特价
        UILabel *super_price=[[UILabel alloc]initWithFrame:CGRectMake(10, _goods_price.bottom+5, 140, 25)];
        [super_price setText:[NSString stringWithFormat:@"￥%@",[dic stringForKey:@"super_price"]]];
        [super_price setTextAlignment:NSTextAlignmentCenter];
        [super_price setFont:[UIFont systemFontOfSize:14]];
        [super_price setTextColor:text2Color];
        [self addSubview:super_price];
        [super_price sizeToFit];
        [super_price setFrame:CGRectMake(10, _goods_price.bottom+5, super_price.width, 25)];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 12, super_price.width, 2)];
        [line setBackgroundColor:LineColor];
        [super_price addSubview:line];
    }else if ([self judgeGoodsType] == 2){
        //秒杀
        if (!timer) {
            timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startCountTime:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
        killImgView.hidden = NO;
        name.minY = killImgView.maxY+5;
        goods_price.hidden = YES;
    }else{
        UILabel *super_price=[[UILabel alloc]initWithFrame:CGRectMake(10, _goods_price.bottom+5, 140, 25)];
        [super_price setText:[NSString stringWithFormat:@"￥%@",[dic stringForKey:@"super_price"]]];
        [super_price setTextAlignment:NSTextAlignmentCenter];
        [super_price setFont:[UIFont systemFontOfSize:14]];
        [super_price setTextColor:[UIColor colorWithHexString:@"343437"]];
        [self addSubview:super_price];
        [super_price sizeToFit];
        [super_price setFrame:CGRectMake(_goods_price.maxX+2, _goods_price.minY, super_price.width, _goods_price.height)];
        //钻石会员图片
        UIImage *specialImage = [UIImage imageNamed:@"commodity_button_label"];
        UIImageView *specialImgView = [[UIImageView alloc]initWithFrame:CGRectMake(super_price.maxX+2, super_price.centerY-specialImage.size.height/2, specialImage.size.width, specialImage.size.height)];
        [specialImgView setImage:specialImage];
        [self addSubview:specialImgView];
    }
    
    
    UILabel *kuncunLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, _goods_price.bottom+35, 40, 25)];
    [kuncunLabel setText:@"库存"];
    [kuncunLabel setTextColor:text2Color];
    [kuncunLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:kuncunLabel];
    if ([self judgeGoodsType] == 1) {
        kuncunLabel.minY = _goods_price.bottom+35;
    }else if ([self judgeGoodsType] == 2){
        kuncunLabel.minY = name.maxY+10;
    }else{
        kuncunLabel.minY = _goods_price.bottom+10;
    }
    
    UILabel *kucun=[[UILabel alloc]initWithFrame:CGRectMake(60, kuncunLabel.y, 120, 25)];
    [kucun setText:[NSString stringWithFormat:@"%@件",[dic stringForKey:@"inventory"]]];
    [kucun setFont:[UIFont boldSystemFontOfSize:15]];
    [kucun setTextColor:[UIColor colorWithHexString:@"2E2E32"]];
    [self addSubview:kucun];
    [kucun sizeToFit];
    [kucun setFrame:CGRectMake(kuncunLabel.right+5, kuncunLabel.y, kucun.width, 25)];
    
    
    //收藏button
    UIButton *collectBnt=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-90, kuncunLabel.y, 80, 25)];
    [collectBnt setImage:[UIImage imageNamed:@"commodity_button_collect_def"] forState:UIControlStateNormal];
    [collectBnt setImage:[UIImage imageNamed:@"commodity_button_collect_sel"] forState:UIControlStateSelected];
    [self addSubview:collectBnt];
    _collectBnt=collectBnt;
    [collectBnt addTarget:self action:@selector(collcetClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([dic intForKey:@"is_collect"]==0) {
        [collectBnt setSelected:NO];
    }else{
        [collectBnt setSelected:YES];
    }
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, kucun.bottom+5, AL_DEVICE_WIDTH, 0.5)];
    [line1 setBackgroundColor:LineColor];
    [self addSubview:line1];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, line1.bottom, AL_DEVICE_WIDTH, 7.5)];
    [lineView1 setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    [self addSubview:lineView1];
    
    UIView *bottomBg=[[UIView alloc]initWithFrame:CGRectMake(0, lineView1.bottom, AL_DEVICE_WIDTH, 44)];
    [bottomBg setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bottomBg];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 0.5)];
    [line2 setBackgroundColor:LineColor];
    [bottomBg addSubview:line2];
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0,43.5 , AL_DEVICE_WIDTH, 0.5)];
    [line3 setBackgroundColor:LineColor];
    [bottomBg addSubview:line3];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, bottomBg.bottom, AL_DEVICE_WIDTH, 7.5)];
    [lineView2 setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    [self addSubview:lineView2];
    
    UILabel *selectLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 44)];
    [selectLabel setText:@"请选择"];
    [selectLabel setTextColor:text2Color];
    [selectLabel setFont:[UIFont systemFontOfSize:16]];
    [bottomBg addSubview:selectLabel];
    
    
    UILabel *selectValue=[[UILabel alloc]initWithFrame:CGRectMake(70, 0, 200, 44)];
    [selectValue setText:@""];
    [selectValue setFont:[UIFont systemFontOfSize:16]];
    [selectValue setTextColor:text1Color];
    [bottomBg addSubview:selectValue];
    _selectValue=selectValue;
    
    UIButton *selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-60, 0, 60, 44)];
    [selectBtn setImage:[UIImage imageNamed:@"commodity_button_more"] forState:UIControlStateNormal];
    [bottomBg addSubview:selectBtn];
    [selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectClick)];
    [bottomBg addGestureRecognizer:tap1];
    
    self.height = bottomBg.maxY+8;
}

-(void)collcetClick:(UIButton*)sender{
    
    if (TOKEN.length==0||(!TOKEN)) {
        [YHHelpper alertLogin];
        return;
    }
    
    NSString *url=YH_REQUEST_DOMAIN;
    if (sender.selected) {
        url=[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,GoodsCancelCollect];
    }else{
        url=[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,GoodsCollect];
    }
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:[_dic stringForKey:@"id"] forKey:@"goods_id"];
    [[XAClient sharedClient]postInBackground:url withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [sender setSelected:!sender.selected];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
}
/*****************************收藏*************************************/


/*****************************选择规格*************************************/
-(void)selectClick{
    if ([self.delegate respondsToSelector:@selector(selectGuiGe)]) {
        [self.delegate selectGuiGe];
    }
}
/*****************************选择规格*************************************/



/**
 判断当前商品的售卖状态 0为普通售卖，没有活动的，1为商品特价，2为商品秒杀

 @return 售卖状态
 */
- (int)judgeGoodsType{
    if ([_dic stringForKey:@"is_special"].intValue == 1) {//当前商品为特价
        return 1;
    }else if ([_dic stringForKey:@"is_recomm"].intValue == 1){ //当前商品为秒杀
        return 2;
    }else{
        return 0;   //当前商品为普通售卖状态
    }
    
    return 0;
}

//TODO:倒计时计算
- (void)startCountTime:(NSTimer *)oneTimer{
    NSString *timeString = @"2018-01-13 20:58:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    date = [NSDate dateWithTimeIntervalSince1970:[_dic[@"end"] integerValue]];
    NSString *labelString = [NSString stringWithFormat:@"距离结束 %@",[LCTools timerFireMethod:date]];
    _timeLabel.attributedText = [self setAttributedStringStyleWithTimeStr:labelString];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//TODO:获取封装的倒计时富文本
- (NSMutableAttributedString *)setAttributedStringStyleWithTimeStr:(NSString *)timeString {
    NSArray *stringArray = [timeString componentsSeparatedByString:@" "];
    NSArray *timeArray = [stringArray[1] componentsSeparatedByString:@":"];
    NSString *hour = timeArray[0];
    NSRange hour_range = NSMakeRange(5, hour.length);
    NSRange min_range = NSMakeRange(5+hour.length+1, 2);
    NSRange second_range = NSMakeRange(5+hour.length+1+2+1, 2);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:timeString];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, timeString.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, timeString.length)];
    //时
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"363736"] range:hour_range];
    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:hour_range];
    //分
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"363736"] range:min_range];
    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:min_range];
    //秒
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"363736"] range:second_range];
    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:second_range];
    
    
    return str;
}

- (NSMutableAttributedString *)getAttributedStr:(NSString *)string{
    
    //中划线
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,string.length)];
    
    [attributeMarket addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
    
    return attributeMarket;
}

- (void)dealloc{
    [timer invalidate];
    timer = nil;
}

@end
