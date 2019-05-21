//
//  LeftViewController.m
//  yihuo
//
//  Created by Carl on 2017/12/26.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftTableViewCell.h"
#import "FiltrateCollectionItem.h"
#import "FiltrateCollectionHeadView.h"

#define FiltrateViewScreenW win_width * 0.75

@interface LeftViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;

@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)NSArray *infoArray;

@property (nonatomic,strong)NSMutableArray *selectArray; //选中的分类

@property (nonatomic,strong)UIButton *resetButton; ///< 重置button
@property (nonatomic,strong)UIButton *confirmButton;  ///< 确认button

@end

@implementation LeftViewController

- (NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 10; //竖间距
        layout.itemSize = CGSizeMake((FiltrateViewScreenW - 6 * 5) / 3, 30);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.frame = CGRectMake(5, DCMargin, FiltrateViewScreenW - DCMargin, win_height - 60 - BottomHeight);
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[FiltrateCollectionItem class] forCellWithReuseIdentifier:@"FiltrateCollectionItem"];//cell
//        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DCHeaderReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCHeaderReusableViewID]; //头部
        [_collectionView registerClass:[FiltrateCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FiltrateCollectionHeadView"];

    }
    return _collectionView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _collectionView.maxY, FiltrateViewScreenW, 60)];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bottomView.width, 1)];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"F1F2F1"]];
        [_bottomView addSubview:lineView];
        
        _resetButton = [self getActionButton:CGRectMake(0, 1, _bottomView.width/2, _bottomView.height-1) andTitle:@"重置" andType:YES];
        [_resetButton addTarget:self  action:@selector(clickResetButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_resetButton];
        
        _confirmButton = [self getActionButton:CGRectMake(_resetButton.maxX, 1, _resetButton.width, _resetButton.height-1) andTitle:@"确定" andType:NO];
        [_confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_confirmButton];
    }
    return _bottomView;
}


- (UIButton *)getActionButton:(CGRect)frame andTitle:(NSString *)title andType:(BOOL)isReset{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    if (isReset) {
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [button setBackgroundColor:STYLECOLOR];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return button;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    [self requestNetwork];
    // Do any additional setup after loading the view.
}

#pragma mark UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _infoArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dic = _infoArray[section];
    NSArray *tmpArray = dic[@"clist"];
    return tmpArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _infoArray[indexPath.section];
    NSArray *tmpArray = dic[@"clist"];
    FiltrateCollectionItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"FiltrateCollectionItem" forIndexPath:indexPath];
    item.itemDic = tmpArray[indexPath.row];
    item.selectBlock = ^(BOOL isSelect, NSDictionary *itemDic) {
        if (isSelect) {
            [self.selectArray addObject:itemDic];
        }else{
            [self.selectArray removeObject:itemDic];
        }
    };
    item.isSelect = NO;
    for (NSDictionary *one in self.selectArray) {
        if ([[one stringForKey:@"id"] isEqualToString:[item.itemDic stringForKey:@"id"]]) {
            item.isSelect = YES;
            break;
        }
    }
    return item;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSDictionary *dic = _infoArray[indexPath.section];
        FiltrateCollectionHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FiltrateCollectionHeadView" forIndexPath:indexPath];
        headView.name = [dic stringForKey:@"name"];
        return headView;
    }
    return [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, win_width, 0.1)];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.width, 55);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((FiltrateViewScreenW - 6 * 5) / 3, 30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击item
}


-(void)setSelectClassBlock:(selectClassBlock)selectClassBlock{
    _selectClassBlock=selectClassBlock;
}

/******************************UITableView代理结束**************************************/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络请求
- (void)requestNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"cat_id"] = _currentModel.cat_id;
    [SVProgressHUD show];
    [self postInbackground:GoodsBrand withParam:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            _infoArray = dic[@"data"];
            [self.collectionView reloadData];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:Network_Error duration:1.2 position:CSToastPositionCenter];
    }];
    
}

//TOOD:点击重置button
- (void)clickResetButton:(UIButton *)button{
    [self.selectArray removeAllObjects];
    [self.collectionView reloadData];
}

//TODO:点击确定button
- (void)clickConfirmButton:(UIButton *)button{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *one in self.selectArray) {
        [tmpArray addObject:[one stringForKey:@"name"]];
    }
    _currentModel.filterArray = [tmpArray copy];
    if (self.selectClassBlock) {
        self.selectClassBlock(_currentModel);
    }
}


@end
