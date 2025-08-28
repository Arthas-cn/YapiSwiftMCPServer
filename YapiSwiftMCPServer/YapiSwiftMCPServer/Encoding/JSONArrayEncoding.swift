//
//  JSONArrayEncoding.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2024/11/25.
//

import Foundation
import Alamofire


/// 将JSON数组作为根元素发送
struct JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()

        guard let json = parameters?["jsonArray"] else {
            return request
        }

        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = data

        return request
    }
}

extension String {
    var urlEscaped: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

//使用示例
//public var task: Task {
//    switch self {
//    case .api:
//        return .requestParameters(parameters: ["jsonArray": ["Yes", "What", "abc"]], encoding: JSONArrayEncoding.default)
//    }
//}
