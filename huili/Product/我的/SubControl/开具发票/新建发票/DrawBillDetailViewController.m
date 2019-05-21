//
//  DrawBillDetailViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "DrawBillDetailViewController.h"
#import "BillListViewController.h"
#import "WJSTPickerArea.h"
#import "DrawBillSuccessViewController.h"

@interface DrawBillDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WJSTPickerAreaDelegate>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)UIView *footerView;

@property(nonatomic)int billType;//开票类型 1为电子发票  2为纸质发票
@property(nonatomic,weak)UIButton *billTypeBtn;//开票选择选中按钮

@property(nonatomic)int taitouType;//抬头类型 1为企业  2为非企业
@property(nonatomic,weak)UIButton *taitouTypeBtn;//抬头选择选中按钮

@property(nonatomic)int fapiaoType;//发票类型 1为普通 2为专用
@property(nonatomic,weak)UIButton *fapiaoTypeBtn;//发票类型选择选中按钮

@property(nonatomic,weak)UITextField *taitouTextFiled;//发票抬头
@property(nonatomic,weak)UITextField *shibiehaoTextFiled;//纳税人识别号
@property(nonatomic,weak)UITextField *phoneTextFiled;//注册地址、电话
@property(nonatomic,weak)UITextField *bandTextFiled;//开户行及银行账号
@property(nonatomic,weak)UITextField *emailTextFiled;//电子邮件
@property(nonatomic,weak)UITextField *nameTextFiled;//收件人
@property(nonatomic,weak)UITextField *mobileTextFiled;//联系电话
@property(nonatomic,weak)UITextField *areaTextFiled;//地区
@property(nonatomic,weak)UITextField *addressTextFiled;//详细地址

@end

@implementation DrawBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.billType=1;
    self.fapiaoType=1;
    self.taitouType=1;
    
    [self setTitle:@"开具发票"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"开票明细" style:UIBarButtonItemStylePlain target:self action:@selector(DrawBillClick)];
    self.navigationItem.rightBarButtonItem=right;
    
    // Do any additional setup after loading the view.
}

-(UIView*)footerView{
    if (_footerView==nil) {
        _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 60)];
        UIButton *sumbit=[[UIButton alloc]initWithFrame:CGRectMake(10, 8, AL_DEVICE_WIDTH-20, 44)];
        [sumbit setBackgroundColor:STYLECOLOR];
        [sumbit setTitle:@"提交" forState:UIControlStateNormal];
        [sumbit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sumbit.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_footerView addSubview:sumbit];
        [sumbit addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

/******************************开票明细************************************/
-(void)DrawBillClick{
    BillListViewController *vc=[[BillListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/******************************开票明细************************************/

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64) style:UITableViewStyleGrouped];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 0.1)];
        _myTableView.tableFooterView=self.footerView;
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}
/******************************UITableView初始化结束**************************************/

