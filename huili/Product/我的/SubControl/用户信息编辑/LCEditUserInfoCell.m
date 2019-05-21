//
//  LCEditUserInfoCell.m
//  StudioRecognition
//
//  Created by zhongweike on 2017/10/11.
//  Copyright © 2017年 zhongweike. All rights reserved.
//

#import "LCEditUserInfoCell.h"

@interface LCEditUserInfoCell ()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation LCEditUserInfoCell

+ (instancetype)getEditUserInfoCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier{
    LCEditUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LCEditUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.indexPath = indexPath;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setupControls];
    }
    return self;
}

//设置UI布局
- (void)setupControls{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 56/2-20/2, 100, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"2D2D30"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    //右侧箭头图片
    UIImage *rightImage = [UIImage imageNamed:@"order_button_arrows_def"];
    UIImageView *rightImgView = [[UIImageView alloc]initWithImage:rightImage];
    [rightImgView sizeToFit];
    [rightImgView setFrame:CGRectMake(win_width-10-rightImgView.width, 56/2-rightImgView.height/2, rightImgView.width, rightImgView.height)];
    [self addSubview:rightImgView];
    
    CGFloat detailL_x = self.titleLabel.maxX +8;
    CGFloat detailL_w = rightImgView.minX - detailL_x  - 15;
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailL_x, self.titleLabel.minY, detailL_w, 20)];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.textColor = [UIColor colorWithHexString:@"545554"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.detailLabel];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 55.5, AL_DEVICE_WIDTH, 0.5)];
    [line setBackgroundColor:LineColor];
    [self addSubview:line];
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    UserInfoModel *userInfo = [UserInfoManager currentUser];
    
    switch (indexPath.section) {
        case 1://昵称
            {
                self.titleLabel.text = @"昵称";
                self.detailLabel.text = userInfo.name;
            }
            break;
        case 2://性别
        {
            self.titleLabel.text = @"手机";
            self.detailLabel.text = userInfo.hidlogin;
        }
            break;
        case 3://手机号
        {
            self.titleLabel.text = @"邮箱";
            self.detailLabel.text = userInfo.email;
        }
            break;
            
        default:
            break;
    }
    
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
