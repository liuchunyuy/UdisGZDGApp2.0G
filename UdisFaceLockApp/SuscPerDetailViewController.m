//
//  SuscPerDetailViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/10/21.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "SuscPerDetailViewController.h"
#import "MBProgressHUD.h"
#import "MyUtiles.h"

#define HH_IsEmptyString1(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] )\
== 1 ? @"moren1":object\
)

@interface SuscPerDetailViewController ()
{

    NSString *totalmessage;
    NSDictionary *dic1;
}
@property(nonatomic)BOOL isLogined;
@property (nonatomic,copy)NSMutableArray *GetMgFaceRecordDetailArray;


@end

@implementation SuscPerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"_MgEmpName is %@", _MgEmpName);
    self.navigationItem.title = [NSString stringWithFormat:@"%@",_MgEmpName];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     totalmessage = @"";
    
    [self getData];
    //[self cteateView];
    
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
    //开始拼接Json字符串
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSLog(@"count username is %@", username);
    NSLog(@"count password is %@",password);
    
    NSLog(@"_FaceRecordID is %@",_FaceRecordID);
    NSDictionary *parmDictionary= [NSDictionary dictionaryWithObjectsAndKeys:username,@"user",
                                   password,@"password",
                                   @"",@"cardnumber",
                                   @"",@"visitmobil",
                                   @"",@"visitname",
                                   @"",@"deviceid",
                                   @"",@"newpassword",
                                   _FaceRecordID,@"mgFaceRecordID",
                                   @"",@"messageID",nil];
    NSDictionary *jsonDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"GetMgFaceRecordDetail",@"command",
                                  parmDictionary,@"parameter",nil];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    NSString * inputMsgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * content = [[_MESSAGE_START stringByAppendingString:inputMsgStr] stringByAppendingString:_MESSAGE_END];
    NSLog(@"send action is: %@",content);
    NSData *sendata = [content dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:sendata withTimeout:20 tag:0];
    //self.isLogined = NO;
    //[self performSelector:@selector(checkIsLogined) withObject:nil afterDelay:20];
    
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


//接收数据
-(void)receiveData :(NSData *)data{
    
    //NSLog(@"-------------------------==== data is %@",data);
    if (data) {
        NSString *recvMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"Detail recvMessage is: %@",recvMessage);
        
        if(recvMessage){
            totalmessage=[totalmessage stringByAppendingString:recvMessage];
            NSLog(@"Detail totalmessage is: %@",totalmessage);
            NSRange rangeStart = [totalmessage rangeOfString:_MESSAGE_START]; //前udis 标示
            int locationStrat = rangeStart.location;
            int leightStart = rangeStart.length;
            NSLog(@"start is %d,%d",locationStrat,leightStart);
            NSRange rangeEnd = [totalmessage rangeOfString:_MESSAGE_END]; //后udis 标示
            int locationEnd = rangeEnd.location;
            int leightEnd = rangeEnd.length;
            NSLog(@"end is %d,%d",locationEnd,leightEnd);
            if (leightStart>0 && leightEnd>0 ) {//接收到完整的数据
                //取消登陆等待框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //截取掉前后 udis 标志
                NSString *needmessage=[[totalmessage substringToIndex:locationEnd] substringFromIndex:leightStart];
               // NSLog(@"--------------%@",totalmessage);
                NSLog(@"Detail --------needmessage is: %@",needmessage);
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[needmessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
               // NSLog(@"Detail dic=%@",dic);
                if([dic objectForKey:@"command"]){//含有command 节点
                    NSString *command=[dic objectForKey:@"command"];
                    NSLog(@"Detail command is: %@",command);
                    if ([command isEqual:@"GetMgFaceRecordDetail"]) {
                        NSLog(@"GetMgFaceRecordDetail");
                        if([dic objectForKey:@"code"]){
                            
                            NSString *code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                            NSLog(@"code is: %@",code);
                            
                            dic1 = [[dic objectForKey:@"mgfacerecords"] lastObject];
                            NSLog(@"dic1 is %@", dic1);
                            
                                [self cteateView];
                        }
                    }
                }
            }
        }
    }
}

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

   // NSString *data = [data s]
    //NSLog(@"data is: %@",data);
    
    [self receiveData:data];
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

- (void)viewWillDisappear:(BOOL)animated{
    [self disconnect :clientSocket];
}

//断开连接
-(void) disconnect:(AsyncSocket *)sock{
    
    //立即断开，任何未处理的读或写都将被丢弃
    //如果socket还没有断开，在这个方法返回之前，onSocketDidDisconnect 委托方法将会被立即调用
    //注意推荐释放AsyncSocket实例的方式：
    NSLog(@"device socket exit!!!");
    [sock setDelegate:nil];
    [sock disconnect];
    //[_clientSocket release];
    
}

//弹出框
- (void)timerFireMethod:(NSTimer*)theTimer{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}



-(void)cteateView{

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-130)/2, 100, 130, 160)];
    NSString *image1 = [[NSString alloc]init];
    image1 = [dic1 objectForKey:@"MgEmpImg"];
    //NSLog(@"image1 is %@", image1);
    NSData *photo   = [[NSData alloc] initWithBase64Encoding:image1];
    //NSData *photo   = [[NSData alloc] initWithBase64EncodedString:image1 options:0];

    image.image=[UIImage imageWithData: photo];
    [self.view addSubview:image];
    
    NSArray *labelArray = @[@"人员类型:",@"联系方式:",@"身份证号:",@"记录时间:"];
    NSArray *detailArray = @[_MgEmpType,_MgEmpPhone,_MgEmpNo,_RecordTime];
    
    for (int i = 0; i < 4; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 300+30*i, 80, 20)];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(130, 300+30*i, self.view.frame.size.width-170, 20)];
        label.text = [NSString stringWithFormat:@"%@ :",labelArray[i]];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        label1.text = [NSString stringWithFormat:@"%@",detailArray[i]];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentRight;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, 300+20+30*i, self.view.frame.size.width-80, 1)];
        view.backgroundColor = [UIColor whiteColor];

        [self.view addSubview:view];
        [self.view addSubview:label1];
        [self.view addSubview:label];
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
