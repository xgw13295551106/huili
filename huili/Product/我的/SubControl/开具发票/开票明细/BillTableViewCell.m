//
//  DrawBillTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BillTableViewCell.h"

@interface BillTableViewCell (){
    UILabel *time;
    UILabel *status;
    UIImageView *row;
    UILabel *priceLabel;
    UILabel *price;
    UILabel *type;
}


@end

@implementation BillTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        time=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
        [time setText:@"开票时间：2017-12-08 10:30"];
        [time setFont:[UIFont systemFontOfSize:14]];
        [time setTextColor:text2Color];
        [self addSubview:time];
        
        status=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-130, 0, 100, 30)];
        [status setText:@"待开票"];
        [status setTextColor:[UIColor colorWithHexString:@"ff0000"]];
        [self addSubview:status];
        [status setFont:[UIFont systemFontOfSize:15]];
        [status setTextAlignment:NSTextAlignmentRight];
        
        row=[[UIImageView alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-30, 0, 30, 30)];
        [row setImage:[UIImage imageNamed:@"next"]];
        [row setContentMode:UIViewContentModeCenter];
        [self addSubview:row];
        
        priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 100, 30)];
        [priceLabel setText:@"开票金额："];
        [priceLabel setTextColor:text1Color];
        [priceLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:priceLabel];
        [priceLabel sizeToFit];
        [priceLabel setFrame:CGRectMake(10, 30, priceLabel.width, 30)];
        
        price=[[UILabel alloc]initWithFrame:CGRectMake(priceLabel.right, priceLabel.y, 140, 30)];
        [price setText:@"30.00元"];
        [price setTextColor:[UIColor colorWithHexString:@"ff0000"]];
        [price setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:price];
        
        type=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH/2+20,price.y, 100, 30)];
        [type setText:@"电子发票"];
        [type setTextColor:text2Color];
        [type setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:type];
        
        
    }
    return self;
}

- (void)setModel:(DrawBillModel *)model{
    _model = model;
    time.text = [NSString stringWithFormat:@"开票时间:%@",model.time];
    price.text = [NSString stringWithFormat:@"%@元",model.price];
    type.text = model.type.intValue == 1?@"电子发票":@"纸质发票";
    if (model.status.intValue == 0) {
        status.text  =@"待开票";
        status.textColor = [UIColor colorWithHexString:@"FE0B0A"];
    }else if (model.status.intValue == 1){
        status.text = @"已开票";
        status.textColor = [UIColor colorWithHexString:@"42CAC4"];
    }else if (model.status.intValue == 2){
        status.text = @"已发出";
        status.textColor = STYLECOLOR;
    }else{
        status.text = @"待开票";
        status.textColor = [UIColor colorWithHexString:@"FE0B0A"];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
