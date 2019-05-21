//
//  LCHomeTableViewCell.m
//  huili
//
//  Created by zhongweike on 2018/1/5.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "LCHomeTableViewCell.h"

#define CellHeight 120

@interface LCHomeTableViewCell (){
    UIImageView *goodsImgView;   //商品图片
    UILabel *titleLabel;         //商品标题
    UILabel *priceLabel;         //特价
    UILabel *oldLabel;           //原价
    UIButton *buyButton;         //购买button
}
@property (nonatomic,strong)NSDictionary *infoDic;
@property (nonatomic,strong)HomeCellBlock block;

@end

@implementation LCHomeTableViewCell

+ (CGFloat)getHomeCellHeight{
    return CellHeight;
}

+ (instancetype)getHomeCell:(UITableView *)tableView andIdentifier:(NSString *)identifier andIndex:(NSIndexPath *)indexPath andDic:(NSDictionary *)dic andBlock:(HomeCellBlock)block{
    LCHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LCHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.block = block;
    [cell setInfoDic:dic];
    
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
    CGFloat img_h = CellHeight-2*10;
    goodsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, img_h, img_h)];
    [self addSubview:goodsImgView];
    
    //标题
    CGFloat titleLabel_w = win_width-8-(goodsImgView.maxX+8);
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsImgView.maxX+8, goodsImgView.minY, titleLabel_w, 36)];
    titleLabel.textColor = [UIColor colorWithHexString:@"626362"];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.numberOfLines = 2;
    [self addSubview:titleLabel];
    
    //立即购买button
    buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setFrame:CGRectMake(titleLabel.minX, goodsImgView.maxY-25, 80, 25)];
    [buyButton setBackgroundColor:STYLECOLOR];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    buyButton.layer.cornerRadius = 2;
    buyButton.layer.masksToBounds = YES;
    [buyButton addTarget:self action:@selector(clickBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buyButton];
    
    
    //价格label
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.minX, buyButton.minY-3-22, 0, 22)];
    priceLabel.textColor = STYLECOLOR;
    priceLabel.font = [UIFont systemFontOfSize:20];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:priceLabel];
    
    //原价
    oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.maxX, priceLabel.minY, 0, 22)];
    oldLabel.textColor = [UIColor colorWithHexString:@"A19FA1"];
    oldLabel.font = [UIFont systemFontOfSize:16];
    oldLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:oldLabel];
    
    
    
}

- (void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    
    //赋值
    [goodsImgView sd_setImageWithURL:[NSURL URLWithString:[infoDic stringForKey:@"img"]] placeholderImage:DefaultsImg];
    titleLabel.text = [infoDic stringForKey:@"name"];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",[infoDic stringForKey:@"price"]];
    oldLabel.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"￥%@",[infoDic stringForKey:@"super_price"]]];
    
    //适配
    [priceLabel sizeToFit];
    [oldLabel sizeToFit];
    priceLabel.size = CGSizeMake(priceLabel.width, 22);
    oldLabel.size = CGSizeMake(oldLabel.width, priceLabel.height);
    oldLabel.minX = priceLabel.maxX +5;
}


- (NSMutableAttributedString *)getAttributedStr:(NSString *)string{
    
    //中划线
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,string.length)];
    
    [attributeMarket addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    
    return attributeMarket;
}

- (void)clickBuyButton:(UIButton *)button{
    if (self.block) {
        self.block(_infoDic);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
