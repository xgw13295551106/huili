//
//  LCBillDetailThirdCell.m
//  YeFu
//
//  Created by zhongweike on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCBillDetailThirdCell.h"
#import "LCIndetailModel.h"

#define RightLabel_x 85
#define RightLabel_w win_width -8 -RightLabel_x
#define RightLabel_h 20

@interface LCBillDetailThirdCell (){
    UILabel *emailTitle;
    UILabel *emailLabel;       ///< 电子邮件
    UILabel *addressTitle;
    UILabel *addressLabel;     ///< 详细地址
    UILabel *contactTitle;
    UILabel *contactLabel;     ///< 收件人
}




@end

@implementation LCBillDetailThirdCell

+ (instancetype)getBillDetailThirdCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andModel:(LCIndetailModel *)model{
    LCBillDetailThirdCell *cell = [[LCBillDetailThirdCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    [cell setInfoWith:model];
    return cell;
}

+ (CGFloat)getBillDetailThirdCellHeight:(LCIndetailModel *)model{
    if (model.type.intValue == 1) {
        return 15+20+10+1+15+20+15;
    }else{
        CGSize address_size = [YHHelpper textSizeWithMaxSize:CGSizeMake(RightLabel_w, MAXFLOAT) font:[UIFont systemFontOfSize:14] text:model.address_info];
        address_size.height = address_size.height<RightLabel_h?RightLabel_h:address_size.height;
        
        return 15+20+10+1+15+address_size.height+8+20+15;
    }
    return 0;
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
    titleLabel.text = @"收件信息";
    [self addSubview:titleLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.minX-5, titleLabel.maxY+10, win_width-2*(titleLabel.minX-5), 1)];
    [lineView1 setBackgroundColor:LineColor];
    [self addSubview:lineView1];
    //电子邮件
    emailTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, lineView1.maxY+15, 80, 20)];
    emailTitle.textColor = [UIColor colorWithHexString:@"9A9B9A"];
    emailTitle.font = [UIFont systemFontOfSize:14];
    emailTitle.text = @"电子邮件：";
    emailTitle.textAlignment = NSTextAlignmentLeft;
    [self addSubview:emailTitle];
    
    emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(RightLabel_x, emailTitle.minY, RightLabel_w, emailTitle.height)];
    emailLabel.textColor = [UIColor colorWithHexString:@"727372"];
    emailLabel.font = [UIFont systemFontOfSize:14];
    emailLabel.text = @"";
    emailLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:emailLabel];
    
    //详细地址
    addressTitle = [[UILabel alloc]initWithFrame:emailTitle.frame];
    addressTitle.textColor = [UIColor colorWithHexString:@"9A9B9A"];
    addressTitle.font = [UIFont systemFontOfSize:14];
    addressTitle.text = @"详细地址：";
    addressTitle.textAlignment = NSTextAlignmentLeft;
    [self addSubview:addressTitle];
    
    addressLabel = [[UILabel alloc]initWithFrame:emailLabel.frame];
    addressLabel.textColor = [UIColor colorWithHexString:@"727372"];
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.numberOfLines = 0;
    [self addSubview:addressLabel];
    
    //收货人
    contactTitle = [[UILabel alloc]initWithFrame:CGRectMake(addressTitle.minX, addressTitle.maxY+8, addressTitle.width, addressTitle.height)];
    contactTitle.textColor = [UIColor colorWithHexString:@"9A9B9A"];
    contactTitle.font = [UIFont systemFontOfSize:14];
    contactTitle.text = @"收件人：";
    [self addSubview:contactTitle];
    
    contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(RightLabel_x, contactTitle.minY, RightLabel_w, RightLabel_h)];
    contactLabel.textColor = [UIColor colorWithHexString:@"727372"];
    contactLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:contactLabel];
    
}

- (CGFloat)setInfoWith:(LCIndetailModel *)model{
    CGFloat totalH = 0;
    
    if (model.type.intValue == 1) {//电子
        emailLabel.text = model.email;
        emailLabel.hidden = NO;
        emailTitle.hidden = NO;
        addressLabel.hidden = YES;
        addressTitle.hidden = YES;
        contactTitle.hidden = YES;
        contactLabel.hidden = YES;
    }else{ //纸质
        addressLabel.text = model.address_info;
        CGSize address_size = [addressLabel sizeThatFits:CGSizeMake(RightLabel_w, MAXFLOAT)];
        if (address_size.height<RightLabel_h) {
            address_size.height = RightLabel_h;
        }
        addressLabel.size = address_size;
        
        contactTitle.minY = addressLabel.maxY +8;
        contactLabel.minY = contactTitle.minY;
        contactLabel.text = [NSString stringWithFormat:@"%@ %@",model.name,model.mobile];
        emailLabel.hidden = YES;
        emailTitle.hidden = YES;
        addressLabel.hidden = NO;
        addressTitle.hidden = NO;
        contactTitle.hidden = NO;
        contactLabel.hidden = NO;
    }
    
    
    return totalH;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
