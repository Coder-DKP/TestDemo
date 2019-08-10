//
//  DKPTouchVc.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/9.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "DKPTouchVc.h"

#import "firstView.h"
#import "secondView.h"
#import "thirdView.h"

@interface DKPTouchVc ()
@property(nonatomic,strong)firstView *first;
@property(nonatomic,strong)secondView *second;
@property(nonatomic,strong)thirdView *third;
@end

@implementation DKPTouchVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.first];
    [self.first addSubview:self.second];
    [self.second addSubview:self.third];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.first.frame = CGRectMake((SCREENW- 200)*0.5, (SCREENH- 200)*0.5, 200, 200);
    self.second.frame = CGRectMake((self.first.bounds.size.width- 100)*0.5, (self.first.bounds.size.height- 100)*0.5, 100, 100);
    self.third.frame = CGRectMake((self.second.bounds.size.width- 50)*0.5, (self.second.bounds.size.height- 50)*0.5, 50, 50);
}
#pragma mark - Getter/Setter

-(firstView *)first{
    if (!_first) {
        _first = [[firstView alloc]init];
        _first.backgroundColor = [UIColor redColor];
    }
    return _first;
}
-(secondView *)second{
    if (!_second) {
        _second = [[secondView alloc]init];
        _second.backgroundColor = [UIColor blueColor];
    }
    return _second;
}
-(thirdView *)third{
    if (!_third) {
        _third = [[thirdView alloc]init];
        _third.backgroundColor = [UIColor yellowColor];
    }
    return _third;
}




@end
