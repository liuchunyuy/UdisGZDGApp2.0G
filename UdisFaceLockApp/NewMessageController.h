//
//  NewMessageController.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/8/9.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "Config.h"
#import "Utils.h"


@interface NewMessageController : UIViewController{


    AsyncSocket *clientSocket;

}


@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITableView *tb;
//@property(nonatomic,assign)RequestType type;
@property(nonatomic,readonly)NSMutableArray *dataArray;

@property(nonatomic,copy)NSMutableArray *messagesArr;
@end
