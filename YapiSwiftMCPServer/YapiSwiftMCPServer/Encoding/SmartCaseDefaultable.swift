//
//  SmartCaseDefaultable.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2024/12/20.
//

import Foundation

public protocol SmartCaseDefaultable: RawRepresentable, Codable {
   /// 使用接收到的数据，无法用枚举类型中的任何值表示而导致解析失败，使用此默认值。
    static var defaultCase: Self { get }
}

public extension SmartCaseDefaultable where Self.RawValue: Decodable {
   init(from decoder: Decoder) throws {
       let container = try decoder.singleValueContainer()
       let rawValue = try container.decode(RawValue.self)
       self = Self.init(rawValue: rawValue) ?? Self.defaultCase
   }
}
