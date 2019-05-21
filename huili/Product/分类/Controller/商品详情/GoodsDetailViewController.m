//
//  GoodsDetailViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/5.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ShareView.h"
#import "GoodsDetailView.h"
#import "MWPhotoBrowser.h"
#import "GoodsModel.h"
#import "GoPayViewController.h"
#import "KefuViewController.h"
#import "StandardsView.h"
#import "AttributesModel.h"
#import "AttPriceModel.h"

static NSString *SectionViewID = @"header";

@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,GoodsDetailViewDelegate,MWPhotoBrowserDelegate,UIWebViewDelegate,StandardsViewDelegate>

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)GoodsDetailView *headerView;

@property(nonatomic)UIView *cartView;//购买View

@property(nonatomic,weak)UISegmentedControl *segmentedControl;

@property(nonatomic,weak)UIButton *lastSelectBtn;

@property(nonatomic)NSString *url1;
@property(nonatomic)NSString *url2;

@property (nonatomic, strong) UIWebView *wkWebView1;

@property(nonatomic)float cellHeight1;


@property (nonatomic,retain) NSMutableArray *photosArray;

@property(nonatomic)NSMutableArray *attributeArray;//规格数组

@property(nonatomic)NSMutableArray *attributePriceArray;//规格价格数组

@property(nonatomic)NSDictionary *resDic;

@property(nonatomic)AttPriceModel *currentPriceMode;

@property(nonatomic,weak)StandardsView *standview;

@property(nonatomic)int num;

@property(nonatomic)RKNotificationHub* hub;

@property (nonatomic,assign)int car_num; ///< 已添加过购物车的数量

@end

@implementation GoodsDetailViewController


-(NSMutableArray*)attributeArray{
    if (_attributeArray==nil) {
        _attributeArray=[[NSMutableArray alloc]init];
    }
    return _attributeArray;
}
-(NSMutableArray*)attributePriceArray{
    if (_attributePriceArray==nil) {
        _attributePriceArray=[[NSMutableArray alloc]init];
    }
    return _attributePriceArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.num=1;
    self.car_num =  0;
    self.cellHeight1=AL_DEVICE_HEIGHT-64;
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"common_button_share_def"] style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
    self.navigationItem.rightBarButtonItem=rightBar;

    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"商品",@"详情",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 7, 200, 30) ;
    _segmentedControl=segmentedControl;
    // 设置默认选择项索引
    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView=segmentedControl;
    [segmentedControl addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = nil;
    
    self.navigationItem.title = @"商品详情";
    
    self.resDic=[[NSDictionary alloc]init];
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:self.goods_id forKey:@"goods_id"];
    [self post:GoodsDetail withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [self.view addSubview:self.myTableView];
            NSDictionary *dic=[responseObject objectForKey:@"data"];
            self.resDic=dic;
            NSLog(@"%@",responseObject);
            [self.headerView setDic:dic];
            self.url1=[dic stringForKey:@"detail_url"];
            self.url2=[dic stringForKey:@"specif_url"];
            NSURL *url = [NSURL URLWithString:self.url1];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.wkWebView1 loadRequest:request];
            [self.view addSubview:self.cartView];
            [self creatCart];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
//            inventory
            NSArray *attsArr=[dic objectForKey:@"attributes"];
            for (int i=0; i<attsArr.count; i++) {
                NSDictionary *dic=[attsArr objectAtIndex:i];
                AttributesModel *model=[AttributesModel model];
                [model initWithDictionary:dic];
                [self.attributeArray addObject:model];
            }
            
            NSArray *priceArr=[dic objectForKey:@"attribute_price"];
            for (int i=0; i<priceArr.count; i++) {
                NSDictionary *dic=[priceArr objectAtIndex:i];
                AttPriceModel *model=[AttPriceModel model];
                [model initWithDictionary:dic];
                [self.attributePriceArray addObject:model];
            }
            [self getCartNumber];
            if (self.attributeArray.count==0) {
                [self.headerView.selectValue setText:@"无规格"];
            }
            
        }
    } failure:nil];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.resDic) {
        [self getCartNumber];
    }
}

