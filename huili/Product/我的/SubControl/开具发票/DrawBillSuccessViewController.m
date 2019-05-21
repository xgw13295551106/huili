//
//  DrawBillSuccessViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "DrawBillSuccessViewController.h"
#import "BillListViewController.h"

@interface DrawBillSuccessViewController ()

@end

@implementation DrawBillSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"开票成功"];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH-80)/2,30 , 80, 80)];
    [img setImage:[UIImage imageNamed:@"user_fapiao_tijiaochenggong"]];
    [self.view addSubview:img];
    [img setContentMode:UIViewContentModeCenter];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, img.bottom, AL_DEVICE_WIDTH-40, 30)];
    [label setText:@"提交成功"];
    [label setTextColor:text2Color];
    [label setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:label];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *lookBill=[[UIButton alloc]initWithFrame:CGRectMake(10, label.bottom+40, AL_DEVICE_WIDTH-20, 44)];
    [lookBill setTitle:@"开票明细" forState:UIControlStateNormal];
    [lookBill setBackgroundColor:STYLECOLOR];
    [lookBill.layer setCornerRadius:3];
    [lookBill setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookBill.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:lookBill];
    [lookBill addTarget:self action:@selector(billClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}

-(void)billClick{
    BillListViewController *vc=[[BillListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
