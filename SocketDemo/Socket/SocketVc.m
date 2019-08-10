//
//  SocketVc.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/9.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "SocketVc.h"
#import "GCDAsyncSocket.h" // for TCP
@interface SocketVc ()<GCDAsyncSocketDelegate>
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)GCDAsyncSocket *socket;
@end

@implementation SocketVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connectToService];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.btn];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.btn.frame = CGRectMake((SCREENW-90)*0.5, (SCREENH-30)*0.5, 90, 30);
}
#pragma mark  - getter/setter
-(UIButton *)btn{
    if (!_btn) {
        _btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"发送消息" forState:UIControlStateNormal];
        [_btn addTarget: self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [_btn setBackgroundColor:[UIColor redColor]];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius=5.0;
    }
    return _btn;
}
-(GCDAsyncSocket *)socket{
    if (!_socket) {
        
        dispatch_queue_t q = dispatch_queue_create("dkp", DISPATCH_QUEUE_SERIAL);
        _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:q];
    }
    return _socket;
}
#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"%@",host);
}
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"%@",err);
    }
    if ([sock.userData isEqualToString:@""]) {
        
    }
}
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%ld",tag);
}
- (void)send{
    NSData *data = [@"dedwedwe" dataUsingEncoding:NSUTF8StringEncoding];
    [self sendMessage:data];
}
#pragma mark - others

-(void)connectToService{
    NSError *error=nil;
    [self.socket connectToHost:@"192.168.100.187" onPort:4000 error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}
-(void)sendMessage:(NSData*)data{
    if ([self.socket isConnected]) {
        [self.socket writeData:data withTimeout:10.f tag:6];
    }
}


@end
