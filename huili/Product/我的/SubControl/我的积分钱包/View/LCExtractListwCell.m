//
//  LCExtractListwCell.m
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "LCExtractListwCell.h"

@interface LCExtractListwCell (){
    UILabel *typeLabel;         ///< 提现类型
    UILabel *timeLabel;         ///< 提现时间
    UILabel *moneyLabel;        ///< 提现金额
}

@property (nonatomic,strong)NSDictionary *dic;

@end

@implementation LCExtractListwCell

+ (instancetype)getExtractListCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andDic:(NSDictionary *)dic{
    LCExtractListwCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LCExtractListwCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.dic = dic;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpControls];
    }
    return self;
}

- (void)setUpControls{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat typeLabel_x = 15;
    CGFloat typeLabel_y = 10;
    CGFloat typeLabel_w = 130;
    CGFloat typeLabel_h = 18;
    typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel_x, typeLabel_y, typeLabel_w, typeLabel_h)];
    typeLabel.textColor = [UIColor colorWithHexString:@"595A59"];
    typeLabel.font = [UIFont systemFontOfSize:14];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:typeLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel_x, CGRectGetMaxY(typeLabel.frame), typeLabel_w, typeLabel_h)];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor colorWithHexString:@"B0B1B0"];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:timeLabel];
    
    CGFloat moneyLabel_x = CGRectGetMaxX(typeLabel.frame)+8;
    CGFloat moneyLabel_w = win_width - 10 - moneyLabel_x;
    CGFloat moneyLabel_h = 20;
    CGFloat moneyLabel_y = 56/2-moneyLabel_h/2; //56是本cell的高度
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel_x, moneyLabel_y, moneyLabel_w, moneyLabel_h)];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.textColor = [UIColor colorWithHexString:@"F06262"];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moneyLabel];
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    
    typeLabel.text = [NSString stringWithFormat:@"%@",[dic stringForKey:@"name"]];
    moneyLabel.text = [NSString stringWithFormat:@"%@%@",[dic stringForKey:@"flag"],[dic stringForKey:@"integral"]];
    moneyLabel.textColor = [[dic stringForKey:@"flag"] isEqualToString:@"-"]?[UIColor colorWithHexString:@"4D4A4A"]:STYLECOLOR;
    timeLabel.text = [NSString stringWithFormat:@"%@",[dic stringForKey:@"created_at"]];
    
    /*
     if ([dic[@"type"] intValue] == 1) {
     moneyLabel.text = [NSString stringWithFormat:@"-%@",dic[@"money"]];
     moneyLabel.textColor = [UIColor colorWithHexString:@"099BF0"];
     }else{
     moneyLabel.text = [NSString stringWithFormat:@"+%@",dic[@"money"]];
     moneyLabel.textColor = [UIColor colorWithHexString:@"F1224B"];
     }
     */
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
