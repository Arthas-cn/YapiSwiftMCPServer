//
//  AuthParams.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/4/10.
//

import Foundation


extension NetworkParams {
    
    /// LoginAuth 定义登录和认证所需的参数
    /// 支持多种登录方式，包括用户名密码登录和第三方授权登录（如苹果、谷歌等）
    struct LoginAuth: Codable {
        /// 用户名，用于用户名密码登录
        var username: String?
        
        /// 密码，用于用户名密码登录
        var password: String?
        
        /// 用户昵称，用于注册或第三方登录时设置显示名称
        var nickname: String?
        
        /// 用户头像的文件URL，用于注册或第三方登录时设置用户头像
        var headImgFileUrl: String?
        
        /// 苹果登录的授权码，用于苹果登录认证
        var authorizationCode: String?
        
        /// 苹果账号关联的电子邮件，用于苹果登录
        var email: String?
        
        /// 授权类型，指定使用的第三方登录服务
        /// 例如：APPLE、GOOGLE等
        var authType: String
    }
}