#pragma mark UITableView代理
/******************************UITableView代理开始**************************************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 8;
    }else{
        if (self.billType==1) {
            return 1;
        }else{
            return 4;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"请选择开票类型";
    }else if (section==1){
        return @"发票详情";
    }else{
        if (self.billType==1) {
            return @"电子邮箱";
        }else{
            return @"收件信息";
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {//发票类型选择
        UITableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:@"Cell0"];
        if (!cell0) {
            cell0 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell0"];
            UIButton *billTypeBtn1=[[UIButton alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH/2-140)/2, 0, 140, 40)];
            [cell0 setSelectionStyle:UITableViewCellSelectionStyleNone];
            [billTypeBtn1 setTitle:@"  电子发票" forState:UIControlStateNormal];
            [billTypeBtn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [billTypeBtn1 setImage:[UIImage imageNamed:@"user_fapiao_weixuanzhong"] forState:UIControlStateNormal];
            [billTypeBtn1 setImage:[UIImage imageNamed:@"user_fapiao_xuanzhong"] forState:UIControlStateSelected];
            [billTypeBtn1 setTitleColor:text2Color forState:UIControlStateNormal];
            [billTypeBtn1 setTitleColor:STYLECOLOR forState:UIControlStateSelected];
            billTypeBtn1.tag=1;
            [billTypeBtn1 setSelected:YES];
            _billTypeBtn=billTypeBtn1;
            [cell0.contentView addSubview:billTypeBtn1];
            [billTypeBtn1 addTarget:self action:@selector(billTypeClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *billTypeBtn2=[[UIButton alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH/2-140)/2+AL_DEVICE_WIDTH/2, 0, 140, 40)];
            [billTypeBtn2 setTitle:@"  纸质发票" forState:UIControlStateNormal];
            [billTypeBtn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [billTypeBtn2 setImage:[UIImage imageNamed:@"user_fapiao_weixuanzhong"] forState:UIControlStateNormal];
            [billTypeBtn2 setImage:[UIImage imageNamed:@"user_fapiao_xuanzhong"] forState:UIControlStateSelected];
            [billTypeBtn2 setTitleColor:text2Color forState:UIControlStateNormal];
            [billTypeBtn2 setTitleColor:STYLECOLOR forState:UIControlStateSelected];
            [cell0.contentView addSubview:billTypeBtn2];
            billTypeBtn2.tag=2;
            [billTypeBtn2 addTarget:self action:@selector(billTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell0;
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            UITableViewCell *cell10 = [tableView dequeueReusableCellWithIdentifier:@"cell10"];
            if (!cell10) {//抬头类型
                cell10 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell10"];
                [cell10 setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *taitouLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
                [taitouLabel setText:@"抬头类型"];
                [taitouLabel setFont:[UIFont systemFontOfSize:15]];
                [taitouLabel setTextColor:text1Color];
                [cell10.contentView addSubview:taitouLabel];
                
                UIButton *taitouTypeBtn1=[[UIButton alloc]initWithFrame:CGRectMake(80, 0, (AL_DEVICE_WIDTH-80)/2, 40)];
                [taitouTypeBtn1 setTitle:@"  企业抬头" forState:UIControlStateNormal];
                [taitouTypeBtn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [taitouTypeBtn1 setImage:[UIImage imageNamed:@"user_fapiao_weixuanzhong"] forState:UIControlStateNormal];
                [taitouTypeBtn1 setImage:[UIImage imageNamed:@"user_fapiao_xuanzhong"] forState:UIControlStateSelected];
                [taitouTypeBtn1 setTitleColor:text2Color forState:UIControlStateNormal];
                [taitouTypeBtn1 setTitleColor:STYLECOLOR forState:UIControlStateSelected];
                taitouTypeBtn1.tag=1;
                [taitouTypeBtn1 setSelected:YES];
                _taitouTypeBtn=taitouTypeBtn1;
                [cell10.contentView addSubview:taitouTypeBtn1];
                [taitouTypeBtn1 addTarget:self action:@selector(taitouTypeClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *taitouTypeBtn2=[[UIButton alloc]initWithFrame:CGRectMake(80+(AL_DEVICE_WIDTH-80)/2, 0, (AL_DEVICE_WIDTH-80)/2, 40)];
                [taitouTypeBtn2 setTitle:@"  个人／非企业单位" forState:UIControlStateNormal];
                [taitouTypeBtn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [taitouTypeBtn2 setImage:[UIImage imageNamed:@"user_fapiao_weixuanzhong"] forState:UIControlStateNormal];
                [taitouTypeBtn2 setImage:[UIImage imageNamed:@"user_fapiao_xuanzhong"] forState:UIControlStateSelected];
                [taitouTypeBtn2 setTitleColor:text2Color forState:UIControlStateNormal];
                [taitouTypeBtn2 setTitleColor:STYLECOLOR forState:UIControlStateSelected];
                [cell10.contentView addSubview:taitouTypeBtn2];
                taitouTypeBtn2.tag=2;
                [taitouTypeBtn2 addTarget:self action:@selector(taitouTypeClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell10;
        }else if (indexPath.row==1) {//发票类型
            UITableViewCell *cell11 = [tableView dequeueReusableCellWithIdentifier:@"cell11"];
            if (!cell11) {//发票类型
                cell11 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
                [cell11 setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *fapiaoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
                [fapiaoLabel setText:@"发票类型"];
                [fapiaoLabel setFont:[UIFont systemFontOfSize:15]];
                [fapiaoLabel setTextColor:text1Color];
                [cell11.contentView addSubview:fapiaoLabel];
                
                UIButton *fapiaoTypeBtn1=[[UIButton alloc]initWithFrame:CGRectMake(80, 0, (AL_DEVICE_WIDTH-80)/2, 40)];
                [fapiaoTypeBtn1 setTitle:@"  普通发票" forState:UIControlStateNormal];
                [fapiaoTypeBtn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [fapiaoTypeBtn1 setImage:[UIImage imageNamed:@"user_fapiao_weixuanzhong"] forState:UIControlStateNormal];
                [fapiaoTypeBtn1 setImage:[UIImage imageNamed:@"user_fapiao_xuanzhong"] forState:UIControlStateSelected];
                [fapiaoTypeBtn1 setTitleColor:text2Color forState:UIControlStateNormal];
                [fapiaoTypeBtn1 setTitleColor:STYLECOLOR forState:UIControlStateSelected];
                fapiaoTypeBtn1.tag=1;
                [fapiaoTypeBtn1 setSelected:YES];
                _fapiaoTypeBtn=fapiaoTypeBtn1;
                [cell11.contentView addSubview:fapiaoTypeBtn1];
                [fapiaoTypeBtn1 addTarget:self action:@selector(fapiaoTypeClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *fapiaoTypeBtn2=[[UIButton alloc]initWithFrame:CGRectMake(80+(AL_DEVICE_WIDTH-80)/2, 0, (AL_DEVICE_WIDTH-80)/2, 40)];
                [fapiaoTypeBtn2 setTitle:@"  专用发票" forState:UIControlStateNormal];
                [fapiaoTypeBtn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [fapiaoTypeBtn2 setImage:[UIImage imageNamed:@"user_fapiao_weixuanzhong"] forState:UIControlStateNormal];
                [fapiaoTypeBtn2 setImage:[UIImage imageNamed:@"user_fapiao_xuanzhong"] forState:UIControlStateSelected];
                [fapiaoTypeBtn2 setTitleColor:text2Color forState:UIControlStateNormal];
                [fapiaoTypeBtn2 setTitleColor:STYLECOLOR forState:UIControlStateSelected];
                [cell11.contentView addSubview:fapiaoTypeBtn2];
                fapiaoTypeBtn2.tag=2;
                [fapiaoTypeBtn2 addTarget:self action:@selector(fapiaoTypeClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            return cell11;
        }else if (indexPath.row==2){//发票抬头
            UITableViewCell *cell12 = [tableView dequeueReusableCellWithIdentifier:@"cell12"];
            if (!cell12) {
                cell12 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell12"];
                [cell12 setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
                [label setText:@"发票抬头"];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextColor:text1Color];
                [cell12.contentView addSubview:label];
                
                UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                [textFiled setTextColor:text1Color];
                [textFiled setFont:[UIFont systemFontOfSize:15]];
                [textFiled setPlaceholder:@"请填写发票抬头"];
                [cell12.contentView addSubview:textFiled];
                _taitouTextFiled=textFiled;
            }
            return cell12;
        }else if (indexPath.row==3){//纳税人识别号
            UITableViewCell *cell13 = [tableView dequeueReusableCellWithIdentifier:@"cell13"];
            if (!cell13) {
                cell13 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell13"];
                [cell13 setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                [label setText:@"纳税人识别号"];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextColor:text1Color];
                [cell13.contentView addSubview:label];
                
                UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                [textFiled setTextColor:text1Color];
                [textFiled setFont:[UIFont systemFontOfSize:15]];
                [textFiled setPlaceholder:@"请填写纳税人识别号"];
                [cell13.contentView addSubview:textFiled];
                _shibiehaoTextFiled=textFiled;
            }
            return cell13;
        }else if (indexPath.row==4){//发票内容
            UITableViewCell *cell14 = [tableView dequeueReusableCellWithIdentifier:@"cell14"];
            if (!cell14) {
                cell14 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell14"];
                [cell14 setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                [label setText:@"发票内容"];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextColor:text1Color];
                [cell14.contentView addSubview:label];
                
                UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                [textFiled setTextColor:text1Color];
                [textFiled setFont:[UIFont systemFontOfSize:15]];
                [textFiled setText:@"明细"];
                [textFiled setEnabled:NO];
                [cell14.contentView addSubview:textFiled];
            }
            return cell14;
        }else if (indexPath.row==5){//发票金额
            UITableViewCell *cell15 = [tableView dequeueReusableCellWithIdentifier:@"cell15"];
            if (!cell15) {
                cell15 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell15"];
                [cell15 setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                [label setText:@"发票金额"];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextColor:text1Color];
                [cell15.contentView addSubview:label];
                
                UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                [textFiled setTextColor:[UIColor colorWithHexString:@"ff0000"]];
                [textFiled setFont:[UIFont systemFontOfSize:15]];
                [textFiled setText:[NSString stringWithFormat:@"%@元",self.amoumt]];
                [textFiled setEnabled:NO];
                [cell15.contentView addSubview:textFiled];
            }
            return cell15;
        }else if (indexPath.row==6){//地址、电话
            UITableViewCell *cell16 = [tableView dequeueReusableCellWithIdentifier:@"cell16"];
            if (!cell16) {
                cell16 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell16"];
                [cell16 setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                [label setText:@"地址、电话"];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextColor:text1Color];
                [cell16.contentView addSubview:label];
                
                UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                [textFiled setTextColor:text1Color];
                [textFiled setKeyboardType:UIKeyboardTypeNumberPad];
                [textFiled setFont:[UIFont systemFontOfSize:15]];
                [textFiled setPlaceholder:@"请填写注册地址、注册电话"];
                [cell16.contentView addSubview:textFiled];
                _phoneTextFiled=textFiled;
            }
            return cell16;
        }else if (indexPath.row==7){//开户行及账号
            UITableViewCell *cell17 = [tableView dequeueReusableCellWithIdentifier:@"cell17"];
            if (!cell17) {
                cell17 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell17"];
                [cell17 setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                [label setText:@"开户行及账号"];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextColor:text1Color];
                [cell17.contentView addSubview:label];
                
                UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                [textFiled setTextColor:text1Color];
                [textFiled setFont:[UIFont systemFontOfSize:15]];
                [textFiled setPlaceholder:@"请填写开户行及银行账号"];
                [cell17.contentView addSubview:textFiled];
                _bandTextFiled=textFiled;
            }
            return cell17;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
            return cell;
        }
    }else{
        if (self.billType==1) {//电子邮件
            UITableViewCell *cell20 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell20) {
                cell20 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                [cell20 setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                [label setText:@"电子邮件"];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextColor:text1Color];
                [cell20.contentView addSubview:label];
                
                UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                [textFiled setTextColor:text1Color];
                [textFiled setFont:[UIFont systemFontOfSize:15]];
                [textFiled setPlaceholder:@"请填写电子邮件"];
                [cell20.contentView addSubview:textFiled];
                _emailTextFiled=textFiled;
            }
            return cell20;
        }else{//地址
            if (indexPath.row==0) {//收件人
                UITableViewCell *cell20 = [tableView dequeueReusableCellWithIdentifier:@"cell20"];
                if (!cell20) {
                    cell20 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell20"];
                    [cell20 setSelectionStyle:UITableViewCellSelectionStyleNone];
                    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                    [label setText:@"收件人"];
                    [label setFont:[UIFont systemFontOfSize:15]];
                    [label setTextColor:text1Color];
                    [cell20.contentView addSubview:label];
                    
                    UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                    [textFiled setTextColor:text1Color];
                    [textFiled setFont:[UIFont systemFontOfSize:15]];
                    [textFiled setPlaceholder:@"请填写收件人"];
                    [cell20.contentView addSubview:textFiled];
                    _nameTextFiled=textFiled;
                }
                return cell20;
            }else if (indexPath.row==1){//联系电话
                UITableViewCell *cell21 = [tableView dequeueReusableCellWithIdentifier:@"cell21"];
                if (!cell21) {
                    cell21 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell21"];
                    [cell21 setSelectionStyle:UITableViewCellSelectionStyleNone];
                    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                    [label setText:@"联系电话"];
                    [label setFont:[UIFont systemFontOfSize:15]];
                    [label setTextColor:text1Color];
                    [cell21.contentView addSubview:label];
                    
                    UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                    [textFiled setTextColor:text1Color];
                    [textFiled setFont:[UIFont systemFontOfSize:15]];
                    [textFiled setPlaceholder:@"请填写联系电话"];
                    [textFiled setKeyboardType:UIKeyboardTypeNumberPad];
                    [cell21.contentView addSubview:textFiled];
                    _mobileTextFiled=textFiled;
                }
                return cell21;
            }else if (indexPath.row==2){//所在地区
                UITableViewCell *cell22 = [tableView dequeueReusableCellWithIdentifier:@"cell22"];
                if (!cell22) {
                    cell22 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell22"];
                    [cell22 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                    [label setText:@"所在地区"];
                    [label setFont:[UIFont systemFontOfSize:15]];
                    [label setTextColor:text1Color];
                    [cell22.contentView addSubview:label];
                    
                    UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                    [textFiled setTextColor:text1Color];
                    [textFiled setFont:[UIFont systemFontOfSize:15]];
                    [textFiled setPlaceholder:@"请选择所在地区"];
                    [textFiled setKeyboardType:UIKeyboardTypeNumberPad];
                    [cell22.contentView addSubview:textFiled];
                    [textFiled setEnabled:NO]; 
                    _areaTextFiled=textFiled;
                }
                return cell22;
            }else if (indexPath.row==3){//详细地址
                UITableViewCell *cell23 = [tableView dequeueReusableCellWithIdentifier:@"cell23"];
                if (!cell23) {
                    cell23 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell23"];
                    [cell23 setSelectionStyle:UITableViewCellSelectionStyleNone];
                    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40)];
                    [label setText:@"详细地址"];
                    [label setFont:[UIFont systemFontOfSize:15]];
                    [label setTextColor:text1Color];
                    [cell23.contentView addSubview:label];
                    
                    UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
                    [textFiled setTextColor:text1Color];
                    [textFiled setFont:[UIFont systemFontOfSize:15]];
                    [textFiled setPlaceholder:@"请填写详细地址"];
                    [cell23.contentView addSubview:textFiled];
                    _addressTextFiled=textFiled;
                }
                return cell23;
            }
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.billType==2) {
        if (indexPath.section==2&&indexPath.row==2) {
            WJSTPickerArea *pickerSingle = [[WJSTPickerArea alloc]init];
            [pickerSingle setTitle:@"请选择所在区域"];
            [pickerSingle setContentMode:STPickerContentModeBottom];
            [pickerSingle setDelegate:self];
            [pickerSingle show];
        }
    }
    
}
/****************************选择区域后代理**************************************/
-(void)pickerArea:(WJSTPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area{
    [_areaTextFiled setText:[NSString stringWithFormat:@"%@ %@ %@",province,city,area]];
}
/****************************选择区域后代理**************************************/

/******************************UITableView代理结束**************************************/

/******************************切换发票类型************************************/
-(void)billTypeClick:(UIButton*)sender{
    [_billTypeBtn setSelected:NO];
    [sender setSelected:YES];
    _billTypeBtn=sender;
    self.billType=(int)sender.tag;
    [self.myTableView reloadData];
}
/******************************切换发票类型************************************/
/*******************************切换抬头类型***********************************/
-(void)taitouTypeClick:(UIButton*)sender{
    [_taitouTypeBtn setSelected:NO];
    [sender setSelected:YES];
    _taitouTypeBtn=sender;
    self.taitouType=(int)sender.tag;
}
/*******************************切换抬头类型***********************************/
/*******************************发票类型切换***********************************/
-(void)fapiaoTypeClick:(UIButton*)sender{
    [_fapiaoTypeBtn setSelected:NO];
    [sender setSelected:YES];
    _fapiaoTypeBtn=sender;
    self.fapiaoType=(int)sender.tag;
}
/*******************************发票类型切换***********************************/

/*******************************提交***********************************/
-(void)sumbitClick{
    
    if (_taitouTextFiled.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请填写发票抬头"];
        return;
    }
    if (_shibiehaoTextFiled.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请填写纳税人识别号"];
        return;
    }
    if (self.billType==1) {//电子发票
        if (_emailTextFiled.text.length==0) {
            [SVProgressHUDHelp SVProgressHUDFail:@"请填写邮箱地址"];
            return;
        }
    }else{//纸质发票
        if (_nameTextFiled.text.length==0) {
            [SVProgressHUDHelp SVProgressHUDFail:@"请填写收件人"];
            return;
        }
        if (_mobileTextFiled.text.length==0) {
            [SVProgressHUDHelp SVProgressHUDFail:@"请填写联系电话"];
            return;
        }
        if (_areaTextFiled.text.length==0) {
            [SVProgressHUDHelp SVProgressHUDFail:@"请选择所在区域"];
            return;
        }
        if (_addressTextFiled.text.length==0) {
            [SVProgressHUDHelp SVProgressHUDFail:@"请填写详细地址"];
            return;
        }
    }
    if (_fapiaoType==2) {//专用发票
        if (_phoneTextFiled.text.length==0) {
            [SVProgressHUDHelp SVProgressHUDFail:@"请填写注册地址、注册电话"];
            return;
        }
        if (_bandTextFiled.text.length==0) {
            [SVProgressHUDHelp SVProgressHUDFail:@"请填写开户行及银行账号"];
            return;
        }
    }
    NSString *message=@"";
    if (self.billType==1) {
        message=@"开票类型：电子发票";
    }else{
        message=@"开票类型：纸质发票";
    }
    if (self.fapiaoType==1) {
        message=[NSString stringWithFormat:@"%@\n发票类型：普通发票",message];
    }else{
        message=[NSString stringWithFormat:@"%@\n发票类型：专用发票",message];
    }
    message=[NSString stringWithFormat:@"%@\n发票抬头：%@",message,_taitouTextFiled.text];
    message=[NSString stringWithFormat:@"%@\n纳税人识别号：%@",message,_shibiehaoTextFiled.text];
    
    if (_fapiaoType==2) {
        message=[NSString stringWithFormat:@"%@\n注册地址及电话：%@",message,_phoneTextFiled.text];
        message=[NSString stringWithFormat:@"%@\n开户行及银行账号：%@",message,_bandTextFiled.text];
    }
    
    if (self.billType==1) {
        message=[NSString stringWithFormat:@"%@\n\n电子邮箱：%@",message,_emailTextFiled.text];
        
        message=[NSString stringWithFormat:@"%@\n\n请确认电子邮箱准确无误，电子发票将在系统开具后发送至您的邮箱，请注意查收",message];
    }else{
        message=[NSString stringWithFormat:@"%@\n\n收件人：%@",message,_nameTextFiled.text];
        message=[NSString stringWithFormat:@"%@\n联系电话：%@",message,_mobileTextFiled.text];
        message=[NSString stringWithFormat:@"%@\n所在区域：%@",message,_areaTextFiled.text];
        message=[NSString stringWithFormat:@"%@\n详细地址：%@",message,_addressTextFiled.text];
        
        message=[NSString stringWithFormat:@"%@\n\n请确认收件地址准确无误",message];
    }
    
    
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"发票预览" message:message];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        
    }]];
    YHWeakSelf
    [alertView addAction:[ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setValue:TOKEN forKey:@"token"];
        [param setValue:self.order_id forKey:@"order_id"];
        [param setValue:[NSString stringWithInt:self.billType] forKey:@"type"];
        [param setValue:[NSString stringWithInt:self.taitouType] forKey:@"title_type"];
        [param setValue:[NSString stringWithInt:self.fapiaoType] forKey:@"flag"];
        [param setValue:self.taitouTextFiled.text forKey:@"title"];
        [param setValue:@"明细" forKey:@"content"];
        [param setValue:self.amoumt forKey:@"amount"];
        [param setValue:self.shibiehaoTextFiled.text forKey:@"taxpayer_identity"];
        [param setValue:self.phoneTextFiled.text forKey:@"address_mob"];
        [param setValue:self.bandTextFiled.text forKey:@"bank_number"];
        [param setValue:self.emailTextFiled.text forKey:@"email"];
        [param setValue:self.nameTextFiled.text forKey:@"name"];
        [param setValue:self.mobileTextFiled.text forKey:@"mobile"];
        [param setValue:self.areaTextFiled.text forKey:@"region"];
        [param setValue:self.addressTextFiled.text forKey:@"address_info"];
        
        [weakSelf post:Invoice withParam:param success:^(id responseObject) {
            int code=[responseObject intForKey:@"code"];
            if (code==1) {
                DrawBillSuccessViewController *vc=[[DrawBillSuccessViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
            }
        } failure:nil];
    }]];
    
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
    alertController.tapBackgroundDismissEnable = NO;
    [self presentViewController:alertController animated:YES completion:nil];
    
}
/*******************************提交***********************************/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
