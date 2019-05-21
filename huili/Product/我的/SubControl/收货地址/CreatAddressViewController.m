//
//  CreatAddressViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/11.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "CreatAddressViewController.h"
#import "SelcetMapViewController.h"
#import "WJSTPickerArea.h"

@interface CreatAddressViewController ()<UITableViewDataSource,UITableViewDelegate,WJSTPickerAreaDelegate>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic,weak)UITextField *numberTextField;//门牌号

@property(nonatomic,weak)UITextField *nameTextField;//收货人

@property(nonatomic,weak)UITextField *phoneTextField;//联系电话

@property(nonatomic,weak)UITextField *areaTextField;//所在地区

@property(nonatomic,weak)UITextField *cityTextField;//所在城市

@property(nonatomic,weak)UISwitch *switchBtn;//是否默认地址的UISwitch

///所在省/直辖市
@property (nonatomic, copy) NSString     *province;
///城市名
@property (nonatomic, copy) NSString     *city;

@property (nonatomic, copy) NSString     *district;

@end

@implementation CreatAddressViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notifi_SelectArressSuccess object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    
    [self setTitle:@"新增收货地址"];
    
    [self.view addSubview:self.myTableView];
    
    [self saveAddress];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SelectAddressSuccess:) name:Notifi_SelectArressSuccess object:nil];
    
    if (self.isEdit) {
        UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(delectClick)];
        self.navigationItem.rightBarButtonItem=right;
        [self setTitle:@"编辑收货地址"];
    }
    
    // Do any additional setup after loading the view.
}

/****************************选择地址后的通知**************************************/
-(void)SelectAddressSuccess:(NSNotification*)noti{
    NSLog(@"%@",noti.userInfo);
    [_cityTextField setText:[noti.userInfo stringForKey:@"area"]];
    [_areaTextField setText:[NSString stringWithFormat:@"%@%@",[noti.userInfo stringForKey:@"name"],[noti.userInfo stringForKey:@"address"]]];
    self.province=[noti.userInfo stringForKey:@"province"];
    self.city=[noti.userInfo stringForKey:@"city"];
    self.district=[noti.userInfo stringForKey:@"district"];
}
/****************************选择地址后的通知**************************************/
#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView=[UIView new];
        [_myTableView setBackgroundColor:[UIColor clearColor]];
        [_myTableView setScrollEnabled:NO];
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
/******************************UITableView初始化结束**************************************/

#pragma mark UITableView代理
/******************************UITableView代理开始**************************************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isEdit&&[self.model.is_default isEqualToString:@"1"]) {
        return 4;
    }
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<4) {
        return 44;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setText:@"收货人："];
        UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
        [textFiled setTextColor:text1Color];
        [textFiled setFont:[UIFont systemFontOfSize:15]];
        [textFiled setPlaceholder:@"请填写收货人"];
        [cell.contentView addSubview:textFiled];
        [textFiled setTextAlignment:NSTextAlignmentRight];
        _nameTextField=textFiled;
        if (self.isEdit) {
            _nameTextField.text=_model.consignee;
        }
        return cell;
    }else if (indexPath.row==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setText:@"联系方式："];
        UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
        [textFiled setTextColor:text1Color];
        [textFiled setFont:[UIFont systemFontOfSize:15]];
        [textFiled setPlaceholder:@"请填写联系方式"];
        [textFiled setKeyboardType:UIKeyboardTypeNumberPad];
        [cell.contentView addSubview:textFiled];
        [textFiled setTextAlignment:NSTextAlignmentRight];
        _phoneTextField=textFiled;
        if (self.isEdit) {
            _phoneTextField.text=_model.mobile;
        }
        return cell;
    }else if (indexPath.row==2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setText:@"所在地区："];
        UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-150, 40)];
        [textFiled setTextColor:text1Color];
        [textFiled setFont:[UIFont systemFontOfSize:15]];
        [textFiled setPlaceholder:@"请选择所在地区"];
        [cell.contentView addSubview:textFiled];
        [textFiled setTextAlignment:NSTextAlignmentRight];
        [textFiled setEnabled:NO];
        if (self.isEdit) {
            textFiled.text=[NSString stringWithFormat:@"%@ %@ %@",self.model.province,self.model.city,self.district];
        }
        _areaTextField=textFiled;
        return cell;
    }else if (indexPath.row==3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setText:@"详细地址："];
        UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, AL_DEVICE_WIDTH-140, 40)];
        [textFiled setTextColor:text1Color];
        [textFiled setFont:[UIFont systemFontOfSize:15]];
        [textFiled setPlaceholder:@"请填写详细地址"];
        [cell.contentView addSubview:textFiled];
        [textFiled setTextAlignment:NSTextAlignmentRight];
        _numberTextField=textFiled;
        if (self.isEdit) {
            _numberTextField.text=_model.address;
        }
        return cell;
    }else if (indexPath.row==4){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 200, 20)];
        [label1 setText:@"设为默认地址"];
        [label1 setTextColor:text1Color];
        [label1 setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:label1];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 250, 20)];
        [label2 setText:@"注：每次下单时默认使用该地址"];
        [label2 setTextColor:text2Color];
        [label2 setFont:[UIFont systemFontOfSize:14]];
        [cell.contentView addSubview:label2];
        
        UISwitch *switchBtn=[[UISwitch alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-60, 14, 0, 0)];
        [switchBtn setTransform:CGAffineTransformMakeScale( 0.8, 0.8)];
        [cell.contentView addSubview:switchBtn];
        _switchBtn=switchBtn;
        
        return cell;
    }
    
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==2) {//选择地区
        //选择地区
        WJSTPickerArea *pickerSingle = [[WJSTPickerArea alloc]init];
        [pickerSingle setTitle:@"请选择所在区域"];
        [pickerSingle setContentMode:STPickerContentModeBottom];
        [pickerSingle setDelegate:self];
        [pickerSingle show];
//        SelcetMapViewController *vc=[[SelcetMapViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

/******************************UITableView代理结束**************************************/

