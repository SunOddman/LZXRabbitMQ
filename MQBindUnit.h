//
//  MQBindUnit.h
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/25.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MQProcessingUnit.h"

@interface MQBindUnit : NSObject

@property (nonatomic, copy, readonly) NSString *funcName;

@property (nonatomic, strong) NSMutableArray<MQProcessingUnit *> *processors;


/**
 向该绑定中添加处理单元

 @param processor 处理单元
 @param pages 响应页面
 */
- (void)addProcessor:(HDLMQCallback)processor forPages:(FunctionOption)pages;

/**
 向该绑定中添加处理单元

 @param target target
 @param selector SEL
 @param pages 响应页面
 */
- (void)addProcessorOnTarget:(id)target selector:(SEL)selector forPages:(FunctionOption)pages;

/**
 移除处理方法

 @param obj target
 */
- (void)removeMQTarget:(nonnull id)obj;

/**
 处理MQ推送的消息

 @param dict 消息
 */
- (void)processMessage:(HDLMQMessage *)message;

+ (instancetype)bindWithFuncName:(NSString *)funcName;

@end
