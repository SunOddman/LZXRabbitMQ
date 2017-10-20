//
//  HDLMQTool.m
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/14.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import "HDLMQTool.h"
#import "MQBindUnit.h"
#import "MQConfig.h"

@interface HDLMQTool ()

@property (nonatomic, strong) RMQConnection *conn;
@property (nonatomic, strong) id<RMQChannel> channel;
@property (nonatomic, strong) RMQExchange *exchange;
@property (nonatomic, strong) RMQQueue *queue;

@property (nonatomic, strong) NSMutableArray<MQBindUnit *> *bindArray;

@end

@implementation HDLMQTool

+ (instancetype)shared {
    static id sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)initConnection {
    [[self shared] initConnection];
}

- (void)initConnection {
    if (_conn) {
        [self destroyConnection];
    }
    NSLog(@"\n\n-----------【MQ推送】初始化 MQ 连接-----------\n");
    NSString *mqUri = [NSString stringWithFormat:@"amqp://%@:%@@%@:%@%@", mq_user, mq_password, mq_ip, mq_port, mq_virtualHost];
    NSLog(@"\n mqUri: 【%@】", mqUri);
    _conn = [[RMQConnection alloc] initWithUri:mqUri delegate:[RMQConnectionDelegateLogger new]];
    if (_conn) {
        
        NSLog(@"\n\n-----------【MQ推送】尝试连接到 MQ 服务器-----------\n");
        [_conn start];
        
        NSLog(@"\n\n-----------【MQ推送】应用 MQ 连接配置-----------\n");
        
        NSLog(@"\n\n-----------【MQ推送】初始化 MQ 通道-----------\n");
        _channel = [_conn createChannel];
        
        NSLog(@"\n\n-----------【MQ推送】初始化 MQ Exchange-----------\n");
        NSLog(@"\n exchangeName: 【%@】", mq_exchangeName);
        _exchange =[_channel topic:mq_exchangeName options:RMQExchangeDeclareDurable];
        
        [self initQueue];
        
    } else {
        NSLog(@"\n\n-----------【MQ推送】初始化 MQ 连接失败，将在 5s 后重试-----------\n");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initConnection];
        });
    }
}

+ (void)destroyConnection {
    [[self shared] destroyConnection];
}

- (void)destroyConnection {
    [_conn close];
    _conn = nil;
}


- (RMQConnection *)conn {
    if (!_conn) {
        NSLog(@"\n\n-----------【MQ推送】没有到 MQ 的连接!-----------\n");
    }
    return _conn;
}

- (NSMutableArray<MQBindUnit *> *)bindArray {
    if (!_bindArray) {
        _bindArray = [[NSMutableArray<MQBindUnit *> alloc] init];
    }
    return _bindArray;
}

- (void)initQueue {
    NSLog(@"\n\n-----------【MQ推送】初始化 MQ 队列-----------\n");
    NSString *queueName = [MQConfig queueName];
    NSLog(@"\n queueName: 【%@】", queueName);
    _queue = [_channel queue:queueName options:mq_queueOptions];
    
    NSLog(@"\n\n-----------【MQ推送】配置 MQ routingKeys-----------\n");
    NSString *routingKey = [MQConfig routingKey];
    NSLog(@"\n routingKey: 【%@】", routingKey);
    [_queue bind:_exchange routingKey:routingKey];
    
    NSLog(@"\n\n-----------【MQ推送】开始接收 MQ 推送-----------\n");
    [_queue subscribe:^(RMQMessage * _Nonnull message) {
        
        NSLog(@"\n\n-----------【MQ推送】Received MQMessage----------- \n %@ \n", [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding]);
        
        HDLMQMessage *mqMessage = [HDLMQMessage messageWithData:message.body];
        
        MQBindUnit *bind = [self bindForFuncName:mqMessage.code];
        
        if (bind) {
            [bind processMessage:mqMessage];
        } else {
            NSLog(@"\n\n-----------【MQ推送】未绑定的MQ推送! ----------- \n %@ \n", mqMessage);
        }
    }];
}

#pragma mark - 注册推送

+ (void)registerMQFunc:(NSString *)mqFunc inPages:(FunctionOption)pages withMQCallback:(NS_NOESCAPE HDLMQCallback)block {
    [[self shared] registerMQFunc:mqFunc inPages:pages withMQCallback:block];
}
- (void)registerMQFunc:(NSString *)mqFunc inPages:(FunctionOption)pages withMQCallback:(NS_NOESCAPE HDLMQCallback)block {
    
    MQBindUnit *bind = [self bindForFuncName:mqFunc];
    if (!bind) {
        bind = [MQBindUnit bindWithFuncName:mqFunc];
        [self.bindArray addObject:bind];
    }
    
    [bind addProcessor:block forPages:pages];
}

+ (void)registerMQFunc:(NSString *)mqFunc inPages:(FunctionOption)pages withTarget:(nonnull id)target selector:(nonnull SEL)selector {
    [[self shared] registerMQFunc:mqFunc inPages:pages withTarget:target selector:selector];
}
- (void)registerMQFunc:(NSString *)mqFunc inPages:(FunctionOption)pages withTarget:(nonnull id)obj selector:(nonnull SEL)selector  {
    
    MQBindUnit *bind = [self bindForFuncName:mqFunc];
    if (!bind) {
        bind = [MQBindUnit bindWithFuncName:mqFunc];
        [self.bindArray addObject:bind];
    }
    
    [bind addProcessorOnTarget:obj selector:selector forPages:pages];
}

+ (void)removeMQTarget:(nonnull id)obj inFunc:(NSString *)mqFunc {
    [[self shared] removeMQTarget:obj inFunc:mqFunc];
}
- (void)removeMQTarget:(nonnull id)obj inFunc:(NSString *)mqFunc {
    
    MQBindUnit *bind = [self bindForFuncName:mqFunc];
    if (!bind) {
        return;
    }
    
    [bind removeMQTarget:obj];
    
}

- (MQBindUnit *)bindForFuncName:(NSString *)funcName {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"funcName = %@", funcName];
    NSArray<MQBindUnit *> *arrR = [self.bindArray filteredArrayUsingPredicate:pre];
    
    NSAssert(arrR.count < 2, @"在 bindArray 中出现重复绑定的 Func");
    
    MQBindUnit *bind = [arrR firstObject];
    return bind;
}




@end
