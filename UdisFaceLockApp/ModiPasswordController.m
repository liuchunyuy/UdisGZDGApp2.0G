
#import "ModiPasswordController.h"
//#import "DbUtil.h"

@interface ModiPasswordController (){
    
    UILabel *signalLabel;
    UISegmentedControl *selectTypeSegment;
    UITextField *oldPassword;
    UITextField *newPassword;
    UITextField *passwordAgain;
    UIButton *confirm;
    //DbUtil *dbUtil;
}
@property(nonatomic)BOOL isLogined;

@end


@implementation ModiPasswordController

- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal{
    
    self = [super init];
    if (self){
        
        self.szSignal = szSignal;
        self.view.frame = frame;
        self.title = szSignal;
        [self.view setBackgroundColor:[UIColor clearColor]];
        //self.view.layer.borderWidth = 1;
       // self.view.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
  	// Do any additional setup after loading the view.
    self.view.backgroundColor  =[UIColor whiteColor];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    
    UILabel *oldLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 100, 60, 30)];
    oldLabel.font  = [UIFont systemFontOfSize:16];
    oldLabel.textAlignment = NSTextAlignmentCenter;
    oldLabel.textColor = [UIColor blackColor];
    oldLabel.text = @"旧密码:";
    [self.view addSubview:oldLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 130, 220, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    oldPassword = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2+60,100, 160, 30)];
    //_userName.borderStyle = UITextBorderStyleRoundedRect;
    oldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    oldPassword.placeholder = @" 请输入旧密码";
    [oldPassword setFont:[UIFont boldSystemFontOfSize:15]];
    oldPassword.backgroundColor = [UIColor clearColor];
    oldPassword.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    oldPassword.clearButtonMode = UITextFieldViewModeAlways;
    //_accountTextField.secureTextEntry = YES;
    [oldPassword endEditing:YES];
    [self.view addSubview:oldPassword];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 150, 60, 30)];
    newLabel.font  = [UIFont systemFontOfSize:16];
    newLabel.textAlignment = NSTextAlignmentCenter;
    newLabel.textColor = [UIColor blackColor];
    newLabel.text = @"新密码:";
    [self.view addSubview:newLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2,180, 220, 1)];
    lineView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView1];
    
    newPassword = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2+60, 150, 160, 30)];
    //_passWord.borderStyle = UITextBorderStyleRoundedRect;
    newPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newPassword.placeholder = @" 请输入新密码";
    [newPassword setFont:[UIFont boldSystemFontOfSize:14]];
    newPassword.backgroundColor = [UIColor clearColor];
    newPassword.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    newPassword.clearButtonMode = UITextFieldViewModeAlways;
    newPassword.secureTextEntry = YES;
    [newPassword endEditing:YES];
    [self.view addSubview:newPassword];
    
    UILabel *againLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 200, 60, 30)];
    againLabel.font  = [UIFont systemFontOfSize:16];
    againLabel.textAlignment = NSTextAlignmentCenter;
    againLabel.textColor = [UIColor blackColor];
    againLabel.text = @"新密码:";
    [self.view addSubview:againLabel];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 230, 220, 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView2];
    
    passwordAgain = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2+60,200 , 160, 30)];
    //_passWord.borderStyle = UITextBorderStyleRoundedRect;
    passwordAgain.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordAgain.placeholder = @" 请再次输入新密码";
    [passwordAgain setFont:[UIFont boldSystemFontOfSize:14]];
    passwordAgain.backgroundColor = [UIColor clearColor];
    passwordAgain.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passwordAgain.clearButtonMode = UITextFieldViewModeAlways;
    passwordAgain.secureTextEntry = YES;
    [passwordAgain endEditing:YES];
    [self.view addSubview:passwordAgain];

    //保存按钮
    confirm= [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setFrame:CGRectMake((self.view.frame.size.width-220)/2,300, 220, 30)];
    [confirm setTitle:@"保存" forState:UIControlStateNormal];
    confirm.backgroundColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    confirm.layer.borderWidth = 1;
//    confirm.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    confirm.layer.masksToBounds = YES;
    confirm.layer.cornerRadius = 5;
    confirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirm addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];

    //关闭软键盘使用
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;

}


-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [oldPassword resignFirstResponder];
}

- (void)setSzSignal:(NSString *)szSignal{
    
    _szSignal = szSignal;
    signalLabel.text = szSignal;
}

- (void)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)save:(id)sender{
    
    [passwordAgain endEditing:YES];
    [newPassword endEditing:YES];
    [oldPassword endEditing:YES]; //保存同时关闭键盘
    
    if([oldPassword.text isEqual:@""] ){
        [Utils showAlert:@"旧密码不能为空!"];
        return;
    }
    
    //NSString *password=[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    //NSLog(@"password is %@",password);
    if(![oldPassword.text isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]] ){
        [Utils showAlert:@"旧密码输入有误!"];
        return;
    }
    
    if([newPassword.text isEqual:@""] ){
        [Utils showAlert:@"新密码不能为空!"];
        return;
    }
    
    if (newPassword.text.length < 6 ) {
        [Utils showAlert:@"新密码至少6位!"];
        return;
    }
        
    if(![newPassword.text isEqual:passwordAgain.text] ){
        [Utils showAlert:@"两次输入的密码必须一致!"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(clientSocket==nil){
        
        [self ConnectToSever];//连接服务器
        [self sendModiPasswordData];
       
    }else{
        [self sendModiPasswordData];
    }
}




//关闭软键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![oldPassword isExclusiveTouch]) {
        [oldPassword resignFirstResponder];
    }
}


