//
//  WOCNetworkPlugin.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/4/10.
//

import Foundation
import Moya

/**
 * Moya提供的默认插件包括：
 * - AccessTokenPlugin: 管理AccessToken的插件，用于自动添加认证令牌到请求头
 * - CredentialsPlugin: 管理认证的插件，处理身份验证
 * - NetworkActivityPlugin: 管理网络状态的插件，可用于显示/隐藏网络活动指示器
 * - NetworkLoggerPlugin: 管理网络日志的插件，记录请求和响应信息
 */

/// MoyaPlugin 提供应用中使用的自定义Moya插件
/// 用于拦截和修改网络请求的各个环节
struct MoyaPlugin {
    /// 初始化插件
    init() {}

    /// 通用插件实例，用于全局请求处理
    /// 可在应用中直接使用此插件实例配置网络请求
    static let generalPlugin = GeneralPlugin()
    
    /// 基础插件配置，包含所有API共用的插件
    static var basePlugins: [PluginType] {
        [generalPlugin]
    }
    
    /// 根据认证需求返回适当的插件列表
    /// - Parameter requiresAuth: 是否需要认证令牌
    /// - Returns: 配置好的插件数组
    static func pluginsForAuthentication(requiresAuth: Bool) -> [PluginType] {
        var plugins = basePlugins
        
        return plugins
    }
}

extension MoyaPlugin {
    /// GeneralPlugin 是应用的通用网络插件
    /// 实现PluginType协议，提供网络请求的拦截和处理功能
    struct GeneralPlugin: PluginType {
        /// 在发送请求前修改请求
        /// 可用于添加公共参数、进行数据加密等操作
        /// - Parameters:
        ///   - request: 原始URLRequest对象
        ///   - target: 目标API端点
        /// - Returns: 修改后的URLRequest对象
        func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
            var request = request
            // 设置请求超时时间为60秒
            request.timeoutInterval = 60
            return request
        }

        /// 在请求即将发送到网络之前调用
        /// 可用于显示加载指示器、记录开始时间等
        /// - Parameters:
        ///   - request: 请求对象
        ///   - target: 目标API端点
        func willSend(_ request: RequestType, target: TargetType) {
            // 这里可以实现网络请求开始的处理逻辑
            // 例如：显示网络加载指示器
        }

        /// 在收到响应后但在调用完成处理程序之前调用
        /// 可用于隐藏加载指示器、记录网络请求结束等
        /// - Parameters:
        ///   - result: 请求结果，包含响应或错误
        ///   - target: 目标API端点
        func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
            // 这里可以实现网络请求结束的处理逻辑
            // 例如：隐藏网络加载指示器
        }

        /// 在完成之前处理结果
        /// 可用于数据解密、通用错误处理等
        /// - Parameters:
        ///   - result: 原始请求结果
        ///   - target: 目标API端点
        /// - Returns: 处理后的结果
        func process(_ result: Result<Response, MoyaError>, target: TargetType)
            -> Result<Response, MoyaError>
        {
            // 这里可以对响应结果进行处理
            // 例如：数据解密、错误转换等
            return result
        }
    }
}
