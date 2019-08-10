//
//  BaseView.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/10.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "BaseView.h"
#import <objc/message.h>
@implementation BaseView

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        Method   originMethod1 = class_getInstanceMethod(class, @selector(hitTest:withEvent:));
        Method   newMethod1 = class_getInstanceMethod(class, @selector(DKP_hitTest:withEvent:));
        BOOL didAddMethod1 = class_addMethod(class,  @selector(hitTest:withEvent:), method_getImplementation(newMethod1), method_getTypeEncoding(newMethod1));
        if (didAddMethod1) {
            class_replaceMethod(class, @selector(DKP_hitTest:withEvent:),method_getImplementation(originMethod1), method_getTypeEncoding(originMethod1));
        }else{
            method_exchangeImplementations(originMethod1, newMethod1);
        }
        
        Method   originMethod2 = class_getInstanceMethod(class, @selector(pointInside:withEvent:));
        Method   newMethod2 = class_getInstanceMethod(class, @selector(DKP_pointInside:withEvent:));
        BOOL didAddMethod2 = class_addMethod(class,  @selector(pointInside:withEvent:), method_getImplementation(newMethod2), method_getTypeEncoding(newMethod2));
        if (didAddMethod2) {
            class_replaceMethod(class, @selector(DKP_pointInside:withEvent:),method_getImplementation(originMethod2), method_getTypeEncoding(originMethod2));
        }else{
            method_exchangeImplementations(originMethod2, newMethod2);
        }
        
        
        Method   originMethod3 = class_getInstanceMethod(class, @selector(touchesBegan:withEvent:));
        Method   newMethod3 = class_getInstanceMethod(class, @selector(DKP_touchesBegan:withEvent:));
        BOOL didAddMethod3 = class_addMethod(class,  @selector(touchesBegan:withEvent:), method_getImplementation(newMethod3), method_getTypeEncoding(newMethod3));
        if (didAddMethod3) {
            class_replaceMethod(class, @selector(DKP_touchesBegan:withEvent:),method_getImplementation(originMethod3), method_getTypeEncoding(originMethod3));
        }else{
            method_exchangeImplementations(originMethod3, newMethod3);
        }
        
        
    });
}
-(UIView *)DKP_hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"%@------%s",NSStringFromClass([self class]),__func__);
    if ([NSStringFromClass([self class]) isEqualToString:@"secondView"]) {
        return self;
    }
    return [self DKP_hitTest:point withEvent:event];
}
-(BOOL)DKP_pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%@------%s",NSStringFromClass([self class]),__func__);
    return  [self DKP_pointInside:point withEvent:event];
}
-(void)DKP_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     NSLog(@"%@------%s",NSStringFromClass([self class]),__func__);

}
@end
