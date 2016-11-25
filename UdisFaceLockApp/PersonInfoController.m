//
//  SetViewController.m
//  CloudShop
//
//  Created by meng jianhua on 14-4-3.
//  Copyright (c) 2014年 mengjianhua. All rights reserved.
//

#import "PersonInfoController.h"
#import "MyUtiles.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+HM.h"

#define IOS7 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
#define IOS8 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
#define IOS9 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)


@interface PersonInfoController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationBarDelegate>{

    NSString *_newMesage;
}

@end

@implementation PersonInfoController

- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal{
    
    self = [super init];
    if (self){
        /*
        self.szSignal = szSignal;
        self.view.frame = frame;
        self.title = szSignal;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.view.layer.borderWidth = 1;
        self.view.layer.borderColor = [UIColor blueColor].CGColor;
         */
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    //self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //改变导航栏颜色
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    
    
    /* 此方法设置nav透明和隐藏下划线，但是回影响到下一个页面的nav，所以采用nav的代理方法隐藏本页面的nav
    //设置nav透明
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //去除nav下的黑线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    */
    self.navigationController.delegate = self; //实现nav代理隐藏本页面的nav
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.layer.cornerRadius = 5;
    exitBtn.backgroundColor = [UIColor redColor];
    [exitBtn setFrame:CGRectMake((self.view.frame.size.width-220)/2, 380,220, 30)];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [exitBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
    
    [self creatView];
    [self creatHeadImg];

}

-(void)creatHeadImg{

    UIImage *image = [UIImage imageNamed:@"head"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    UIImage *image1 = [UIImage imageNamed:@"header1"];
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2, 70, 50, 50)];
    imageView1.image = image1;
    [imageView addSubview:imageView1];
}

-(void)creatView{

    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 200, 100, 30)];
    numLabel.font  = [UIFont systemFontOfSize:16];
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.textColor = [UIColor blackColor];
    numLabel.text = @"手机号码:";
    [self.view addSubview:numLabel];
    
    UILabel *numLabel1 = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2+100, 200, 120, 30)];
    numLabel1.font  = [UIFont systemFontOfSize:15];
    numLabel1.textAlignment = NSTextAlignmentRight;
    numLabel1.textColor = [UIColor blackColor];
    NSString *user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    numLabel1.text = [NSString stringWithFormat:@"%@",user];
    [self.view addSubview:numLabel1];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 230, 220, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
        
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 240, 100, 30)];
    userNameLabel.font  = [UIFont systemFontOfSize:16];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.textColor = [UIColor blackColor];
    userNameLabel.text = @"用户名字:";
    [self.view addSubview:userNameLabel];
    
    UILabel *userNameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2+100, 240, 120, 30)];
    userNameLabel1.font  = [UIFont systemFontOfSize:15];
    userNameLabel1.textAlignment = NSTextAlignmentRight;
    userNameLabel1.textColor = [UIColor blackColor];
    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    userNameLabel1.text = [NSString stringWithFormat:@"%@",username];
    [self.view addSubview:userNameLabel1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 270, 220, 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView2];
    
//    UIButton *modiBtn = [MyUtiles createBtnWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 280, 220, 30) title:@"修改密码" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(modiPassword)];
//    [modiBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [modiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    modiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    modiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //按钮文子居左
//    modiBtn.backgroundColor = [UIColor clearColor];
//    UIImage *image = [UIImage imageNamed:@"arrow_right2@2x"];
//    [modiBtn setImage:image forState:UIControlStateNormal];
//    /*
//     setTitleEdgeInsets 设置button上文字位置（距上，左，下，右）
//     setImageEdgeInsets 设置button上图片位置（距上，左，下，右）
//     */
//    [modiBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
//    [modiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, modiBtn.bounds.size.width-image.size.width, 0, -modiBtn.bounds.size.width)];
//    [self.view addSubview:modiBtn];
//    
//    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 310, 220, 1)];
//    lineView3.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:lineView3];
    
    
    UIButton *clearBtn = [MyUtiles createBtnWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 280, 220, 30) title:@"清除缓存" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(clearTmpPics)];
    [clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //按钮文子居左
    clearBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearBtn];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 310, 220, 1)];
    lineView4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView4];

}

-(void)clearTmpPics{
    
    if (IOS8) {
        
        NSLog(@"systemVersion >= 8");
        float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
        NSString *message = [NSString stringWithFormat:@"%@ ?", clearCacheName];
        NSLog(@"clearCacheName is %@", clearCacheName);
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"clear disk");
            [self showHUD];
            [[SDImageCache sharedImageCache] clearDisk];
            //[[SDImageCache sharedImageCache] clearMemory];
            [self hideHUD];
            
        }];
        [alertC addAction:cancelAction];
        [alertC addAction:defaultAction];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else {
        
        NSLog(@"systemVersion < 8");
        float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
        NSString *message = [NSString stringWithFormat:@"%@ ?", clearCacheName];
        NSLog(@"clearCacheName is %@", clearCacheName);

        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        NSLog(@"clear disk");
        [self showHUD];
        [[SDImageCache sharedImageCache] clearDisk];
        //[[SDImageCache sharedImageCache] clearMemory];
        [self hideHUD];
    }
}

-(void)exit{

    exit(0);
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)modiPassword{

    self.hidesBottomBarWhenPushed = YES;
    ModiPasswordController *modiPassWordVc = [[ModiPasswordController alloc]init];
    [self.navigationController pushViewController:modiPassWordVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

//隐藏本页面的nav
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //如果是当前控制器，则隐藏背景；如果不是当前控制器，则显示背景
    if (viewController == self) {
        for (UIView *view in [self.navigationController.navigationBar subviews]) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                
                //最好使用隐藏，指不定什么时候你又想让他出现
                view.hidden = YES;
                
                //如果不想让它一直出现，那么可以移除
                //[view removeFromSuperview];
            }
        }
    } else {
        for (UIView *view in [self.navigationController.navigationBar subviews]) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                view.hidden = NO;
            }
        }
    }
}

/*
-(void)LocationPath:(NSInteger *)section{
    
    self.dataSource1 = [NSArray arrayWithObjects:@"本地文件路径",@"视频扫描设置",@"选择解码方式",@"左眼开启效果",nil];
    self.dataSource2 = [NSArray arrayWithObjects:@"视频来源",@"同时缓存数",@"离线缓存保存位置",@"语言设置",nil];

    if (section == 0) {
        [self AlertLogMsg:@"本地文件路径"];
    }else{
        [self AlertLogMsg:@"视频来源"];
    }
}

-(void)VideoScan:(NSInteger *)section{
    if (section == 0) {
        [self AlertLogMsg:@"视频扫描设置"];
    }else{
        [self AlertLogMsg:@"同时缓存数"];
    }
}

-(void)SeleDecodeTyep:(NSInteger *)section{
    if (section == 0) {
        [self AlertLogMsg:@"选择解码方式"];
    }else{
        [self AlertLogMsg:@"离线缓存保存位置"];
    }
}

-(void)LeftEyeEffect:(NSInteger *)section{
    if (section == 0) {
        [self AlertLogMsg:@"左眼开启效果"];
    }else{
        [self AlertLogMsg:@"语言设置"];
    }
}
*/


-(void)superBackButtonTouchEvent:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)pushVC:(UIViewController *)ViewVC{
    [self.navigationController pushViewController:ViewVC animated:YES];
}

-(void)AlertLogMsg:(NSString *)logMsg{
    NSLog(@"您选择了%@",logMsg);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:logMsg message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
