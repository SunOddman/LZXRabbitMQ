//
//  MQConfig.m
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/22.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import "MQConfig.h"



@implementation MQConfig


+ (NSString *)routingKey {
    // TODO: 根据服务器约定定义 RoutingKey 规范
    return [NSString stringWithFormat:@"%@.%@.#", mq_routingKeyPrifix, [HSingleGlobalData sharedInstanced].storeId];
}

+ (NSString *)queueName {
    // TODO: 根据服务器约定定义 QueueName 规范
    return [NSString stringWithFormat:@"%@.%@", mq_queueNamePrifix, [[[UIDevice currentDevice] identifierForVendor] UUIDString]]; 
}

@end
