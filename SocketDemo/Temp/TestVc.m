//
//  TestVc.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/6.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "TestVc.h"

#import "DKPConstVc.h"

@interface TestVc ()

@end
 
@implementation TestVc

- (void)viewDidLoad {
    [super viewDidLoad];
    DKPConstVc *vc = [[DKPConstVc alloc]init];
    for (int i=0; i<5; i++) {
        [vc forStatic];
    }
    extern  NSString *name;
    NSLog(@"%s",__func__);
    NSLog(@"%@",name);
    name =@"changed";
    userCode = @"1231323123123";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
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
