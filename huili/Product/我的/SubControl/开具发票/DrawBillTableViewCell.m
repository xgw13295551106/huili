//
//  DrawBillTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "DrawBillTableViewCell.h"

@interface DrawBillTableViewCell ()

@property(nonatomic)NSMutableArray *imgArray;

@property(nonatomic,weak)UIButton *selectBtn;

@property(nonatomic,weak)UILabel *price;

@property(nonatomic,weak)UILabel *order_sn;

@property(nonatomic,weak)UILabel *time;

@end

@implementation DrawBillTableViewCell

-(NSMutableArray*)imgArray{
    if (_imgArray==nil) {
        _imgArray=[[NSMutableArray alloc]init];
    }
    return _imgArray;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (int i=0; i<3; i++) {
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(40+85*i, 12.5, 70, 70)];
            [img setImage:DefaultsImg];
            [img setContentMode:UIViewContentModeScaleAspectFill];
            [img.layer setMasksToBounds:YES];
            [self addSubview:img];
            [self.imgArray addObject:img];
        }
        
        
        
        UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-120, 10, 110, 75)];
        _price=price;
        [price setFont:[UIFont boldSystemFontOfSize:16]];
        [price setTextColor:text1Color];
        [price setTextAlignment:NSTextAlignmentRight];
        [self addSubview:price];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(40, price.bottom+5, AL_DEVICE_WIDTH, 0.5)];
        [line setBackgroundColor:LineColor];
        [self addSubview:line];
        
        UILabel *order_sn=[[UILabel alloc]initWithFrame:CGRectMake(40, line.bottom, 210, 30)];
        [order_sn setFont:[UIFont systemFontOfSize:14]];
        [order_sn setTextColor:text2Color];
        [self addSubview:order_sn];
        _order_sn=order_sn;
        
        UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-160, line.bottom, 150, 30)];
        _time=time;
        [time setTextAlignment:NSTextAlignmentRight];
        [time setFont:[UIFont systemFontOfSize:14]];
        [time setTextColor:text2Color];
        [self addSubview:time];
        
        
        UIButton *selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 120)];
        [selectBtn setImage:[UIImage imageNamed:@"cart_button_select"] forState:UIControlStateSelected];
        [selectBtn setImage:[UIImage imageNamed:@"cart_button_unselect"] forState:UIControlStateNormal];
        [self addSubview:selectBtn];
        _selectBtn=selectBtn;
        [selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setModel:(BillModel *)model{
    _model=model;
    for (int i=0; i<self.imgArray.count; i++) {
        UIImageView *img=[self.imgArray objectAtIndex:i];
        [img setHidden:YES];
    }
    for (int i=0;i<model.imgArr.count; i++) {
        if (self.imgArray.count>i) {
            UIImageView *img=[self.imgArray objectAtIndex:i];
            [img setHidden:NO];
            [img sd_setImageWithURL:[NSURL URLWithString:[model.imgArr objectAtIndex:i]] placeholderImage:DefaultsImg];
        }
    }
    [_order_sn setText:[NSString stringWithFormat:@"订单号：%@",model.order_sn]];
    [_time setText:model.time];
    [_price setText:[NSString stringWithFormat:@"¥%@",model.price]];
    if (_model.isSelect) {
        [_selectBtn setSelected:YES];
    }else{
        [_selectBtn setSelected:NO];
    }
    if (_noSelect) {
        _selectBtn.hidden = YES;
    }else{
        _selectBtn.hidden = NO;
    }
}

-(void)selectClick{
    if (_selectBtn.selected) {
        [_selectBtn setSelected:NO];
        _model.isSelect=NO;
    }else{
        [_selectBtn setSelected:YES];
        _model.isSelect=YES;
    }
    if ([self.delegate respondsToSelector:@selector(checkPrice)]) {
        [self.delegate checkPrice];
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
