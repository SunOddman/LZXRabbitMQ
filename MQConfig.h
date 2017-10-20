//
//  MQConfig.h
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/22.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RMQClient/RMQClient.h>

#pragma mark - MQ Setting
#warning 配置 MQ 连接设置
static NSString * mq_user = @"";
static NSString * mq_password = @"";

static NSString * mq_ip = @"";
static NSString * mq_port = @"";
static NSString * mq_virtualHost = @"";
static NSString * mq_exchangeName = @"";
static RMQExchangeDeclareOptions mq_exchangeOptions = RMQExchangeDeclareDurable;
static NSString * mq_queueNamePrifix = @"";
static RMQQueueDeclareOptions mq_queueOptions = RMQQueueDeclareAutoDelete;

static NSString * mq_routingKeyPrifix = @"";


@interface MQConfig : NSObject

+ (NSString *)routingKey;

+ (NSString *)queueName;

@end
