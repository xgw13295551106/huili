//
//  DrawBillViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "DrawBillViewController.h"
#import "DrawBillTableViewCell.h"
#import "BillListViewController.h"
#import "DrawBillDetailViewController.h"

@interface DrawBillViewController ()<UITableViewDelegate,UITableViewDataSource,DrawBillTableViewCellDelegate>

@property(nonatomic)BGTableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic)int page;

@property(nonatomic,weak)UIButton *selectBtn;

@property(nonatomic,weak)UILabel *sumAmount;

@property(nonatomic,weak)UILabel *sumPrice1;

@property(nonatomic,weak)UILabel *sumPrice;

@property(nonatomic)NSString *amoumt;

@property(nonatomic)UIView *noData;

@property(nonatomic,weak)UIView *bottomBg;

@end

@implementation DrawBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"开具发票"];
    
    [self.view addSubview:self.myTableView];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    [self creatBottom];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"开票明细" style:UIBarButtonItemStylePlain target:self action:@selector(DrawBillClick)];
    self.navigationItem.rightBarButtonItem=right;
    
    [self.view addSubview:self.noData];
    // Do any additional setup after loading the view.
}

-(UIView*)noData{
    if (_noData==nil) {
        _noData=[[UIView alloc]initWithFrame:CGRectMake(0, 100, AL_DEVICE_WIDTH, 220)];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 200)];
        [img setImage:[UIImage imageNamed:@"order_pic_default"]];
        [img setContentMode:UIViewContentModeCenter];
        [_noData addSubview:img];
        [_noData setHidden:YES];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom, AL_DEVICE_WIDTH, 20)];
        [label setText:@"您还没有可开发票的订单"];
        [label setTextColor:text3Color];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [_noData addSubview:label];
    }
    return _noData;
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (BGTableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[BGTableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64-50-KIsiPhoneXH) style:UITableViewStylePlain];
        [_myTableView setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _myTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            weakSelf.page=1;
            [weakSelf reloadeTable];
        }];
        _myTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            [weakSelf reloadeTable];
        }];
        [_myTableView.mj_header beginRefreshing];
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
    if (self.dataArray.count == 0) {
        return 0;
    }
    BillArrayModel *model=[self.dataArray objectAtIndex:section];
    return model.billArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    BillArrayModel *model=[self.dataArray objectAtIndex:section];
    return model.month;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DrawBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[DrawBillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    BillArrayModel *model=[self.dataArray objectAtIndex:indexPath.section];
    [cell setDelegate:self];
    cell.model = [model.billArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/******************************UITableView代理结束**************************************/

-(void)reloadeTable{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"page"] = [NSString stringWithFormat:@"%i",_page];
    [self postInbackground:VoList withParam:para success:^(id responseObject) {
        [self endRefresh];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            if (_page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *tmpArray = dic[@"data"];
            for (NSDictionary *oneDic in tmpArray) {
                BillArrayModel *model = [[BillArrayModel model]initWithDictionary:oneDic];
                [self.dataArray addObject:model];
            }
            if (self.dataArray.count==0) {
                [self.noData setHidden:NO];
                [_bottomBg setHidden:YES];
            }else{
                [self.noData setHidden:YES];
                [_bottomBg setHidden:NO];
            }
            
            [self.myTableView reloadData];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
    }];
}

- (void)endRefresh{
    [self.myTableView.mj_header endRefreshing];
    [self.myTableView.mj_footer endRefreshing];
}

/******************************底部************************************/
-(void)creatBottom{
    UIView *bottomBg=[[UIView alloc]initWithFrame:CGRectMake(0, AL_DEVICE_HEIGHT-64-50-KIsiPhoneXH, AL_DEVICE_WIDTH, 50)];
    [self.view addSubview:bottomBg];
    [bottomBg setBackgroundColor:[UIColor whiteColor]];
    _bottomBg=bottomBg;
    [_bottomBg.layer setMasksToBounds:YES];
    
    UIButton *orderSumbit=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-90, 0, 90, 50)];
    [orderSumbit setTitle:@"开发票" forState:UIControlStateNormal];
    [orderSumbit setBackgroundColor:STYLECOLOR];
    [orderSumbit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderSumbit.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bottomBg addSubview:orderSumbit];
    [orderSumbit addTarget:self action:@selector(orderSumbitClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    [selectBtn setImage:[UIImage imageNamed:@"cart_button_select"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"cart_button_unselect"] forState:UIControlStateNormal];
    [bottomBg addSubview:selectBtn];
    _selectBtn=selectBtn;
    [selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *selectLabel=[[UILabel alloc]initWithFrame:CGRectMake(selectBtn.right, 0, 45, 50)];
    [selectLabel setText:@"全选"];
    [selectLabel setTextColor:text1Color];
    [bottomBg addSubview:selectLabel];
    [selectLabel setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *sumAmount=[[UILabel alloc]initWithFrame:CGRectMake(selectLabel.right, 0, 100, 50)];
    [sumAmount setTextColor:text1Color];
    [sumAmount setFont:[UIFont systemFontOfSize:15]];
    [bottomBg addSubview:sumAmount];
    _sumAmount=sumAmount;
    
    UILabel *sumPrice1=[[UILabel alloc]initWithFrame:CGRectMake(sumAmount.right, 0, 100, 50)];
    [sumPrice1 setTextColor:text1Color];
    [sumPrice1 setFont:[UIFont systemFontOfSize:18]];
    [bottomBg addSubview:sumPrice1];
    _sumPrice1=sumPrice1;
    
    UILabel *sumPrice=[[UILabel alloc]initWithFrame:CGRectMake(sumAmount.right, 0, 100, 50)];
    [sumPrice setTextColor:[UIColor colorWithHexString:@"f23030"]];
    [sumPrice setFont:[UIFont systemFontOfSize:18]];
    [bottomBg addSubview:sumPrice];
    _sumPrice=sumPrice;
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 0.5)];
    [line setBackgroundColor:LineColor];
    [bottomBg addSubview:line];
    
    [self checkFramAmount:0 Sum:0];
    
}
/******************************底部************************************/
/*******************************调整总计位置***********************************/
-(void)checkFramAmount:(float)amoumt Sum:(int)sum{
    [_sumAmount setText:[NSString stringWithFormat:@"共%d件",sum]];
    [_sumAmount sizeToFit];
    [_sumAmount setFrame:CGRectMake(85, 0, _sumAmount.width, 50)];
    [_sumPrice1 setText:@"合计:"];
    [_sumPrice1 sizeToFit];
    [_sumPrice1 setFrame:CGRectMake(_sumAmount.right+5, 0, _sumPrice1.width, 50)];
    [_sumPrice setText:[NSString stringWithFormat:@"¥%.2f",amoumt]];
    [_sumPrice sizeToFit];
    [_sumPrice setFrame:CGRectMake(_sumPrice1.right, 0, _sumPrice.width, 50)];
    _amoumt=[NSString stringWithFormat:@"%.2f",amoumt];
    
}
/*******************************调整总计位置***********************************/

/*******************************提交开票***********************************/
-(void)orderSumbitClick{
    NSMutableArray *orderIdrray=[[NSMutableArray alloc]init];
    for (int i=0; i<self.dataArray.count; i++) {
        BillArrayModel *model=[self.dataArray objectAtIndex:i];
        for (int j=0; j<model.billArray.count; j++) {
            BillModel *model2=[model.billArray objectAtIndex:j];
            if (model2.isSelect) {
                [orderIdrray addObject:model2.order_id];
            }
        }
    }
    NSString *tempString = [orderIdrray componentsJoinedByString:@","];//分隔符逗号
    DrawBillDetailViewController *vc=[[DrawBillDetailViewController alloc]init];
    [vc setAmoumt:self.amoumt];
    [vc setOrder_id:tempString];
    [self.navigationController pushViewController:vc animated:YES];
}
/*******************************提交开票***********************************/
/*******************************全选***********************************/
-(void)selectClick{
    if (_selectBtn.selected) {
        [_selectBtn setSelected:NO];
        for (int i=0; i<self.dataArray.count; i++) {
            BillArrayModel *model=[self.dataArray objectAtIndex:i];
            for (int j=0; j<model.billArray.count; j++) {
                BillModel *model2=[model.billArray objectAtIndex:j];
                model2.isSelect=NO;
            }
        }
    }else{
        [_selectBtn setSelected:YES];
        for (int i=0; i<self.dataArray.count; i++) {
            BillArrayModel *model=[self.dataArray objectAtIndex:i];
            for (int j=0; j<model.billArray.count; j++) {
                BillModel *model2=[model.billArray objectAtIndex:j];
                model2.isSelect=YES;
            }
        }
    }
    [self checkPrice];
    [self.myTableView reloadData];
}
/*******************************全选***********************************/

/******************************计算总价************************************/
-(void)checkPrice{
    float sumPrice=0.0;
    int sumCount=0;
    for (int i=0; i<self.dataArray.count; i++) {
        BillArrayModel *model=[self.dataArray objectAtIndex:i];
        for (int j=0; j<model.billArray.count; j++) {
            BillModel *model2=[model.billArray objectAtIndex:j];
            if (model2.isSelect) {
                sumPrice=model2.amount+sumPrice;
                sumCount=sumCount+1;
            }
        }
    }
    
    [self checkFramAmount:sumPrice Sum:sumCount];
}
/******************************计算总价************************************/

/******************************开票明细************************************/
-(void)DrawBillClick{
    BillListViewController *vc=[[BillListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/******************************开票明细************************************/

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
