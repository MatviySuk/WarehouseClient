//
//  ViewModel.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import Foundation

class ViewModel: ObservableObject {
    let container: DIContainer
    
    private(set) var cancelBag = CancelBag()
    
    init(container: DIContainer) {
        self.container = container
    }
}
