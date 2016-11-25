

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "DbUtil.h"
#import "ServerInfo.h"
#import "Utils.h"
#import "Config.h"
#import "CNPPopupController.h"

//弹出窗口
#import "PopoverView.h"

@interface MainAppViewController : UIViewController{
    AsyncSocket *clientSocket;
}

@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *user;
@property(nonatomic,copy) NSString *username;
@property (nonatomic, copy) NSString *usertype;


@end
