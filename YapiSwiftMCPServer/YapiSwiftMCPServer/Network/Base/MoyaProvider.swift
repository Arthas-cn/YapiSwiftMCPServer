//
//  MoyaProvider.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/4/10.
//

import Combine
import CombineMoya
import Foundation
import Moya

/// 将Swift的并发Task重命名为ConcurrentTask，避免与Moya的Task冲突
typealias ConcurrentTask = _Concurrency.Task

/// MoyaProvider扩展，为MultiTarget提供者添加异步请求功能
extension MoyaProvider<MultiTarget> {
    // MARK: - MoyaConcurrency
    
    /// MoyaConcurrency 提供基于Swift并发(async/await)的网络请求能力
    /// 封装Moya的Publisher，使其支持Swift的现代并发模型
    class MoyaConcurrency {
        /// 底层的Moya提供者实例
        private let provider: MoyaProvider<MultiTarget>
        
        /// 用于存储和管理订阅的令牌
        private let subToken: SubscriptionToken = .init()
        
        /// 初始化MoyaConcurrency实例
        /// - Parameter provider: 用于执行网络请求的MoyaProvider实例
        init(provider: MoyaProvider<MultiTarget>) {
            self.provider = provider
        }
        
        /// 创建一个请求发布者，用于执行网络请求并返回响应
        /// - Parameters:
        ///   - api: 目标API端点，遵循TargetType协议
        ///   - responseType: 期望的响应数据类型
        ///   - decoder: 用于解码响应的JSONDecoder，默认使用安全解码器
        /// - Returns: 一个发布者，发出ResponseBase<T>类型的响应或NetworkError错误
        @discardableResult
        func requestPublisher<T: Decodable, D: TargetType>(api: D, responseType: T.Type, decoder: JSONDecoder = JSONDecoder.safeDecoder) -> AnyPublisher<ResponseBase<T>, NetworkError> {
            provider.requestPublisher(MultiTarget(api))
                .tryMap { response in
                    // 当HTTP状态码不在200-299范围内时，抛出网络错误
                    guard (200 ... 299).contains(response.statusCode) else {
                        let error = NetworkError.networkingFailed(response.statusCode)

                        if response.statusCode == 401 {
                            // 401错误处理
                            // 注意：在非异步上下文中不能直接使用MainActor.run
                            // 401错误（未授权）应在调用处理
                        }
                        throw error
                    }
                    return response.data
                }
                .decode(type: ResponseBase<T>.self, decoder: decoder)
                .tryMap { response in
                    // 检查服务器返回的状态码
                    if response.code != 200 {
                        throw NetworkError.serverError(response.code, response.message)
                    }
                    return response
                }
                .mapError { error -> NetworkError in
                    // 将所有错误类型统一映射为NetworkError
                    switch error {
                    case let decodingError as DecodingError:
                        print("解码失败: \(decodingError.localizedDescription)")
                        return .dataDecodingFailed // 数据解码失败错误

                    case let networkError as NetworkError:
                        return networkError // 已经是NetworkError类型，直接返回

                    default:
                        return .networkingFailed(-999) // 其他未知错误，使用默认错误码
                    }
                }
                .eraseToAnyPublisher()
        }
        
        /// 执行异步网络请求并返回响应结果
        /// 使用Swift的async/await语法，简化网络请求的处理
        /// - Parameters:
        ///   - api: 目标API端点，遵循TargetType协议
        ///   - responseType: 期望的响应数据类型
        ///   - decoder: 用于解码响应的JSONDecoder，默认使用安全解码器
        /// - Returns: 解码后的ResponseBase<T>对象
        /// - Throws: 请求过程中的NetworkError错误
        @discardableResult
        func request<T: Decodable, D: TargetType>(
            api: D,
            responseType: T.Type,
            decoder: JSONDecoder = JSONDecoder.safeDecoder
        ) async throws -> ResponseBase<T> {
            // 使用continuation将基于回调的API转换为async/await模式
            return try await withCheckedThrowingContinuation { continuation in
                let cancellable = requestPublisher(api: api, responseType: responseType, decoder: decoder)
                    .sink(
                        receiveCompletion: { completion in
                            self.subToken.unseal() // 释放订阅令牌
                            switch completion {
                            case .finished: break
                            case .failure(let error):
                                continuation.resume(throwing: error)
                            }
                        },
                        receiveValue: { response in
                            continuation.resume(returning: response)
                        }
                    )
                cancellable.seal(in: self.subToken)
            }
        }
    }
    
    /// 提供异步网络请求能力的属性
    /// 通过此属性可以访问MoyaConcurrency类提供的async/await网络请求方法
    var async: MoyaConcurrency {
        MoyaConcurrency(provider: self)
    }
}
