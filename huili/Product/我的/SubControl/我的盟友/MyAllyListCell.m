//
//  MyAllyListCell.m
//  huili
//
//  Created by zhongweike on 2018/1/16.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "MyAllyListCell.h"

#define cell_height 80

@interface MyAllyListCell (){
    UIImageView *headImgView;
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *moneyLabel;
}


@end

@implementation MyAllyListCell

+ (CGFloat)getAllyListCellHeight{
    return cell_height;
}

+ (instancetype)getAllyListCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andDic:(NSDictionary *)dic{
    MyAllyListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyAllyListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
    headImgView.layer.cornerRadius = headImgView.height/2;
    headImgView.layer.masksToBounds = YES;
    [self addSubview:headImgView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(headImgView.maxX+8, headImgView.minY, 180, headImgView.height)];
    nameLabel.textColor = [UIColor colorWithHexString:@"545554"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:nameLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(win_width-10-145, headImgView.minY+2, 145, 25)];
    timeLabel.textColor = [UIColor colorWithHexString:@"6C6A6C"];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLabel];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(timeLabel.minX, headImgView.maxY-25-2, timeLabel.width, 25)];
    moneyLabel.textColor = STYLECOLOR;
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moneyLabel];
    
    nameLabel.width = timeLabel.minX-8-nameLabel.minX;
}

- (CGFloat)setInfoWith:(NSDictionary *)dict{
    CGFloat totalH = 0;
    
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[dict stringForKey:@"img"]] placeholderImage:DefaultsImg];
    nameLabel.text = [dict stringForKey:@"login"];
    timeLabel.text = [dict stringForKey:@"created_at"];
    moneyLabel.text = [dict stringForKey:@"integral"];
    
    return totalH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
