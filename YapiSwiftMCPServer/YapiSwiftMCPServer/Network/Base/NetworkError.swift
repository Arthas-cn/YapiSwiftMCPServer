//
//  NetworkError.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/4/10.
//

/// NetworkError 定义了应用中可能遇到的网络错误类型
/// 实现了Error, Identifiable, Sendable协议，用于错误处理和传递
enum NetworkError: Error, Identifiable, Sendable {
    /// 用错误描述作为唯一标识符，实现Identifiable协议要求
    var id: String { localizedDescription }
    
    /// 网络层错误，通常是HTTP状态码错误
    /// - Parameter: HTTP状态码
    case networkingFailed(Int)
    
    /// 数据解析错误，通常发生在JSON解码失败时
    case dataDecodingFailed
    
    /// 服务器返回的业务错误
    /// - Parameters:
    ///   - Int: 服务器错误码
    ///   - String?: 错误消息描述
    case serverError(Int, String?)
}

/// NetworkError扩展，提供错误的本地化描述
extension NetworkError {
    /// 返回错误的本地化描述，用于展示给用户或日志记录
    var localizedDescription: String {
        switch self {
        case .networkingFailed(let Status):
            return "Network error \(Status)"
        case .dataDecodingFailed:
            return "Data decoding failed"
        case .serverError(let code, let message):
            return "Server error \(code): \(message ?? "")"
        }
    }
}
