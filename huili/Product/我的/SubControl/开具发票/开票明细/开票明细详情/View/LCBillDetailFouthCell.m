//
//  LCBillDetailFouthCell.m
//  YeFu
//
//  Created by zhongweike on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCBillDetailFouthCell.h"
#import "LCIndetailModel.h"
#import "LCTextCardView.h"

#define CardView_h 40
#define RightLabel_x 120
#define RightLabel_w win_width -8 -RightLabel_x
#define RightLaebl_h 20

@interface LCBillDetailFouthCell (){
    LCTextCardView *cardView1;   ///< 发票类型
    LCTextCardView *cardView2;   ///< 发票抬头
    LCTextCardView *cardView3;   ///< 纳税人识别号
    LCTextCardView *cardView4;   ///< 发票内容
    LCTextCardView *cardView5;   ///< 发票金额
    LCTextCardView *cardView6;   ///< 申请时间
    
    UILabel *typeLabel;
    UILabel *titleTextLabel;     ///< 发票抬头
    UILabel *numLabel;           ///< 纳税人识别号
    UILabel *contentLabel;
    UILabel *moneyLabel;
    UILabel *timeLabel;
}


@end

@implementation LCBillDetailFouthCell


+ (instancetype)getBillDetailFouthCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andModel:(LCIndetailModel *)model{
    LCBillDetailFouthCell *cell = [[LCBillDetailFouthCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    [cell setInfoWith:model];
    return cell;
}

+ (CGFloat)getBillDetailFouthCellHeight{
    return 15+20+10+1+6*CardView_h;
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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 200, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"565756"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"发票信息";
    [self addSubview:titleLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.minX-5, titleLabel.maxY+10, win_width-2*(titleLabel.minX-5), 1)];
    [lineView1 setBackgroundColor:LineColor];
    [self addSubview:lineView1];
    
    
    cardView1 = [LCTextCardView getViewWith:CGRectMake(0, lineView1.maxY, win_width, CardView_h) andText:@"发票类型:" andPosition:CenterPosition];
    [self addSubview:cardView1];
    typeLabel = [self getRightLabel];
    [cardView1 addSubview:typeLabel];
    //-----------
    cardView2 = [LCTextCardView getViewWith:CGRectMake(0, cardView1.maxY, win_width, CardView_h) andText:@"发票抬头:" andPosition:CenterPosition];
    [self addSubview:cardView2];
    titleTextLabel = [self getRightLabel];
    [cardView2 addSubview:titleTextLabel];
    //------------
    cardView3 = [LCTextCardView getViewWith:CGRectMake(0, cardView2.maxY, win_width, CardView_h) andText:@"纳税人识别号:" andPosition:CenterPosition];
    [self addSubview:cardView3];
    numLabel = [self getRightLabel];
    [cardView3 addSubview:numLabel];
    //-------------
    cardView4 = [LCTextCardView getViewWith:CGRectMake(0, cardView3.maxY, win_width, CardView_h) andText:@"发票内容:" andPosition:CenterPosition];
    [self addSubview:cardView4];
    contentLabel = [self getRightLabel];
    [cardView4 addSubview:contentLabel];
    //-------------
    cardView5 = [LCTextCardView getViewWith:CGRectMake(0, cardView4.maxY, win_width, CardView_h) andText:@"发票金额:" andPosition:CenterPosition];
    [self addSubview:cardView5];
    moneyLabel = [self getRightLabel];
    [cardView5 addSubview:moneyLabel];
    //--------------
    cardView6 = [LCTextCardView getViewWith:CGRectMake(0, cardView5.maxY, win_width, CardView_h) andText:@"申请时间:" andPosition:CenterPosition];
    [self addSubview:cardView6];
    timeLabel = [self getRightLabel];
    [cardView6 addSubview:timeLabel];
}

- (UILabel *)getRightLabel{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(RightLabel_x,CardView_h/2-RightLaebl_h/2, RightLabel_w, RightLaebl_h)];
    label.textColor = [UIColor colorWithHexString:@"545554"];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;

    return label;
}

- (CGFloat)setInfoWith:(LCIndetailModel *)model{
    CGFloat totalH = 0;
    
    typeLabel.text = model.flag.intValue == 1?@"普通发票":@"专用发票";
    titleTextLabel.text = model.title;
    numLabel.text = model.taxpayer_identity;
    contentLabel.text = model.content;
    moneyLabel.text = [NSString stringWithFormat:@"%@元",model.amount];
    timeLabel.text = model.created_at;
    
    return totalH;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
