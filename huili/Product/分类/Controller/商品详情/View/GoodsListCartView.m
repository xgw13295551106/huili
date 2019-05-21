//
//  GoodsListCartView.m
//  YeFu
//
//  Created by Carl on 2017/12/22.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "GoodsListCartView.h"

@interface GoodsListCartView ()

@property(nonatomic)UILabel *price;

@property(nonatomic)UIButton *cartBtn;

@property(nonatomic)float pricePre;

@end

@implementation GoodsListCartView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIButton *cartBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, -15, 50, 50)];
        [cartBtn setImage:[UIImage imageNamed:@"cart_button_shopping_cart_def"] forState:UIControlStateNormal];
        [self addSubview:cartBtn];
        [cartBtn addTarget:self action:@selector(gotoCart) forControlEvents:UIControlEventTouchUpInside];
        _cartBtn=cartBtn;
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 80, 50)];
        [priceLabel setText:@"合计："];
        [priceLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [priceLabel setTextColor:text1Color];
        [self addSubview:priceLabel];
        
        UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(130, 0, 80, 50)];
        _price=price;
        [price setFont:[UIFont boldSystemFontOfSize:16]];
        [price setTextColor:[UIColor colorWithHexString:@"f55656"]];
        [self addSubview:price];
        
        UIButton *addCart=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-100, 0, 100, 50)];
        [addCart setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
        [addCart setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [addCart setTitle:@"去结算" forState:UIControlStateNormal];
        [addCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addCart.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:addCart];
        [addCart addTarget:self action:@selector(addCartClick) forControlEvents:UIControlEventTouchUpInside];
        _addCart=addCart;
        
        [self getCartNumber];
        
    }
    return self;
}

-(void)addCartClick{
    if ([self.delegate respondsToSelector:@selector(goToOrder)]) {
        [self.delegate goToOrder];
    }
}

-(void)getCartNumber{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [param setValue:TOKEN forKey:@"token"];
    [[XAClient sharedClient]postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,CartNumber] withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSLog(@"%@",responseObject);
            NSDictionary *data=[responseObject objectForKey:@"data"];
            int num=[data intForKey:@"num"];
            RKNotificationHub* hub = [[RKNotificationHub alloc]initWithView:_cartBtn];
            [hub setCircleAtFrame:CGRectMake(_cartBtn.width-15, 0, 20, 20)];
            hub.count=num;
            [_price setText:[NSString stringWithFormat:@"¥%@",[data stringForKey:@"price"]]];
        }
    } failure:nil];
}


-(void)gotoCart{
    if ([self.delegate respondsToSelector:@selector(gotoCart)]) {
        [self.delegate gotoCart];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
