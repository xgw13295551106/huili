//
//  OrderPayFootView.m
//  YeFu
//
//  Created by Carl on 2017/12/19.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "OrderPayFootView.h"
#import "PPNumberButton.h"

#define LabelColor  [UIColor colorWithHexString:@"242428"]

@interface OrderPayFootView ()<PPNumberButtonDelegate>{
    UIView *numBgView;
    UIView *buyBgView;
}

@property (nonatomic,strong)UILabel *sumNumLabel;
@property (nonatomic,strong)UILabel *sendFee;
@property (nonatomic,strong)UILabel *sumPrice;
@property (nonatomic,strong)UILabel *handLabel;
@property (nonatomic,strong)UILabel *scoreLabel;



@property(nonatomic,strong)PPNumberButton *numberButton;

@end

@implementation OrderPayFootView

#pragma mark --Setter方法

- (void)setNumValue:(NSString *)numValue{
    _numValue = numValue;
    _numberButton.currentNumber = numValue.integerValue;
}

- (void)setCoinValue:(NSString *)coinValue{
    _coinValue = coinValue;
    _sumPrice.attributedText = [self setAttributedStringStyleWithFirst:coinValue second:@""];
}

- (void)setScoreValue:(NSString *)scoreValue{
    _scoreValue = scoreValue;
    float money = scoreValue.floatValue/100 *[CommonConfig shared].jifenChange.floatValue;
    _scoreLabel.text = [NSString stringWithFormat:@"可用积分%.f分,抵￥%.2f",scoreValue.floatValue,money];
}

- (void)setBalanceValue:(NSString *)balanceValue{
    _balanceValue = balanceValue;
    
    UserInfoModel *userModel = [UserInfoManager currentUser];
    userModel.balance = balanceValue;
    [[UserInfoManager manager] saveUserInfo:userModel];
}


- (void)setEditNum:(BOOL)editNum{
    _editNum = editNum;

    if (editNum) {
        numBgView.hidden = NO;
        buyBgView.minY = numBgView.maxY+10;
    }else{
        numBgView.hidden = YES;
        buyBgView.minY = 10;
    }
    self.height = buyBgView.maxY;
}

#pragma mark 初始化
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        //第一个section购买数量
        numBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, win_width, 45)];
        [numBgView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:numBgView];
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 25)];
        numLabel.textColor = [UIColor colorWithHexString:@"242428"];
        numLabel.font = [UIFont systemFontOfSize:14];
        numLabel.text = @"购买数量";
        [numBgView addSubview:numLabel];
        
        __weak typeof(self) weakSelf = self;
        PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(AL_DEVICE_WIDTH-80-10, numLabel.minY, 80, 25)];
        numberButton.delegate = self;
        // 初始化时隐藏减按钮
        numberButton.decreaseHide = YES;
        numberButton.shakeAnimation = YES;
        numberButton.borderColor = [UIColor grayColor];
        numberButton.increaseTitle = @"＋";
        numberButton.decreaseTitle = @"－";
        numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
            weakSelf.numValue = [NSString stringWithFormat:@"%i",(int)num];
            if ([weakSelf.delegate respondsToSelector:@selector(changeBuyNum)]) {
                [weakSelf.delegate changeBuyNum];
            }
        };
        [numBgView addSubview:numberButton];
        _numberButton=numberButton;
        
        _sumNumLabel = [[UILabel alloc]initWithFrame:numberButton.frame];
        _sumNumLabel.textColor = LabelColor;
        _sumNumLabel.font = [UIFont systemFontOfSize:14];
        _sumNumLabel.textAlignment = NSTextAlignmentRight;
        [numBgView addSubview:_sumNumLabel];
        _sumNumLabel.hidden = YES;
        
        //第二个section 购买信息
        buyBgView = [[UIView alloc]initWithFrame:CGRectMake(0, numBgView.maxY+10, win_width, 183)];
        [buyBgView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:buyBgView];
        
        //使用积分
        UILabel *secondLeft = [self getLabelWith:CGRectMake(15, 10, 0, 25) andText:@"积分" andNSTextAlignment:NSTextAlignmentLeft];
        [buyBgView addSubview:secondLeft];
        
        UISwitch *coinSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-70, secondLeft.centerY-30/2, 60, 30)];
        [coinSwitch setOn:YES];
        _coinSwitch=coinSwitch;
        [coinSwitch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
        [buyBgView addSubview:coinSwitch];
        coinSwitch.centerY = secondLeft.centerY;
        
        _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(secondLeft.maxX+8, secondLeft.minY, coinSwitch.minX-10 -(secondLeft.maxX+8), secondLeft.height)];
        _scoreLabel.textColor = [UIColor colorWithHexString:@"919291"];
        _scoreLabel.font = [UIFont systemFontOfSize:14];
        _scoreLabel.text = [NSString stringWithFormat:@"可用积分0分，抵￥0.00"];
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
        [buyBgView addSubview:_scoreLabel];
        
        buyBgView.height = secondLeft.maxY+10;
        
        self.height = buyBgView.maxY;
        
    }
    return self;
}


- (UILabel *)getLabelWith:(CGRect)frame andText:(NSString *)text andNSTextAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = LabelColor;
    label.font = [UIFont systemFontOfSize:15];
    label.text = text;
    label.textAlignment = textAlignment;
    if (textAlignment == NSTextAlignmentLeft) {
        [label sizeToFit];
        label.size = CGSizeMake(label.width, 25);
    }
    
    return label;
}


-(void)switchChange{
    if ([self.delegate respondsToSelector:@selector(clickSwitchAction:)]) {
        [self.delegate clickSwitchAction:_coinSwitch];
    }
}

-(void)feeClick{
    if ([self.delegate respondsToSelector:@selector(clickHandFeeButton)]) {
        [self.delegate clickHandFeeButton];
    }
}

/**
 创建富文本对象并返回
 
 @param string1 第一段文字
 @param string2 第二段文字
 @return 返回创建好的富文本
 */
- (NSMutableAttributedString *)setAttributedStringStyleWithFirst:(NSString *)string1 second:(NSString *)string2 {
    
    NSString *first_string = [NSString stringWithFormat:@"%@",string1];
    NSString *second_string = [NSString stringWithFormat:@" %@",string2];
    
    NSString *totalString = [NSString stringWithFormat:@"%@%@",first_string,second_string];
    //找到各个string在总字符串中的位置
    NSRange first_range = [totalString rangeOfString:first_string];
    NSRange second_range = [totalString rangeOfString:second_string];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:totalString];
    //易货币金额的格式
    [str addAttribute:NSForegroundColorAttributeName value:STYLECOLOR range:first_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:first_range];
    //易货币的格式
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"242428"] range:second_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:second_range];
    
    return str;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
