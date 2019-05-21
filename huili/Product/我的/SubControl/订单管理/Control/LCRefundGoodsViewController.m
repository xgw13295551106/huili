//
//  LCRefundGoodsViewController.m
//  yihuo
//
//  Created by zhongweike on 2017/12/28.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCRefundGoodsViewController.h"
#import "LLImagePickerView.h"
#import "LCMyOrderGoodsModel.h"

#define SelectColor  [UIColor colorWithHexString:@"F13030"]
#define UnSelectColor [UIColor colorWithHexString:@"80828E"]

@interface LCRefundGoodsViewController ()<UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *centerView;
@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)UIButton *refundButton;  ///< 退货button
@property (nonatomic,strong)UIButton *changeButton;  ///< 换货button

@property (nonatomic,strong)UITextView *remarkTextView;
@property (nonatomic,strong)UILabel *placeholder;            ///< 评价内容提示
@property (nonatomic,strong)UIButton *submitButton;         ///< 提交申请

@property (nonatomic,strong)NSMutableArray *imageArray;  ///< 选中的图片数组
@property (nonatomic,assign)int selectType;   ///< 退款类型 1退货 2换货


@end

@implementation LCRefundGoodsViewController

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, win_width, _submitButton.minY)];
        [_scrollView setBackgroundColor:[UIColor colorWithHexString:@"F6F7F6"]];
        _scrollView.delegate= self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setFrame:CGRectMake(0, win_height-NavHeight-BottomHeight-50, win_width, 50)];
        [_submitButton setTitle:@"提交申请" forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:STYLECOLOR];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_submitButton addTarget:self action:@selector(clickSubmitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"申请售后";
    [self setUpControls];
    
}

- (void)setUpControls{
    
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.scrollView];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 100)];
    [_topView setBackgroundColor:[UIColor whiteColor]];
    [self setupTopViewUI];
    
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.maxY+10, win_width, 80)];
    [_centerView setBackgroundColor:[UIColor whiteColor]];
    [self setCenterViewUI];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _centerView.maxY+10, win_width, 170)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [self setupBottomViewUI];
    
    [self.scrollView addSubview:self.topView];
    [self.scrollView addSubview:self.centerView];
    [self.scrollView addSubview:self.bottomView];
    self.scrollView.contentSize = CGSizeMake(-1, _bottomView.maxY+20);
    
    
}


- (void)setupTopViewUI{
    //商品图片
    UIImageView *goodsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 80, 80)];
    [_topView addSubview:goodsImgView];
    
    //商品名
    CGFloat nameLabel_x = goodsImgView.maxX+8;
    CGFloat nameLabel_w = win_width-15-nameLabel_x;
    UILabel *goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel_x, goodsImgView.minY-2,nameLabel_w, 35)];
    goodsNameLabel.textColor = [UIColor colorWithHexString:@"2B2B2E"];
    goodsNameLabel.font = [UIFont systemFontOfSize:13];
    goodsNameLabel.numberOfLines = 2;
    [_topView addSubview:goodsNameLabel];
    
    //商品数量
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(win_width-10-50, goodsImgView.centerY-5, 50, 18)];
    numLabel.textColor = [UIColor colorWithHexString:@"6E707B"];
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.textAlignment = NSTextAlignmentRight;
    [_topView addSubview:numLabel];
    
    //分类
    UILabel *formatLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsNameLabel.minX, goodsImgView.centerY-5, 180, 18)];
    formatLabel.textColor = [UIColor colorWithHexString:@"6E707B"];
    formatLabel.font = [UIFont systemFontOfSize:12];
    [_topView addSubview:formatLabel];
    
    [goodsImgView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goods_img] placeholderImage:DefaultsImg];
    goodsNameLabel.text = _goodsModel.goods_name;
    NSString *number = [NSString stringIsNull:_goodsModel.goods_num]?_goodsModel.number:_goodsModel.goods_num;
    numLabel.text = [NSString stringWithFormat:@"x%@",number];
    [numLabel sizeToFit];
    [numLabel setFrame:CGRectMake(win_width-10-numLabel.width, goodsImgView.centerY-5, numLabel.width, 18)];
    formatLabel.text = _goodsModel.attr_names;
    formatLabel.width = numLabel.minX - 8 -goodsNameLabel.minX;
}

