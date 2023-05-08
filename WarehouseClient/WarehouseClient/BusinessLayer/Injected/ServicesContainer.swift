//
//  DIContainer.Interactors.swift
//

struct Services {
    let authService: AuthService
    
    init(
        authService: AuthService
    ) {
        self.authService = authService
    }
    
    static var stub: Self {
        let appState = Store<AppState>(AppState())
        
        return .init(
            authService: LocalAuthService(appState: appState)
        )
    }
}
