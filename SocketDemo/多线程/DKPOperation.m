//
//  DKPOperation.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/9.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "DKPOperation.h"

@interface DKPOperation()
@property(nonatomic,copy)DKPOperationBlock block;

@end

@implementation DKPOperation
-(instancetype)initWithBlock:(DKPOperationBlock)block{
    if (self =[super init]) {
        self.block = block;
    }
    return self;
}
-(void)main{
    if (self.block) {
        self.block();
    }
}
@end