/****************************选择区域后代理**************************************/
-(void)pickerArea:(WJSTPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:province forKey:@"province"];
    [param setValue:city forKey:@"city"];
    [param setValue:area forKey:@"district"];
    self.province=province;
    self.city=city;
    self.district=area;
    [_areaTextField setText:[NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.district]];
}
/****************************选择区域后代理**************************************/

/******************************新建收获地址按钮************************************/
-(void)saveAddress{
    UIButton *saveAddressBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-44, AL_DEVICE_WIDTH, 44)];
    [saveAddressBtn setBackgroundColor:STYLECOLOR];
    [saveAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveAddressBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
    [saveAddressBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:saveAddressBtn];
    [saveAddressBtn addTarget:self action:@selector(addressSaveClick) forControlEvents:UIControlEventTouchUpInside];
    
}
/******************************新建收获地址按钮************************************/

/******************************保存并使用************************************/
-(void)addressSaveClick{
    if (_nameTextField.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请填写收货人"];
        return;
    }
    if (_phoneTextField.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请填写联系电话"];
        return;
    }
    if (_numberTextField.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请填写详细地址"];
        return;
    }
    if (_areaTextField.text.length==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请选择所在地区"];
        return;
    }
    NSMutableDictionary *parma=[[NSMutableDictionary alloc]init];
    [parma setValue:TOKEN forKey:@"token"];
    [parma setValue:self.province forKey:@"province"];
    [parma setValue:self.city forKey:@"city"];
    [parma setValue:self.district forKey:@"district"];
    [parma setValue:_numberTextField.text forKey:@"address"];
    [parma setValue:_nameTextField.text forKey:@"consignee"];
    [parma setValue:_phoneTextField.text forKey:@"mobile"];
    if (self.switchBtn.on) {
        [parma setValue:@"1" forKey:@"is_default"];
    }
    NSString *url=CREATADDRESS;
    if (self.isEdit) {
        [parma setValue:self.model.address_id forKey:@"add_id"];
        url=AddressEdit;
        if ([self.model.is_default isEqualToString:@"1"]) {
            [parma setValue:@"1" forKey:@"is_default"];
        }
    }
    
    [self post:url withParam:parma success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
    
    
    
}
/******************************保存并使用************************************/

/******************************编辑地址传model************************************/
-(void)setModel:(AddressListModel *)model{
    _model=model;
    self.province=_model.province;
    self.city=_model.city;
    self.district=_model.district;
}
/******************************编辑地址传model************************************/

/******************************删除地址************************************/
-(void)delectClick{
    YHWeakSelf
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:App_Name message:@"删除地址" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setValue:TOKEN forKey:@"token"];
        [param setValue:_model.address_id forKey:@"add_id"];
        [weakSelf post:AddressDec withParam:param success:^(id responseObject) {
            int code=[responseObject intForKey:@"code"];
            if (code==1) {
                [SVProgressHUDHelp SVProgressHUDSuccess:@"删除成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
            }
        } failure:nil];
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
/******************************删除地址************************************/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setIsBuyTo:(BOOL)isBuyTo{
    _isBuyTo=isBuyTo;
    SelcetMapViewController *vc=[[SelcetMapViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
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
