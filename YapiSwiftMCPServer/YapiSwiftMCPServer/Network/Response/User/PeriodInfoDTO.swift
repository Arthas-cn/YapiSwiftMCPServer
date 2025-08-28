//
//  PeriodInfoDTO.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2025/5/13.
//
import Foundation

/// 经期信息
struct PeriodInfoDTO: Codable, Sendable {
    /// 数据版本号
    var versionId: Int
    /// 经期开始时间
    var startTime: String
    /// 经期结束时间
    var endTime: String?
    /// 数据库自增主键
    var indexIncre: Int
}
