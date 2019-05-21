//
//  LCEditHeadImgCell.m
//  StudioRecognition
//
//  Created by zhongweike on 2017/10/11.
//  Copyright © 2017年 zhongweike. All rights reserved.
//

#import "LCEditHeadImgCell.h"

@interface LCEditHeadImgCell ()

@property (nonatomic,strong)UIImageView *headImgView;
@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation LCEditHeadImgCell

+ (instancetype)getEditHeadImgCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier{
    //这里只用到一个，就不写复用了
    LCEditHeadImgCell *cell = [[LCEditHeadImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    UserInfoModel *userInfo = [UserInfoManager currentUser];
    
    //左侧标题
    CGFloat nameLabel_x = 25;
    CGFloat nameLabel_h = 22;
    CGFloat nameLabel_w = 100;
    CGFloat nameLabel_y = 90/2 - nameLabel_h/2;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel_x, nameLabel_y, nameLabel_w, nameLabel_h)];
    _titleLabel.textColor = [UIColor colorWithHexString:@"2D2D30"];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"头像";
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    
    //右侧箭头图片
    UIImage *rightImage = [UIImage imageNamed:@"order_button_arrows_def"];
    UIImageView *rightImgView = [[UIImageView alloc]initWithImage:rightImage];
    [rightImgView sizeToFit];
    [rightImgView setFrame:CGRectMake(win_width-10-rightImgView.width, 90/2-rightImgView.height/2, rightImgView.width, rightImgView.height)];
    [self addSubview:rightImgView];
    
    //头像图片
    CGFloat headImgView_w = 65;
    CGFloat headImgView_h = headImgView_w;
    CGFloat headImgView_x = rightImgView.minX - 15 - headImgView_w;
    CGFloat headImgView_y = 12.5;
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(headImgView_x, headImgView_y, headImgView_w, headImgView_h)];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.img] placeholderImage:[UIImage imageWithColor:LineColor]];
    _headImgView.layer.cornerRadius = headImgView_w/2;
    _headImgView.layer.masksToBounds = YES;
    [self addSubview:_headImgView];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 89.5, AL_DEVICE_WIDTH, 0.5)];
    [line setBackgroundColor:LineColor];
    [self addSubview:line];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
