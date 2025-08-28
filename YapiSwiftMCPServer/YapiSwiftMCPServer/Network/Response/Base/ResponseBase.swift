//
//  ResponseBase.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/4/10.
//

import Foundation

// MARK: - 基本数据结构

/// ResponseBase 定义API响应的基本结构
/// 泛型参数T表示响应中包含的具体数据类型
/// 实现Decodable和Sendable协议，支持解码和在并发环境中安全传递
struct ResponseBase<T: Decodable & Sendable>: Decodable, Sendable {
    /// 服务器返回的状态码，200表示成功
    var code: Int
    
    /// 服务器返回的消息，通常在出错时包含错误描述
    var message: String?
    
    /// 服务器返回的实际数据，类型由泛型参数T确定
    var data: T?
}

/// ResponseList 定义分页列表的响应结构
/// 用于服务器返回列表数据时，包含分页信息和数据列表
/// 泛型参数S表示列表中包含的具体数据类型
struct ResponseList<S: Decodable & Sendable>: Decodable, Sendable {
    /// 是否有下一页数据
    var hasNextPage: Bool
    
    /// 当前返回的数据列表
    var list: [S]
    
    /// 下一页的页码
    var nextPage: Int
    
    /// 总数据条数
    var total: Int
    
    /// 最后一条数据的ID，用于某些分页实现
    var lastId: String?
    
    /// 数据版本，用于缓存或同步控制
    var version: String?
}

// MARK: - Json解码

extension JSONDecoder {
    /// 安全的JSON解码器，配置了适合应用的解码策略
    /// 自动将服务器返回的snake_case转换为camelCase
    static var safeDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase // 自动转换 snake_case 到 camelCase
        return decoder
    }
}

/// 空结果模型，用于不需要返回数据的API
/// 实现Decodable协议，可以作为ResponseBase的泛型参数
struct WOCEmptyModel: Decodable {}
