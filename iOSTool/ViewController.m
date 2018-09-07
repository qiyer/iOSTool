//
//  ViewController.m
//  iOSTool
//
//  Created by Zhi Zhuang on 2018/8/23.
//  Copyright © 2018年 qiye. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"
#import "PlayerModel.h"

@interface ViewController ()

@end

@implementation ViewController{
    UserModel   *  userModel;
    PlayerModel *  playerModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    userModel = [UserModel new];
//    userModel.b = @"ha";
//    [userModel kvo_addObserver:self forKeyPath:@"b" options:NSKeyValueObservingOptionNew context:nil];
//    userModel.b = @"hello";
    
    playerModel = [PlayerModel new];
    [playerModel block_addObserver:self forKeyPath:@"name" block:^(id newValue, id oldValue) {
        NSLog(@"change:%@",newValue);
    }];
    playerModel.name = @"fuck,,,";
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    NSLog(@"observeValueForKeyPath:%@",keyPath);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