- (void)setCenterViewUI{
    UILabel *promptLaebl = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 22)];
    promptLaebl.textColor = [UIColor colorWithHexString:@"1D1D20"];
    promptLaebl.font = [UIFont systemFontOfSize:15];
    promptLaebl.text = @"服务类型";
    promptLaebl.textAlignment = NSTextAlignmentLeft;
    [_centerView addSubview:promptLaebl];
    
    //退货button
    _refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refundButton setFrame:CGRectMake(promptLaebl.minX, promptLaebl.maxY+10, 80, 25)];
    [_refundButton setTitle:@"退货" forState:UIControlStateNormal];
    [_refundButton setTitleColor:SelectColor forState:UIControlStateNormal];
    _refundButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _refundButton.layer.cornerRadius = 2;
    _refundButton.layer.masksToBounds = YES;
    _refundButton.layer.borderColor = [SelectColor CGColor];
    _refundButton.layer.borderWidth = 1;
    [_centerView addSubview:_refundButton];
    [_refundButton addTarget:self action:@selector(clickTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //换货
    _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changeButton setFrame:CGRectMake(_refundButton.maxX+15, _refundButton.minY, 80, 25)];
    [_changeButton setTitle:@"换货" forState:UIControlStateNormal];
    [_changeButton setTitleColor:UnSelectColor forState:UIControlStateNormal];
    _changeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _changeButton.layer.cornerRadius = 2;
    _changeButton.layer.masksToBounds = YES;
    _changeButton.layer.borderColor = [UnSelectColor CGColor];
    _changeButton.layer.borderWidth = 1;
    [_centerView addSubview:_changeButton];
    [_changeButton addTarget:self action:@selector(clickTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _selectType = 1;
}

- (void)setupBottomViewUI{
    //提示问题描述
    UILabel *promptLaebl = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 20)];
    promptLaebl.textColor = [UIColor colorWithHexString:@"1D1D20"];
    promptLaebl.font = [UIFont systemFontOfSize:15];
    promptLaebl.text = @"问题描述";
    promptLaebl.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:promptLaebl];
    
    //评价内容
    _remarkTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, promptLaebl.maxY +5, win_width-15*2, 120)];
    _remarkTextView.backgroundColor = [UIColor colorWithHexString:@"F2F3F2"];
    _remarkTextView.font = [UIFont systemFontOfSize:14];
    _remarkTextView.delegate = self;
    _remarkTextView.layer.cornerRadius = 5;
    _remarkTextView.layer.masksToBounds = YES;
    _remarkTextView.layer.borderColor = [UIColor colorWithHexString:@"CCCDCC"].CGColor;
    _remarkTextView.layer.borderWidth = 0.5;
    [_bottomView addSubview:_remarkTextView];
    
    _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(_remarkTextView.minX+3, _remarkTextView.minY+3, _remarkTextView.width, 20)];
    _placeholder.textColor = [UIColor colorWithHexString:@"9C9D9C"];
    _placeholder.font = [UIFont systemFontOfSize:14];
    _placeholder.text = @"请在此描述问题";
    _placeholder.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:_placeholder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextView 代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _placeholder.hidden = YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeholder.hidden = NO;
    }
}

#pragma mark 点击提交
- (void)clickSubmitButtonAction:(UIButton *)button{
    if ([NSString stringIsNull:self.remarkTextView.text]) {
        [self.view makeToast:@"请填写退款说明" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    NSLog(@"提交评价");
    if (self.imageArray.count>0) {
        [self requestUploadImageNet];
    }else{
        [self requestApplyNetworkWith:nil];
    }
}

#pragma mark button点击事件
- (void)clickTypeButton:(UIButton *)button{
    if (button == _refundButton) {
        _refundButton.layer.borderColor = [SelectColor CGColor];
        [_refundButton setTitleColor:SelectColor forState:UIControlStateNormal];
        _changeButton.layer.borderColor = [UnSelectColor CGColor];
        [_changeButton setTitleColor:UnSelectColor forState:UIControlStateNormal];
        _selectType = 1;
    }else{
        _refundButton.layer.borderColor = [UnSelectColor CGColor];
        [_refundButton setTitleColor:UnSelectColor forState:UIControlStateNormal];
        _changeButton.layer.borderColor = [SelectColor CGColor];
        [_changeButton setTitleColor:SelectColor forState:UIControlStateNormal];
        _selectType = 2;
    }
}

#pragma mark 网络请求
//TODO:提交申请
- (void)requestApplyNetworkWith:(NSMutableDictionary *)para{
    if (para == nil) {
        para = [NSMutableDictionary dictionary];
    }
    para[@"token"] = TOKEN;
    para[@"order_id"] = self.order_id;
    para[@"back_remark"] = self.remarkTextView.text;
    para[@"order_good_id"] = self.goodsModel.id;
    para[@"back_type"] = [NSString stringWithFormat:@"%i",self.selectType];
    
    [self postInbackground:LCOrderRefund withParam:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            [self.view makeToast:@"提交成功，请耐心等候" duration:1.2 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:Network_Error duration:1.2 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    
}


- (void)requestUploadImageNet{
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [self JDuploadImages:self.imageArray isAsync:YES complete:^(NSArray<NSString *> *names) {
        NSString *str = [names componentsJoinedByString:@","];
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        para[@"back_img"] = str;
        [weakSelf requestApplyNetworkWith:para];
    } fail:^{
        [self.view makeToast:Network_Error duration:1.2 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
}



#pragma mark UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}



@end
