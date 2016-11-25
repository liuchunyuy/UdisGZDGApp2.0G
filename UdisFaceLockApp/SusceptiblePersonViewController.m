//
//  SusceptiblePersonViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/10/19.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "SusceptiblePersonViewController.h"
#import "SuscPerListViewController.h"
#import "SuscPerCountViewController.h"

@interface SusceptiblePersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SusceptiblePersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self createTableView];
}

-(void)createTableView{

    _dataArray = [NSMutableArray arrayWithObjects:@"敏感人群开门记录列表",@"敏感人群类型统计",nil];
    //_dataArray = @[@"敏感人群列表",@"敏感人群类型统计"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-113)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_tableView];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = @"cell";
    //NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    
    //cell右边的显示方式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = _dataArray[0];
    }else if (indexPath.row == 1){
    
        cell.textLabel.text = _dataArray[1];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:bar];
        SuscPerListViewController *suscPerListVc = [[SuscPerListViewController alloc]init];
        [self.navigationController pushViewController:suscPerListVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (indexPath.row == 1){
        self.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:bar];
        SuscPerCountViewController *suscPerCountVc = [[SuscPerCountViewController alloc]init];
        [self.navigationController pushViewController:suscPerCountVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
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
