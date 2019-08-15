//
//  DKPAnimationVc.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/12.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "DKPAnimationVc.h"

@interface DKPAnimationVc ()
@property(nonatomic, strong)UIView *animeteView;
@property(nonatomic,strong)CALayer *aLayer;
@property(nonatomic,strong)UIButton *btn;
@end

@implementation DKPAnimationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.animeteView];
    [self.view addSubview:self.btn];
    [self.view.layer addSublayer:self.aLayer];
    [self aboutLayer];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.animeteView.frame = CGRectMake((SCREENW-50)*0.5,(SCREENH-50)*0.5, 50, 50);
    self.btn.frame = CGRectMake((SCREENW-90)*0.5, (SCREENH-33)*0.5+100, 90, 33);
    self.aLayer.frame = CGRectMake(0, 64, 40, 40);
}
#pragma mark  - Getter/Setter
-(UIView *)animeteView{
    if (!_animeteView) {
        _animeteView = [[UIView alloc]init];
        _animeteView.backgroundColor = [UIColor redColor];
    }
    return _animeteView;
}
- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btn setTitle:@"Start" forState:UIControlStateNormal];
        [_btn addTarget: self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [_btn setBackgroundColor:[UIColor redColor]];
        _btn.layer.masksToBounds  = YES;
        _btn.layer.cornerRadius = 5.0f;
    }
    return _btn;
}
-(CALayer *)aLayer{
    if (!_aLayer) {
        _aLayer = [[CALayer alloc]init];
        _aLayer.backgroundColor = [UIColor yellowColor].CGColor;
    }
    return _aLayer;
}
#pragma mark -Others
//开始动画
-(void)start{
//    [self test];
    [self coreAnimation];
}
#pragma mark -Animation
-(void)test{
    /*
    [UIView animateWithDuration:1.0 animations:^{
        NSLog(@"%@",NSStringFromCGRect(self.animeteView.frame));
        self.animeteView.transform =CGAffineTransformMakeRotation(M_PI_4);
    } completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"%@",NSStringFromCGRect(self.animeteView.frame));
        }
    }];
     */
/*
 1.隐式动画
 每个view都关联着一个CALayer,除了这个关联的layer外，添加上去的layer都默认存在隐式动画；
 什么事隐式动画？：改变layer的一些属性，所自带的动画效果；
 如何改变默认隐式动画？通过CATransaction（事务）
 
  [CATransaction begin];
    ....动画
   [CATransaction commit];

代码：
 [CATransaction begin];
 [CATransaction setDisableActions:NO];
 [CATransaction setAnimationDuration:2.0];
 self.aLayer.frame = CGRectMake(self.aLayer.frame.origin.x, self.aLayer.frame.origin.y+50, self.aLayer.bounds.size.width, self.aLayer.bounds.size.height);
 self.aLayer.backgroundColor = [UIColor blueColor].CGColor;
 self.view.layer.backgroundColor = [UIColor yellowColor].CGColor;
 NSLog(@"%@",kCATransactionAnimationDuration);
 [CATransaction setCompletionBlock:^{
 //setCompletionBlock中的block在当前这个事务结束后调用，所以，当前事务设置的属性比如动画时间，对其无效
 self.aLayer.anchorPoint = CGPointMake(0, 0.5);
 }];
 [CATransaction commit];
 
 */

  //2.transform动画（Core Graphics）；即仿射变换CGAffineTransform
    /*
     坐标点与仿射矩阵做乘法得到新的坐标点。
     新坐标点=原坐标点*仿射矩阵；
     [y`,x`,1] = [y，x，1]*[a,b,c,d,tx,ty];
     api介绍：
     1. CGAffineTransformIdentity([ 1 0 0 1 0 0 ])-->恢复变换
     
     2. CGAffineTransformMake(CGFloat a, CGFloat b,
     CGFloat c, CGFloat d, CGFloat tx, CGFloat ty)（[ a b c d tx ty ]）-->创建变换矩阵；
     
     3.CGAffineTransformMakeTranslation(CGFloat tx,CGFloat ty)（[ 1 0 0 1 tx ty ]）-->平移变换
     
     4.CGAffineTransformMakeScale(CGFloat sx, CGFloat sy) （[ sx 0 0 sy 0 0 ]）-->缩放变换
     
     5.CGAffineTransformMakeRotation(CGFloat angle)（[ cos(angle) sin(angle) -sin(angle) cos(angle) 0 0 ]）-->转角变换

     6.CGAffineTransformIsIdentity(CGAffineTransform t)-->当前变换处于初始状态返回YES,否则为NO，可以通过CGAffineTransformIdentity,初始换变换
     
    7、CGAffineTransformTranslate(CGAffineTransform t， CGFloat tx, CGFloat ty)（ [ 1 0 0 1 tx ty ] * t）-->在现有变换基础上再做平移变换；
     8、 CGAffineTransformScale(CGAffineTransform t,CGFloat sx, CGFloat sy)（[ sx 0 0 sy 0 0 ] * t ）-->在现有变换基础上再做缩放
     9.CGAffineTransformRotate(CGAffineTransform t,CGFloat angle)（t' =  [ cos(angle) sin(angle) -sin(angle) cos(angle) 0 0 ] * t）-->在现有变换基础上再做旋转
    10.CGAffineTransformInvert(CGAffineTransform t)-->倒置变换矩阵
     11.CGAffineTransformConcat(CGAffineTransform t1,CGAffineTransform t2)（ t' = t1 * t2 ）-->串联变换，即两个变换效果叠加
     12.CGAffineTransformEqualToTransform(CGAffineTransform t1, CGAffineTransform t2)-->比较
eg.
     [UIView animateWithDuration:0.25 animations:^{
            self.animeteView.transform = CGAffineTransformTranslate(self.animeteView.transform, 100, 0);
            self.animeteView.transform =CGAffineTransformMakeScale(2.0, 2.0);
            self.animeteView.transform=CGAffineTransformRotate(self.animeteView.transform, M_PI/2);
     }];
 */
  

    
/*组合变换*/
//    [UIView animateWithDuration:2.0 animations:^{
      //创建单位矩阵
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        //scale by 50%
//        transform = CGAffineTransformScale(transform, 0.5, 0.5);
//        //rotate by 30 degrees
//        transform = CGAffineTransformRotate(transform, M_PI/180.0*20.0);
//        //translate by 200 points
//        transform = CGAffineTransformTranslate(transform, 200, 0);
//        //apply transform to layer
//        self.animeteView.layer.affineTransform = transform;
//       //  equal to apply view
//       //  self.animeteView.transform = transform;
//    }];

/*transform3D*/
    /*
    [UIView animateWithDuration:2.0 animations:^{
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = - 1.0 / 100.0;
        transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
        self.animeteView.layer.transform = transform;
    }];
   */
}
-(void)coreAnimation{
    /*
     1.CABasicAnimation------->继承CAPropertyAnimation
     
     CABasicAnimation *animation =[CABasicAnimation animation];
     animation.keyPath =@"transform.scale";
     animation.duration = 2.0f;
     animation.repeatCount=2;
     animation.autoreverses = NO;
     animation.fromValue = @(0.5);
     animation.toValue = @(2);
     [self.animeteView.layer addAnimation:animation forKey:nil];
     
     keyPath:
     缩放
     transform.scale
     transform.scale.x
     transform.scale.y
    bounds
     旋转
     transform.rotation
     transform.rotation.x
     transform.rotation.y
     transform.rotation.z
     
     平移
     position
     圆角---可以变成圆
     cornerRadius
     
    不透明度
     opacity
     。
     。
     。
     
     
     */
    
    /*
    CAKeyframeAnimation--->继承自 CAPropertyAnimation
     */
 
    /*
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.duration = 2.0f;
        animation.keyPath=@"transform.scale";
        animation.values = @[@(0.1),@(0.5),@(1.0),@(2.0)];
        [self.animeteView.layer addAnimation:animation forKey:nil];
    */
    /*
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.duration = 2.0f;
        animation.keyPath=@"position";
        animation.path=path.CGPath;
        [self.animeteView.layer addAnimation:animation forKey:nil];
     */
    /*
    CASpringAnimation *animation = [CASpringAnimation animation];
    animation.keyPath=@"position";
    animation.mass = 1;
    //弹簧刚度系数
    animation.stiffness = 100;
    //减震系数
    animation.damping = 1;
    //初始速度，小于0时先反方向运动
    animation.initialVelocity = 10;
    animation.duration = 2.0;
    animation.toValue = @(CGPointMake(100, 100));
    [self.animeteView.layer addAnimation:animation forKey:nil];
     */
    /*
    CABasicAnimation *anmation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anmation1.duration=0.5;
    anmation1.repeatCount = 4;
    anmation1.autoreverses = NO;
    anmation1.byValue=@(M_PI);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.animeteView.center];
    [path addLineToPoint:CGPointMake(0, 200)];
    [path addArcWithCenter:CGPointMake(100, 200) radius:100 startAngle:M_PI endAngle:0 clockwise:NO];
    [path moveToPoint:self.animeteView.center];
    CAKeyframeAnimation *anmation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anmation2.duration=2.0;
    anmation2.autoreverses = YES;
    anmation2.path = path.CGPath;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations=@[anmation1,anmation2];
    group.duration = 2.0;
    [self.animeteView.layer addAnimation:group forKey:nil];
    */
    /*
    CATransition *animation = [CATransition animation];
    animation.type =kCATransitionR/Users/luoyujie/Desktop/TestDemo/SocketDemoeveal;
    animation.subtype = kCATransitionFromTop;
    [self.animeteView.layer addAnimation:animation forKey:nil];
    */
    [UIView transitionWithView:self.animeteView duration:2.0 options:UIViewAnimationOptionAutoreverse animations:^{
        self.animeteView.backgroundColor = [UIColor yellowColor];
    } completion:nil];
    CATransition
}
//UIView自带动画.(UIView.h中有三个分类，分别代表3种不同的UIView动画)
-(void)animationofUIView{
    //1.UIView(UIViewAnimation)

    //开始动画
    [UIView beginAnimations:@"scale" context:nil];
   // ....具体动画
    self.animeteView.frame = CGRectMake(self.animeteView.frame.origin.x, self.animeteView.frame.origin.y+50, self.animeteView.bounds.size.width, self.animeteView.bounds.size.height);
    [UIView commitAnimations];
    
    
    //2.UIView(UIViewAnimationWithBlocks)---block动画

    [UIView animateWithDuration:2.0 animations:^{
        
    }];
    [UIView animateWithDuration:2.0 animations:^{
        
    } completion:nil];
    /*
    *弹簧效果动画
    * Damping:阻尼系数 值越小弹簧效果越明显 取值0到1
    *Velocity:初始的速度，数值越大一开始移动越快
     */
     
    [UIView animateWithDuration:2.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:100 options:UIViewAnimationOptionRepeat animations:^{
        
    } completion:nil];

    //3.UIView (UIViewKeyframeAnimations)--关键帧动画
    /*
     *duration:整个动画的时间，包含所有帧
     */
    [UIView animateKeyframesWithDuration:4 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
        
        /*
         *frameStartTime:当前帧相对整个时间的起始时间，0到1的小数
         *frameDuration：当前帧相对整个时间的时间间隔，0到1的小数
         */
        //第一帧
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            self.animeteView.backgroundColor = [UIColor yellowColor];
        }];
        //第二帧
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            self.animeteView.backgroundColor = [UIColor whiteColor];
        }];
        
    } completion:nil];
    
}

-(void)aboutLayer{
    //阴影
    /*
    self.animeteView.layer.shadowOpacity = 0.5f;
    self.animeteView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.animeteView.layer.shadowRadius = 5.0f;
     
     指定阴影形状
     
     
    */
//    self.animeteView.layer.shadowOpacity = 0.5f;
//  CGMutablePathRef pathRef = CGPathCreateMutable();
////      self.animeteView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
////    CGPathAddRect(pathRef, NULL, self.animeteView.bounds);
//    CGPathAddEllipseInRect(pathRef, NULL, self.animeteView.bounds);
//    self.animeteView.layer.shadowPath = pathRef;
//    CGPathRelease(pathRef);
}








- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//   UITouch *myTouch = [touches anyObject];
//   CGPoint p = [myTouch locationInView:self.view];
//    self.animeteView.center = p;
//
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint p = [myTouch locationInView:self.view];
    self.animeteView.center = p;

    
}
@end
