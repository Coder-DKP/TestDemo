//
//  DKPTabVc.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/15.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "DKPTabVc.h"
#import "mainVc.h"
@interface DKPTabVc ()

@end

@implementation DKPTabVc
-(instancetype)init{
    if (self = [super init]) {
        [self addChildVc];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;

}
-(void)addChildVc{
    
    mainVc *first = [[mainVc alloc]init];
    UINavigationController *nVc1 = [[UINavigationController alloc]initWithRootViewController:first];
    first.tabBarItem.title = @"首页";
    [first.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    first.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    [self addChildViewController:nVc1];
    
    UIViewController *second = [[UIViewController alloc]init];
    UINavigationController *nVc2 = [[UINavigationController alloc]initWithRootViewController:second];
    second.tabBarItem.title = @"商城";
    [second.tabBarItem setSelectedImage:[UIImage imageNamed:@"dp_give_blue"]];
    second.tabBarItem.image = [UIImage imageNamed:@"dp_give_gray"];
    [self addChildViewController:nVc2];
    
    mainVc *third = [[mainVc alloc]init];
    UINavigationController *nVc3 = [[UINavigationController alloc]initWithRootViewController:third];
    
    third.tabBarItem.title = @"资产";
    [third.tabBarItem setSelectedImage:[UIImage imageNamed:@"dp_property_sel"]];
    third.tabBarItem.image = [UIImage imageNamed:@"dp_property_def"];
    [self addChildViewController:nVc3];
    
    mainVc *forth = [[mainVc alloc]init];
    UINavigationController *nVc4 = [[UINavigationController alloc]initWithRootViewController:forth];
    forth.tabBarItem.title = @"资讯";
    [forth.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_info_selected"]];
    forth.tabBarItem.image = [UIImage imageNamed:@"tabbar_info"];
    [self addChildViewController:nVc4];
    
    mainVc *fifth = [[mainVc alloc]init];
    
    UINavigationController *nVc5 = [[UINavigationController alloc]initWithRootViewController:fifth];
    fifth.tabBarItem.title = @"我的";
    [fifth.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_user_selected"]];
    fifth.tabBarItem.image = [UIImage imageNamed:@"tabbar_user"];
    [self addChildViewController:nVc5];
    
    
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    [first.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateNormal];
    [second.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateNormal];
    [third.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateNormal];
    [forth.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateNormal];
    [fifth.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateNormal];
    [first.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    [second.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    [third.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    [forth.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    [fifth.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    CATransition *transition = [CATransition animation];
//    transition.type = @"pageCurl";
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
}
@end
