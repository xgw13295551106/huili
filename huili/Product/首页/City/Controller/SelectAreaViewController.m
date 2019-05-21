//
//  SelectAreaViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/7.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "SelectAreaViewController.h"
#import "SLCityListCell.h"
#import "SLCityModel.h"

@interface SelectAreaViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;

@end

@implementation SelectAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:self.city forKey:@"city"];
    [self postInbackground:GetDis withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSArray *array=[responseObject objectForKey:@"data"];
            [self.dataArray removeAllObjects];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                SLCity *model=[SLCity new];
                model.name=[dic stringForKey:@"district"];
                model.Id=[dic integerForKey:@"supplier_id"];
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
    
    [self.view addSubview:self.myTableView];
    
    // Do any additional setup after loading the view.
}
-(void)setCity:(NSString *)city{
    _city=city;
}

#pragma mark -- 设置navigationBar
- (void)setupNavigationBar {
    
    [self setTitle:self.city];
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
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
    return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    SLCity *model=[self.dataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:model.name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLCity *model=[self.dataArray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(sl_currentCity:supplier_id:)]) {
        [self.delegate sl_currentCity:[NSString stringWithFormat:@"%@%@",self.city,model.name] supplier_id:model.Id];
    }
}

/******************************UITableView代理结束**************************************/


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
