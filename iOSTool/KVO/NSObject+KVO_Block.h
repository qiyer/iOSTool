//
//  NSObject+KVO_Block.h
//  iOSTool
//
//  Created by Zhi Zhuang on 2018/9/4.
//  Copyright © 2018年 qiye. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Block_KVO)(id newValue, id oldValue);

@interface NSObject (KVO_Block)

@property(nonatomic,strong) NSMutableDictionary<NSString* ,Block_KVO> * blockDic;

-(void)block_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context block:(Block_KVO) block;
-(void)block_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(Block_KVO) block;

@end
