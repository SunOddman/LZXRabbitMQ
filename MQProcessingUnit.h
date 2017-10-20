//
//  MQProcessingUnit.h
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/25.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDLMQMessage.h"

typedef void (^HDLMQCallback)(HDLMQMessage *pushDict);

/**
 MQ业务处理单元
 */
@interface MQProcessingUnit : NSObject

@property (nonatomic, assign) FunctionOption allowedPages;

@property (nonatomic, copy) HDLMQCallback callBackBlock;

@property (nonatomic, weak) id callBackTarget;
@property (nonatomic, assign) SEL callBackSelector;

- (void)processMessage:(HDLMQMessage *)message;

@end
