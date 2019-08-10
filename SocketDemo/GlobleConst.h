//
//  GlobleConst.h
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/6.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobleConst : NSObject
/*可变数据*/
extern  NSString *name;
extern  NSString *phone;
/*值可变，地址不可变*/
extern  NSString const*  userCode;
extern  const NSString *  userName;
/*值不可变，地址可变*/
extern  NSString * const sex;




@end

NS_ASSUME_NONNULL_END
