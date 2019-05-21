//
//  LCIncomeListCell.m
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "LCIncomeListCell.h"

@interface LCIncomeListCell ()

@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *moneyLabel;

@end

@implementation LCIncomeListCell

+ (instancetype)getIncomeListCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andDic:(NSDictionary *)dic{
    LCIncomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LCIncomeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setInfoWith:dic];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpControls];
    }
    return self;
}

- (void)setUpControls{
    //日期
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 30)];
    _timeLabel.textColor = [UIColor colorWithHexString:@"555655"];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_timeLabel];
    
    //金额
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(win_width-15-150, 10, 150, 30)];
    _moneyLabel.textColor = STYLECOLOR;
    _moneyLabel.font = [UIFont systemFontOfSize:15];
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_moneyLabel];
}

- (CGFloat)setInfoWith:(NSDictionary *)dic{
    CGFloat totalH = 0;
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",dic[@"month"]];
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@",dic[@"commission"]];
    
    return totalH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
