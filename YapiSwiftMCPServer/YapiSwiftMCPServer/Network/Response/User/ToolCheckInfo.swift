//
//  ToolCheckInfo.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2024/12/23.
//

import Foundation

/// 工具检查信息
struct ToolCheckInfo: Codable, Sendable {
    // 是否已经填写过 经期初始化信息
    var isFill: Bool = false
    // 工具填写信息
    var info: ToolSettingInfo?
    
    enum CodingKeys: String, CodingKey {
        case isFill = "init"
        case info
    }
    
    init() {}
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isFill = try container.decode(Bool.self, forKey: .isFill)
        // 只有当为true时才解析
        if isFill {
            self.info = try ToolSettingInfo(from: decoder)
        }
    }
}

/// 工具设置数据
struct ToolSettingInfo: Codable, Sendable {
    /// 最近一次月经日期
    var lastStartDate: String?
    /// 月经长度
    var periodLength: Int
    /// 周期长度 -- 是否自动计算，true自动计算，后台默认为true为了兼容
    var isCloseAutoCycle: Bool
    /// 周期长度 -- 用户修改的
    var cycleLength: Int
    /// 周期长度初始值 -- 后台返回固定的
    var initialCycleLength: Int
    /// 出生年月日
    var birthday: String
    /// 月经模式 0-月经管理，1-备孕管理,2-怀孕管理
    var showType: ToolMode = .period
    /// 孕期开始时间
    var pregnancyStartTime: String?
    /// 预产期
    var pregnancyDueTime: String?
    /// 预测方式 (BASE:线性回归 PRO:模型) 默认为BASE
    var predictionType: PredictionType = .base
    /// PRO预测周期长度 (模型预测结果, 重新预测会清空)
    var propredictionCycleLength: Int?
    /// 表盘视图类型
    var dialViewType: DialMode?
}

extension ToolSettingInfo {
    /// 用户选择的工具模式
    enum ToolMode: Int, Codable, SmartCaseDefaultable, Sendable {
        case period = 0 // 经期
        case pregnancy // 备孕
        case concive // 怀孕

        static let defaultCase: ToolMode = .period
    }
    
    /// 经期数据预测方式
    enum PredictionType: String, Codable, SmartCaseDefaultable, Sendable {
        case base
        case pro
        
        static let defaultCase: PredictionType = .base
        
        enum CodingKeys: String, CodingKey {
            case base = "BASE"
            case pro = "PRO"
        }
    }
    
    /// 表盘模式
    enum DialMode: String, Codable, SmartCaseDefaultable, Sendable {
        case `default` // 默认
        case line // 线性
        case round // 圆盘
        
        static let defaultCase: DialMode = .default
        
        enum CodingKeys: String, CodingKey {
            case `default` = "DEFAULT"
            case line = "LINE"
            case round = "ROUND"
        }
    }
}
