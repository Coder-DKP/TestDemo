//
//  DKPNetWorkVc.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/16.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "DKPNetWorkVc.h"
#import "AFNetworking.h"
//C函数
NSString *testStr(NSString*temp){
    return temp;
}

@interface DKPNetWorkVc ()
@property(nonatomic,strong)NSURLRequest *request;
@property(nonatomic,strong)NSURLCache *cache;
@end

@implementation DKPNetWorkVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self nsurlSession];
//    [self AFNetworkReachabilityManager];
    [self SecurityPolicy];
    
}

-(void)nsurlSession{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSString *urlStr =@"https://api.apiopen.top/getJoke?page=1&count=2&type=video";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    self.request = request;
    self.cache = [NSURLCache sharedURLCache];
   NSCachedURLResponse *cachedResponse =  [self.cache cachedResponseForRequest:self.request];
    NSLog(@"%@",cachedResponse.data);
   NSURLSessionDataTask *dataTask=    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      NSError *error1 = nil;
      if (data) {
          NSDictionary *dict =   [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error1];
          if (!error) {
              NSLog(@"%@",dict);
          }
      }
    }];
    

    [dataTask resume];
    
}
-(void)AFNetworkReachabilityManager{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                 NSLog(@"不可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                 NSLog(@"蜂窝");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                 NSLog(@"WiFi");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}
-(void)SecurityPolicy{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    //要求校验证书
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName=NO;
     securityPolicy.pinnedCertificates= [NSSet setWithArray:@[cerData]];
    manager.securityPolicy = securityPolicy;
    [manager POST:@"https://api.apiopen.top/getJoke?page=1&count=2&type=video" parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:nil];
}
@end
