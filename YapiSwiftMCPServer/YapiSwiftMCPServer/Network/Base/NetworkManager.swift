//
//  NetworkManager.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/4/10.
//

import Foundation
import Alamofire
import Moya

/// 网络管理器，负责维护共享的网络会话和配置
/// 使用actor确保在并发环境中的线程安全性
actor NetworkManager {
    /// 共享实例
    static let shared = NetworkManager()
    
    /// 共享的Alamofire会话实例
    let session: Alamofire.Session
    
    /// 缓存的登录相关API的Provider实例
    private lazy var _loginProvider: MoyaProvider<MultiTarget> = createLoginProvider()
    
    /// 缓存的用户相关API的Provider实例
    private lazy var _userProvider: MoyaProvider<MultiTarget> = createUserProvider()
    
    /// 初始化方法
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        
       let defaultHeaders =  [
            // 内容类型，指定为JSON格式
            "Content-type": "application/json;charset=utf-8",
        ]
        
        configuration.headers = HTTPHeaders(defaultHeaders)
        self.session = Alamofire.Session(configuration: configuration)
    }
    
    /// 更新会话配置（例如在登录状态变化时）
    func updateHeaders() async {
        // 如果需要重新创建session和provider，可以在这里实现
        // 例如在登录状态变化时，需要重新创建带有新授权令牌的provider
        resetProviders()
    }
    
    /// 重置所有Provider实例
    /// 在需要刷新Provider配置时调用，例如登录状态变化
    func resetProviders() {
        _loginProvider = createLoginProvider()
        _userProvider = createUserProvider()
    }
    
    /// 创建登录相关API的Provider
    private func createLoginProvider() -> MoyaProvider<MultiTarget> {
        return MoyaProvider<MultiTarget>(
            session: session,
            plugins: MoyaPlugin.pluginsForAuthentication(requiresAuth: false)
        )
    }
    
    /// 创建用户相关API的Provider
    private func createUserProvider() -> MoyaProvider<MultiTarget> {
        return MoyaProvider<MultiTarget>(
            session: session,
            plugins: MoyaPlugin.pluginsForAuthentication(requiresAuth: true)
        )
    }
    
    /// 获取登录相关API的Provider
    /// 返回缓存的Provider实例，避免重复创建
    func loginProvider() -> MoyaProvider<MultiTarget> {
        return _loginProvider
    }
    
    /// 获取用户相关API的Provider
    /// 返回缓存的Provider实例，避免重复创建
    func userProvider() -> MoyaProvider<MultiTarget> {
        return _userProvider
    }
}
