//
//  HDLMQMessage.m
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/25.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import "HDLMQMessage.h"

@implementation HDLMQMessage

+ (instancetype)messageWithData:(NSData *)data {
    return [self yy_modelWithJSON:data];
}

- (NSString *)description {
    NSMutableString *str = [NSMutableString new];
    [str appendFormat:@"<%@:%p> {\n", [self class], self];
    [str appendFormat:@"\t code : %@\n", self.code];
    [str appendFormat:@"\t data : %@\n", self.data];
    [str appendFormat:@"\t message : %@\n", self.message];
    [str appendFormat:@"}\n"];
    return str;
}


@end
