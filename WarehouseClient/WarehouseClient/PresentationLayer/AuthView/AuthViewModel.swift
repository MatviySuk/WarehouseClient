//
//  AuthViewModel.swift
//  DreyfusQuestionnaire
//
//  Created by Matviy Suk on 05.03.2023.
//

import Foundation

final class AuthViewModel: ViewModel {
    @Published var name: String = "Matviy"
    
    func logIn() {
        container.services.authService.logIn(User(name: name))
    }
}
