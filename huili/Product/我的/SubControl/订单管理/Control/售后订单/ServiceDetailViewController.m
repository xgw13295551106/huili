//
//  ServiceDetailViewController.m
//  huili
//
//  Created by zhongweike on 2018/1/15.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "LCMyOrderDetailModel.h"
#import "LCStatusProgressView.h"
#import "LCTextCardView.h"

#define selectImage [UIImage imageNamed:@"order_button_finish"]
#define unSelectImage [UIImage imageNamed:@"order_button_clock"]

@interface ServiceDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView; ///< 背景view
@property (nonatomic,strong)UILabel *orderSnLabel; ///< 服务单号
@property (nonatomic,strong)UILabel *timeLabel;    ///< 申请时间

@property (nonatomic,strong)UILabel *progressLabel; ///< 售后进度
@property (nonatomic,strong)LCStatusProgressView *progressView;
@property (nonatomic,strong)UILabel *remarkLabel;   ///< 问题描述
@property (nonatomic,strong)UILabel *typeLabel;     ///< 服务类型
@property (nonatomic,strong)UILabel *contactLabel;  ///< 联系人
@property (nonatomic,strong)UILabel *phoneLabel;    ///< 联系电话
@property (nonatomic,strong)UILabel *addressLabel;  ///< 联系地址

@property (nonatomic,strong)LCMyOrderDetailModel *detailModel;  ///< 订单详情

@end

@implementation ServiceDetailViewController

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-NavHeight-BottomHeight)];
        [_scrollView setBackgroundColor:[UIColor colorWithHexString:@"F6F7F6"]];
        _scrollView.delegate= self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"服务单详情";
    [self requestDetailNetworking];
    
}
#pragma mark 界面初始化
- (void)setupUI{
    [self.view addSubview:self.scrollView];
    //集成第一部分的view
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 25)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:view1];
    [self setupFirstView:view1];
    
    //集成第二部分的view
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.maxY+10, win_width, 150)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:view2];
    [self setupSecondView:view2];
    
    //集成第三部分
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, view2.maxY+10, win_width, 80)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:view3];
    [self setupThirdView:view3];
    
    //集成第四部分
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, view3.maxY+10, win_width, 150)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:view4];
    [self setupFouthView:view4];
    
    _scrollView.contentSize = CGSizeMake(-1, view4.maxY+20);
}

//TODO:集成第一部分的view
- (void)setupFirstView:(UIView *)bgView{
    _orderSnLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 2.5, 0, 20)];
    _orderSnLabel.textColor = [UIColor colorWithHexString:@"8C8D97"];
    _orderSnLabel.font = [UIFont systemFontOfSize:12];
    _orderSnLabel.text = [NSString stringWithFormat:@"服务单号：%@",_detailModel.order_sn];
    _orderSnLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_orderSnLabel];
    [_orderSnLabel sizeToFit];
    _orderSnLabel.size = CGSizeMake(_orderSnLabel.width, 20);
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderSnLabel.maxX+20, _orderSnLabel.minY, win_width-8-(_orderSnLabel.maxX+20), 20)];
    _timeLabel.textColor = [UIColor colorWithHexString:@"8C8D97"];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.text = [NSString stringWithFormat:@"申请时间：%@",_detailModel.created_at];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_timeLabel];
}

//TODO:集成第二部分view
- (void)setupSecondView:(UIView *)bgView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"363736"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"售后进度";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.minX, titleLabel.maxY+5, win_width-2*titleLabel.minX, 1)];
    [lineView setBackgroundColor:LineColor];
    [bgView addSubview:lineView];
    
    NSDictionary *item1 = @{@"":@"等待审核"};
    NSDictionary *item2 = @{@"":@"等待商家收货"};
    NSDictionary *item3 = _detailModel.back_type.intValue == 1?@{@"":@"等待退款"}:@{@"":@"等待重新发货"};
    NSDictionary *item4 = @{@"":@"已完成"};
    NSArray *items = @[item1,item2,item3,item4];
    _progressView = [LCStatusProgressView getStatusProgressView:CGRectMake(15, lineView.maxY, win_width-2*15, 100) andItems:items andSelectImage:selectImage andUnSelectImage:unSelectImage andSelectColor:[UIColor colorWithHexString:@"56CA02"] andUnSelectColor:[UIColor colorWithHexString:@"E4E5E4"]];
    //int order_status = detailModel.order_status.intValue;
    if (_detailModel.back_status.intValue == 0) {
        _progressView.selectIndex = 1;
    }else if (_detailModel.back_status.intValue == 1){
        _progressView.selectIndex = 2;
    }else if (_detailModel.back_status.intValue == 2){
        _progressView.selectIndex = 3;
    }else if (_detailModel.back_status.intValue == 3){
        _progressView.selectIndex = 4;
    }else{
        _progressView.selectIndex = 0;
    }
    [_progressView layoutSubviews];
    [bgView addSubview:_progressView];
    
    _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _progressView.maxY+10, win_width-2*15, 20)];
    _progressLabel.textColor = [UIColor colorWithHexString:@"3B3C3B"];
    _progressLabel.font = [UIFont systemFontOfSize:14];
    _progressLabel.text = [self getStatusContentString:_detailModel.back_status.intValue];
    [bgView addSubview:_progressLabel];
    
    bgView.height = _progressLabel.maxY+10;
}

