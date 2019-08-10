//
//  DKPConstVc.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/9.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "DKPConstVc.h"
#import "TestVc.h"
@interface DKPConstVc ()

@end
/*const在*号的右边，修饰的是值，值不可变，地址可变*/
NSString  *const temStr1 =@"constTest";
/*const在*号的左边，修饰的是地址，地址不可变，值可变*/
const NSString  *temStr2 =@"constTest";
NSString  const*  temStr3 =@"constTest";

@implementation DKPConstVc

- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor = [UIColor lightGrayColor];
    
    
        for (int i=0; i<5; i++) {
            [self forStatic];
        }
    
        extern NSString *userCode;
        NSLog(@"%s",__func__);
        NSLog(@"userCode:%@",userCode);
    
        NSLog(@"sex:%@",sex);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            TestVc *vc = [[TestVc alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        });
}

-(void)forStatic{
    /*局部变量*/
    static int number = 1;
    ++ number;
    NSLog(@"number:%d,地址：%p",number,&number);
    
}

@end
