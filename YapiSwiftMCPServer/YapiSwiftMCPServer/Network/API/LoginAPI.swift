//
//  LoginAPI.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2024/11/24.
//

import Combine
import Foundation
import Moya

/// LoginAPI 定义登录相关的API端点
/// 包含登录、身份验证等与用户认证相关的请求
enum LoginAPI {
    /// 测试端点，用于验证服务器连接
    case test
    /// 用户认证端点，用于登录和身份验证
    /// - Parameter params: 登录认证参数
    case auth(params: NetworkParams.LoginAuth)
}

/// 为LoginAPI实现Moya的TargetType协议
/// 提供API请求所需的URL、路径、方法等信息
extension LoginAPI: TargetType {
    /// API的基础URL
    /// 从环境配置中获取主机地址
    var baseURL: URL { .init(string: "xxx")! }
    
    /// API的路径
    /// 根据不同的API端点返回对应的路径
    var path: String {
        switch self {
        case .test: return "auth/test"
        case .auth: return "auth/login"
        }
    }

    /// HTTP请求方法
    /// 根据不同的API端点返回对应的HTTP方法
    var method: Moya.Method {
        switch self {
        case .test: return .get
        case .auth: return .post
        }
    }

    /// 请求参数字典
    /// 默认为nil，在task中处理参数
    var parameters: [String: Any]? { nil }
    
    /// 请求任务
    /// 定义如何处理和编码请求参数
    var task: Task {
        switch self {
        case .test: 
            // 测试请求不需要参数
            return .requestPlain
        case .auth(let auth):
            // 将认证参数转换为字典并使用JSON编码
            let parameters: [String: Any] = auth.asDictionary ?? [:]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    /// 请求头
    /// 默认为nil，使用NetworkRequestManager提供的默认头部
    var headers: [String: String]? { nil }
}