- (void) ConnectToSever{
    if(clientSocket==nil){
        
        clientSocket=[[AsyncSocket alloc] initWithDelegate:self];
        NSError *error=nil;
        //if(![clientSocket connectToHost:@"192.168.2.130" onPort:[@"90" intValue] withTimeout:3 error:&error])
        NSString *address = [clientSocket getProperIPWithAddress:_SERVER_ADDRESS port:_SERVER_PORT];
        if(![clientSocket connectToHost:address onPort:_SERVER_PORT withTimeout:5 error:&error]){
            
            //_Status.text=@"连接服务器失败!";
            clientSocket = nil;
            NSLog(@"Connect fail!");
        }else{
            //_Status.text=@"已连接!";
            NSLog(@"Connect sucess!");
        }
    }else{
        //_Status.text=@"已连接!";
        NSLog(@"Connected!");
    }
}

- (void)sendModiPasswordData{
    
    NSLog(@"sendModiPasswordData!");
    NSString *user=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    NSLog(@"user is %@",user);
    //开始拼接Json字符串
    NSDictionary *parmDictionary= [NSDictionary dictionaryWithObjectsAndKeys:user,@"user",
                                   oldPassword.text,@"password",
                                   @"",@"cardnumber",
                                   @"",@"visitmobil",
                                   @"",@"visitname",
                                   @"",@"deviceid",
                                   newPassword.text,@"newpassword",
                                   @"",@"messageID",nil];
    NSDictionary *jsonDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"ModiPassword",@"command",
                                  parmDictionary,@"parameter",nil];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    NSString * inputMsgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * content = [[_MESSAGE_START stringByAppendingString:inputMsgStr] stringByAppendingString:_MESSAGE_END];
    NSLog(@"send action is: %@",content);
    NSData *sendata = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [clientSocket writeData:sendata withTimeout:-1 tag:0];
    self.isLogined = NO;
    [self performSelector:@selector(checkIsLogined) withObject:nil afterDelay:20];
    
}

- (void)timerFireMethod:(NSTimer*)theTimer{ //弹出框

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
    NSString *totalmessage=@"";
    if (data) {
        NSString *recvMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"recvMessage is: %@",recvMessage);
        if(recvMessage){
            totalmessage=[totalmessage stringByAppendingString:recvMessage];
            NSLog(@"totalmessage is: %@",totalmessage);
            NSRange rangeStart = [totalmessage rangeOfString:_MESSAGE_START];
            int locationStrat = rangeStart.location;
            int leightStart = rangeStart.length;
            NSLog(@"start is %d,%d",locationStrat,leightStart);
            NSRange rangeEnd = [totalmessage rangeOfString:_MESSAGE_END];
            int locationEnd = rangeEnd.location;
            int leightEnd = rangeEnd.length;
            NSLog(@"end is %d,%d",locationEnd,leightEnd);
            if (leightStart>0 && leightEnd>0 ) {// 接收到完整的数据
                //取消登陆等待框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //截取掉前后 udis 标志
                NSString *needmessage=[[totalmessage substringToIndex:locationEnd] substringFromIndex:leightStart];
                NSLog(@"needmessage is: %@",needmessage);
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[needmessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                totalmessage=@"";
                NSLog(@"dic=%@",dic);
                if([dic objectForKey:@"command"]){//含有command 节点
                    NSString *command=[dic objectForKey:@"command"];
                    NSLog(@"command is: %@",command);
                    //远程开门
                    if ([command isEqual:@"ModiPassword"]) {
                        NSLog(@"ModiPassword!!!!");
                        if([dic objectForKey:@"code"]){
                            //NSString *code=[dic objectForKey:@"code"];
                            NSString *code=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                            NSLog(@"code is: %@",code);
                            if ([code isEqual:@"0"]) {
                                [[NSUserDefaults standardUserDefaults] setObject: newPassword.text forKey:@"password"];
                                [Utils showAlert:@"修改密码成功!!!"];
                            }
                            if ([code isEqual:@"1"]) {
                                [Utils showAlert:@"用户不存在，请联系管理员!"];
                            }
                            if ([code isEqual:@"2"]) {
                                [Utils showAlert:@"旧口令错误!"];
                            }
                            if ([code isEqual:@"3"]) {
                                [Utils showAlert:@"系统异常，请重新修改!"];
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
    //[sock readDataWithTimeout:1 tag:0];
    
    /* readDataWithTimeout:-1 否则就自动断开连接 */
    [sock readDataWithTimeout:-1 tag:0];
    
    
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];  // 这句话仅仅接收\r\n的数据
    NSLog(@"didWriteDataWithTag");
    [sock readDataWithTimeout: -1 tag: 0];
    //[sock readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
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
    
    //断开连接了
    if (!self.isLogined) {
        return;
    }
    NSLog(@"onSocketDidDisconnect:%p", sock);
    NSString *msg = @"Sorry this connect is failure";
    NSLog(@"%@", msg);
    clientSocket = nil;
    //[self showAlert:@"连接服务器失败，请检查设置!!"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils showAlert:_SOCKET_CONNECT_FAIL];
}
#pragma end Delegate

@end
