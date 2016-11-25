

#import "MainAppViewController.h"
#import "SubViewController.h"
#import "TouchPropagatedScrollView.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "SZKRoundScrollView.h"
#import "MyUtiles.h"
#import "OpenLockViewController.h"
#import "QRCodeViewController.h"
#import "NewMessageController.h"
#import "OpenLockRecordViewController.h"

#define HH_IsEmptyString1(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] )\
== 1 ? @"没有登记":object\
)


#define MENU_HEIGHT 36
#define MENU_BUTTON_WIDTH  100
#define MIN_MENU_FONT  13.f
#define MAX_MENU_FONT  18.f
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width //轮播宽
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height //轮播高

#define VIEW_HEIGTH self.view.frame.size.height
#define VIEW_WEIGHT self.view.frame.size.width

NSString *totalmessage=@"";

@interface MainAppViewController ()<UIScrollViewDelegate>{

    NSString *totalmessage;
}



@property(nonatomic,copy)SZKRoundScrollView *roundScrollView;
@property(nonatomic,copy)UIScrollView *buttonScrollView;
@property(nonatomic,copy)NSArray *localImageArr;
@property(nonatomic,copy)NSMutableArray *netImageArr;
@property(nonatomic,strong) OpenLockRecordViewController * recordVC;

@property(nonatomic)BOOL isLogined;

@end

@implementation MainAppViewController

////本地图片
//-(NSArray *)localImageArr{
//    
//    _localImageArr=@[@"mv_00",@"mv_01",@"mv_02"];
//    //轮播图图片数组
//    return _localImageArr;
//}

-(void)viewWillAppear:(BOOL)animated{
    
    NSString * pushLocal = [[NSUserDefaults standardUserDefaults]objectForKey:@"localPush"];
    if ([pushLocal isEqualToString:@"IWillGo"]) {
        
        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:bar];
        self.hidesBottomBarWhenPushed = NO;
        OpenLockRecordViewController *vc = [[OpenLockRecordViewController alloc]init];
        self.recordVC = vc;
        vc.photo = _photo;
        vc.user = _user;
        vc.username = _username;
        vc.usertype = _usertype;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad{
    
    UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1){
        
        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.f);
        statusBarView.backgroundColor = [UIColor clearColor];
        ((UIImageView *)statusBarView).backgroundColor = [UIColor clearColor];
        [self.view addSubview:statusBarView];
    }
    
    //self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //关闭软键盘使用
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    [super viewDidLoad];
    
    //按钮
    _buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+(VIEW_HEIGTH-64-49)/3, VIEW_WEIGHT, VIEW_HEIGTH-64-49- (VIEW_HEIGTH-64-49)/3)];
    _buttonScrollView.contentSize = CGSizeMake(VIEW_WEIGHT, VIEW_WEIGHT-20+VIEW_WEIGHT/3);
    _buttonScrollView.showsHorizontalScrollIndicator = NO;
    _buttonScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_buttonScrollView];
    totalmessage = @"";
        
    [self getData];
    [self creatBtnView];
    [self netImageArr];
    
}

//网络图片
-(NSArray *)netImageArr
{
    _netImageArr = [NSMutableArray array];
    NSString *url = @"http://140.207.101.214/UDISGZDG/advertisement.json";
    NSURL *url1 = [NSURL URLWithString:url];
    NSURLRequest *urlR = [NSURLRequest requestWithURL:url1];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlR completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *rec = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[rec dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"-----------------------------%@", dic);
        
        //回到主线程刷新页面
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (NSDictionary *dic1 in dic) {
                NSString *imgUrl =  [dic1 objectForKey:@"imgUrl"];
               // NSLog(@"imgUrl is %@", imgUrl);
                [_netImageArr addObject:imgUrl];
                //NSLog(@"_netImageArr is %@", _netImageArr);
            }
            NSLog(@"--------%@", _netImageArr);
            //展示图
            _roundScrollView=[SZKRoundScrollView roundScrollViewWithFrame:CGRectMake(0, 64, VIEW_WEIGHT, (VIEW_HEIGTH-64-49)/3) imageArr:_netImageArr timerWithTimeInterval:2 imageClick:^(NSInteger imageIndex) {
                NSLog(@"imageIndex:第%ld个",(long)imageIndex);
            }];
            
            [self.view addSubview:_roundScrollView];
        });
        
        //小圆点控制器位置
        _roundScrollView.pageControlAlignment=NSPageControlAlignmentCenter;
        //当前小圆点颜色
        _roundScrollView.curPageControlColor=[UIColor yellowColor];
        //其余小圆点颜色
        _roundScrollView.otherPageControlColor=[UIColor orangeColor];
        
    }];
    [dataTask resume];
    
    return _netImageArr;
    
}

