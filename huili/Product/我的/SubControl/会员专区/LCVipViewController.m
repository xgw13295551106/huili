//
//  LCVipViewController.m
//  huili
//
//  Created by zhongweike on 2018/1/16.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "LCVipViewController.h"



@interface LCVipViewController ()

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *bottomView;


@end

@implementation LCVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"会员专区";
    [self setUpControls];
}

- (void)setUpControls{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 180)];
    [_topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_topView];
    [self setupTopView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.maxY, win_width, win_height-NavHeight-BottomHeight-_topView.height)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottomView];
    
    [self setupBottomView];
}

- (void)setupTopView{
    UserInfoModel *userModel = [UserInfoManager currentUser];
    //vip背景图片
    NSString *vipImageName = [NSString stringWithFormat:@"user_vip_bg%i",userModel.type.intValue];
    UIImage *vipImage = [UIImage imageNamed:vipImageName];
    UIImageView *vipImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_width*vipImage.size.height/vipImage.size.width)];
    [vipImgView setImage:vipImage];
    [_topView addSubview:vipImgView];
    //用户头像
    UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    [headImgView sd_setImageWithURL:[NSURL URLWithString:userModel.img] placeholderImage:DefaultsImg];
    headImgView.layer.cornerRadius = headImgView.height/2;
    headImgView.layer.masksToBounds = YES;
    [vipImgView addSubview:headImgView];
    
    //用户名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(headImgView.maxX+10, headImgView.centerY-20/2, win_width - 8-(headImgView.maxX+10), 20)];
    nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = userModel.name;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [vipImgView addSubview:nameLabel];
    
    //到期时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(headImgView.minX, headImgView.maxY+10, win_width-10*2, 22)];
    timeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.text = [NSString stringWithFormat:@"会员到期时间：%@",userModel.end_time];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [vipImgView addSubview:timeLabel];
    
    //会员等级
    UILabel *vipLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(vipImgView.width-20-80, 15, 80, 20)];
    vipLevelLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    vipLevelLabel.font = [UIFont systemFontOfSize:15];
    vipLevelLabel.textAlignment = NSTextAlignmentRight;
    [vipImgView addSubview:vipLevelLabel];
    if (userModel.type.intValue == 1) {
        vipLevelLabel.text = @"铜牌会员";
    }else if (userModel.type.intValue == 2){
        vipLevelLabel.text = @"银牌会员";
    }else if (userModel.type.intValue == 3){
        vipLevelLabel.text = @"金牌会员";
    }else if (userModel.type.intValue == 4){
        vipLevelLabel.text = @"钻石会员";
    }
    
    _topView.height = vipImgView.maxY;
}

- (void)setupBottomView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 200, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"会员专属特权";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:titleLabel];
    
    //左侧打折信息
    NSString *leftImgName = [NSString stringWithFormat:@"user_vip_discount%i",[UserInfoManager currentUser].type.intValue];
    UIImage *leftImage = [UIImage imageNamed:leftImgName];
    UIImageView *leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_bottomView.width/4-4-leftImage.size.width, titleLabel.maxY+20, leftImage.size.width, leftImage.size.height)];
    [leftImgView setImage:leftImage];
    [_bottomView addSubview:leftImgView];
    //折扣
    int discount = [self getDiscount];
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftImgView.maxX+8, leftImgView.minY, 100, leftImgView.height)];
    leftLabel.textColor = [UIColor colorWithHexString:@"000000"];
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.text = [NSString stringWithFormat:@"全场%i折",discount];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:leftLabel];
    
    //右侧盟友信息
    NSString *rightImgName =[NSString stringWithFormat:@"user_vip_ally%i",[UserInfoManager currentUser].type.intValue];
    UIImage *rightImage = [UIImage imageNamed:rightImgName];
    UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(3*_bottomView.width/4-rightImage.size.width-4, leftImgView.minY, rightImage.size.width, rightImage.size.height)];
    [rightImgView setImage:rightImage];
    [_bottomView addSubview:rightImgView];
    
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightImgView.maxX+8, rightImgView.minY, 100, rightImgView.height)];
    rightLabel.textColor = [UIColor colorWithHexString:@"000000"];
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.text = @"盟友分销";
    rightLabel.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:rightLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, leftImgView.maxY+20, _bottomView.width, 1)];
    [lineView1 setBackgroundColor:LineColor];
    [_bottomView addSubview:lineView1];
    
    UILabel *codeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, lineView1.maxY+10, 0, 20)];
    codeTitleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    codeTitleLabel.font = [UIFont systemFontOfSize:16];
    codeTitleLabel.text = @"我的邀请码";
    [_bottomView addSubview:codeTitleLabel];
    [codeTitleLabel sizeToFit];
    codeTitleLabel.size = CGSizeMake(codeTitleLabel.width, 20);
    
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(codeTitleLabel.maxX+8, codeTitleLabel.minY, 160, codeTitleLabel.height)];
    codeLabel.textColor = [UIColor colorWithHexString:@"8B8C8B"];
    codeLabel.font = [UIFont systemFontOfSize:14];
    codeLabel.text = [UserInfoManager currentUser].code;
    codeLabel.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:codeLabel];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setFrame:CGRectMake(_bottomView.width-15-60, lineView1.maxY+7.5, 60, 25)];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:STYLECOLOR forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    copyButton.layer.cornerRadius = copyButton.height/2;
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.borderColor  =[STYLECOLOR CGColor];
    copyButton.layer.borderWidth = 1;
    [copyButton addTarget:self action:@selector(clickCopyButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:copyButton];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, codeTitleLabel.maxY+10, _bottomView.width, 1)];
    [lineView2 setBackgroundColor:LineColor];
    [_bottomView addSubview:lineView2];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:获取全场折扣是几折
-(int)getDiscount{
    int discount = 10;
    int type = [UserInfoManager currentUser].type.intValue;
    
    if (type == 1) {
        discount = [CommonConfig shared].vip_level1.floatValue *10;
    }else if (type == 2){
        discount = [CommonConfig shared].vip_level2.floatValue *10;
    }else if (type == 3){
        discount = [CommonConfig shared].vip_level3.floatValue *10;
    }else if (type == 4){
        discount = [CommonConfig shared].vip_level4.floatValue *10;
    }
    
    return discount;
}


#pragma mark 点击复制按钮
- (void)clickCopyButton:(UIButton *)button{
    [self.view makeToast:@"复制成功!" duration:1.2 position:CSToastPositionCenter];
    
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string=[UserInfoManager currentUser].code;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
