//
//  DKPConcurrentVc.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/9.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "DKPConcurrentVc.h"
#import <pthread.h>
#import "DKPOperation.h"
@interface DKPConcurrentVc ()
@property(nonatomic,strong) NSLock *lock;

@end
int money=100;
@implementation DKPConcurrentVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _lock = [[NSLock alloc]init];
    [self concurentNSOperation];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

-(void)pthread{
    pthread_t p = NULL;
    id str = @"i'm pthread param";
    int result=  pthread_create(&p, NULL, demo, (__bridge void *)(str));
    if (result == 0) {
        NSLog(@"创建线程 OK");
    } else {
        NSLog(@"创建线程失败 %d", result);
    }
    // pthread_detach:设置子线程的状态设置为detached,则该线程运行结束后会自动释放所有资源。
    pthread_detach(p);
    
}
// 后台线程调用函数
void *demo(void *params) {
    NSString *str = (__bridge NSString *)(params);
    
    NSLog(@"%@ - %@", [NSThread currentThread], str);
    
    return NULL;
}
-(void)concurrentNSThread{
    //    NSThread *thread1 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread1.name=@"thread1";
    //    [thread1 start];
    //
    //
    //
    //    NSThread *thread2 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread2.name=@"thread2";
    //    [thread2 start];
    //
    //
    //
    //    NSThread *thread3 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread3.name=@"thread3";
    //    [thread3 start];
    //
    //
    //    NSThread *thread4 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread4.name=@"thread4";
    //    [thread4 start];
    //
    //    NSThread *thread5 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread5.name=@"thread5";
    //    [thread5 start];
    //
    //    NSThread *thread6 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread6.name=@"thread6";
    //    [thread6 start];
    //
    //    NSThread *thread7 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread7.name=@"thread7";
    //    [thread7 start];
    //
    //    NSThread *thread8 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread8.name=@"thread8";
    //    [thread8 start];
    //
    //
    //    NSThread *thread9 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread9.name=@"thread9";
    //    [thread9 start];
    //
    //
    //    NSThread *thread10 = [[NSThread alloc]initWithBlock:^{
    //        //要执行的任务
    //        [self getMoney];
    //    }];
    //    thread10.name=@"thread10";
    //    [thread10 start];
    //
    //    return;
    

    for (int i = 0; i<100; i++) {
        
        //1.block
        NSThread *thread = [[NSThread alloc]initWithBlock:^{
            //要执行的任务
            if (i==1) {
                [NSThread sleepForTimeInterval:3.0];
            }
            [self getMoney];
            
        }];
        thread.name=[NSString stringWithFormat:@"thread%d",i];
        [thread start];
        
        /*
         //2.target
         NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(getMoney) object:nil];
         thread.name=[NSString stringWithFormat:@"thread%d",i];
         [thread start];
         */
        //       [NSThread detachNewThreadWithBlock:^{
        //            [self getMoney];
        //       }];
        //        [NSThread detachNewThreadSelector:@selector(getMoney) toTarget:self withObject:nil];
        
        
        
    }
    
}
-(void)concurrentGCD{
    
    dispatch_queue_t  serialQueue = dispatch_queue_create("串行队列", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t  concurentQueue = dispatch_queue_create("并发队列", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i<10000; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"---------------------------");
        });
    }
    for (int i = 0; i<10; i++) {
        dispatch_barrier_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"只有等栅栏函数执行完了，才会执行下面的%@",[NSThread currentThread]);
            
        });
    }
    //    NSLog(@"只有等栅栏函数执行完了，才会执行下面的");
    for (int i = 0; i<10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getMoney];
        });
    }
    //    dispatch_async(concurentQueue, ^{
    //        NSLog(@"---------------------------");
    //    });
    //    for (int i = 0; i<100; i++) {
    //        dispatch_async(concurentQueue, ^{
    //      NSLog(@"---------------------------");
    //        });
    //
    //    }
    //
    //同步函数+串行队列:不会开启新的线程，任务都在主线程中串行执行，不会出现资源抢夺（Data Race）
    //    dispatch_sync(serialQueue, ^{
    //        [self getMoney];
    //    }) ;
    
    //同步函数+并发队列:不会开启新的线程，任务都在主线程中串行执行，不会出现资源抢夺（Data Race）
    //        dispatch_sync(dispatch_queue_create("同步函数+并发队列", DISPATCH_QUEUE_CONCURRENT), ^{
    //             [self getMoney];
    //        });
    
    //异步函数+串行队列:开启一条子线程，任务在子线程中串行执行，不会出现资源抢夺（Data Race）
    //        dispatch_async(dispatch_queue_create("异步函数+串行队列", DISPATCH_QUEUE_SERIAL), ^{
    //               [self getMoney];
    //        });
    
    //异步函数+并发队列:开启多条新的线程，任务再子线程中并发执行，会出现资源抢夺（Data Race）
    //        dispatch_async(dispatch_queue_create("异步函数+并发队列", DISPATCH_QUEUE_CONCURRENT), ^{
    //            [self getMoney];
    //        });
    
    
    //同步函数+全局队列:不会开启新的线程，任务都在主线程中串行执行，不会出现资源抢夺（Data Race）
    //            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //                [self getMoney];
    //            }) ;
    
    
    
    //异步函数+全局队列:开启多条新的线程，任务再子线程中并发执行，会出现资源抢夺（Data Race）
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //            [self getMoney];
    //        }) ;
    //
    
    //     //同步函数+主队列 在主线程中，出现死锁
    //    dispatch_sync(dispatch_get_main_queue(), ^{
    //        [self getMoney];
    //    }) ;
    
    //    //同步函数+主队列在子线程中，不会出现死锁，任务在主线程串行执行，不会Data Race
    //    dispatch_async(dispatch_queue_create("异步函数+串行队列", DISPATCH_QUEUE_SERIAL), ^{
    //            dispatch_sync(dispatch_get_main_queue(), ^{
    //                [self getMoney];
    //            }) ;
    //    });
    
    
    
    
    
    
    
    //      for (int i = 0; i<100; i++) {
    //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //                [self getMoney];
    //            });
    //      }
}

