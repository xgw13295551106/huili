//
//  LCUserInfoCell.m
//  zhuaWaWa
//
//  Created by zhongweike on 2017/11/24.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCUserInfoCell.h"

@interface LCUserInfoCell ()

@property (strong, nonatomic) UIImageView *leftImgView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIImageView *rightImgView;
@property (nonatomic,strong) UserInfoCellBlock block;

@end

@implementation LCUserInfoCell

+ (instancetype)getUserInfoCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andArray:(NSArray *)dataArray andBlock:(UserInfoCellBlock)block{
    LCUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LCUserInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.block = block;
    }
    [cell setInfoWith:dataArray andIndex:indexPath];
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
    CGFloat imgView_x = 15;
    CGFloat imageView_w = 20;
    CGFloat imageView_h = imageView_w;
    CGFloat imageView_y = 50/2 - imageView_h/2;
    _leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgView_x, imageView_y, imageView_w, imageView_h)];
    _leftImgView.contentMode = UIViewContentModeCenter;
    [self addSubview:_leftImgView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_leftImgView.maxX+10, _leftImgView.minY, 120, _leftImgView.height)];
    _titleLabel.textColor = [UIColor colorWithHexString:@"383938"];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    
    CGFloat rightImgView_w = 8;
    CGFloat rightImgView_h = 15;
    CGFloat rightImgView_x = win_width - rightImgView_w - 10;
    CGFloat rightImgView_y = 50/2 - rightImgView_h/2;
    _rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(rightImgView_x, rightImgView_y, rightImgView_w, rightImgView_h)];
    [_rightImgView setImage:[UIImage imageNamed:@"next"]];
    [self addSubview:_rightImgView];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_rightImgView.minX -10 -150, _leftImgView.minY, 150, _leftImgView.height)];
    _detailLabel.textColor = [UIColor colorWithHexString:@"989998"];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_detailLabel];
    
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDetailLabelWith:)];
    [_detailLabel addGestureRecognizer:tap];
}

- (void)setInfoWith:(NSArray *)dataArray andIndex:(NSIndexPath *)indexPath{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    NSArray *array = dataArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    NSString *idString = dic[@"id"];
    [_leftImgView setImage:[UIImage imageNamed:dic[@"image"]]];
    _titleLabel.text = dic[@"name"];
    //当不是显示清除缓存时，显示箭头
    _rightImgView.hidden = NO;
    [_detailLabel setFrame:CGRectMake(_rightImgView.minX -10 -150, _leftImgView.minY, 150, _leftImgView.height)];
    _detailLabel.textColor = [UIColor colorWithHexString:@"989998"];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.userInteractionEnabled = NO;
    
    if ([idString isEqualToString:@"0"]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _detailLabel.text = @"26";
        _rightImgView.hidden = YES;
        _detailLabel.text = @"充值";
        [_detailLabel setFrame:CGRectMake(win_width -10 -70, 11, 70, 28)];
        _detailLabel.backgroundColor = STYLECOLOR;
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.layer.cornerRadius = _detailLabel.height/2;
        _detailLabel.layer.masksToBounds = YES;
        _titleLabel.text = @"0";
        _detailLabel.userInteractionEnabled = YES;
    }else if ([idString isEqualToString:@"10"]){
        _rightImgView.hidden = YES;
        _detailLabel.text = @"";
        
    }else if ([idString isEqualToString:@"9"]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _detailLabel.text = @"version 1.0.0";
        [_detailLabel setFrame:CGRectMake(win_width -10 -120, 11, 120, 28)];
        _rightImgView.hidden = YES;
    }
    
    
    
}

//点击detailLabel触发事件（仅充值时调用）
- (void)touchDetailLabelWith:(UIGestureRecognizer *)gesture{
    if (self.block) {
        self.block(YES);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
