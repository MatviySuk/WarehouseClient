//
//  WarehouseClientApp.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 08.05.2023.
//

import SwiftUI

@main
struct WarehouseClientApp: App {
    private let container: DIContainer
    
    init() {
        let environment = AppEnvironment.bootstrap()

        self.container = environment.container
    }
    
    var body: some Scene {
        WindowGroup {
            BaseView(viewModel: .init(container: container))
        }
    }
}
