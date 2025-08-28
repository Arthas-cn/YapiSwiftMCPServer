//
//  NetworkClient.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/4/10.
//

import Foundation
import Moya

/// NetworkClient 定义网络客户端的通用接口
/// 所有客户端类型都应该遵循此协议以保持一致性
protocol NetworkClient {
    /// 客户端所使用的Provider类型
    associatedtype ProviderType
    
    /// 获取Provider实例
    var provider: ProviderType { get }
    
    /// 使用指定的Provider初始化客户端
    init(provider: ProviderType)
}

/// DefaultNetworkClient 扩展协议，添加默认实例支持
/// 允许通过static default属性快速获取配置好的客户端实例
protocol DefaultNetworkClient: NetworkClient where ProviderType == MoyaProvider<MultiTarget> {
    /// 获取默认配置的客户端实例
    static var `default`: Self { get async }
}

/// 为遵循DefaultNetworkClient协议的类型提供默认实现
extension DefaultNetworkClient {
    /// 默认实现，从NetworkManager获取适当的Provider并创建客户端实例
    static var `default`: Self {
        get async {
            // 子类必须在实现中重写此方法
            fatalError("Subclasses must implement this property")
        }
    }
    
    /// 重置网络配置
    /// 在用户登录状态变化、网络环境变化等情况下调用
    /// 会更新HTTP头部信息并重置Provider实例
    static func resetNetworkConfiguration() async {
        await NetworkManager.shared.updateHeaders()
    }
}

/// 网络客户端工厂，提供创建网络客户端的静态方法
enum NetworkClientFactory {
    /// 重置所有网络配置
    /// 在登录状态变化或应用启动时调用
    static func resetAllConfigurations() async {
        await NetworkManager.shared.updateHeaders()
    }
} 