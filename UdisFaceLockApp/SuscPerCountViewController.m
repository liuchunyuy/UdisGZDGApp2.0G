//
//  SuscPerCountViewController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/10/19.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "SuscPerCountViewController.h"
#import "LXMPieView.h"
#import "MBProgressHUD.h"

#import "PNChart.h"
#import "CONST.h"


#define BgColor [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1]


@interface SuscPerCountViewController ()<LXMPieViewDelegate>{

    NSString *totalmessage;
    UILabel *_lable;
}
@property (nonatomic, strong) LXMPieView *pieView;
@property(nonatomic)BOOL isLogined;
//@property (nonatomic, strong) LXMPieView *pieView;
@property (nonatomic,copy)NSMutableArray *valueArray;
@property (nonatomic,strong)NSMutableArray *valueNumArray;
@property (nonatomic,strong)NSMutableArray *MgEmpTypeArray;

@property (nonatomic,strong) PNPieChart *pieChart;
@end

@implementation SuscPerCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"敏感人群类型统计";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //右刷新按钮
//    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(handleButtonTapped)];
//    addBtn.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = addBtn;
    totalmessage = @"";
    
    [self getData];
}

-(void)getData{
    _valueNumArray = [NSMutableArray array];
    _MgEmpTypeArray = [NSMutableArray array];
    
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
    //开始拼接Json字符串
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSLog(@"count username is %@", username);
    NSLog(@"count password is %@",password);
    NSDictionary *parmDictionary= [NSDictionary dictionaryWithObjectsAndKeys:username,@"user",
                                   password,@"password",
                                   @"",@"cardnumber",
                                   @"",@"visitmobil",
                                   @"",@"visitname",
                                   @"",@"deviceid",
                                   @"",@"newpassword",
                                   @"",@"messageID",nil];
    NSDictionary *jsonDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"GetMgEmpTypeTotal",@"command",
                                  parmDictionary,@"parameter",nil];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    NSString * inputMsgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * content = [[_MESSAGE_START stringByAppendingString:inputMsgStr] stringByAppendingString:_MESSAGE_END];
    NSLog(@"send action is: %@",content);
    NSData *sendata = [content dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:sendata withTimeout:20 tag:0];
    self.isLogined = NO;
    [self performSelector:@selector(checkIsLogined) withObject:nil afterDelay:20];
    
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
    //NSLog(@"device data is %@",data);
    //NSString *totalmessage=@"";
    if (data) {
        NSString *recvMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"count recvMessage is: %@",recvMessage);
        if(recvMessage){
            totalmessage=[totalmessage stringByAppendingString:recvMessage];
            NSLog(@"count totalmessage is: %@",totalmessage);
            NSRange rangeStart = [totalmessage rangeOfString:_MESSAGE_START];
            int locationStrat = rangeStart.location;
            int leightStart = rangeStart.length;
            NSLog(@"start is %d,%d",locationStrat,leightStart);
            NSRange rangeEnd = [totalmessage rangeOfString:_MESSAGE_END];
            int locationEnd = rangeEnd.location;
            int leightEnd = rangeEnd.length;
            NSLog(@"end is %d,%d",locationEnd,leightEnd);
            if (leightStart>0 && leightEnd>0 ) {//接收到完整的数据
                //取消登陆等待框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //截取掉前后 udis 标志
                NSString *needmessage=[[totalmessage substringToIndex:locationEnd] substringFromIndex:leightStart];
                NSLog(@"count --------needmessage is: %@",needmessage);
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[needmessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                totalmessage=@"";
                NSLog(@"dic=%@",dic);
                if([dic objectForKey:@"command"]){//含有command 节点
                    NSString *command=[dic objectForKey:@"command"];
                    NSLog(@"count command is: %@",command);
                    if ([command isEqual:@"GetMgEmpTypeTotal"]) {
                        NSLog(@"GetMgEmpTypeTotal");
                        if([dic objectForKey:@"code"]){
                            
                            NSString *code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                            NSLog(@"code is: %@",code);
                            _valueArray = [dic objectForKey:@"mgemptypetotals"];
                            
                            NSLog(@"count _valueArray is %@", _valueArray);
                            if (_valueArray.count == 0) {
                                [self showAlert:@"暂时无敏感人员登记"];
                            }else{
                                _valueNumArray  = [NSMutableArray array];
                                _MgEmpTypeArray = [NSMutableArray array];
                                for (NSDictionary *dic in _valueArray) {
                                    NSString *count = dic[@"Count"];
                                    NSString *MgEmpType = dic[@"MgEmpType"];
                                    [_valueNumArray addObject:count];
                                    NSString *str2 = [MgEmpType stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                    //NSString *str2 = [MgEmpType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                    [_MgEmpTypeArray addObject:str2];
                                    NSLog(@"arr is %@", _valueNumArray);
                                    NSLog(@"MgEmpTypeArray is %@", _MgEmpTypeArray);
                                }
                                
                                float sum = 0.0;
                                for (NSString *str in _valueNumArray) {
                                    float number = [str floatValue];
                                    sum += number;
                                }
                                NSLog(@"count sum is %.2f",sum);
                                
                                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, 25)];
                                view.backgroundColor = [UIColor whiteColor];
                                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 25)];
                                label.backgroundColor = [UIColor clearColor];
                                label.text = [NSString stringWithFormat:@"敏感人群比例示意图 (共%.0f人)",sum];
                                label.font = [UIFont systemFontOfSize:13];
                                [self.view addSubview:view];
                                [view addSubview:label];
                                
                                [self createPie];
                            }
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
    
    NSLog(@"data is: %@",data);
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


-(void)createPie{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 25)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"敏感人群分类"];
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:view];
    [view addSubview:label];

    NSMutableArray *modelArray = [NSMutableArray array];

    NSLog(@"_valueNumArray is %@", _valueNumArray);
    NSArray *colorArray = @[[UIColor redColor],
                            [UIColor orangeColor],
                            [UIColor yellowColor],
                            [UIColor greenColor],
                            [UIColor purpleColor],
                            [UIColor darkGrayColor],
                            [UIColor brownColor],
                            [UIColor blueColor],
                            [UIColor cyanColor],
                            [UIColor magentaColor],
                            [UIColor colorWithRed:0.3 green:0.2 blue:0.7 alpha:1.0],
                            [UIColor colorWithRed:0.1 green:0.8 blue:0.3 alpha:1.0],
                            [UIColor colorWithRed:0.8 green:0.5 blue:0.2 alpha:1.0],
                            [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0],
                            [UIColor colorWithRed:0.5 green:0.7 blue:0.9 alpha:1.0],
                            [UIColor colorWithRed:0.9 green:0.8 blue:0.2 alpha:1.0],
                            [UIColor colorWithRed:0.2 green:0.8 blue:0.5 alpha:1.0],
                            [UIColor colorWithRed:0.6 green:0.1 blue:0.8 alpha:1.0],
                            [UIColor colorWithRed:0.5 green:0.6 blue:0.9 alpha:1.0],
                            [UIColor colorWithRed:0.4 green:0.6 blue:0.2 alpha:1.0]];
    
    for (int i = 0 ; i <_valueNumArray.count ; i++) {
        LXMPieModel *model = [[LXMPieModel alloc] initWithColor:colorArray[i] value:[_valueNumArray[i] floatValue] text:nil];
        [modelArray addObject:model];
    }
    
    LXMPieView *pieView = [[LXMPieView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 110, 180, 180) values:modelArray];
    pieView.delegate = self;
    [self.view addSubview:pieView];
    self.pieView = pieView;
    
    for (int i = 0; i < _valueNumArray.count; i++) {
        //敏感人群分类颜色
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(50, 330+20*i, 13, 13)];
        view.backgroundColor = colorArray[i];

        //敏感人群分类名称
        _lable = [[UILabel alloc]initWithFrame:CGRectMake(70, 330+20*i, 100, 15)];
        _lable.font = [UIFont systemFontOfSize:11];
        _lable.text = [NSString stringWithFormat:@"%@ (%@人)", _MgEmpTypeArray[i],_valueNumArray[i]];
        
        [self.view addSubview:_lable];
        [self.view addSubview:view];
    }
}

#pragma mark - LXMPieViewDelegate

- (void)lxmPieView:(LXMPieView *)pieView didSelectSectionAtIndex:(NSInteger)index {
    NSLog(@"didSelectSectionAtIndex : %@", @(index));
}

#pragma mark - buttonAction

- (void)handleButtonTapped {
    
    [_valueNumArray removeAllObjects];
    [_lable removeFromSuperview];
    [self getData];
    //[self.pieView reloadData];
    
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