-(void)delayMethod{
    [self selectClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*****************************商品详情*************************************/
-(GoodsDetailView*)headerView{
    if (_headerView==nil) {
        _headerView=[[GoodsDetailView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_WIDTH+172.5)];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        [_headerView setDelegate:self];
    }
    return _headerView;
    
}
/*****************************商品详情*************************************/
/***************************商品，详情切换***************************************/
-(void)changeSeg:(UISegmentedControl*)seg{
    NSLog(@"%d",(int)seg.selectedSegmentIndex);
    if ((int)seg.selectedSegmentIndex==0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.myTableView setContentOffset:CGPointMake(0, 0)];
        }];
        
    }else{
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.myTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
/***************************商品，详情切换***************************************/
/***************************分享***************************************/
-(void)shareClick{
    [[ShareView ShareViewClient] shareClick:nil setTitle:nil setContent:nil setIcon:nil];
}
/***************************分享***************************************/

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-50) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableHeaderView=self.headerView;
        _myTableView.showsVerticalScrollIndicator = NO;
        [_myTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:SectionViewID];
    }
    return _myTableView;
}
/******************************UITableView初始化结束**************************************/

#pragma mark UITableView代理
/******************************UITableView代理开始**************************************/

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 44)];
    [header setBackgroundColor:[UIColor whiteColor]];
    header.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(win_width/2-80/2, 12, 80, 20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"A4A5A4"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"商品详情";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:titleLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, 21.5, titleLabel.minX-15, 1)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"A4A5A4"];
    [header addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.maxX, lineView1.minY, win_width-15-titleLabel.maxX, 1)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"A4A5A4"];
    [header addSubview:lineView2];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectClick)];
    [header addGestureRecognizer:tap];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, 1)];
    [topLine setBackgroundColor:LineColor];
    [header addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, header.height-1, win_width, 1)];
    [bottomLine setBackgroundColor:LineColor];
    [header addSubview:bottomLine];
   
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell addSubview:self.wkWebView1];
    }
    [self.wkWebView1 setFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, self.cellHeight1)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setBackgroundColor:[UIColor orangeColor]];
    
    
    
    return cell;
}

/******************************UITableView代理结束**************************************/

-(UIWebView*)wkWebView1{
    if (_wkWebView1==nil) {
        _wkWebView1=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, self.cellHeight1)];
        [_wkWebView1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_wkWebView1 setMultipleTouchEnabled:YES];
        [_wkWebView1 setAutoresizesSubviews:YES];
        [_wkWebView1.scrollView setAlwaysBounceVertical:YES];
        [_wkWebView1 setDelegate:self];
        _wkWebView1.scrollView.scrollEnabled = NO;
        
        _wkWebView1.scrollView.bounces = NO;
    }
    return _wkWebView1;
}
/*******************************选择详情或者规格***********************************/
-(void)selectClick{
    NSURL *url = [NSURL URLWithString:self.url1];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView1 loadRequest:request];
}
/*******************************选择详情或者规格***********************************/

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [webView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id data, NSError * _Nullable error) {
//        CGFloat height = [data floatValue];
////        document.body.scrollHeight
//        //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
//        self.cellHeight1=height;
////        self.wkWebView1=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, self.cellHeight1)];
//        [self.myTableView reloadData];
//
//    }];
//
//}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    // 计算UIWebView高度
    CGRect frame =webView.frame;
    frame.size.height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] doubleValue]+8;
    webView.frame = frame;
    
    CGFloat height = frame.size.height;
    //        document.body.scrollHeight
    //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
    self.cellHeight1=height;
    //        self.wkWebView1=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, self.cellHeight1)];
    [self.myTableView reloadData];
}