//TODO:集成第三部分view
- (void)setupThirdView:(UIView *)bgView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"363736"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"问题描述";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.minX, titleLabel.maxY+5, win_width-2*titleLabel.minX, 1)];
    [lineView setBackgroundColor:LineColor];
    [bgView addSubview:lineView];
    
    _remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, lineView.maxY+10, lineView.width, 0)];
    _remarkLabel.textColor = [UIColor colorWithHexString:@"3D3E3D"];
    _remarkLabel.font = [UIFont systemFontOfSize:14];
    _remarkLabel.numberOfLines = 0;
    _remarkLabel.text = [NSString stringIsNull:_detailModel.back_remark]?@"无":_detailModel.back_remark;
    [bgView addSubview:_remarkLabel];
    CGSize size = [_remarkLabel sizeThatFits:CGSizeMake(_remarkLabel.width, MAXFLOAT)];
    _remarkLabel.size = size;
    
    bgView.height = _remarkLabel.maxY+12;
    
}

//TODO:集成第四部分view
- (void)setupFouthView:(UIView *)bgView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"363736"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"服务单信息";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.minX, titleLabel.maxY+5, win_width-2*titleLabel.minX, 1)];
    [lineView setBackgroundColor:LineColor];
    [bgView addSubview:lineView];
    
    CGFloat cardView_h = 28;
    LCTextCardView *cardView1 = [LCTextCardView getViewWith:CGRectMake(0, 5+lineView.maxY, win_width, cardView_h) andText:@"服务类型:" andPosition:CenterPosition];
    [bgView addSubview:cardView1];
    NSString *typeString = _detailModel.back_type.intValue == 1?@"退货":@"换货";
    _typeLabel = [self getInfoLabelWithTitle:typeString];
    [cardView1 addSubview:_typeLabel];
    
    LCTextCardView *cardView2 = [LCTextCardView getViewWith:CGRectMake(0, cardView1.maxY, win_width, cardView_h) andText:@"退款方式:" andPosition:CenterPosition];
    [bgView addSubview:cardView2];
    UILabel *returnLabel = [self getInfoLabelWithTitle:@"原返"];
    [cardView2 addSubview:returnLabel];
    
    LCTextCardView *cardView3 = [LCTextCardView getViewWith:CGRectMake(0, cardView2.maxY, win_width, cardView_h) andText:@"联系人:" andPosition:CenterPosition];
    [bgView addSubview:cardView3];
    _contactLabel = [self getInfoLabelWithTitle:_detailModel.consignee];
    [cardView3 addSubview:_contactLabel];
    
    LCTextCardView *cardView4 = [LCTextCardView getViewWith:CGRectMake(0, cardView3.maxY, win_width, cardView_h) andText:@"联系电话:" andPosition:CenterPosition];
    [bgView addSubview:cardView4];
    _phoneLabel = [self getInfoLabelWithTitle:_detailModel.mobile];
    [cardView4 addSubview:_phoneLabel];
    
    LCTextCardView *cardView5 = [LCTextCardView getViewWith:CGRectMake(0, cardView4.maxY, win_width, cardView_h) andText:@"联系地址:" andPosition:TopPosition];
    [bgView addSubview:cardView5];
    NSString *addressString = [NSString stringIsNull:_detailModel.detail_address]?@"未填写":_detailModel.detail_address;
    _addressLabel = [self getInfoLabelWithTitle:addressString];
    [cardView5 addSubview:_addressLabel];
    _addressLabel.numberOfLines = 0;
    CGSize size = [_addressLabel sizeThatFits:CGSizeMake(win_width-10-85, MAXFLOAT)];
    _addressLabel.size = size;
    _addressLabel.minY = 10;
    cardView5.height = _addressLabel.maxY+12;
    bgView.height = cardView5.maxY+12;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:获取封装的服务单信息label
- (UILabel *)getInfoLabelWithTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(85, 4, win_width-10-85, 20)];
    label.textColor = [UIColor colorWithHexString:@"3D3E3D"];
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    label.textAlignment = NSTextAlignmentLeft;
    
    return label;
}

#pragma mark 网络请求
//TODO:请求订单详情信息
- (void)requestDetailNetworking{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"order_id"] = self.order_id;
    [self post:LCOrderDetail withParam:para success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            self.detailModel = [LCMyOrderDetailModel mj_objectWithKeyValues:dic[@"data"]];
           [self setupUI];
            
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 获取审核状态详细描述
 
 @param back_status back_status 审核状态数字
 @return 审核状态文字
 */
- (NSString *)getStatusContentString:(int)back_status{
    //0为待处理 1为等地商家收货 2为等待重新发货、等待退款 3已完成
    if (back_status == 0) {
        return @"您的服务单申请已提交，请等待审核";
    }else if (back_status == 1){
        return @"您的服务单已审核完成，请等待商家收货";
    }else if (back_status == 2){
        return _detailModel.back_type.intValue ==1?@"您的服务单商家已收货，请等待退款":@"您的服务单商家已收货，请等待重新发货";
    }else if (back_status == 3){
        return _detailModel.back_type.intValue ==1?@"您的服务单已成功退款，请注意查收":@"您的服务单商家已发货，请注意查收";
    }else{
        return @"正在处理";
    }
}

@end
