//
//  MQBindUnit.m
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/25.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import "MQBindUnit.h"

@implementation MQBindUnit

+ (instancetype)bindWithFuncName:(NSString *)funcName {
    return [[self alloc] initWithFuncName:funcName];
}

- (instancetype)initWithFuncName:(NSString *)funcName {
    if (self = [super init]) {
        _funcName = funcName;
    }
    return self;
}

- (NSMutableArray<MQProcessingUnit *> *)processors {
    if (!_processors) {
        _processors = [[NSMutableArray<MQProcessingUnit *> alloc] init];
    }
    return _processors;
}

- (void)addProcessor:(HDLMQCallback)processor forPages:(FunctionOption)pages {
    
    MQProcessingUnit *processorUnit = [[MQProcessingUnit alloc] init];
    processorUnit.allowedPages = pages;
    processorUnit.callBackBlock = processor;
    
    [self.processors addObject:processorUnit];
}

- (void)addProcessorOnTarget:(id)target selector:(SEL)selector forPages:(FunctionOption)pages {
    
    MQProcessingUnit *processorUnit = [[MQProcessingUnit alloc] init];
    processorUnit.callBackTarget = target;
    processorUnit.callBackSelector = selector;
    
    [self.processors addObject:processorUnit];
}

- (void)removeMQTarget:(nonnull id)obj {
    
    [[NSNotificationCenter defaultCenter] removeObserver:obj name:self.funcName object:nil];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"callBackTarget != %@", obj];
    [self.processors filterUsingPredicate:pre];
    
}


- (void)processMessage:(HDLMQMessage *)message {
    [self.processors enumerateObjectsUsingBlock:^(MQProcessingUnit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj processMessage:message];
    }];
}

@end
