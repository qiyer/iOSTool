//
//  NSObject+KVO_Block.m
//  iOSTool
//
//  Created by Zhi Zhuang on 2018/9/4.
//  Copyright © 2018年 qiye. All rights reserved.
//

#import "NSObject+KVO_Block.h"
#import <objc/runtime.h>

@implementation NSObject (KVO_Block)

static const char * BLOCK_KEY = "block_key";

-(void)block_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context block:(Block_KVO) block
{
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
    [self.blockDic setObject:[block copy] forKey:keyPath];
    [self setBlockDic:self.blockDic];
}

-(void)block_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(Block_KVO) block
{
    [self block_addObserver:observer forKeyPath:keyPath options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil block:block];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSMutableDictionary<NSString* ,Block_KVO> * _dic = [object blockDic];
    Block_KVO block = [_dic objectForKey:keyPath];
    if (block) {
        block(change[@"new"],change[@"old"]);
    }
}

-(NSMutableDictionary<NSString* ,Block_KVO> * )blockDic
{
    NSMutableDictionary<NSString* ,Block_KVO> * _dic = objc_getAssociatedObject(self, BLOCK_KEY);
    if (!_dic) {
        _dic = [NSMutableDictionary new];
        self.blockDic = _dic;
    }
    return _dic;
}

-(void)setBlockDic:(NSMutableDictionary<NSString *,Block_KVO> *)blockDic
{
    objc_setAssociatedObject(self, BLOCK_KEY, blockDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
