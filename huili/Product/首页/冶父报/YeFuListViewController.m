//
//  YeFuListViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/7.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YeFuListViewController.h"
#import "ZYColumnViewController.h"
#import "YeFuTableView.h"
#import "WKBaseViewController.h"

@interface YeFuListViewController ()<ZYColumnViewControllerDelegate,YeFuTableViewDelegate>

@property(nonatomic,weak)UIScrollView *scroll;

@property(nonatomic)NSMutableArray *checkArray;

@property(nonatomic,weak)ZYColumnViewController *columnViewVC;

@property(nonatomic)NSMutableArray *array;

@end

@implementation YeFuListViewController

-(NSMutableArray*)checkArray{
    if (_checkArray==nil) {
        _checkArray=[[NSMutableArray alloc]init];
    }
    return _checkArray;
}
-(NSMutableArray*)array{
    if (_array==nil) {
        _array=[[NSMutableArray alloc]init];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"冶父报"];
    
    
    self.array=[UserDefaults objectForKey:@"artcat"];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (int i=0; i<self.array.count; i++) {
        NSDictionary *dic=[self.array objectAtIndex:i];
        [array addObject:[dic stringForKey:@"name"]];
    }
    // 使用方法：
//    NSArray *array = @[@"头条",@"财经",@"体育",@"娱乐圈",@"段子",@"健康",@"图片",@"军事",@"精选",@"国际足球",@"历史",@"跟帖",@"居家"];
    NSArray *spareArray = @[];
    
    
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64-40)];
    [scroll setScrollEnabled:NO];
    _scroll=scroll;
    [scroll setContentSize:CGSizeMake(AL_DEVICE_WIDTH*array.count, AL_DEVICE_HEIGHT-64-40)];
    [self.view addSubview:scroll];
    
     [self creatTabel:0 isScroll:YES];
    
    // 初始化
    ZYColumnViewController *columnViewVC = [[ZYColumnViewController alloc] initWithColumnNames:array SpareColumnNames:spareArray];
    columnViewVC.fixedCount = 1;
    _columnViewVC=columnViewVC;
    columnViewVC.delegate = self;
    [columnViewVC setSelColor:STYLECOLOR];
    [columnViewVC setIndicatorColor:STYLECOLOR];
    [self.view insertSubview:columnViewVC.view atIndex:100];
    [self addChildViewController:columnViewVC];
    // Do any additional setup after loading the view.
}
#pragma mark - ZYColumnViewController 代理方法
- (void)columnViewDidSelected:(ZYColumnViewController *)columnViewVC AtIndex:(NSInteger)index
{
    [self creatTabel:(int)index isScroll:YES];
    
}

- (void)columnViewDidChanged:(NSMutableArray *)columnNames SpareColumnNamesArray:(NSMutableArray *)spareColumnNames{
    
}

- (void)columnViewColumnTitleButton:(UIButton *)button DidClickAtIndex:(NSInteger)index {
    [self creatTabel:(int)index isScroll:YES];
}


-(void)creatTabel:(int)index isScroll:(BOOL)scroll{
//    NSArray *array = @[@"头条",@"财经",@"体育",@"娱乐圈",@"段子",@"健康",@"图片",@"军事",@"精选",@"国际足球",@"历史",@"跟帖",@"居家"];
    BOOL check=[self.checkArray containsObject:[NSString stringWithFormat:@"%d",(int)index]];
    if (!check) {
        YeFuTableView *view=[[YeFuTableView alloc]initWithFrame:CGRectMake(index*AL_DEVICE_WIDTH, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-64-40)];
        NSDictionary *dic=[self.array objectAtIndex:index];
        [view setName:[dic stringForKey:@"name"]];
        [view setCat_id:[dic stringForKey:@"id"]];
        [_scroll addSubview:view];
        [self.checkArray addObject:[NSString stringWithFormat:@"%d",(int)index]];
        [view setDelegate:self];
    }
    if (scroll) {
        [_scroll setContentOffset:CGPointMake(AL_DEVICE_WIDTH*index, 0) animated:YES];
    }
    
}


/*****************************查看冶父报*************************************/
-(void)lookDetail:(YeFuListModel *)model{
    WKBaseViewController *vc=[[WKBaseViewController alloc]init];
    [vc setModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}
/*****************************查看冶父报*************************************/

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
