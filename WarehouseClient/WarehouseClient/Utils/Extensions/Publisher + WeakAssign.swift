//
//  Publisher + WeakAssign.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
// 

import Foundation
import Combine

extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        on object: T,
        onReceive: @escaping (Self.Output) -> () = { _ in }
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
            onReceive(value)
        }
    }
}
