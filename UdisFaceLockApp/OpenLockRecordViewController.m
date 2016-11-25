//
//  OpenLockRecordViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/10/25.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "OpenLockRecordViewController.h"


#define HH_IsEmptyString1(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] )\
== 1 ? @"暂无记录":object\
)

@interface OpenLockRecordViewController ()
{
    NSArray *detailArray;
}
@end

@implementation OpenLockRecordViewController

-(void)viewWillAppear:(BOOL)animated{
    
    NSString * pushLocal = [[NSUserDefaults standardUserDefaults]objectForKey:@"localPush"];
    if ([pushLocal isEqualToString:@"IWillGo"]){
        
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"localPush"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = @"最新一次开门记录";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    _user = [[NSUserDefaults standardUserDefaults]objectForKey:@"n_user"];
    _username = [[NSUserDefaults standardUserDefaults]objectForKey:@"n_username"];
    _usertype = [[NSUserDefaults standardUserDefaults]objectForKey:@"n_usertype"];
    _photo = [[NSUserDefaults standardUserDefaults]objectForKey:@"n_photo"];

    NSLog(@"_photo----%@",_photo);
    NSLog(@"_user----%@",_user);
    NSLog(@"_username----%@",_username);
    NSLog(@"_usertype----%@",_usertype);
    
    [self createView];

}

-(void)createView{
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-60)/2, 84, 60, 30)];
    labelName.text = HH_IsEmptyString1(_username);
    
    labelName.font = [UIFont systemFontOfSize:15];
    labelName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelName];
    
    detailArray = [NSArray array];
    NSArray *labelArray = @[@"人员类型:",@"联系方式:",@"记录时间:"];
    if (_usertype == nil || _user == nil) {
        detailArray = @[@"暂无记录",@"暂无记录",@"暂无记录"];
    }else{
        NSDate *date=[NSDate date];//获取当前时间
        NSDateFormatter *format1=[[NSDateFormatter alloc]init];
        [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *str1=[format1 stringFromDate:date];
    detailArray = @[_usertype,_user,str1];
    }
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 340+30*i, 80, 20)];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(130, 340+30*i, self.view.frame.size.width-170, 20)];
        label.text = [NSString stringWithFormat:@"%@ :",labelArray[i]];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        label1.text = [NSString stringWithFormat:@"%@",detailArray[i]];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentRight;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, 340+20+30*i, self.view.frame.size.width-80, 1)];
        view.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:view];
        [self.view addSubview:label1];
        [self.view addSubview:label];
    }
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-130)/2, 130, 130, 160)];
    NSString *image1 = [[NSString alloc]init];
    image1 = _photo;
   // NSLog(@"image1 is %@", image1);
    if (image1 == NULL) {
        image.image = [UIImage imageNamed:@"moren1"];
        [self.view addSubview:image];
        return;
    }
    //NSData *photo  = [[NSData alloc] initWithBase64Encoding:image1];
    NSData *photo   = [[NSData alloc] initWithBase64EncodedString:image1 options:1];
    
    image.image=[UIImage imageWithData: photo];
    
    
    [self.view addSubview:image];

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
