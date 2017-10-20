# LZXRabbitMQ
RabbitMQ适配多模块的通信

## Feature
- 与 `MQ 服务器` 配合使用 Topic 模式
- 能够精确区分响应模块
- 无需考虑 MQ 连接的生命周期
- 提供 `block` 和 `observer` 两种注册模式

## Useage

### 准备工作
. 在 `MQConfig.h` 和 `MQConfig.m` 中修改 MQ服务器 的连接信息
. 在 `MQNotificationConfig.h` 中增加需要响应 MQ消息 的类型名称
. 在需要启动 MQ推送接收 功能的地方调用 `[HDLMQTool initConnection]`

### 使用
. `#import "MQConfig.h"` 
. 调用下列方法中的任意一个进行注册
```
+ (void)registerMQFunc:(NSString *)mqFunc inPages:(FunctionOption)pages withMQCallback:(NS_NOESCAPE void(^)(HDLMQMessage *pushDict))block
```
或
```
+ (void)registerMQFunc:(NSString *)mqFunc inPages:(FunctionOption)pages withTarget:(nonnull id)target selector:(nonnull SEL)selector;
+ (void)removeMQTarget:(nonnull id)obj inFunc:(NSString *)mqFunc;
```

## 使用注意
- 如果需要关闭推送，调用 `[HDLMQTool destroyConnection]`
- 在 `dealloc 中成对的调用 `+ (void)removeMQTarget:(nonnull id)obj inFunc:(NSString *)mqFunc`
