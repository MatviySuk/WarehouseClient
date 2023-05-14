//
//  AppEnvironment.swift
//
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import Combine

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())

        
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        
        let services = configuredServices(appState: appState, webRepositories: webRepositories)
        let diContainer = DIContainer(appState: appState, services: services)
        
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredURLSession() -> URLSession {
        let delegate = LocalhostSessionDelegate()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 20
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }
    
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let warehouseRepository = RealWarehouseRepository(session: session, baseURL: "https://localhost:7010")
        
        return .init(warehouseRepository: warehouseRepository)
    }
    
    private static func configuredServices(appState: Store<AppState>, webRepositories: DIContainer.WebRepositories) -> Services {
        let authService = LocalAuthService(appState: appState)
        let warehouseService = RealWarehouseService(webRepository: webRepositories.warehouseRepository, appState: appState)
        
        return .init(authService: authService, warehouseService: warehouseService)
    }
}
