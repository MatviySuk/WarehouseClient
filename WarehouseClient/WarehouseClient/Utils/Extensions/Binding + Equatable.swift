//
//  Binding + Equatable.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import SwiftUI

extension Binding where Value: Equatable {
    typealias ValueClosure = (Value) -> Void
    
    func onSet(_ perform: @escaping ValueClosure) -> Self {
        return .init(get: { () -> Value in
            self.wrappedValue
        }, set: { value in
            if self.wrappedValue != value {
                self.wrappedValue = value
            }
            perform(value)
        })
    }
}
