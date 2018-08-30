//
//  NSObject+KVO.m
//  iOSTool
//
//  Created by Zhi Zhuang on 2018/8/23.
//  Copyright © 2018年 qiye. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation NSObject (KVO)

-(void)kvo_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    NSString * className      = NSStringFromClass([self class]);
    NSString * childClassName = [@"KVO_" stringByAppendingString:className];
    Class      childClass     = objc_allocateClassPair([self class], childClassName.UTF8String, 0);
    //这里严谨一点判断一下 首字符 是不是 字母
    NSString * headChar       = [keyPath substringToIndex:1];
    NSString * setKeyPath     = [headChar.uppercaseString stringByAppendingString:[keyPath substringFromIndex:1]];
    NSString * selectorName   = [[@"set" stringByAppendingString:setKeyPath] stringByAppendingString:@":"];
    
    Method clazzMethod        = class_getInstanceMethod([self class], NSSelectorFromString(selectorName));
    const char *types         = method_getTypeEncoding(clazzMethod);
    
    class_addMethod(childClass, NSSelectorFromString(selectorName), (IMP)setKVOvalue, types);
    objc_registerClassPair(childClass);
    
    object_setClass(self, childClass);
    objc_setAssociatedObject(self, (__bridge const void*)@"Retained_object", observer, OBJC_ASSOCIATION_RETAIN);
    
    objc_setAssociatedObject(self, (__bridge const void*)@"KVO_setter", selectorName, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void*)@"KVO_getter", keyPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

void setKVOvalue(id _self,SEL sel,id newValue){
    Class curClass = [_self class];
    object_setClass(_self, class_getSuperclass(curClass));
    
    NSString *setNameStr = objc_getAssociatedObject(_self, (__bridge const void*)@"KVO_setter");
    NSString *getNameStr = objc_getAssociatedObject(_self, (__bridge const void*)@"KVO_getter");
    
    //获取旧的值
    //id oldValue = objc_msgSend(_self, NSSelectorFromString(getNameStr));
    IMP imp_getOldValue = [_self methodForSelector:NSSelectorFromString(getNameStr)];
    id (*IMP_getOldValue)(void *, SEL) = (void *)imp_getOldValue;
    id oldValue  = IMP_getOldValue((__bridge void *)(_self),NSSelectorFromString(getNameStr));
    
    //调用原类set方法
    //objc_msgSend(_self, NSSelectorFromString(setNameStr), newValue);
    IMP imp_setName = [_self methodForSelector:sel];
    void (*IMP_setName)(void *, SEL, id) = (void *)imp_setName;
    IMP_setName((__bridge void *)(_self),sel,newValue);
    
    NSMutableDictionary *change = @{}.mutableCopy;
    if (newValue) change[NSKeyValueChangeNewKey] = newValue;
    if (oldValue) change[NSKeyValueChangeOldKey] = oldValue;
    
    NSObject * observer =objc_getAssociatedObject(_self, (__bridge const void*)@"Retained_object");
    //调用 observeValueForKeyPath:ofObject:change:context:通知观察对象
    //objc_msgSend(observer, @selector(observeValueForKeyPath: ofObject: change: context:), getNameStr, _self, change, nil);
    SEL obSEL = NSSelectorFromString(@"observeValueForKeyPath:ofObject:change:context:");
    IMP imp_observe = [observer methodForSelector:obSEL];
    void (*IMP_observe)(void *, SEL, id,id,id,id) = (void *)imp_observe;
    IMP_observe((__bridge void *)observer,obSEL,getNameStr,_self,change,nil);
    
    object_setClass(_self, curClass);
}

- (void)printAllFunctionNames:(id) observer
{
    unsigned int count;
    Method *methods = class_copyMethodList([observer class], &count);
    for (int i = 0; i < count; i++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        NSLog(@"方法名称：%@",name);
    }
}

@end
