//
//  ViewController.m
//  iOSTool
//
//  Created by Zhi Zhuang on 2018/8/23.
//  Copyright © 2018年 qiye. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"

@interface ViewController ()

@end

@implementation ViewController{
    UserModel *  userModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userModel = [UserModel new];
    userModel.b = @"aaa";
    [userModel kvo_addObserver:self forKeyPath:@"b" options:NSKeyValueObservingOptionNew context:nil];
    userModel.b = @"dsdsdsds";
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"observeValueForKeyPath:%@",keyPath);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
