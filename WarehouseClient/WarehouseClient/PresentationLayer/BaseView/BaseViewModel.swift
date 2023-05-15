//
//  BaseViewModel.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import Foundation

final class BaseViewModel: ViewModel {
    @Published var isAuth = false
    
    override init(container: DIContainer) {
        super.init(container: container)
        
        cancelBag.collect {
            container.appState.updates(for: \.auth)
                .map(\.isAuthorized)
                .weakAssign(to: \.isAuth, on: self)
        }
    }
    
    func reloadWorks() {
        container.services.warehouseService.getAllWorksRecords()
    }
}
