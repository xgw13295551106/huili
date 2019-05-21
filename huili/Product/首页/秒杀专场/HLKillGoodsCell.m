//
//  HLKillGoodsCell.m
//  huili
//
//  Created by zhongweike on 2018/1/9.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "HLKillGoodsCell.h"
#import "GoodsModel.h"

#define cell_height 120

@interface HLKillGoodsCell (){
    UIImageView *goodsImgView;   ///< 商品图片
    UILabel *nameLabel;          ///< 商品名
    UILabel *priceLabel;         ///< 秒杀价
    UILabel *oldLabel;           ///< 原价label
    UIButton *buyButton;         ///< 抢购button
}

@property (nonatomic,strong)GoodsModel *goodsModel;
@property (nonatomic,strong)KillGoodsBlock killBlock;

@end

@implementation HLKillGoodsCell

+ (CGFloat)getKillGoodsCellHeight{
    return cell_height;
}

+ (instancetype)getKillGoodsCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifer:(NSString *)identifier andModel:(GoodsModel *)model andBlock:(KillGoodsBlock)killBlock{
    HLKillGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HLKillGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.killBlock = killBlock;
    [cell setInfoWith:model];
    
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
    CGFloat img_h = cell_height - 2*10;
    CGFloat img_w = img_h;
    goodsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, img_w, img_h)];
    [self addSubview:goodsImgView];
    
    //商品名
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsImgView.maxX+8, goodsImgView.minY, win_width-8-(goodsImgView.maxX+8), 36)];
    nameLabel.textColor = [UIColor colorWithHexString:@"373837"];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.numberOfLines = 2;
    [self addSubview:nameLabel];
    
    //立即抢购
    buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setFrame:CGRectMake(nameLabel.maxX-80, goodsImgView.maxY-30, 80, 30)];
    [buyButton setBackgroundColor:STYLECOLOR];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    buyButton.layer.cornerRadius = 2;
    buyButton.layer.masksToBounds = YES;
    [buyButton addTarget:self action:@selector(clickBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buyButton];
    
    //原价
    oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.minX, goodsImgView.maxY-22, buyButton.minX-5-nameLabel.minX, 22)];
    oldLabel.textColor = [UIColor colorWithHexString:@"A19FA1"];
    oldLabel.font = [UIFont systemFontOfSize:16];
    oldLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:oldLabel];
    
    //价格label
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(oldLabel.minX, oldLabel.minY-3-22, oldLabel.width, 22)];
    priceLabel.textColor = STYLECOLOR;
    priceLabel.font = [UIFont systemFontOfSize:20];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:priceLabel];
    
    
    
}

- (CGFloat)setInfoWith:(GoodsModel *)model{
    CGFloat totalH = 0;
    _goodsModel = model;
    
    //赋值
    [goodsImgView sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:DefaultsImg];
    nameLabel.text = model.goods_name;
    priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    oldLabel.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"￥%@",model.super_price]];
    
    return totalH;
}


- (NSMutableAttributedString *)getAttributedStr:(NSString *)string{
    
    //中划线
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,string.length)];
    
    [attributeMarket addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    
    return attributeMarket;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickBuyButton:(UIButton *)button{
    if (self.killBlock) {
        self.killBlock(_goodsModel);
    }
}

@end
