//
//  LCBalanceTableCell.m
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "LCBalanceTableCell.h"

@interface LCBalanceTableCell (){
    UIImageView *leftImgView;   ///< 左侧图标
    UILabel *titleLabel;        ///< cell标题内容
    UIImageView *rightImgView;  ///< 右侧箭头img
}

@property (nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation LCBalanceTableCell

+ (instancetype)getMyPurseInfoCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier{
    LCBalanceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LCBalanceTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.indexPath = indexPath;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpControls];
    }
    return self;
}

- (void)setUpControls{
    leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 44/2-22.5/2, 22.5, 22.5)];
    leftImgView.contentMode = UIViewContentModeCenter;
    [self addSubview:leftImgView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImgView.frame)+8, leftImgView.origin.y, 200, 22.5)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"595A59"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    UIImage *image  = [UIImage imageNamed:@"next"];
    rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(win_width-12-image.size.width, 44/2-image.size.height/2, image.size.width, image.size.height)];
    [rightImgView setImage:image];
    [self addSubview:rightImgView];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [leftImgView setImage:[UIImage imageNamed:@"user_wallet_details"]];
            titleLabel.text = @"钱包明细";
        }else if (indexPath.row == 1){
            [leftImgView setImage:[UIImage imageNamed:@"user_wallet_points"]];
            titleLabel.text = @"积分明细";
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [leftImgView setImage:[UIImage imageNamed:@"user_wallet_withdraw"]];
            titleLabel.text = @"积分提现";
        }else if (indexPath.row == 1){
            [leftImgView setImage:[UIImage imageNamed:@"user_wallet_recharge"]];
            titleLabel.text = @"余额充值";
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [leftImgView setImage:[UIImage imageNamed:@"user_wallet_account"]];
            titleLabel.text = @"绑定账户";
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