/******************************图片浏览************************************/
-(NSMutableArray*)photosArray{
    if (_photosArray==nil) {
        _photosArray=[[NSMutableArray alloc]init];
    }
    return _photosArray;
}
-(void)showImgArray:(NSArray *)array setIndex:(int)index{
    //先清空数组
    [self.photosArray removeAllObjects];
    //再添加图片
    for (int i = 0;i < array.count; i++) {
        MWPhoto *photo=[MWPhoto photoWithURL:[NSURL URLWithString:[array objectAtIndex:i]]];
        photo.caption = [NSString stringWithFormat:@"第%d张图片",i+1];
        [self.photosArray addObject:photo];
    }
    
    //初始化
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    //set options
    [photoBrowser setCurrentPhotoIndex:index];
    photoBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
    photoBrowser.displayNavArrows = NO; //显示左右划动
    photoBrowser.displaySelectionButtons = NO; //是否显示选择图片按钮
    photoBrowser.alwaysShowControls = NO; //控制条始终显示
    photoBrowser.zoomPhotosToFill = YES; //是否自适应大小
    photoBrowser.enableGrid = YES;//是否允许网络查看图片
    photoBrowser.startOnGrid = YES; //是否以网格开始;
    photoBrowser.enableSwipeToDismiss = YES;
    photoBrowser.autoPlayOnAppear = NO;//是否自动播放视频
    
    //这样处理的目的是让整个页面跳转更加自然
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:photoBrowser];
    navC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:navC animated:YES completion:nil];
    
}

