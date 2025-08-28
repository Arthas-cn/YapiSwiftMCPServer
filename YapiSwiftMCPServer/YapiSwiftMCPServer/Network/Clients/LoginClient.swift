//
//  LoginClient.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/4/10.
//

import Foundation
@preconcurrency import Moya

/// LoginClient 处理与用户登录和认证相关的网络请求
/// 提供用户登录、注册、认证等操作的接口
struct LoginClient: DefaultNetworkClient, Sendable {
    /// 提供默认实例的快捷访问方式
    static var `default`: LoginClient {
        get async {
            let provider = await NetworkManager.shared.loginProvider()
            return LoginClient(provider: provider)
        }
    }
    
    /// Moya提供者，用于执行登录相关的网络请求
    let provider: MoyaProvider<MultiTarget>
    
    /// 初始化方法，接受一个Provider实例
    init(provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }
    
    /// 测试API连接是否正常
    /// - Throws: 网络请求错误
    func testPass() async throws {
        // 尝试调用测试API，忽略返回结果
        let _ = try? await provider.async.request(api: LoginAPI.test, responseType: WOCEmptyModel.self)
    }
    
}
