//
//  WalletListTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "WalletListTableViewCell.h"

@interface WalletListTableViewCell (){
    UILabel *title;
    UILabel *price;
    UILabel *time;
    UILabel *type;
}


@end

@implementation WalletListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title =[[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, 150, 30)];
        [title setText:@"钱包充值"];
        [title setTextColor:text1Color];
        [title setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:title];
        
        price=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-140, 2.5, 130, 30)];
        [price setTextColor:STYLECOLOR];
        [price setFont:[UIFont boldSystemFontOfSize:16]];
        [price setTextAlignment:NSTextAlignmentRight];
        [price setText:@"+150.00"];
        [self addSubview:price];
        
        time=[[UILabel alloc]initWithFrame:CGRectMake(10, title.bottom, 200, 30)];
        [time setText:@"2017-08-06 10:20"];
        [time setTextColor:text2Color];
        [time setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:time];
        
        type=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-130, title.bottom, 120, 30)];
        [type setText:@"充值成功"];
        [type setTextAlignment:NSTextAlignmentRight];
        [type setTextColor:text2Color];
        [type setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:type];
        
    }
    return self;
}

-(void)setModel:(WalletListModel *)model{
    _model=model;
    
    title.text = model.remark;
    time.text = model.created_at;
    type.text = model.name;
    if ([model.flag isEqualToString:@"+"]) {
        price.text = [NSString stringWithFormat:@"+%@",model.money];
        price.textColor = [UIColor colorWithHexString:@"E7010D"];
    }else{
        price.text = [NSString stringWithFormat:@"-%@",model.money];
        price.textColor = [UIColor colorWithHexString:@"545554"];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
