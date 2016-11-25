//
//  SusceptiblePersonViewController.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/10/19.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SusceptiblePersonViewController : UIViewController

@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,assign)RequestType type;
@property(nonatomic,readonly)NSArray *dataArray;

@end
