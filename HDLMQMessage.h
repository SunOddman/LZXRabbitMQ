//
//  HDLMQMessage.h
//  HDL_PH
//
//  Created by 海底捞lzx on 2017/8/25.
//  Copyright © 2017年 hoperun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDLMQMessage : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *message;

+ (instancetype)messageWithData:(NSData *)data;

@end
