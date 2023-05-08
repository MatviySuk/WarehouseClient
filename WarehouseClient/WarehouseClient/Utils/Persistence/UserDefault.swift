//
//  UserDefaults.swift
//  syndicate
//
//  Created by Matviy Suk on 14.02.2023.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {

    // MARK: - Properties

    let prefix: String
    let key: String
    let defaultValue: T
    let container: UserDefaults

    var wrappedValue: T {
        get { container.object(forKey: fullKey()) as? T ?? defaultValue }
        set {
            let key = fullKey()

            if let newValue = newValue as? OptionalProtocol, newValue.isNil() {
                container.removeObject(forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
        }
    }

    // MARK: - Initialization

    init(
        prefix: String = Bundle.main.bundleIdentifier ?? "warehouseclient",
        key: String,
        defaultValue: T,
        in container: UserDefaults = .standard
    ) {
        self.prefix = prefix
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }

    // MARK: - Helpers

    private func fullKey() -> String {
        "\(prefix)_\(key)"
    }
}

private protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional: OptionalProtocol {
    func isNil() -> Bool {
        self == nil
    }
}
