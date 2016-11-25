//
//  SuscPerListViewController.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/10/19.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "Config.h"
#import "Utils.h"

@interface SuscPerListViewController : UIViewController{

    AsyncSocket *clientSocket;

}

@property(nonatomic,strong)UITableView *tb;
@property(nonatomic,readonly)NSMutableArray *dataArray;

//@property(nonatomic,copy)NSString *userId;

@end
