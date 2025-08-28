//
//  UserClient.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/4/10.
//


import Foundation
@preconcurrency import Moya

/// UserClient 处理与用户信息和数据相关的网络请求
/// 提供获取用户信息、初始化数据、经期信息等操作的接口
struct UserClient: DefaultNetworkClient, Sendable {
    /// 提供默认实例的快捷访问方式
    static var `default`: UserClient {
        get async {
            let provider = await NetworkManager.shared.userProvider()
            return UserClient(provider: provider)
        }
    }
    
    /// Moya提供者，用于执行用户相关的网络请求
    let provider: MoyaProvider<MultiTarget>
    
    /// 初始化方法，接受一个Provider实例
    init(provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }
    
    /// 获取当前授权用户的基本信息
    /// 需要用户已登录并授权
    /// - Returns: 当前授权用户的详细信息
    /// - Throws: 网络请求错误或数据解析错误
    func currentUserInfo() async throws -> AuthenticatedUser {
        // 执行获取用户信息请求
        let response = try await provider.async.request(
            api: UserAPI.userInfo, 
            responseType: AuthenticatedUser.self
        )
        // 检查响应中是否包含数据
        guard let data = response.data else {
            throw NetworkError.dataDecodingFailed
        }
        return data
    }
    
    /// 获取当前用户的初始化信息
    /// 用于应用启动时获取用户的基础配置
    /// - Returns: 用户初始化信息
    /// - Throws: 网络请求错误或数据解析错误
    func initInfo() async throws -> ToolCheckInfo {
        // 执行获取初始化信息请求
        let response = try await provider.async.request(
            api: UserAPI.initInfo, 
            responseType: ToolCheckInfo.self
        )
        // 检查响应中是否包含数据
        guard let data = response.data else {
            throw NetworkError.dataDecodingFailed
        }
        return data
    }
    
    /// 获取用户的经期信息
    /// 用于展示和计算经期相关数据
    /// - Returns: 经期信息数组，若无数据则返回空数组
    /// - Throws: 网络请求错误
    func periodInfo() async throws -> [PeriodInfoDTO] {
        // 执行获取经期信息请求
        let response = try await provider.async.request(
            api: UserAPI.pridodSync, 
            responseType: [PeriodInfoDTO].self
        )
        // 如果没有数据，返回空数组而不是抛出错误
        guard let data = response.data else {
            return []
        }
        return data
    }
    
    /// 获取用户的症状日志
    /// 用于展示和计算经期相关数据
    /// - Returns: 症状日志数组，若无数据则返回空数组
    /// - Throws: 网络请求错误
    func symptomLog() async throws -> [SymptomLogDTO] {
       // 获取所有日志，直到没有更多数据
        var page = 1
        let size = 50
        var logs: [SymptomLogDTO] = []
        var hasMore = false
        repeat {
            let response = try await symptomLog(page: page, size: size)
            logs.append(contentsOf: response.list)
            page = response.nextPage
            hasMore = response.hasNextPage
        } while hasMore
        return logs
    }

    /// 获取症状日志列表
    /// - Parameters:
    ///   - page: 当前页码
    ///   - size: 每页条数
    /// - Returns: 症状日志列表
    /// - Throws: 网络请求错误
    private func symptomLog(page: Int, size: Int) async throws -> ResponseList<SymptomLogDTO> {
        let response = try await provider.async.request(
            api: UserAPI.symptomLog(page: page, size: size),
            responseType: ResponseList<SymptomLogDTO>.self
        )
        guard let data = response.data else {
            throw NetworkError.dataDecodingFailed
        }
        return data
    }
}
