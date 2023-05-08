//
//  AppEnvironment.swift
//
//

import AppKit
import Combine

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())

        let services = configuredServices(appState: appState)
        let diContainer = DIContainer(appState: appState, services: services)
        
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredServices(appState: Store<AppState>) -> Services {
        let authService = LocalAuthService(appState: appState)
        
        return .init(authService: authService)
    }
}