#pragma mark - MWPhotosBrowserDelegate
//必须实现的方法
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return  self.photosArray.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < self.photosArray.count) {
        return [self.photosArray objectAtIndex:index];
    }
    return nil;
}
//可选方法
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    NSLog(@"当前显示图片编号----%ld",index);
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index{
    NSLog(@"分享按钮的点击方法----%ld",index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index{
    //浏览图片时是图片是否选中状态
    return NO;
}
//有navigationBar时title才会显示
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    
    NSString *str = nil;
    switch (index) {
        case 0 :
            str = @"图片详情";
            break;
        case 1 :
            str = @"图片详情";
            break;
        case 2 :
            str = @"图片详情";
            break;
        default:
            break;
    }
    return str
    ;
}

-(void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/******************************图片浏览************************************/

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSIndexPath *path =  [self.myTableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<(AL_DEVICE_WIDTH+127)) {
        [_segmentedControl setSelectedSegmentIndex:0];
    }else{
        [_segmentedControl setSelectedSegmentIndex:1];
    }
}


/******************************购买View************************************/
-(UIView*)cartView{
    if (_cartView==nil) {
        _cartView=[[UIView alloc]initWithFrame:CGRectMake(0, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-50, AL_DEVICE_WIDTH, 50)];
        [_cartView setBackgroundColor:[UIColor whiteColor]];
        UIButton *buyBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH/2, 50)];
        [buyBtn setBackgroundColor:[UIColor colorWithHexString:@"ffa31e"]];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_cartView addSubview:buyBtn];
        [buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *CartAddBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH/2, 0, AL_DEVICE_WIDTH/2, 50)];
        [CartAddBtn setBackgroundColor:STYLECOLOR];
        [CartAddBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [CartAddBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [CartAddBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_cartView addSubview:CartAddBtn];
        [CartAddBtn addTarget:self action:@selector(cartAddClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cartView;
}
#pragma mark--立即购买
-(void)buyClick{
    if (self.currentPriceMode||self.attributeArray.count==0) {
        [self goToOrder];
        
        return;
    }
    StandardsView *mystandardsView = [self buildStandardView:[self.resDic stringForKey:@"goods_img"] andIndex:0];
    mystandardsView.GoodDetailView = self.view;//设置该属性 对应的view 会缩小
    mystandardsView.showAnimationType = StandsViewShowAnimationShowFrombelow;
    mystandardsView.dismissAnimationType = StandsViewDismissAnimationDisFrombelow;
    [mystandardsView show];
    
}
#pragma mark--加入购物车
-(void)cartAddClick{
    
    if (TOKEN.length==0||(!TOKEN)) {
        [YHHelpper alertLogin];
        return;
    }
    
    if (self.currentPriceMode||self.attributeArray.count==0) {
        self.car_num++;
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setValue:TOKEN forKey:@"token"];
        [param setValue:@"1" forKey:@"type"];
        if (self.attributeArray.count==0) {
            [param setValue:@"0" forKey:@"attr_ids"];
        }else{
            [param setValue:self.currentPriceMode.attribute_id forKey:@"attr_ids"];
        }
        [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
        [param setValue:self.goods_id forKey:@"goods_id"];
        [param setValue:[NSString stringWithInt:self.num] forKey:@"num"];
        [self post:AddCart withParam:param success:^(id responseObject) {
            int code=[responseObject intForKey:@"code"];
            if (code==1) {
                [SVProgressHUDHelp SVProgressHUDSuccess:@"加入购物车成功"];
                NSDictionary *dic=[responseObject objectForKey:@"data"];
                [_hub setCount:[dic intForKey:@"num"]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_CartChange object:nil userInfo:nil];
            }else{
                [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
            }
        } failure:nil];
        return;
    }
    StandardsView *mystandardsView = [self buildStandardView:[self.resDic stringForKey:@"goods_img"] andIndex:0];
    mystandardsView.GoodDetailView = self.view;//设置该属性 对应的view 会缩小
    mystandardsView.showAnimationType = StandsViewShowAnimationShowFrombelow;
    mystandardsView.dismissAnimationType = StandsViewDismissAnimationDisFrombelow;
    [mystandardsView show];
}
/******************************购买View************************************/



/*******************************结算***********************************/
-(void)goToOrder{
    
    if (TOKEN.length==0||(!TOKEN)) {
        [YHHelpper alertLogin];
        return;
    }
    
    NSString *ids=@"";
    
    if (self.attributeArray.count==0) {
        ids=[NSString stringWithFormat:@"%@_%@_%d",self.goods_id,@"0",self.num];
    }else{
        ids=[NSString stringWithFormat:@"%@_%@_%d",self.goods_id,self.currentPriceMode.attribute_id,self.num];
    }
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:@"1" forKey:@"type"];
    [param setValue:ids forKey:@"ids"];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [self post:GoOrderInfo withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSDictionary *dic=[responseObject objectForKey:@"data"];
            GoPayViewController *vc=[[GoPayViewController alloc]init];
            vc.push_type = 1;
            [vc setDicData:dic];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.view makeToast:[responseObject stringForKey:@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
}

/********************************创建购物车按钮**********************************/
-(void)creatCart{
    UIButton *cartBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-80, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-160, 60, 60)];
    [cartBtn setImage:[UIImage imageNamed:@"commodity_button_cart_def"] forState:UIControlStateNormal];
    [self.view addSubview:cartBtn];
    [cartBtn addTarget:self action:@selector(gotoCart) forControlEvents:UIControlEventTouchUpInside];
    RKNotificationHub* hub = [[RKNotificationHub alloc]initWithView:cartBtn];
    [hub setCircleAtFrame:CGRectMake(cartBtn.width-25, 5, 20, 20)];
    hub.count=0;
    _hub=hub;
}
/********************************创建购物车按钮**********************************/
/********************************前往购物车**********************************/
-(void)gotoCart{
    if (TOKEN.length==0||(!TOKEN)) {
        [YHHelpper alertLogin];
        return;
    }
    [self.tabBarController setSelectedIndex:2];
}
/********************************前往购物车**********************************/
#pragma mark--规格选择
/********************************规格选择**********************************/
-(StandardsView *)buildStandardView:(NSString *)img andIndex:(NSInteger)index
{
    StandardsView *standview = [[StandardsView alloc] init];
    _standview=standview;
    standview.tag = index;
    standview.delegate = self;
    [standview.mainImgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:DefaultsImg];
    standview.mainImgView.backgroundColor = [UIColor whiteColor];
    standview.priceLab.text = [NSString stringWithFormat:@"￥%@",[self.resDic stringForKey:@"price"]];
    standview.tipLab.text = @"请选择规格";
    standview.goodNum.text =[NSString stringWithFormat:@"库存 %@件",[self.resDic stringForKey:@"inventory"]];
    
    standview.customBtns = @[@"确定"];
    
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    for (int i=0; i<self.attributeArray.count; i++) {
        NSMutableArray *tempClassInfoArr=[[NSMutableArray alloc]init];
        AttributesModel *model=[self.attributeArray objectAtIndex:i];
        for (int j=0; j<model.array.count; j++) {
            AttributeModel *attModel=[model.array objectAtIndex:j];
                standardClassInfo *tempClassInfo = [standardClassInfo StandardClassInfoWith:attModel.attribute_id andStandClassName:attModel.name];
            [tempClassInfoArr addObject:tempClassInfo];
        }
        StandardModel *tempModel = [StandardModel StandardModelWith:tempClassInfoArr andStandName:model.name];
        [tempArray addObject:tempModel];
    }
    standview.standardArr = tempArray;

    return standview;
}

#pragma mark - standardView  delegate
//点击自定义按键
-(void)StandardsView:(StandardsView *)standardView CustomBtnClickAction:(UIButton *)sender
{
    if (sender.tag == 0) {
        if (!self.currentPriceMode) {
            [SVProgressHUDHelp SVProgressHUDFail:@"请选择规格"];
            return;
        }
        //将商品图片抛到指定点
        self.num=(int)standardView.buyNum;
        [_standview dismiss];
        self.car_num = self.num -1 + self.car_num; //这里减一是为了方便后面加入购物车直接默认加一
//        [self cartAddClick];
        
//        [standardView ThrowGoodTo:CGPointMake(AL_DEVICE_WIDTH-30, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-130) andDuration:1.6 andHeight:10 andScale:20];
    }
    else
    {
        [standardView dismiss];
    }
}

//点击规格代理
-(void)Standards:(StandardsView *)standardView SelectBtnClick:(UIButton *)sender andSelectID:(NSString *)selectID andStandName:(NSString *)standName andIndex:(NSInteger)index
{
    AttributesModel *model=[self.attributeArray objectAtIndex:index];
    for (int i=0; i<model.array.count; i++) {
        AttributeModel *attModel=[model.array objectAtIndex:i];
        attModel.isSelect=NO;
        if ([attModel.attribute_id isEqualToString:selectID]) {
            attModel.isSelect=YES;
        }
    }
    [self checkAttribute];
    NSLog(@"selectID = %@ standName = %@ index = %ld",selectID,standName,(long)index);
    
    [self checkAttribute];
}
//设置自定义btn的属性
-(void)StandardsView:(StandardsView *)standardView SetBtn:(UIButton *)btn
{
    if (btn.tag == 0) {
        btn.backgroundColor = STYLECOLOR;
    }
    else if (btn.tag == 1)
    {
        btn.backgroundColor = [UIColor orangeColor];
    }
}



#pragma mark--规则选择代理
-(void)selectGuiGe{
    if (self.attributeArray.count>0) {
        StandardsView *mystandardsView = [self buildStandardView:[self.resDic stringForKey:@"goods_img"] andIndex:0];
        mystandardsView.GoodDetailView = self.view;//设置该属性 对应的view 会缩小
        mystandardsView.showAnimationType = StandsViewShowAnimationShowFrombelow;
        mystandardsView.dismissAnimationType = StandsViewDismissAnimationDisFrombelow;
        [mystandardsView show];
    }
    
}

/********************************规格选择**********************************/
#pragma mark--检测规格
-(void)checkAttribute{
    NSMutableArray *idsArray=[[NSMutableArray alloc]init];
    for (int i=0; i<self.attributeArray.count; i++) {
        AttributesModel *model=[self.attributeArray objectAtIndex:i];
        for (int j=0; j<model.array.count; j++) {
            AttributeModel *attModel=[model.array objectAtIndex:j];
            if (attModel.isSelect) {
                [idsArray addObject:attModel.attribute_id];
            }
        }
    }
    NSString *tempString = [idsArray componentsJoinedByString:@","];
    tempString=[NSString stringWithFormat:@",%@,",tempString];
    NSLog(@"%@",tempString);
    
    for (int i=0; i<self.attributePriceArray.count; i++) {
        AttPriceModel *model=[self.attributePriceArray objectAtIndex:i];
        if ([model.attr_ids isEqualToString:tempString]) {
            self.currentPriceMode=model;
        }
    }
    if (self.currentPriceMode) {
        _standview.priceLab.text = [NSString stringWithFormat:@"￥%@",self.currentPriceMode.price];
        _standview.tipLab.text = self.currentPriceMode.attr_names;
        _standview.goodNum.text =[NSString stringWithFormat:@"库存 %@件",self.currentPriceMode.inventory];
        [self.headerView.selectValue setText:self.currentPriceMode.attr_names];
    }
    
}

-(void)getCartNumber{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [param setValue:TOKEN forKey:@"token"];
    [[XAClient sharedClient]postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,CartNumber] withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSLog(@"%@",responseObject);
            NSDictionary *data=[responseObject objectForKey:@"data"];
            int num=[data intForKey:@"num"];
            [_hub setCount:num];
        }
    } failure:nil];
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