-(void)creatBtnView{

    //开门按钮
    UIButton *openBtn = [MyUtiles createBtnWithFrame:CGRectMake(0, 0, VIEW_WEIGHT/2, VIEW_WEIGHT/3-20) title:@"开门" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(goOpenView)];
    openBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    openBtn.layer.borderWidth = 1.0f;
    openBtn.layer.masksToBounds = YES;
    //openBtn.layer.cornerRadius = 40;
    [openBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [openBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    //设置按钮上字体的位置（四个参数表示距离上边界，左边界，下边界，右边界，默认都为0）
    [openBtn setImage:[UIImage imageNamed:@"开门@2x"] forState:UIControlStateNormal];
    openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    openBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -10, 0);
    openBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    openBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [_buttonScrollView addSubview:openBtn];
    
    //二维码按钮
    UIButton *qrCodeBtn = [MyUtiles createBtnWithFrame:CGRectMake(VIEW_WEIGHT/2, 0, VIEW_WEIGHT/2, VIEW_WEIGHT/3-20) title:@"二维码" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(goQRCodeView)];
    qrCodeBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    qrCodeBtn.layer.borderWidth = 1.0f;
    qrCodeBtn.layer.masksToBounds = YES;
    //qrCodeBtn.layer.cornerRadius = 40;
    [qrCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qrCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    //设置按钮上字体的位置（四个参数表示距离上边界，左边界，下边界，右边界，默认都为0）
    qrCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [qrCodeBtn setImage:[UIImage imageNamed:@"二维码@2x"] forState:UIControlStateNormal];
    openBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -10, 0);
    qrCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    qrCodeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [_buttonScrollView addSubview:qrCodeBtn];
    
    //九宫格按钮
    for (int i = 0; i < 9; i ++) {
        CGFloat n = i % 3 * (VIEW_WEIGHT/3);        
        CGFloat m =VIEW_WEIGHT/3-20 + i / 3 * (VIEW_WEIGHT/3);
        UIButton * bun = [UIButton buttonWithType:UIButtonTypeCustom];
        NSArray *nameArr = @[@"最新记录",@"便民信息",@"阳光政务",@"社区园地",@"交通服务",@"旅游服务",@"敬请期待...",@"敬请期待...",@"敬请期待..."];
        bun.frame = CGRectMake(n, m, VIEW_WEIGHT/3, VIEW_WEIGHT/3);
        [bun setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bun setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
        [bun setTitle:nameArr[i] forState:UIControlStateNormal];
        if (i == 0) {
            [bun setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        bun.titleLabel.font = [UIFont systemFontOfSize:16];
        bun.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        bun.layer.borderWidth = 1.0f;
        bun.layer.masksToBounds = YES;
        //bun.layer.cornerRadius = 30;
        //设置按钮上字体的位置（四个参数表示距离上边界，左边界，下边界，右边界，默认都为0）
        bun.titleLabel.font = [UIFont systemFontOfSize:15];
        NSArray *iconImg = @[@"record@2x",@"旅游@2x",@"小区咨讯@2x",@"其他1@2x",@"交通2@2x",@"飞机票@2x",@"其他2@2x",@"其他2@2x",@"其他2@2x"];
        [bun setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",iconImg[i]]] forState:UIControlStateNormal];
        [bun.imageView setContentMode:UIViewContentModeScaleToFill];
        [self initButton:bun];
        bun.tag = i + 1000;
        [bun addTarget:self action:@selector(buttonSix:) forControlEvents:UIControlEventTouchUpInside];
       //[self.view addSubview:bun];
        [_buttonScrollView addSubview:bun];
    }
}

//封装调整button上文字和图片居中，且图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+10 ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-30, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

-(void)buttonSix:(UIButton *)btn{

    NSInteger num = btn.tag - 1000;
        NSLog(@"点击第%ld个按钮",(long)num);
    if (num == 0) {
        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:bar];

        self.hidesBottomBarWhenPushed = YES;
        //OpenLockRecordViewController *vc = [[OpenLockRecordViewController alloc]init];
        OpenLockRecordViewController *vc = [[OpenLockRecordViewController alloc]init];
        vc.photo = _photo;
        vc.user = _user;
        vc.username = _username;
        vc.usertype = _usertype;
        //                    [vc setValue:photo forKey:@"photo"];
        //                    [vc setValue:user forKey:@"user"];
        //                    [vc setValue:username forKey:@"username"];
        //                    [vc setValue:usertype forKey:@"usertype"];

        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        [self showAlert:@"功能建设中，敬请期待～～"];
    }
}

-(void)goOpenView{

    self.hidesBottomBarWhenPushed = YES;
    OpenLockViewController *OLVc = [[OpenLockViewController alloc]init];
    [self.navigationController pushViewController:OLVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#warning Using the official version block qr code to open the door
-(void)goQRCodeView{
    
    [self showAlert:@"此版本不可用"];
    return;

    self.hidesBottomBarWhenPushed = YES;
    QRCodeViewController *QRCVc = [[QRCodeViewController alloc]init];
    [self.navigationController pushViewController:QRCVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)getData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(clientSocket==nil){
        //[self ConnectToSever];//连接服务器
        if ([self ConnectToSever]) {
            [self login];
        }
    }else{
        [self login];
    }
}

-(void) login {
    
    [self sendData];
    
}

- (BOOL) ConnectToSever{
    if(clientSocket==nil){
        clientSocket=[[AsyncSocket alloc] initWithDelegate:self];
        NSError *error=nil;
        NSString *address = [clientSocket getProperIPWithAddress:_SERVER_ADDRESS port:_SERVER_PORT];
        if(![clientSocket connectToHost:address onPort:_SERVER_PORT withTimeout:3 error:&error]){
            clientSocket = nil;
            return FALSE;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utils showAlert:@"连接服务器失败，请检查设置!!"];
        }else{
            NSLog(@"Connect sucess!");
            //[Utils showAlert:@"连接服务器成功!!"];
            return TRUE;
        }
    }else{
        //_Status.text=@"已连接!";
        NSLog(@"Connected!");
        return TRUE;
    }
}

- (void)sendData{
    
    NSLog(@"sendData!");
    //Start stitching Json string
    NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME1"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSDictionary *parmDictionary= [NSDictionary dictionaryWithObjectsAndKeys:user,@"user",
                                   password,@"password",
                                   @"",@"cardnumber",
                                   @"",@"visitmobil",
                                   @"",@"visitname",
                                   @"",@"deviceid",
                                   @"",@"newpassword",
                                   @"",@"messageID",
                                   @"1",@"userType",nil];
    NSDictionary *jsonDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"Login",@"command",
                                  parmDictionary,@"parameter",nil];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    NSString * inputMsgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * content = [[_MESSAGE_START stringByAppendingString:inputMsgStr] stringByAppendingString:_MESSAGE_END];
    NSLog(@"send action is: %@",content);
    NSData *sendata = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [clientSocket writeData:sendata withTimeout:20 tag:0];
    self.isLogined = NO;
    [self performSelector:@selector(checkIsLogined) withObject:nil afterDelay:20];
    
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
-(void)checkIsLogined{
    if (self.isLogined) {
        //已经登录
    }else{
        //未登录
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlert:@"系统忙，稍候再试 "];
        clientSocket = nil;
    }
}

// Receive data
//-(void)receiveData :(NSData *)data{
    //NSLog(@"device data is %@",data);
    //NSString *totalmessage=@"";



#pragma AsyncScoket Delagate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"didConnectToHost:onSocket:%p didConnectToHost:%@ port:%hu",sock,host,port);
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"didWriteDataWithTag");
    [sock readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"didReadData");
    self.isLogined = YES;
    //[self receiveData:data];
    if (data) {
        NSString *recvMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
       // NSLog(@"通知 recvMessage is: %@",recvMessage);
        if(recvMessage){
            totalmessage=[totalmessage stringByAppendingString:recvMessage];
            //NSLog(@"通知 totalmessage is: %@",totalmessage);
            NSRange rangeStart = [totalmessage rangeOfString:_MESSAGE_START];
            int locationStrat = rangeStart.location;
            int leightStart = rangeStart.length;
            NSLog(@"通知 start is %d,%d",locationStrat,leightStart);
            NSRange rangeEnd = [totalmessage rangeOfString:_MESSAGE_END];
            int locationEnd = rangeEnd.location;
            int leightEnd = rangeEnd.length;
            NSLog(@"通知 end is %d,%d",locationEnd,leightEnd);
            if (leightStart>0 && leightEnd>0 ) {// Receipt of a complete data
                
                // Cancel Login box waiting
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                // Interception sign out front udis
                NSString *needmessage=[[totalmessage substringToIndex:locationEnd] substringFromIndex:leightStart];
                //NSLog(@"通知 --------needmessage is: %@",needmessage);
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[needmessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                totalmessage=@"";
                NSLog(@"通知 dic=%@",dic);
                if([dic objectForKey:@"command"]){// Node containing the command
                    NSString *command=[dic objectForKey:@"command"];
                    if ([command isEqualToString:@"IdentifyRecord"]) {
                        // 1.创建通知
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        
                        // 2.设置通知的必选参数
                        // 设置通知显示的内容
                        localNotification.alertBody = @"您有一条新敏感人员开门通知，请注意查看!";
                        // 设置通知的发送时间
                        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
                        localNotification.soundName = @"win.aac";
                        //消息数量
                        localNotification.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications] count]+1;
                        //localNotification.applicationIconBadgeNumber = 1;
                        // 设置锁屏状态下, "滑动XXX"
                        localNotification.hasAction = YES;
                        localNotification.alertAction = @"解锁查看!";
                        
//                        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
//                        
//                        localNotification.userInfo = infoDic;
                        
                        // 3.发送通知
                        // 方式一: 根据通知的发送时间(fireDate)发送通知
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                        
                        NSLog(@"command is: %@",command);
                        
                        NSDictionary *userinfoDic = [dic objectForKey:@"userinfo"];
                        NSLog(@"通知 userinofo is%@", userinfoDic);
                        
                        _photo = [userinfoDic objectForKey:@"photo"];
                        _user = [userinfoDic objectForKey:@"user"];
                        _username = [userinfoDic objectForKey:@"username"];
                        _usertype = [userinfoDic objectForKey:@"usertype"];
                        
                        NSString *userNum = HH_IsEmptyString1(_user);
                        NSString *username = HH_IsEmptyString1(_username);
                        NSString *userType = HH_IsEmptyString1(_usertype);
                        
                        //敏感人员手机号码
                        [[NSUserDefaults standardUserDefaults]setObject:userNum forKey:@"n_user"];
                        //敏感人员名字
                        [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"n_username"];
                        [[NSUserDefaults standardUserDefaults]setObject:userType forKey:@"n_usertype"];
                        [[NSUserDefaults standardUserDefaults]setObject:_photo forKey:@"n_photo"];
                        
                        NSLog(@"photo is %@", _photo);
                        NSLog(@"user is %@", _user);
                        NSLog(@"username is %@", _username);
                        NSLog(@"usertype is %@", _usertype);
                    }
                }
            }
        }
    }
    [sock readDataWithTimeout:-1 tag:0];

}


- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag{
    
    NSLog(@"onSocket:%p didSecure:YES", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    
    NSLog(@"willDisconnectWithError: onSocket:%p willDisconnectWithError:%@", sock, err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    
    if (!self.isLogined) {
        return;
    }
    //断开连接了
    NSLog(@"onSocketDidDisconnect:%p", sock);
    NSString *msg = @"Sorry this connect is failure";
    NSLog(@"%@", msg);
    clientSocket = nil;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils showAlert:_SOCKET_CONNECT_FAIL];
}

#pragma end Delegate

//- (void)viewWillDisappear:(BOOL)animated{
//    [self disconnect :clientSocket];
//}
//
////断开连接
//-(void) disconnect:(AsyncSocket *)sock{
//    
//    //立即断开，任何未处理的读或写都将被丢弃
//    //如果socket还没有断开，在这个方法返回之前，onSocketDidDisconnect 委托方法将会被立即调用
//    //注意推荐释放AsyncSocket实例的方式：
//    NSLog(@"device socket exit!!!");
//    [sock setDelegate:nil];
//    [sock disconnect];
//    //[_clientSocket release];
//    
//}


#pragma end Delegate


//- (void)timerFireMethod:(NSTimer*)theTimer { //弹出框
//
//    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
//    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
//    promptAlert =NULL;
//}
//
//- (void)showAlert:(NSString *) _message{//时间
//    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//    
//    [NSTimer scheduledTimerWithTimeInterval:2.5f
//                                     target:self
//                                   selector:@selector(timerFireMethod:)
//                                   userInfo:promptAlert
//                                    repeats:YES];
//    [promptAlert show];
//}


@end
