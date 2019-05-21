//
//  LCBillDetailSecondCell.m
//  YeFu
//
//  Created by zhongweike on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCBillDetailSecondCell.h"
#import "LCIndetailModel.h"

@interface LCBillDetailSecondCell (){
    UILabel *titleLabel; ///< 状态label
    UILabel *timeLabel;
    UILabel *numLabel;   ///< 快递单号
}


@end

@implementation LCBillDetailSecondCell

+ (instancetype)getBillDetailSecondCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andModel:(LCIndetailModel *)model{
    LCBillDetailSecondCell *cell = [[LCBillDetailSecondCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    [cell setInfoWith:model];

    return cell;
}

+ (CGFloat)getBillDetailSecondCellHeight:(LCIndetailModel *)model{
    if (model.status.intValue == 1) {
        return 78;
    }else{
        return 106;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpControls];
    }
    return self;
}

- (void)setUpControls{
    //状态
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, win_width-15*2, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"36C7C0"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"发票已开具";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    //快递单号(纸质发票)
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.minX, titleLabel.maxY+8, titleLabel.width, titleLabel.height)];
    numLabel.textColor = [UIColor colorWithHexString:@"36C7C0"];
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.text = @"快递单号:";
    numLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:numLabel];
    
    //时间label
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.minX, numLabel.maxY+8, titleLabel.width, titleLabel.height)];
    timeLabel.textColor = [UIColor colorWithHexString:@"9E9F9E"];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.text = @"2017-11-13 18:01:03";
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:timeLabel];
}

- (CGFloat)setInfoWith:(LCIndetailModel *)model{
    CGFloat totalH = 0;
    
    if (model.status.intValue == 1) {
        titleLabel.text = @"电子发票已开具，请前往邮箱查看";
        timeLabel.minY = titleLabel.maxY+8;
        numLabel.hidden = YES;
    }else if (model.status.intValue == 2){
        titleLabel.text = @"纸质发票已发出";
        numLabel.text = [NSString stringWithFormat:@"快递单号:%@",model.track_num];
        timeLabel.minY = numLabel.maxY +8;
        numLabel.hidden = NO;
    }
    
    timeLabel.text = model.created_at;
    
    
    
    return totalH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
