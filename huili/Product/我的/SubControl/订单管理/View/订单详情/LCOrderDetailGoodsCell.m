//
//  LCOrderDetailGoodsCell.m
//  yihuo
//
//  Created by zhongweike on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCOrderDetailGoodsCell.h"
#import "LCMyOrderDetailModel.h"
#import "LCMyOrderGoodsModel.h"

@interface LCOrderDetailGoodsCell (){
    UIImageView *goodsImgView;   ///< 商品图片
    UILabel *goodsNameLabel;     ///< 商品名
    UILabel *formatLabel;        ///< 商品分类规格
    UILabel *priceLaebl;         ///< 商品价格
    UILabel *numLabel;           ///< 购买的数量
    UIButton *refundButton;      ///< 申请售后
}
@property (nonatomic,strong)LCMyOrderGoodsModel *goodsModel;
@property (nonatomic,strong)OrderDetailGoodsBlock goodsBlock;
@property (nonatomic,assign)BOOL isRefund;   ///< 是否为拒绝

@end

@implementation LCOrderDetailGoodsCell

+ (instancetype)getOrderDetailGoodsCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andModel:(LCMyOrderGoodsModel *)model andBlock:(OrderDetailGoodsBlock)block andType:(BOOL)isRefund{
    LCOrderDetailGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LCOrderDetailGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.goodsBlock = block;
    cell.isRefund = isRefund;
    [cell setInfoWith:model];
    return cell;
}

+ (CGFloat)getOrderDetailGoodsCellHeight{
    return 100;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpControls];
    }
    return self;
}

- (void)setUpControls{
    //商品图片
    goodsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 80, 80)];
    [goodsImgView setImage:DefaultsImg];
    [self addSubview:goodsImgView];
    
    //商品名
    CGFloat nameLabel_x = goodsImgView.maxX+8;
    CGFloat nameLabel_w = win_width-15-nameLabel_x;
    goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel_x, goodsImgView.minY-2,nameLabel_w, 35)];
    goodsNameLabel.textColor = [UIColor colorWithHexString:@"2B2B2E"];
    goodsNameLabel.font = [UIFont systemFontOfSize:13];
    goodsNameLabel.numberOfLines = 2;
    [self addSubview:goodsNameLabel];
    
    //商品数量
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(win_width-10-50, goodsImgView.centerY-5, 50, 18)];
    numLabel.textColor = [UIColor colorWithHexString:@"6E707B"];
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:numLabel];
    
    //分类
    formatLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsNameLabel.minX, goodsImgView.centerY-5, 180, 18)];
    formatLabel.textColor = [UIColor colorWithHexString:@"6E707B"];
    formatLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:formatLabel];
    
    //申请售后
    refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refundButton setFrame:CGRectMake(win_width-10-80, goodsImgView.maxY-25, 80, 25)];
    [refundButton setTitle:@"申请售后" forState:UIControlStateNormal];
    [refundButton setTitleColor:[UIColor colorWithHexString:@"80828E"] forState:UIControlStateNormal];
    refundButton.titleLabel.font = [UIFont systemFontOfSize:14];
    refundButton.layer.cornerRadius = 2;
    refundButton.layer.masksToBounds = YES;
    refundButton.layer.borderColor = [[UIColor colorWithHexString:@"80828E"]  CGColor];
    refundButton.layer.borderWidth = 1;
    [self addSubview:refundButton];
    [refundButton addTarget:self action:@selector(clickRefundButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //金额
    priceLaebl = [[UILabel alloc]initWithFrame:CGRectMake(goodsNameLabel.minX, refundButton.minY, refundButton.minX-8-goodsNameLabel.minX, refundButton.height)];
    [self addSubview:priceLaebl];
}

- (CGFloat)setInfoWith:(LCMyOrderGoodsModel *)model{
    CGFloat totalH = 0;
    _goodsModel = model;
    
    [goodsImgView sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:DefaultsImg];
    goodsNameLabel.text = model.goods_name;
    NSString *number = [NSString stringIsNull:model.goods_num]?model.number:model.goods_num;
    numLabel.text = [NSString stringWithFormat:@"x%@",number];
    [numLabel sizeToFit];
    [numLabel setFrame:CGRectMake(win_width-10-numLabel.width, goodsImgView.centerY-5, numLabel.width, 18)];
    formatLabel.text = model.attr_names;
    formatLabel.width = numLabel.minX - 8 -goodsNameLabel.minX;
    
    NSString *priceStr = [NSString stringIsNull:model.goods_amount]?model.price:model.goods_amount;
    priceLaebl.attributedText = [self setAttributedStringStyleWithFirst:priceStr second:@""];
    refundButton.hidden = !_isRefund;
    
    
    return totalH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//TODO:点击申请售后
- (void)clickRefundButton:(UIButton *)button{
    if (self.goodsBlock) {
        self.goodsBlock(self.goodsModel);
    }
}


/**
 创建富文本对象并返回
 
 @param string1 第一段文字
 @param string2 第二段文字
 @return 返回创建好的富文本
 */
- (NSMutableAttributedString *)setAttributedStringStyleWithFirst:(NSString *)string1 second:(NSString *)string2 {
   
    NSString *first_string = [NSString stringWithFormat:@"￥%@",string1];
    NSString *second_string = [NSString stringWithFormat:@" %@",string2];

    NSString *totalString = [NSString stringWithFormat:@"%@%@",first_string,second_string];
    //找到各个string在总字符串中的位置
    NSRange first_range = [totalString rangeOfString:first_string];
    NSRange second_range = [totalString rangeOfString:second_string];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:totalString];
    //易货币金额的格式
    [str addAttribute:NSForegroundColorAttributeName value:STYLECOLOR range:first_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:first_range];
    //易货币的格式
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"D71E25"] range:second_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:second_range];
    
    return str;
}


@end
