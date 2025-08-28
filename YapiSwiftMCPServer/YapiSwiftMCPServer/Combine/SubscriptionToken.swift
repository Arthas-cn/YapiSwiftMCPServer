//
//  SubscriptionToken.swift
//  WocuteSwiftUI
//
//  Created by 周志官 on 2024/12/19.
//

import Combine
import Foundation

class SubscriptionToken {
    var cancellable: AnyCancellable?
    
    func seal(_ cancellable: AnyCancellable) {
        self.cancellable = cancellable
    }
    
    func unseal() {
        cancellable?.cancel()
        cancellable = nil
    }
}



extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
