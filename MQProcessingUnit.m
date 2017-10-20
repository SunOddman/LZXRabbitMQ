//
//  MQProcessingUnit.m
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/25.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import "MQProcessingUnit.h"

@implementation MQProcessingUnit

- (void)processMessage:(HDLMQMessage *)message {
    if ([HSingleGlobalData sharedInstanced].currentFunction & self.allowedPages) {
        
        self.callBackBlock(message);
        
        if (NULL != self.callBackSelector) {
            [[NSNotificationCenter defaultCenter] postNotificationName:message.code object:nil];
        }
        
    }
}

@end
