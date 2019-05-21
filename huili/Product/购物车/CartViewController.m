//
//  CartViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/4.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "GoPayViewController.h"

@interface CartViewController ()<UITableViewDelegate,UITableViewDataSource,CartTableViewCellDelegate>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic,weak)UIButton *selectBtn;
@property(nonatomic,weak)UIButton *selectBtn2;

@property(nonatomic,weak)UILabel *sumPrice;

@property(nonatomic)UIView *noData;

@property(nonatomic)UIView *bottomBg;
@property(nonatomic)UIView *bottomBg2;

@property(nonatomic,weak)UIButton *statusBtn;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"购物车"];
    
    UIButton *statusBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    _statusBtn=statusBtn;
    [statusBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [statusBtn setTitle:@"完成" forState:UIControlStateSelected];
    [statusBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [statusBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:statusBtn];
    self.navigationItem.rightBarButtonItem=barItem;
    //暂时不用
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.view addSubview:self.myTableView];
    
    [self.view addSubview:self.noData];
    
    [self creatBottom];
    [self creatBottom2];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

-(void)editClick:(UIButton*)sender{
    sender.selected=!sender.selected;
    [self checkBottom];
}

-(void)checkBottom{
    if (_statusBtn.selected) {//编辑状态下
        [_bottomBg setHidden:YES];
        [_bottomBg2 setHidden:NO];
    }else{//正常状态下
        [_bottomBg setHidden:NO];
        [_bottomBg2 setHidden:YES];
    }
    
    if (self.dataArray.count==0) {
        [_bottomBg setHidden:YES];
        [_bottomBg2 setHidden:YES];
    }
}

-(UIView*)noData{
    if (_noData==nil) {
        _noData=[[UIView alloc]initWithFrame:CGRectMake(0, 100, AL_DEVICE_WIDTH, 220)];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 200)];
        [img setImage:[UIImage imageNamed:@"home_pic_search_default"]];
        [img setContentMode:UIViewContentModeCenter];
        [_noData addSubview:img];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom, AL_DEVICE_WIDTH, 30)];
        [label setText:@"当前购物车没有任何物品"];
        [label setTextColor:text3Color];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [_noData addSubview:label];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, label.bottom, AL_DEVICE_WIDTH, 20)];
        [label2 setText:[CommonConfig shared].pageAd];
        [label2 setTextColor:STYLECOLOR];
        [label2 setFont:[UIFont boldSystemFontOfSize:16]];
        [label2 setTextAlignment:NSTextAlignmentCenter];
        [_noData addSubview:label2];
        [_noData setHidden:YES];
    }
    return _noData;
}


#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64-100-KIsiPhoneXH) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView=[UIView new];
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];;
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
    return 130*PROPORTION;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.model = self.dataArray[indexPath.row];
    [cell setDelegate:self];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }];
//    
//    return @[action1];
//}
/******************************UITableView代理结束**************************************/

/******************************计算总价************************************/
-(void)checkPrice{
    float sumPrice=0.0;
    int sumCount=0;
    for (int i=0; i<self.dataArray.count; i++) {
        CartListModel *model=[self.dataArray objectAtIndex:i];
        if (model.isSelect) {
            sumCount=model.goods_ammount+sumCount;
            sumPrice=sumPrice+model.goods_ammount*[model.goods_price floatValue];
        }
    }
    [self checkFramAmount:sumPrice Sum:sumCount];
}
/******************************计算总价************************************/

