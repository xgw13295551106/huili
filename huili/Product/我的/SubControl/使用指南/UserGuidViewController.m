//
//  UserGuidViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "UserGuidViewController.h"
#import "WKBaseViewController.h"

@interface UserGuidViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)NSArray *array;

@end

@implementation UserGuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"使用指南"];
    self.array=[[NSArray alloc]init];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:@"1" forKey:@"type"];
    [self postInbackground:Glist withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            self.array=[responseObject objectForKey:@"data"];
            [self.view addSubview:self.myTableView];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
    
    // Do any additional setup after loading the view.
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView=[UIView new];
        
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}

/******************************UITableView初始化结束**************************************/

#pragma mark UITableView代理
/******************************UITableView代理开始**************************************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSDictionary *dic=[self.array objectAtIndex:indexPath.row];
    NSLog(@"%@",dic);
    [cell.textLabel setText:[dic stringForKey:@"title"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=[self.array objectAtIndex:indexPath.row];
    WKBaseViewController *vc=[[WKBaseViewController alloc]init];
    [vc setUrl:[dic stringForKey:@"url"]];
    [self.navigationController pushViewController:vc animated:YES];
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
