//
//  YeFuTableView.m
//  YeFu
//
//  Created by Carl on 2017/12/7.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YeFuTableView.h"

@interface YeFuTableView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *myTableView;
@property(nonatomic)NSMutableArray *dataArray;
@property(nonatomic)int page;

@end

@implementation YeFuTableView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    }
    return self;
}

-(void)setName:(NSString *)name{
    _name=name;
    [self addSubview:self.myTableView];
    [self.myTableView.mj_header beginRefreshing];
}
-(void)setCat_id:(NSString *)cat_id{
    _cat_id=cat_id;
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        [_myTableView setBorderColor:STYLECOLOR];
        _myTableView.delegate = self;
        _myTableView.tableFooterView=[UIView new];
        __weak typeof(self) weakSelf = self;
        _myTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            weakSelf.page=1;
            [weakSelf reloadeTable];
        }];
        _myTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            [weakSelf reloadeTable];
        }];
        
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
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 10)];
    [view setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YeFuListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[YeFuListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    YeFuListModel *model=[self.dataArray objectAtIndex:indexPath.row];
    [cell setModel:model];
//    [cell.textLabel setText:model.title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YeFuListModel *model=[self.dataArray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(lookDetail:)]) {
        [self.delegate lookDetail:model];
    }
}
/******************************UITableView代理结束**************************************/

-(void)reloadeTable{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:_cat_id forKey:@"cat_id"];
    [param setValue:[NSString stringWithInt:self.page] forKey:@"page"];
    [[XAClient sharedClient] postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,YeFuList] withParam:param success:^(id responseObject) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            if (self.page==1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *array=[responseObject objectForKey:@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic=[array objectAtIndex:i];
                YeFuListModel *model=[YeFuListModel model];
                [model initWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
