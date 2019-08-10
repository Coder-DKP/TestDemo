//
//  one.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/5.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "one.h"

@interface one()

@property(nonatomic,copy)NSString *name;

@end
@implementation one
+(instancetype)shareInstance{
    static one *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    NSLog(@"_instance:%p",&_instance);
    return _instance;
}
@end