/******************************底部************************************/
-(void)creatBottom{
    UIView *bottomBg=[[UIView alloc]initWithFrame:CGRectMake(0, AL_DEVICE_HEIGHT-64-100-KIsiPhoneXH, AL_DEVICE_WIDTH, 50)];
    [self.view addSubview:bottomBg];
    [bottomBg setBackgroundColor:[UIColor whiteColor]];
    _bottomBg=bottomBg;
    
    UIButton *orderSumbit=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-100, 0, 100, 50)];
    [orderSumbit setTitle:@"提交订单" forState:UIControlStateNormal];
    [orderSumbit setBackgroundColor:STYLECOLOR];
    [orderSumbit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderSumbit.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bottomBg addSubview:orderSumbit];
    [orderSumbit addTarget:self action:@selector(orderSumbitClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    [selectBtn setImage:[UIImage imageNamed:@"common_icon_select"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"common_icon_unselect"] forState:UIControlStateNormal];
    [bottomBg addSubview:selectBtn];
    _selectBtn=selectBtn;
    [selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *selectLabel=[[UILabel alloc]initWithFrame:CGRectMake(selectBtn.right, 0, 45, 50)];
    [selectLabel setText:@"全选"];
    [selectLabel setTextColor:text1Color];
    [bottomBg addSubview:selectLabel];
    [selectLabel setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *sumPrice=[[UILabel alloc]initWithFrame:CGRectMake(selectLabel.right, 0, 180, 50)];
    [sumPrice setTextColor:text1Color];
    [sumPrice setFont:[UIFont systemFontOfSize:18]];
    [bottomBg addSubview:sumPrice];
    _sumPrice=sumPrice;
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 0.5)];
    [line setBackgroundColor:LineColor];
    [bottomBg addSubview:line];
    
    [self checkFramAmount:0 Sum:0];
    
}
/******************************底部************************************/

/******************************底部************************************/
-(void)creatBottom2{
    UIView *bottom2Bg=[[UIView alloc]initWithFrame:CGRectMake(0, AL_DEVICE_HEIGHT-64-100-KIsiPhoneXH, AL_DEVICE_WIDTH, 50)];
    [self.view addSubview:bottom2Bg];
    [bottom2Bg setBackgroundColor:[UIColor whiteColor]];
    _bottomBg2=bottom2Bg;
    [bottom2Bg setHidden:YES];
    
    
    UIButton *selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    [selectBtn setImage:[UIImage imageNamed:@"common_icon_select"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"common_icon_unselect"] forState:UIControlStateNormal];
    [bottom2Bg addSubview:selectBtn];
    _selectBtn2=selectBtn;
    [selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *selectLabel=[[UILabel alloc]initWithFrame:CGRectMake(selectBtn.right, 0, 45, 50)];
    [selectLabel setText:@"全选"];
    [selectLabel setTextColor:text1Color];
    [bottom2Bg addSubview:selectLabel];
    [selectLabel setFont:[UIFont systemFontOfSize:14]];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 0.5)];
    [line setBackgroundColor:LineColor];
    [bottom2Bg addSubview:line];
    
    UIButton *delectBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-100, 12.5, 80, 25)];
    [delectBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delectBtn setTitleColor:[UIColor colorWithHexString:@"f23030"] forState:UIControlStateNormal];
    [delectBtn.layer setCornerRadius:3];
    [delectBtn.layer setMasksToBounds:YES];
    [delectBtn.layer setBorderColor:[UIColor colorWithHexString:@"f23030"].CGColor];
    [delectBtn.layer setBorderWidth:1];
    [bottom2Bg addSubview:delectBtn];
    [delectBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [delectBtn addTarget:self action:@selector(delectClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(delectBtn.left-100, 12.5, 80, 25)];
    [collectBtn setTitle:@"移入收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor colorWithHexString:@"81838e"] forState:UIControlStateNormal];
    [collectBtn.layer setCornerRadius:3];
    [collectBtn.layer setMasksToBounds:YES];
    [collectBtn.layer setBorderColor:[UIColor colorWithHexString:@"81838e"].CGColor];
    [collectBtn.layer setBorderWidth:1];
    [bottom2Bg addSubview:collectBtn];
    [collectBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark--删除
-(void)delectClick{
    NSMutableArray *cartIdArr=[[NSMutableArray alloc]init];
    for (int i=0; i<self.dataArray.count; i++) {
        CartListModel *model=[self.dataArray objectAtIndex:i];
        if (model.isSelect) {
            [cartIdArr addObject:model.cart_id];
        }
    }
    if (cartIdArr.count==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请选择要删除的商品"];
        return;
    }
    NSString *tempString = [cartIdArr componentsJoinedByString:@","];//分隔符逗号
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [param setValue:tempString forKey:@"ids"];
    [param setValue:@"1" forKey:@"type"];
    [self post:ClaerCart withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [SVProgressHUDHelp SVProgressHUDSuccess:@"删除成功"];
            [self getCartNet];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_CartChange object:nil userInfo:nil];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
}
#pragma mark--收藏
-(void)collectClick{
    NSMutableArray *cartIdArr=[[NSMutableArray alloc]init];
    for (int i=0; i<self.dataArray.count; i++) {
        CartListModel *model=[self.dataArray objectAtIndex:i];
        if (model.isSelect) {
            [cartIdArr addObject:model.cart_id];
        }
    }
    if (cartIdArr.count==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请选择要收藏的商品"];
        return;
    }
    NSString *tempString = [cartIdArr componentsJoinedByString:@","];//分隔符逗号
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [param setValue:tempString forKey:@"goods_id"];
    [param setValue:@"1" forKey:@"type"];
    [self post:GoodsCollect withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [SVProgressHUDHelp SVProgressHUDSuccess:@"移入收藏夹成功"];
            [self getCartNet];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
}
/******************************底部************************************/

/*******************************提交订单***********************************/
-(void)orderSumbitClick{
//    cart_id
    NSMutableArray *cartIdArr=[[NSMutableArray alloc]init];
    for (int i=0; i<self.dataArray.count; i++) {
        CartListModel *model=[self.dataArray objectAtIndex:i];
        if (model.isSelect) {
            [cartIdArr addObject:model.cart_id];
        }
    }
    if (cartIdArr.count==0) {
        [SVProgressHUDHelp SVProgressHUDFail:@"请选择要购买的商品"];
        return;
    }
    NSString *tempString = [cartIdArr componentsJoinedByString:@","];//分隔符逗号
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [param setValue:tempString forKey:@"ids"];
    [param setValue:@"2" forKey:@"type"];
    [self post:GoOrderInfo withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSDictionary *dic=[responseObject objectForKey:@"data"];
            GoPayViewController *vc=[[GoPayViewController alloc]init];
            [vc setPush_type:2];
            [vc setDicData:dic];
            [vc setCart_id:tempString];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
}
/*******************************提交订单***********************************/

/*******************************全选***********************************/
-(void)selectClick{
    if (_selectBtn.selected) {
        [_selectBtn setSelected:NO];
        for (int i=0; i<self.dataArray.count; i++) {
            CartListModel *model=[self.dataArray objectAtIndex:i];
            model.isSelect=NO;
        }
    }else{
        [_selectBtn setSelected:YES];
        for (int i=0; i<self.dataArray.count; i++) {
            CartListModel *model=[self.dataArray objectAtIndex:i];
            model.isSelect=YES;
        }
    }
    if (_selectBtn2.selected) {
        [_selectBtn2 setSelected:NO];
        for (int i=0; i<self.dataArray.count; i++) {
            CartListModel *model=[self.dataArray objectAtIndex:i];
            model.isSelect=NO;
        }
    }else{
        [_selectBtn2 setSelected:YES];
        for (int i=0; i<self.dataArray.count; i++) {
            CartListModel *model=[self.dataArray objectAtIndex:i];
            model.isSelect=YES;
        }
    }
    [self checkPrice];
    [self.myTableView reloadData];
}
/*******************************全选***********************************/

/*******************************调整总计位置***********************************/
-(void)checkFramAmount:(float)amoumt Sum:(int)sum{
    [_sumPrice setText:[NSString stringWithFormat:@"合计：￥%.2f",amoumt]];
    
    BOOL isAll=YES;
    for (int i=0; i<self.dataArray.count; i++) {
        CartListModel *model=[self.dataArray objectAtIndex:i];
        if (!model.isSelect) {
            isAll=NO;
            break;
        }
    }
    if (isAll) {
        [_selectBtn setSelected:YES];
        [_selectBtn2 setSelected:YES];
    }else{
        [_selectBtn setSelected:NO];
        [_selectBtn2 setSelected:NO];
    }
    
    
}
/*******************************调整总计位置***********************************/

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCartNet];
}

-(void)getCartNet{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [SVProgressHUD showWithStatus:@"加载中"];
    [self postInbackground:CartList withParam:param success:^(id responseObject) {
        [SVProgressHUD dismiss];
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [self.dataArray removeAllObjects];
            NSDictionary *res=[responseObject objectForKey:@"data"];
            NSArray *array=[res objectForKey:@"list"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                CartListModel *model=[CartListModel model];
                [model initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            if (self.dataArray.count==0) {
                [self.noData setHidden:NO];
                [_bottomBg setHidden:YES];
                [_bottomBg2 setHidden:YES];
            }else{
                [self.noData setHidden:YES];
                [_bottomBg setHidden:NO];
            }
            [self.myTableView reloadData];
            [self checkPrice];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/*******************************cell数量减少为0***********************************/
-(void)delectCell:(CartListModel *)model{
    [self getCartNet];
}
/*******************************cell数量减少为0***********************************/

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
