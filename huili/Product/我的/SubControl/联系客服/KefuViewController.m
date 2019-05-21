//
//  KefuViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/18.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "KefuViewController.h"

@interface KefuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *myTableView;

@end

@implementation KefuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"联系客服"];
    
    [self.view addSubview:self.myTableView];
    // Do any additional setup after loading the view.
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-50-KIsiPhoneXNavHAndB) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView=[UIView new];
        [_myTableView setScrollEnabled:NO];
        
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}
/******************************UITableView初始化结束**************************************/

#pragma mark UITableView代理
/******************************UITableView代理开始**************************************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
        if (indexPath.row==2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            [cell.textLabel setText:@"电话客服"];
            [cell.detailTextLabel setText:[CommonConfig shared].mobileSer];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            if (indexPath.row==0) {
                [cell.textLabel setText:@"在线客服"];
            }else{
                [cell.textLabel setText:@"QQ客服"];
            }
        }
        
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0://在线客服
        {
            
        }
            break;
        case 1://QQ客服
        {
            UIWebView *webView=[[UIWebView alloc]init];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[CommonConfig shared].KefuQQ]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
            [self.view addSubview:webView];
        }
            break;
        case 2://电话客服
        {
            [YHHelpper callPhoneAlert:[CommonConfig shared].mobileSer setTitle:@"客服热线"];
        }
            break;
            
        default:
            break;
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
