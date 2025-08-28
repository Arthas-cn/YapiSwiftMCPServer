# Network 网络模块

Network模块是Wocute应用的网络层实现，基于Moya和Combine框架构建，采用现代Swift并发特性（async/await），提供了一套简洁、类型安全的网络请求接口。模块使用actor模式确保并发安全，高效管理网络资源。

## 目录结构

```
Network/
├── Base/             # 网络基础组件
├── API/              # API端点定义
├── Clients/          # 网络客户端实现
├── Request/          # 请求模型
└── Response/         # 响应模型
```

## 模块组成

### Base - 基础组件

基础组件提供网络请求的底层支持：

- **NetworkManager**: 基于actor的网络管理器，维护共享的网络会话和Provider实例，确保并发安全性
- **NetworkClient**: 网络客户端协议和默认实现，定义客户端通用接口
- **MoyaProvider**: Moya提供者的扩展，增加了对Swift并发（async/await）的支持
- **NetworkError**: 网络错误类型定义，统一处理网络层错误
- **MoyaPlugin**: Moya插件配置，提供日志记录等功能

### API - 接口定义

使用Moya的`TargetType`协议定义各种API端点：

- **LoginAPI**: 登录相关的API端点
- **UserAPI**: 用户相关的API端点

每个API枚举包含具体的请求路径、方法、参数等配置。

### Clients - 网络客户端

封装特定领域的API调用，提供面向业务的接口：

- **LoginClient**: 处理登录相关的网络请求
- **UserClient**: 处理用户相关的网络请求

客户端遵循`DefaultNetworkClient`协议，通过`static default`属性提供便捷访问，内部使用共享的Provider实例。

### Request - 请求模型

定义网络请求的参数模型：

- **NetworkParams**: 请求参数的命名空间
- **LoginAuth**: 登录授权相关的请求参数

所有请求模型支持编码为JSON格式。

### Response - 响应模型

定义网络响应的数据结构：

- **ResponseBase**: 通用响应基础结构，包含状态码、消息和数据
- **ResponseList**: 分页列表响应结构
- **WOCEmptyModel**: 空响应模型，用于不需要返回数据的接口

## 使用示例

### 定义API端点

```swift
enum UserAPI {
    case getUserInfo(userId: String)
    case updateProfile(params: UserProfileParams)
}

extension UserAPI: TargetType {
    // 实现TargetType协议的属性和方法
}
```

### 创建客户端

```swift
// 定义客户端，遵循DefaultNetworkClient协议
struct UserClient: DefaultNetworkClient, Sendable {
    // 提供default属性用于快速获取配置好的客户端实例
    static var `default`: UserClient {
        get async {
            let provider = await NetworkManager.shared.userProvider()
            return UserClient(provider: provider)
        }
    }
    
    // Provider实例，由外部注入
    let provider: MoyaProvider<MultiTarget>
    
    // 初始化方法，接受Provider实例
    init(provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }
    
    // 业务方法实现
    func getUserInfo(userId: String) async throws -> UserInfo {
        let response = try await provider.async.request(
            api: UserAPI.getUserInfo(userId: userId),
            responseType: UserInfo.self
        )
        guard let data = response.data else {
            throw NetworkError.dataDecodingFailed
        }
        return data
    }
}
```

### 调用网络请求

```swift
// 在异步上下文中
Task {
    do {
        // 使用default属性获取配置好的客户端
        let userClient = await UserClient.default
        
        // 调用业务方法
        let userInfo = try await userClient.getUserInfo(userId: "123")
        // 处理获取到的用户信息
    } catch let error as NetworkError {
        // 处理网络错误
    }
}
```

### 重置网络配置

当登录状态变化或需要更新全局网络配置时：

```swift
// 通过工厂方法重置所有网络配置
await NetworkClientFactory.resetAllConfigurations()

// 或者通过客户端类型重置特定配置
await UserClient.resetNetworkConfiguration()
```

## 错误处理

Network模块定义了统一的`NetworkError`类型处理不同层级的错误：

- **networkingFailed**: HTTP层错误，包含状态码
- **dataDecodingFailed**: 数据解析错误
- **serverError**: 服务器返回的业务错误，包含错误码和消息

## 架构特点

- **并发安全**：通过actor保证线程安全
- **资源共享**：Session和Provider实例全局共享，避免资源浪费
- **依赖注入**：通过构造函数注入Provider，提高可测试性
- **便捷访问**：提供default属性快速获取配置好的客户端
- **灵活配置**：支持按需配置插件和授权方式

## 扩展指南

### 添加新的API端点

1. 在相应的API枚举中添加新的case
2. 在扩展中实现对应的路径、方法、参数等配置

### 添加新的客户端

1. 创建新的Client结构体，遵循DefaultNetworkClient协议
2. 实现static default属性，获取合适的Provider
3. 添加业务方法，使用provider.async.request调用API端点

### 添加新的Provider类型

1. 在NetworkManager中添加新的Provider创建和缓存方法
2. 确保在resetProviders()方法中重置新增的Provider 