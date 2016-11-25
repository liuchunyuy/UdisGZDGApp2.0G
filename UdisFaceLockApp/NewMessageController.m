//
//  NewMessageController.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/8/9.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "NewMessageController.h"
#import "MyUtiles.h"
#import "NewMessageTableViewCell.h"
#import "NewMessageModel.h"
#import "RegisteredController.h"
#import "NewMessageDetailsViewController.h"

#import "MBProgressHUD.h"

// 字符串为 nil null <null>的时候 替代方法
#define HH_IsEmptyString(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] )\
== 1 ? @"无":object\
)

#define HH_IsEmptyString1(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] )\
== 1 ? @"moren1":object\
)

#define HH_IsEmptyString2(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] ||\
[object isEqualToString:@"\n"]||\
[object isEqualToString:@""])\
== 1 ? @"无最新消息":object\
)

@interface NewMessageController ()<UITableViewDelegate,UITableViewDataSource>

{

    UIImageView *_backGroundImg;
    NSString *totalmessage;
   
}

@property(nonatomic)BOOL isLogined;

@end

@implementation NewMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSLog(@"最新消息页面");
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    addBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addBtn;
    totalmessage = @"";
    _messagesArr = [NSMutableArray array];
        
    [self getData];
   // [self creatTextView];

    // Do any additional setup after loading the view.
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
    //开始拼接Json字符串
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME1"];
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
                                   @"",@"messageID",
                                   @"1",@"userType",nil];
    NSDictionary *jsonDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"Login",@"command",
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
                NSLog(@"newMessage --------needmessage is: %@",needmessage);
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[needmessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                totalmessage=@"";
                NSLog(@"newMessage dic=%@",dic);
                if([dic objectForKey:@"command"]){//含有command 节点
                    NSString *command=[dic objectForKey:@"command"];
                    NSLog(@"newMessage command is: %@",command);
                    if ([command isEqual:@"Login"]) {
                        NSLog(@"newMessage Login");
                        NSLog(@"Login!!!!");
                        if([dic objectForKey:@"code"]){
                            //NSString *code=[dic objectForKey:@"code"];
                            NSString *code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                            NSLog(@"code is: %@",code);
                            NSArray *messages = [dic objectForKey:@"messages"];
                            NSMutableArray *arr = [NSMutableArray arrayWithArray:messages];
                            _messagesArr = arr;
                            NSLog(@"_messagesArr is 11----%@", _messagesArr);
                            [self creatTextView];
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




-(void)creatTextView{
    
    _dataArray = [[NSMutableArray alloc]init];
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-113)];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.backgroundColor = [UIColor whiteColor];
    _tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [_tb registerNib:[UINib nibWithNibName:@"NewMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewMessageTableViewCell"];
    _tb.showsHorizontalScrollIndicator = NO;
    _tb.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //_tb.separatorStyle = UITableViewCellSeparatorStyleNone;  取消cell的分割线

    [self.view addSubview:_tb];
    
    NSLog(@"_messagesArr is %@", _messagesArr);
    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
        for (dic1 in _messagesArr) {
            NewMessageModel *model = [[NewMessageModel alloc]init];
            NSString *str = [dic1[@"message"] stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            model.message = HH_IsEmptyString2(str3);
           // model.datetime = HH_IsEmptyString(dic1[@"datetime"]);
            model.messageImg = HH_IsEmptyString1(dic1[@"messageImg"]);
            
            if ((dic1[@"datetime"] == nil ||
                 [dic1[@"datetime"] isKindOfClass:[NSNull class]] ||
                 [dic1[@"datetime"] isEqualToString:@"(null)"] ||
                 [dic1[@"datetime"] isEqualToString:@"null"] ||
                 [dic1[@"datetime"] isEqualToString:@"<null>"] )) {
                NSDate *date=[NSDate date];//获取当前时间
                NSDateFormatter *format1=[[NSDateFormatter alloc]init];
                [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *str1=[format1 stringFromDate:date];
                NSLog(@"str1  is  ----%@", str1);
                model.datetime = str1;
            }else{
                model.datetime = dic1[@"datetime"];
            }
                        
            NSLog(@"message is %@", model.message);
            NSLog(@"datetime is %@", model.datetime);
            NSLog(@"messageImg is %@", model.messageImg);
        
            [_dataArray addObject:model];
            
            NSLog(@"_dataArray is %@", _dataArray);
        }
        [_tb reloadData];
}

#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"_dataArray.count = %lu",(unsigned long)_dataArray.count);
    return _dataArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMessageTableViewCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  //右箭头
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return; //点击功能未添加，暂时取消
    NSLog(@"点击的第%ld行", (long)indexPath.row);
    self.hidesBottomBarWhenPushed = YES;
    NewMessageDetailsViewController *detialsVc = [[NewMessageDetailsViewController alloc]init];
    [self.navigationController pushViewController:detialsVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}


-(void)backAction:(UIButton *)btn{

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)refresh{

    [_dataArray removeAllObjects];
    [self creatTextView];
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
