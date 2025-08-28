//
//  SymptomLogDTO.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2024/12/23.
//

import Foundation

struct SymptomLogDTO: Codable, Sendable {
    /// 日期
    var date: String
    
    /// 版本号
    var versionId: Int = 0
    
    /// 怀孕测试结果
    var pregnancyTest: String?
    
    /// 血量常量id
    var bleeding: String?
    
    /// 粘稠度常量id
    var mucus: String?
    
    /// 体力常量id
    var energy: String?
    
    /// 用药常量id
    var pills: String?
    
    /// 性行为常量id
    var love: String?
    
    /// 备注
    var note: String?
    
    /// 症状id列表
    var symptoms: [String]?
    
    /// 心情id列表
    var moods: [String]?
    
    /// 是否还没有保存到服务器，默认值：false 表示已经提交到服务器，true 表示还没有保存到服务器
    var isNotSave: Bool? = false

    /// 是否被删除
    var isDelete: Bool?
}
