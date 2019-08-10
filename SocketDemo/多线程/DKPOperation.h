//
//  DKPOperation.h
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/9.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DKPOperationBlock)(void);
@interface DKPOperation : NSOperation
-(instancetype)initWithBlock:(DKPOperationBlock)block;
@end

NS_ASSUME_NONNULL_END
