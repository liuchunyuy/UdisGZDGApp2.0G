//
//  AppDelegate.m
//  NewsFourApp
//
//  Created by chen on 14/8/8.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainAppViewController.h"
#import "PersonInfoController.h"
#import "NewMessageController.h"
#import "SusceptiblePersonViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "RegisteredController.h"
#import "OpenLockRecordViewController.h"

#import <AdSupport/AdSupport.h>
#import "JPUSHService.h"
//#import <UserNotifications/UserNotifications.h>

#import<UIKit/UIKit.h>

static NSString *appKey = @"e67da345f5485b342b98e1cb";//申请应用成功以后官方会提供给你

static NSString *channel = @"Publish channel";

static BOOL isProduction = FALSE;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //[JSPatch startWithAppKey:@"717e9d60336ca60e"];
   // [JSPatch sync];
    
    // 设置应用程序的图标右上角的数字(首次启动设置为0)
    [application setApplicationIconBadgeNumber:0];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor]; //.............
    self.window.rootViewController = [[RegisteredController alloc]init];
    [self.window makeKeyAndVisible];

    return YES;

}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收到本地通知");
        
    // 查看当前的状态出于(前台: 0)/(后台: 2)/(从后台进入前台: 1)
    NSLog(@"applicationState.rawValue: %zd", application.applicationState);
    
    // 执行响应操作
    // 如果当前App在前台,执行操作
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"执行前台对应的操作");
        [application setApplicationIconBadgeNumber:0];
        [self showAlert:@"有敏感人群开门，请去最新记录查看!"];
        
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 后台进入前台
        NSLog(@"执行后台进入前台对应的操作");
        NSLog(@"%@", notification.userInfo);
        [[NSUserDefaults standardUserDefaults] setObject:@"IWillGo" forKey:@"localPush"];
        [self goToActionViewController];
        
    } else {
        // 当前App在后台
        NSLog(@"执行后台对应的操作");
    }
}


-(void)goToActionViewController{
    
    //加载主页面
    NSMutableArray *VcArr = [[NSMutableArray alloc]init];
    UITabBarController * tabbarController = [[UITabBarController alloc]init];
    
    MainAppViewController *mainVc = [[MainAppViewController alloc]init];
    mainVc.title = @"主要服务";
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:mainVc];
    
    NewMessageController *newMessageVc = [[NewMessageController alloc]init];
    newMessageVc.title = @"最新消息";
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:newMessageVc];
    
    PersonInfoController *personInfoVc = [[PersonInfoController alloc]init];
    personInfoVc.title = @"个人中心";
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:personInfoVc];
    
    SusceptiblePersonViewController *suscPerVc = [[SusceptiblePersonViewController alloc]init];
    suscPerVc.title = @"敏感人群统计";
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:suscPerVc];
    
    [VcArr addObject:nav1];
    [VcArr addObject:nav2];
    [VcArr addObject:nav3];
    [VcArr addObject:nav4];
    tabbarController.viewControllers = VcArr;
    NSArray *imageArray = @[@"主要@2x",@"最新@2x",@"个人@2x",@"个人@2x"];
    for (int i = 0; i < imageArray.count; i++) {
        UITabBarItem *item = tabbarController.tabBar.items[i];
        [item setImage:[UIImage imageNamed:imageArray[i]]];
    }
    self.window.rootViewController = tabbarController;
    
}

// Pop-up box
- (void)timerFireMethod:(NSTimer*)theTimer{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{// time
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication]endBackgroundTask:UIBackgroundTaskInvalid];
    [application setApplicationIconBadgeNumber:0];   //清除角标
    //[application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
