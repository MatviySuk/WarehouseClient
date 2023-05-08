//
//  DependencyInjector.swift
//

import SwiftUI
import Combine

// MARK: - DIContainer

struct DIContainer: EnvironmentKey {
    
    let appState: Store<AppState>
    let services: Services
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = DIContainer(appState: AppState(), services: .stub)
    
    init(appState: Store<AppState>, services: Services) {
        self.appState = appState
        self.services = services
    }
    
    init(appState: AppState, services: Services) {
        self.init(appState: Store(appState), services: services)
    }
}

extension DIContainer {
    static var preview: Self {
        .init(appState: AppState.preview, services: .stub)
    }
}

