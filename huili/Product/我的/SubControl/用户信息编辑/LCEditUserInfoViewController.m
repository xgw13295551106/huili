//
//  LCEditUserInfoViewController.m
//  zhuaWaWa
//
//  Created by zhongweike on 2017/11/24.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCEditUserInfoViewController.h"
#import "LCEditHeadImgCell.h"
#import "LCEditUserInfoCell.h"
#import "WJSTPickerArea.h"
#import "ModifyMobileViewController.h"
#import "LCUpdateEmailViewController.h"

@interface LCEditUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WJSTPickerAreaDelegate>

@property (nonatomic,strong)UITableView *tableView;


@end

@implementation LCEditUserInfoViewController


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-64 - 150) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"F4F5F4"]];
        _tableView.tableFooterView = [UIView new];
        [_tableView setScrollEnabled:NO];
        [_tableView setSeparatorColor:[UIColor clearColor]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    [self setUpControls];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self requestUserInfoNetwork];
}

- (void)setUpControls{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"F4F5F4"]];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LCEditHeadImgCell *cell = [LCEditHeadImgCell getEditHeadImgCell:tableView andIndex:indexPath andIdentifier:@"editHeadImgCell"];
        return cell;
    }else if (indexPath.section >0){
        LCEditUserInfoCell *cell = [LCEditUserInfoCell getEditUserInfoCell:tableView andIndex:indexPath andIdentifier:@"editUserInfoCell"];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //点击修改头像
        [self uploadImage];
    }else if (indexPath.section == 1){
        //点击修改昵称
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:App_Name message:@"修改姓名" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"请输入姓名";
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alert.textFields.firstObject;
            if (textField.text.length==0) {
                [self toast:@"姓名不能为空"];
                return;
            }
            NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
            [param setValue:textField.text forKey:@"name"];
            [self requestUpdateNetworkWith:param];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (indexPath.section==2){
        //修改手机号
        ModifyMobileViewController *vc=[[ModifyMobileViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==3){
        //修改邮箱
        LCUpdateEmailViewController *vc = [[LCUpdateEmailViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }else {
        return 56;
    }
}

// 去掉UItableview sectionHeaderView黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark 图片上传
//TODO:选择上传图片方式
- (void)uploadImage{
    
    __block NSUInteger sourceType = 0;
    LCEditUserInfoViewController *editVC = self;
    [self addUISheetControlWithString:@"请选择上传方式" title1:@"相机" withFirstActionBlock:^{
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [editVC chooseImage:sourceType];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的手机不支持拍照功能" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [editVC presentViewController:alert animated:YES completion:nil];
        }
    } andTiele:@"相册" secondBlock:^{
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [editVC chooseImage:sourceType];
    }];
}

//从本地选择照片（拍照或从相册选择）
-(void)chooseImage:(NSInteger)sourceType
{
    //创建对象
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
    [imagePickerController.navigationBar setTintColor:[UIColor whiteColor]];
    [imagePickerController.navigationBar setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forBarMetrics:UIBarMetricsDefault];
    //设置代理
    imagePickerController.delegate = self;
    //是否允许图片进行编辑
    imagePickerController.allowsEditing = YES;
    //选择图片还是开启相机
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerController代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //选择图片
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSArray *imageArray = [[NSArray alloc]initWithObjects:image, nil];
    //上传图片操作
    [self requestUpdateHeadImgWith:imageArray];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 网络请求
//TODO:上传图片
- (void)requestUpdateHeadImgWith:(NSArray *)imageArray{
    [self JDuploadImages:imageArray isAsync:YES complete:^(NSArray<NSString *> *names) {
        NSString *imageName = names[0];
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        para[@"img"] = imageName;
        [self requestUpdateNetworkWith:para];
    } fail:nil];
}

//TODO:获取用户信息
- (void)requestUserInfoNetwork{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    [self post:GETINFO withParam:para success:^(id resultObject) {
        NSDictionary *dic = resultObject;
        if ([dic[@"code"] intValue] == 1) {
            UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues:dic[@"data"]];
            userInfo.token = TOKEN;
            [[UserInfoManager manager] saveUserInfo:userInfo];
            [self.tableView reloadData];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
    
}

//TODO:更改用户信息
- (void)requestUpdateNetworkWith:(NSMutableDictionary *)para{
    para[@"token"] = TOKEN;
    [SVProgressHUD show];
    [self postInbackground:XYUpdate withParam:para success:^(id resultObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = resultObject;
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *dataDic = dic[@"data"];
            UserInfoModel *userInfo = [UserInfoManager currentUser];
            userInfo.img = dataDic[@"img"];
            userInfo.name = dataDic[@"name"];
            userInfo.email = dataDic[@"email"];
            userInfo.province = dataDic[@"province"];
            userInfo.city = dataDic[@"city"];
            userInfo.gender = dataDic[@"gender"];
            userInfo.district = dataDic[@"district"];
            [[UserInfoManager manager] saveUserInfo:userInfo];
            [self.view makeToast:@"保存成功" duration:1.2 position:CSToastPositionCenter];
            [self.tableView reloadData];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:nil];
}


/****************************选择区域后代理**************************************/
-(void)pickerArea:(WJSTPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:province forKey:@"province"];
    [param setValue:city forKey:@"city"];
    [param setValue:area forKey:@"district"];
    [self requestUpdateNetworkWith:param];
}
/****************************选择区域后代理**************************************/

#pragma mark UIAlert
- (void)addUISheetControlWithString:(NSString *)string title1:(NSString *)title1 withFirstActionBlock:(void(^)())firstBlock andTiele:(NSString *)title2 secondBlock:(void(^)())secondBlock{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        firstBlock();
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        secondBlock();
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:sheet animated:YES completion:nil];
    
}

@end
