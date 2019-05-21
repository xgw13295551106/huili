//
//  AboutViewController.m
//  Bee
//
//  Created by zxy on 2017/3/17.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#define CellHeight 44.f
#define HeaderHeight 220.f

#import "AboutViewController.h"


@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *tableHeader;
@property (nonatomic,strong) UIView *tableFooter;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"关于我们"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
    [self.table reloadData];
}

- (UIView *)tableHeader{
    if (!_tableHeader) {
        _tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 220)];
        
        CGFloat logoDiameter = 80;
        
        UIImageView *icon = [[UIImageView alloc]init];
        [_tableHeader addSubview:icon];
        icon.frame = CGRectMake((AL_DEVICE_WIDTH-logoDiameter)/2, 50, logoDiameter, logoDiameter);
        icon.contentMode = UIViewContentModeScaleAspectFill;
        icon.cornerRadius = 5;
        icon.image = [UIImage imageNamed:App_icon];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, icon.bottom+10, AL_DEVICE_WIDTH-20, 20)];
        [_tableHeader addSubview:nameLabel];
        nameLabel.text = App_Name;
        nameLabel.textAlignment = 1;
        nameLabel.textColor = text1Color;
        nameLabel.font = [UIFont systemFontOfSize:18];
    }
    return _tableHeader;
}
- (UIView *)tableFooter{
    if (!_tableFooter) {
        _tableFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64-CellHeight*self.dataArray.count-HeaderHeight)];
        
        UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _tableFooter.height-40, AL_DEVICE_WIDTH-20, 20)];
        [_tableFooter addSubview:companyLabel];
        companyLabel.text = [CommonConfig shared].copyright;
        companyLabel.textAlignment = 1;
        companyLabel.textColor = text3Color;
        companyLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _tableFooter;
    
}
-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray = [[NSMutableArray alloc]init];
        
        [_dataArray addObjectsFromArray:@[@"微信公众号",@"联系电话",@"电子邮箱",@"官方网站"]];
    }
    return _dataArray;
}
- (UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT - 64) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table setScrollEnabled:NO];
        _table.tableHeaderView = self.tableHeader;
        _table.tableFooterView = self.tableFooter;
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_table];
    }
    return _table;
}

#pragma mark - ************ UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight-1, AL_DEVICE_WIDTH, 0.5)];
        [cell.contentView addSubview:line1];
        line1.backgroundColor = LineColor;
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    // ------model
    UIView *headerLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 0.5)];
    [cell.contentView addSubview:headerLine];
    headerLine.backgroundColor = LineColor;
    headerLine.hidden = indexPath.row;
    
    cell.textLabel.text = _dataArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"user_aboutus_wxgongzhonghao"]];
            cell.detailTextLabel.text = [CommonConfig shared].wxG;
        }
            break;
        case 1:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"user_aboutus_phone"]];
            cell.detailTextLabel.text = [CommonConfig shared].mobileSer;
        }
            break;
        case 2:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"user_aboutus_mail"]];
            cell.detailTextLabel.text = [CommonConfig shared].email;
        }
            break;
        case 3:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"user_aboutus_web"]];
            cell.detailTextLabel.text = [CommonConfig shared].net;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //无
    
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