-(void)concurentNSOperation{
    
    NSOperationQueue *q = [[NSOperationQueue alloc]init];
    for (int i = 0; i < 100; i ++) {
        DKPOperation *operation = [[DKPOperation alloc]initWithBlock:^{
            [self getMoney];
        }];
        [q addOperation:operation];
    }
    
    
    
    //创建队列
    //    NSOperationQueue *mainQ = [NSOperationQueue mainQueue];
    //    NSOperationQueue *q = [[NSOperationQueue alloc]init];
    //    q.maxConcurrentOperationCount=2;
    //    for (int i = 0; i< 100; i++) {
    //        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
    //
    //            [self getMoney];
    //
    //        }];
    //
    //        [q addOperation:operation];
    //    }
    //
    
    
    
    
    
    
    //    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
    //        NSLog(@"operation1-----%@",[NSThread currentThread]);
    //    }];
    //    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
    //        NSLog(@"operation2-----%@",[NSThread currentThread]);
    //    }];
    //    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
    //        NSLog(@"operation3-----%@",[NSThread currentThread]);
    //    }];
    //
    //    [operation1 addDependency:operation2];
    //    [operation2 addDependency:operation3];
    //    [q addOperations:@[operation1,operation2,operation3] waitUntilFinished:NO];
    
    //    for (int i = 0; i< 100; i++) {
    //        NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(getMoney) object:nil];
    //        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
    //            [self getMoney];
    //        }];
    //        DKPOperation *myOperation = [[DKPOperation alloc]init];
    //        [q addOperation:myOperation];
    //    }
    
    
}
-(void)getMoney{
    
    @synchronized (self) {
        money--;
        NSLog(@"money:%d,thread:%@",money,[NSThread currentThread]);
    }
}
@end
