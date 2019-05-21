//
//  CartTableViewCell.m
//  yihuo
//
//  Created by Carl on 2017/12/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "CartTableViewCell.h"

#import "PPNumberButton.h"

@interface CartTableViewCell ()<PPNumberButtonDelegate>
@property(nonatomic,weak)UIImageView *img;
@property(nonatomic,weak)UILabel *name;
@property(nonatomic,weak)UILabel *goods_des;
@property(nonatomic,weak)UILabel *goods_price;
@property(nonatomic,weak)PPNumberButton *numberButton;
@property(nonatomic,weak)UIButton *addCart;
@property(nonatomic,weak)UIButton *selectBtn;

@end

@implementation CartTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(10*PROPORTION, 15*PROPORTION, 100*PROPORTION, 100*PROPORTION)];
        [img setImage:DefaultsImg];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [img.layer setMasksToBounds:YES];
        [self addSubview:img];
        _img=img;
        
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(img.right+10*PROPORTION, 10*PROPORTION, AL_DEVICE_WIDTH-(img.right+20*PROPORTION), 50*PROPORTION)];
        [name setTextColor:text1Color];
        [name setNumberOfLines:2];
        [name setFont:[UIFont boldSystemFontOfSize:18*PROPORTION]];
        [self addSubview:name];
        _name=name;
        
        UILabel *goods_des=[[UILabel alloc]initWithFrame:CGRectMake(img.right+10*PROPORTION, name.bottom, AL_DEVICE_WIDTH-(img.right+20*PROPORTION), 25*PROPORTION)];
        [goods_des setTextColor:text2Color];
        [goods_des setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:goods_des];
        _goods_des=goods_des;
        
        UILabel *goods_price=[[UILabel alloc]initWithFrame:CGRectMake(img.right+10, goods_des.bottom, AL_DEVICE_WIDTH-(img.right+20*PROPORTION), 30*PROPORTION)];
        [goods_price setTextColor:[UIColor colorWithHexString:@"f23030"]];
        [goods_price setFont:[UIFont boldSystemFontOfSize:17]];
        [self addSubview:goods_price];
        _goods_price=goods_price;
        
        
        UIButton *addCart=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-100, goods_price.y, 80, 30)];
        [addCart setTitle:@"加入购物车" forState:UIControlStateNormal];
        [addCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addCart.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:addCart];
        [addCart setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
        [addCart setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [addCart.layer setCornerRadius:5];
        _addCart=addCart;
        [addCart addTarget:self action:@selector(addCartClick) forControlEvents:UIControlEventTouchUpInside];
        addCart.hidden = YES;
        
        PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(AL_DEVICE_WIDTH-90, goods_price.y, 80, 25)];
        numberButton.delegate = self;
        // 初始化时隐藏减按钮
        numberButton.decreaseHide = YES;
        numberButton.shakeAnimation = YES;
        numberButton.borderColor = [UIColor grayColor];
        numberButton.increaseTitle = @"＋";
        numberButton.decreaseTitle = @"－";
        numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
            _model.goods_ammount = (int)num;
            [self addCartNet];
            [self checkAmount];
        };
        [self addSubview:numberButton];
        _numberButton=numberButton;
        
        UIButton *selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 130*PROPORTION)];
        [selectBtn setImage:[UIImage imageNamed:@"common_icon_select"] forState:UIControlStateSelected];
        [selectBtn setImage:[UIImage imageNamed:@"common_icon_unselect"] forState:UIControlStateNormal];
        [self addSubview:selectBtn];
        _selectBtn=selectBtn;
        [selectBtn setHidden:YES];
        [selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
#pragma mark - PPNumberButtonDelegate
//- (void)pp_numberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
//{
//    _model.goods_ammount = (int)number;
//    [self checkAmount];
//}
-(void)setModel:(CartListModel *)model{
    _model=model;
    if (_model.goods_ammount>0) {
        [_numberButton setHidden:NO];
        [_addCart setHidden:YES];
    }else{
        [_numberButton setHidden:YES];
        [_addCart setHidden:NO];
    }
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.goods_img] placeholderImage:DefaultsImg];
    [_name setText:_model.goods_name];
    [_goods_des setText:_model.attr_names];
    
    [_goods_price setText:[NSString stringWithFormat:@"￥%@",_model.goods_price]];
    _numberButton.currentNumber=_model.goods_ammount;
    [self checkAmount];
    [self checkFram];
    
    if (_model.isSelect) {
        [_selectBtn setSelected:YES];
    }else{
        [_selectBtn setSelected:NO];
    }
    
    [_numberButton setMaxValue:[_model.inventory intValue]];
    
    [_img setFrame:CGRectMake(40*PROPORTION, 15*PROPORTION, 100*PROPORTION, 100*PROPORTION)];
    [self checkFram];
    [_selectBtn setHidden:NO];
}

-(void)addCartClick{
    _numberButton.currentNumber = 1;
    _model.goods_ammount=1;
    [self addCartNet];
    [self checkAmount];
}

-(void)checkAmount{
    if (_model.goods_ammount>0) {
        [_numberButton setHidden:NO];
        [_addCart setHidden:YES];
    }else{
        [_numberButton setHidden:YES];
        [_addCart setHidden:NO];
        if ([self.delegate respondsToSelector:@selector(delectCell:)]) {
            [self.delegate delectCell:_model];
        }
    }
    if ([self.delegate respondsToSelector:@selector(checkPrice)]) {
        [self.delegate checkPrice];
    }
    _addCart.hidden = YES;
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

-(void)checkFram{
    [_name setFrame:CGRectMake(_img.right+10*PROPORTION, 10*PROPORTION, AL_DEVICE_WIDTH-(_img.right+20*PROPORTION), 50*PROPORTION)];
    [_goods_des setFrame:CGRectMake(_img.right+10*PROPORTION, _name.bottom, AL_DEVICE_WIDTH-(_img.right+20*PROPORTION), 25*PROPORTION)];
    [_goods_price sizeToFit];
    [_goods_price setFrame:CGRectMake(_img.right+10, _goods_des.bottom, _goods_price.width, 30*PROPORTION)];
}


-(void)addCartNet{
    NSMutableDictionary *parma=[[NSMutableDictionary alloc]init];
    [parma setValue:TOKEN forKey:@"token"];
    [parma setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [parma setValue:[NSString stringWithInt:(int)_numberButton.currentNumber] forKey:@"num"];
    [parma setValue:_model.goods_id forKey:@"goods_id"];
    [parma setValue:_model.attr_ids forKey:@"attr_ids"];
    [[XAClient sharedClient]postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,AddCart] withParam:parma success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSDictionary *dic=[responseObject objectForKey:@"data"];
//            _model.goods_ammount=[dic intForKey:@"num"];
            [self checkAmount];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_CartChange object:nil userInfo:nil];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
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
