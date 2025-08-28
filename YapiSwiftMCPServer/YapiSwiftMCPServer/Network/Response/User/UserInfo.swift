//
//  UserInfo.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2024/12/1.
//

import Foundation

/// 用户信息
struct UserInfo: Codable, Sendable {
    /// 用户全局唯一ID
    var login: String = ""
    /// Wocute ID
    var displayId: String = ""
    /// 昵称  如果存在则说明已经注册过
    var nickname: String = ""
    /// 头像   注册才会存在
    var headImgFileUrl: String = ""
    /// 生日 eg: 2000-1-1
    var birthday: String?
    /// 签名
    var signature: String?
    /// 关注数量
    var followsNum: Int = 0
    /// 粉丝数量
    var fansNum: Int = 0
    ///  网络地址用于回传检索地址
    var locationIds: [String]?
    /// 用户中心封面图
    var userCenterBgImage: CenterBgImage?
    /// 用户类型
    var userType: UserType = .USER
    /// 是否开启参与互动的栏目
    var openParticipated: Bool = false
    /// 设置敏感内容开关
    var openSensitived: Bool?
    /// 用户的创建时间
    var createdTime: TimeInterval = 0
    /// 用户是否已经删除
    var deleted: Bool = false
}

extension UserInfo {
    struct CenterBgImage: Codable, Sendable {
        var url: String = ""
        var brightness: Float = 0
    }

    enum UserType: String, Codable, Sendable, SmartCaseDefaultable {
        case USER
        case SYSTEM
        
        static let defaultCase: UserType = .USER
    }
}


// 当前登录用户才有的专属信息
struct AuthUserInfo: Codable, Sendable {
    /// 禁言用户信息, 非禁言用户没有这个信息
    var banUserInfo: BlockInfo?
    /// 用户邮箱
    var email: String?
    /// 是否验证用户邮箱
    var verifyEmail: Bool = false
    /// 是否填写过资料（是否设置过个人资料）
    var isFullProfile: Bool = false
    /// 最后更新密码的时间（如果这个字段为空，则代表用户从来没有设置过密码，也相当于老用户）
    var lastModifiedPassword: String?
    /// 社区匿名用户身份
    var anonymousInfo: AnonymousInfo?

    enum CodingKeys: String, CodingKey {
        case anonymousInfo = "userAnonymousDTO"
    }
}

extension AuthUserInfo {
    /// 禁言信息
    struct BlockInfo: Codable, Sendable {
        /// 类型 SYSTEM-系统禁言 ARTIFICIAL-人工禁言
        var type: String = ""
        /// 封禁结束时间(null: 永久)
        var banEndTime: String?
        /// 提示文案
        var message: String = ""
    }

    /// 匿名信息
    struct AnonymousInfo: Codable, Sendable {
        /// 匿名昵称显示
        var displayName: String = ""
        /// 匿名用户头像
        var headImgUrl: String = ""
    }
}

/// 授权用户信息
struct AuthenticatedUser: Codable, Sendable {
    /// 用户信息
    var info: UserInfo = .init()
    /// 专属登录信息
    var detailsInfo: AuthUserInfo = .init()

    // 自定义编码键
    enum CodingKeys: String, CodingKey {
        case info
        case detailsInfo
    }

    /// 自定义初始化器，通过两次解析来生成完整对象
    init(from decoder: Decoder) throws {
        // 尝试作为嵌套对象解码（用于从本地文件加载）
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.info = try container.decode(UserInfo.self, forKey: .info)
            self.detailsInfo = try container.decode(AuthUserInfo.self, forKey: .detailsInfo)
        } catch {
            // 如果嵌套解码失败，尝试作为API响应解码（API返回的格式）
            // 将解码器直接传递给子类型的解码器
            self.info = try UserInfo(from: decoder)
            self.detailsInfo = try AuthUserInfo(from: decoder)
        }
    }
    
    init() {}
}





