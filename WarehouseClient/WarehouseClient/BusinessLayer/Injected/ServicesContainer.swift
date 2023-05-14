//
//  DIContainer.Interactors.swift
//

struct Services {
    let authService: AuthService
    let warehouseService: WarehouseService
    
    init(
        authService: AuthService,
        warehouseService: WarehouseService
    ) {
        self.authService = authService
        self.warehouseService = warehouseService
    }
    
    static var stub: Self {
        let appState = Store<AppState>(AppState())
        
        return .init(
            authService: LocalAuthService(appState: appState),
            warehouseService: MockWarehouseService()
        )
    }
}
