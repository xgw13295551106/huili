//
//  JifenListTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "JifenListTableViewCell.h"

@interface JifenListTableViewCell (){
    UILabel *title;
    UILabel *price;
    UILabel *time;
    
}


@end

@implementation JifenListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title=[[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, 150, 30)];
        [title setText:@"消费成功"];
        [title setTextColor:text1Color];
        [title setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:title];
        
        price=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-140, 2.5, 130, 60)];
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
        
    }
    return self;
}

- (void)setModel:(JifenModel *)model{
    _model = model;
    title.text = model.name;
    time.text = model.created_at;
    if ([model.flag isEqualToString:@"+"]) {
        price.text = [NSString stringWithFormat:@"+%@",model.integral];
        price.textColor = [UIColor colorWithHexString:@"37C7C1"];
    }else{
        price.text = [NSString stringWithFormat:@"-%@",model.integral];
        price.textColor = [UIColor colorWithHexString:@"EC4D4C"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
