//
//  WarehouseChartsViewModel.swift
//  WarehouseClient
//
//  Created by Matviy Suk on 15.05.2023.
//

import Foundation


final class WarehouseChartsViewModel: ViewModel {
    @Published var works: Loadable<[FactWorks]> = .notRequested

    
    override init(container: DIContainer) {
        super.init(container: container)
        
        cancelBag.collect {
            container.appState.updates(for: \.userData.works)
                .weakAssign(to: \.works, on: self)
        }
    }
    
    func reloadWorks() {
        container.services.warehouseService.getAllWorksRecords(cancelBag: cancelBag)
    }
}
