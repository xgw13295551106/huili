//
//  LCWuliuCell.m
//  huili
//
//  Created by zhongweike on 2018/1/12.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "LCWuliuCell.h"

#define cell_height 60

#define NewColor [UIColor colorWithHexString:@"1FB30D"]   ///< 最新状态的颜色
#define OldColor [UIColor colorWithHexString:@"8B8D97"]   ///< 之前状态的颜色

@interface LCWuliuCell (){
    UILabel *timeLabel;    ///< 时间label
    UILabel *statusLabel;  ///< 物流状态label
    UIView *pointView;    ///< 点view
    UIView *horLineView;  ///< 水平线view
    UIView *verLineView;  ///< 垂直线view
}
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)BOOL isLast;   /// <判断是否是最后一个

@end

@implementation LCWuliuCell

+ (CGFloat)getWuliuCellHeightWith:(NSDictionary *)dic{
    CGFloat totalH = 0;
    LCWuliuCell *cell = [[LCWuliuCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    totalH = [cell setInfoWith:dic];
    cell = nil;
    return totalH;
}

+ (instancetype)getWuliuCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andDic:(NSDictionary *)dic{
    LCWuliuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LCWuliuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.indexPath = indexPath;
    cell.isLast = indexPath.row == ([tableView numberOfRowsInSection:0]-1)?YES:NO;
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
    //线条view
    verLineView = [[UIView alloc]init];
    verLineView.width = 1;
    [verLineView setBackgroundColor:LineColor];
    [self addSubview:verLineView];
    
    
    //圆点view
    CGFloat pointViewH = 8;
    pointView = [[UIView alloc]initWithFrame:CGRectMake(15, cell_height/2-pointViewH/2, pointViewH, pointViewH)];
    pointView.layer.cornerRadius = pointViewH/2;
    pointView.layer.masksToBounds = YES;
    [self addSubview:pointView];
    
    //水平线条view
    horLineView = [[UIView alloc]initWithFrame:CGRectMake(pointView.maxX+15, cell_height-1, win_width-(pointView.maxX+15), 1)];
    [horLineView setBackgroundColor:LineColor];
    [self addSubview:horLineView];
    
    //物流信息
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(horLineView.minX, 10, horLineView.width-8, 0)];
    statusLabel.textColor = OldColor;
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.numberOfLines = 0;
    [self addSubview:statusLabel];
    
    //时间信息
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusLabel.minX, statusLabel.maxY+2, statusLabel.width, 18)];
    timeLabel.textColor = NewColor;
    timeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:timeLabel];
    
}

- (CGFloat)setInfoWith:(NSDictionary *)dic{
    CGFloat totalH = 0;
    //context物流信息内容 time时间
    
    statusLabel.text = [dic stringForKey:@"context"];
    timeLabel.text = [dic stringForKey:@"time"];
    
    CGSize size = [statusLabel sizeThatFits:CGSizeMake(horLineView.width-8, MAXFLOAT)];
    statusLabel.size = size;
    timeLabel.minY = statusLabel.maxY+2;
    
    totalH  = timeLabel.maxY+10;
    horLineView.minY = totalH -1;
    
    pointView.centerY = totalH/2;
    verLineView.centerX = pointView.centerX;
    if (_indexPath.row == 0 && !_isLast) {
        verLineView.height = totalH/2;
        verLineView.minY = pointView.centerY;
        pointView.backgroundColor = NewColor;
        statusLabel.textColor = NewColor;
        timeLabel.textColor = NewColor;
    }else if (_indexPath.row == 0 && _isLast){
        verLineView.height = 0;
        pointView.backgroundColor = NewColor;
        statusLabel.textColor = NewColor;
        timeLabel.textColor = NewColor;
    }else if(_isLast && _indexPath.row != 0){
        verLineView.height = totalH/2;
        verLineView.minY = 0;
        pointView.backgroundColor = OldColor;
        statusLabel.textColor = OldColor;
        timeLabel.textColor = OldColor;
    }else{
        verLineView.height =totalH;
        verLineView.minY = 0;
        pointView.backgroundColor = OldColor;
        statusLabel.textColor = OldColor;
        timeLabel.textColor = OldColor;
    }
    
    return totalH;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
