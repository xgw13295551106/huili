//
//  AddressListViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AddressListViewController.h"
#import "CreatAddressViewController.h"
#import "AddressSectionModel.h"
#import "AddressListHeadView.h"

@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource,AddressListTableViewCellDelegate>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic)AddressListHeadView *headView;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"地址列表"];
    
    
    [self.view addSubview:self.myTableView];
    
    [self creatAddress];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    
    
    // Do any additional setup after loading the view.
}

-(AddressListHeadView*)headView{
    if (_headView==nil) {
        _headView=[[AddressListHeadView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 95)];
        [_headView setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
        [_headView.addressAdd addTarget:self action:@selector(addressLocationClock) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}

-(void)setSelectAddressBlock:(AddressListBlock)selectAddressBlock{
    _selectAddressBlock=selectAddressBlock;
}

/******************************新建收获地址按钮************************************/
-(void)creatAddress{
    UIButton *creatAddressBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-44, AL_DEVICE_WIDTH, 44)];
    [creatAddressBtn setBackgroundColor:STYLECOLOR];
    [creatAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [creatAddressBtn setTitle:@"+ 新建地址" forState:UIControlStateNormal];
    [creatAddressBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:creatAddressBtn];
    [creatAddressBtn addTarget:self action:@selector(addressCreatClick) forControlEvents:UIControlEventTouchUpInside];
    
}
/******************************新建收获地址按钮************************************/

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-44) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
//        if (self.isSelectAddress) {
//            _myTableView.tableHeaderView=self.headView;
//        }
        
        _myTableView.tableFooterView=[UIView new];
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
/******************************UITableView初始化结束**************************************/

#pragma mark UITableView代理
/******************************UITableView代理开始**************************************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[AddressListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    AddressListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    [cell setDelegate:self];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSelectAddress) {
        AddressListModel *model = self.dataArray[indexPath.row];
        self.selectAddressBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/******************************UITableView代理结束**************************************/

/******************************创建地址************************************/
-(void)addressCreatClick{
    CreatAddressViewController *vc=[[CreatAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/******************************创建地址************************************/

-(void)reloadeTable{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [self postInbackground:AddressList withParam:param success:^(id responseObject) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [self.dataArray removeAllObjects];
            NSArray *array=[responseObject objectForKey:@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                AddressListModel *model=[AddressListModel model];
                [model initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
}
/****************************编辑地址**************************************/
-(void)editAddress:(AddressListModel *)model{
    CreatAddressViewController *vc=[[CreatAddressViewController alloc]init];
    [vc setIsEdit:YES];
    [vc setModel:model];
    [self.navigationController pushViewController:vc animated:YES];
    
}
/****************************编辑地址**************************************/

/****************************定位选择地址**************************************/
-(void)addressLocationClock{
    CreatAddressViewController *vc=[[CreatAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    [vc setIsBuyTo:YES];
}
/****************************定位选择地址**************************************/

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadeTable];
}

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
