//
//  HDLMQTool.h
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/14.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQNotificationConfig.h"
@class HDLMQMessage;

@interface HDLMQTool : NSObject

+ (instancetype)shared;

+ (void)initConnection;
+ (void)destroyConnection;

+ (void)registerMQFunc:(NSString *)mqFunc inPages:(FunctionOption)pages withMQCallback:(NS_NOESCAPE void(^)(HDLMQMessage *pushDict))block;
+ (void)registerMQFunc:(NSString *)mqFunc inPages:(FunctionOption)pages withTarget:(nonnull id)target selector:(nonnull SEL)selector;
+ (void)removeMQTarget:(nonnull id)obj inFunc:(NSString *)mqFunc;

@end
