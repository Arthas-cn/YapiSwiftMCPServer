//
//  UserAPI.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2024/11/25.
//

import Combine
import Foundation
import Moya

/// UserAPI 定义用户相关的API端点
/// 包含用户信息、经期数据等与用户相关的请求
enum UserAPI {
    /// 获取用户基本信息
    case userInfo
    /// 获取应用初始化信息
    case initInfo
    /// 同步用户症状日志
    case symptomLog(page: Int, size: Int)
    /// 同步用户经期数据
    case pridodSync
}

/// 为UserAPI实现Moya的TargetType协议
/// 提供API请求所需的URL、路径、方法等信息
extension UserAPI: TargetType {
    /// API的基础URL
    /// 从环境配置中获取主机地址
    var baseURL: URL { .init(string: "")! }
    
    /// API的路径
    /// 根据不同的API端点返回对应的路径
    var path: String {
        switch self {
            case .userInfo:
                // 获取用户信息API路径
                return "services/uaa/api/users/get-user"
            case .initInfo:
                // 检查经期初始化状态API路径
                return "services/period/api/init-period/check"
        case .symptomLog:
                // 同步用户健康状况API路径
                return "services/period/api/user-condition/sync"
            case .pridodSync:
                // 同步用户经期数据API路径
                return "services/period/api/user-period/sync"
        }
    }

    /// HTTP请求方法
    /// 所有用户API都使用GET方法
    var method: Moya.Method { .get }
    
    /// 请求参数字典
    /// 默认为nil，在task中处理参数
    var parameters: [String: Any]? { nil }
    
    /// 请求任务
    var task: Task {
        switch self {
        case .symptomLog(let page, let size):
            return .requestParameters(parameters: ["pageNo": page, "pageSize": size], encoding: URLEncoding.default)
        default :
            return .requestPlain
        }
    }
    
    /// 请求头
    /// 默认为nil，使用NetworkRequestManager提供的默认头部
    var headers: [String: String]? { nil }
}

/// 实现AccessTokenAuthorizable协议，添加授权令牌支持
/// 用户相关API需要授权才能访问
extension UserAPI: AccessTokenAuthorizable {
    /// 令牌认证方式
    /// 使用自定义认证类型，从用户登录信息中获取授权令牌
    var authorizationType: Moya.AuthorizationType? {
        .custom( "")
    }
}
