//
//  NSObject+KVO.h
//  iOSTool
//
//  Created by Zhi Zhuang on 2018/8/23.
//  Copyright © 2018年 qiye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)

-(void)kvo_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
